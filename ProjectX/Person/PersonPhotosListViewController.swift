//
//  PersonPhotosListViewController.swift
//  ProjectX
//
//  Created by Bruce Colby on 8/27/18.
//  Copyright © 2018 AmTrust. All rights reserved.
//

import UIKit
import ProjectXCore
import SwiftyGif

class PersonPhotosListViewController: UIViewController {
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
}

// MARK: - Setup
extension PersonPhotosListViewController {
    private func setupController() {
        controller.delegate = self
    }
    
    private func loadModels() {
        controller.fetchCats()
    }
}

extension PersonPhotosListViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSourcePrefetching {
    var listReuseidentifier: String {
        return "list"
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return controller.total
    }
    
    //https://github.com/kirualex/SwiftyGif/issues/75
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: listReuseidentifier, for: indexPath) as? ListCell else { return UICollectionViewCell() }
        cell.imageView.stopAnimatingGif()
        SwiftyGifManager.defaultManager.deleteImageView(cell.imageView)
        cell.imageView.image = nil
        cell.imageView.layer.cornerRadius  = 7
        cell.imageView.layer.masksToBounds = true
        
        if controller.isLoadingCell(for: indexPath) {
            cell.setup(with: ListViewModel(image: #imageLiteral(resourceName: "placeholder"), url: nil, isGif: false))
        } else {
            let model = controller.models[indexPath.row]
            cell.setup(with: model)
        }
        
        return cell
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
extension PersonPhotosListViewController: ListControllerDelegate {
    func onFetchCompleted(with indexPaths: [IndexPath]?) {
        guard let indexPaths = indexPaths else {
            collectionView.reloadData()
            return
        }
        
        let visibleIndexPaths = visibleIndexPathsToReload(intersecting: indexPaths)
        collectionView.reloadItems(at: visibleIndexPaths)
    }
}
