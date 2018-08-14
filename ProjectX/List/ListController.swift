//
//  ListController.swift
//  ProjectX
//
//  Created by Bruce Colby on 8/14/18.
//  Copyright © 2018 AmTrust. All rights reserved.
//

import Foundation
import Alamofire
import ProjectXCore

protocol ListControllerDelegate: class {
    func onFetchCompleted(with indexPaths: [IndexPath]?)
}

class ListController {
    // MARK: - Public Properties
    var isFetching = false
    var iteration  = 0
    
    // MARK: - Private Properties
    private var interactor = CatInteractor.self
    
    // MARK: - Lazy Properties
    lazy var models    = [] as [ListViewModel]
    
    // MARK: - Weak Properties
    weak var delegate: ListControllerDelegate?
}

// MARK: - State Manger
extension ListController {
    var total: Int {
        return 1000
    }
}

// MARK: - Network Requests
extension ListController {
    func fetchCats() {
        if isFetching {
            return
        } else {
            isFetching = true
        }
        
        let completion = { (result: XMLResult<Cat>) in
            switch result {
            case .success(let cat):
                self.onSuccess(cat)
            case .failure(let error):
                self.onFailure(error)
            }
        }
        
        DispatchQueue.global(qos: .background).async {
            self.interactor.getImages(completion: completion)
        }
    }
}

// MARK: - Network Response
extension ListController {
    func onSuccess(_ cat: Cat) {
        OperationQueue().addOperation {
            let group = DispatchGroup()
            
            var fetchedModels: [ListViewModel] = []
            
            cat.images.forEach {
                group.enter()
                let url       = $0.url
                $0.imageAsync { result in
                    switch result {
                    case .success(let image, let isGif):
                        fetchedModels.append(ListViewModel(image: image, url: url, isGif: isGif))
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                    group.leave()
                }
            }
            
            group.wait()
            
            DispatchQueue.main.async {
                self.done(fetchedModels)
            }
        }
    }
    
    func onFailure(_ error: Error) {
        print(error.localizedDescription)
        self.isFetching = false
    }
}

// MARK: - Completion
extension ListController {
    private func done(_ fetchedModels: [ListViewModel]) {
        iteration += 1
        isFetching = false
        models.append(contentsOf: fetchedModels)
        
        if iteration > 1 {
            // Subsequent page
            let indexPaths = self.calculateIndexPathsToReload(from: fetchedModels)
            delegate?.onFetchCompleted(with: indexPaths)
        } else {
            // First page
            delegate?.onFetchCompleted(with: .none)
        }
    }
}

// MARK: - Collection View Helpers
extension ListController {
    func isLoadingCell(for indexPath: IndexPath) -> Bool {
        return indexPath.row >= models.count
    }
    
    private func calculateIndexPathsToReload(from fetchedModels: [ListViewModel]) -> [IndexPath] {
        let startIndex = models.count - fetchedModels.count
        let endIndex   = startIndex   + fetchedModels.count
        
        return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
    }
}
