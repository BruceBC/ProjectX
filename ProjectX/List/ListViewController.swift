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
    
    // MARK: - Public Properties
    var controller = ListController()
    
    // MARK: - Overriden Properties
    override var prefersStatusBarHidden: Bool { return true }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupController()
        loadModels()
    }
    
    // MARK: - IBActions
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - Setup
extension ListViewController {
    private func setupController() {
        controller.delegate = self
    }
    
    private func loadModels() {
        controller.fetchCats()
    }
}

extension ListViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSourcePrefetching {
    var listReuseidentifier: String {
        return "list"
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return controller.total
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: listReuseidentifier, for: indexPath) as? ListCell else { return UICollectionViewCell() }
        
        if controller.isLoadingCell(for: indexPath) {
            cell.setup(with: ListViewModel(image: #imageLiteral(resourceName: "trainGuy"), url: nil, isGif: false))
        } else {
            let model = controller.models[indexPath.row]
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
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: controller.isLoadingCell) {
            controller.fetchCats()
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        collectionView.reloadData()
    }
    
    private func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
        let indexPathsForVisibleRows = collectionView.indexPathsForVisibleItems
        let indexPathsIntersection = Set(indexPathsForVisibleRows).intersection(indexPaths)
        return Array(indexPathsIntersection)
    }
}

// MARK: HomeController Delegate
extension ListViewController: ListControllerDelegate {
    func onFetchCompleted(with indexPaths: [IndexPath]?) {
        guard let indexPaths = indexPaths else {
            collectionView.reloadData()
            return
        }
        
        let visibleIndexPaths = visibleIndexPathsToReload(intersecting: indexPaths)
        collectionView.reloadItems(at: visibleIndexPaths)
    }
}
