//
//  ListViewController.swift
//  ProjectX
//
//  Created by Bruce Colby on 8/9/18.
//  Copyright © 2018 AmTrust. All rights reserved.
//

import UIKit
import ProjectXCore

class ListViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Properties
    override var prefersStatusBarHidden: Bool { return true }
    var models: [ListViewModel] = []
    var isFetching = false
    var page       = 0
    var total      = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.prefetchDataSource = self
        loadModels()
    }
    
    // MARK: - IBActions
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - Setup
extension ListViewController {
    private func loadModels() {
        fetchCats()
    }
}

extension ListViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSourcePrefetching {
    var listReuseidentifier: String {
        return "list"
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return models.count
        return total
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: listReuseidentifier, for: indexPath) as? ListCell else { return UICollectionViewCell() }
        
        if isLoadingCell(for: indexPath) {
            cell.setup(with: ListViewModel(image: #imageLiteral(resourceName: "trainGuy"), url: nil, isGif: false))
        } else {
            let model = models[indexPath.row]
            cell.setup(with: model)
        }
        
        return cell
    }
    
    // https://stackoverflow.com/questions/40974973/how-to-resize-the-collection-view-cells-according-to-device-screen-size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Aspect Ratio: 16:9
        // Formula: adjusted height = <user-chosen width> * original height / original width
        // Source: https://math.stackexchange.com/questions/180804/how-to-get-the-aspect-ratio-of-an-image
        let spacing: CGFloat = 13
        let screenWidth = UIScreen.main.bounds.size.width
        let width = (screenWidth / 2) - spacing
        let height = (width * 9 / 16)// + 90
        let size = CGSize(width: width, height: height)
        return size
    }
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let storyboard = UIStoryboard(name: "Video", bundle: nil)
//        guard let vc = storyboard.instantiateViewController(withIdentifier: "VideoCoordinatorViewController") as? VideoCoordinatorViewController else { return }
//        vc.video = thumbnails[indexPath.row]
//        self.navigationController?.pushViewController(vc, animated: true)
//    }
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: isLoadingCell) {
            fetchCats()
            print("prefetching")
        }
        print("no need to prefetch")
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        collectionView.reloadData()
    }
}

// MARK: - Network Requests
extension ListViewController {
    private func fetchCats() {
        guard !isFetching else { return }
        isFetching = true
        
        CatInteractor.getImages { result in
            switch result {
            case .success(let cat):
                self.onFetchCatSuccess(cat)
            case .error(let error):
                self.onFetchCatFailure(error)
            }
        }
    }
}

// MARK: - Network Events
extension ListViewController {
    private func onFetchCatSuccess(_ cat: Cat) {
        OperationQueue().addOperation {
            let group = DispatchGroup()
            
            var models: [ListViewModel] = []
            
            cat.images.forEach {
                group.enter()
                let url = $0.url
                $0.image { (image, isGif) in
                    models.append(ListViewModel(image: image ?? #imageLiteral(resourceName: "trainGuy"), url: url, isGif: isGif))
                    group.leave()
                }
            }
            
            group.wait()
            
            DispatchQueue.main.async {
                self.didLoadViewModels(models)
            }
        }
    }
    
    private func onFetchCatFailure(_ error: Error) {
        DispatchQueue.main.async {
            self.isFetching = false
            print(error.localizedDescription)
        }
    }
    
    private func didLoadViewModels(_ models: [ListViewModel], completion: (() -> Void)? = nil) {
        self.page += 1
        self.total = 1000
        self.isFetching = false
        
        self.models.append(contentsOf: models)
        
        if self.page > 1 {
            // Subsequent page
            let indexPathsToReload = self.calculateIndexPathsToReload(from: models)
            self.onFetchCompleted(with: indexPathsToReload)
        } else {
            // First page
            self.onFetchCompleted(with: .none)
        }
        
        completion?()
    }
    
    private func onFetchCompleted(with nexIndexPathsToReload: [IndexPath]?) {
        guard let newIndexPathsToReload = nexIndexPathsToReload else {
            self.collectionView.reloadData()
            return
        }
        
        let indexPathsToReload = visibleIndexPathsToReload(intersecting: newIndexPathsToReload)
        collectionView.reloadItems(at: indexPathsToReload)
    }
}

// MARK: - Collection View Helpers
extension ListViewController {
    private func isLoadingCell(for indexPath: IndexPath) -> Bool {
        return indexPath.row >= models.count
    }
    
    private func calculateIndexPathsToReload(from newModels: [ListViewModel]) -> [IndexPath] {
        let startIndex = models.count - newModels.count
        let endIndex   = startIndex   + newModels.count
        
        return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
    }
    
    private func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
        let indexPathsForVisibleRows = collectionView.indexPathsForVisibleItems
        let indexPathsIntersection = Set(indexPathsForVisibleRows).intersection(indexPaths)
        return Array(indexPathsIntersection)
    }
}
