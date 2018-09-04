//
//  SearchSwipePresentInteractionController.swift
//  ProjectX
//
//  Created by Bruce Colby on 9/4/18.
//  Copyright © 2018 AmTrust. All rights reserved.
//

import UIKit

class SearchSwipePresentInteractionController: UIPercentDrivenInteractiveTransition {
    // MARK: - Public Properties
    var segue                 = ""
    var interactionInProgress = false
    
    // MARK: - Private Properties
    private var shouldCompleteTransition = false
    private weak var viewController: UIViewController!
    
    init(from fromVC: UIViewController, to segue: String, view: UIView) {
        super.init()
        self.viewController = fromVC
        self.segue          = segue
        setupGestureRecognizer(in: view)
    }
}

// MARK: - Setup
extension SearchSwipePresentInteractionController {
    private func setupGestureRecognizer(in view: UIView) {
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(handleGesture(_:)))
        view.addGestureRecognizer(gesture)
    }
}

// MARK: - Gesture Recognizers
extension SearchSwipePresentInteractionController {
    @objc func handleGesture(_ gestureRecognizer: UIPanGestureRecognizer) {
        // 1
        let translation = gestureRecognizer.translation(in: gestureRecognizer.view!.superview!)
        var progress = (-translation.y / 200)
        progress = CGFloat(fminf(fmaxf(Float(progress), 0.0), 1.0))
        
        switch gestureRecognizer.state {
            
        // 2
        case .began:
            interactionInProgress = true
            viewController.performSegue(withIdentifier: segue, sender: self)
            
        // 3
        case .changed:
            shouldCompleteTransition = progress > 0.5
            update(progress)
            
        // 4
        case .cancelled:
            interactionInProgress = false
            cancel()
            
        // 5
        case .ended:
            interactionInProgress = false
            if shouldCompleteTransition {
                finish()
            } else {
                cancel()
            }
        default:
            break
        }
    }
}
