//
//  SearchSwipeInteractionController.swift
//  ProjectX
//
//  Created by Bruce Colby on 9/4/18.
//  Copyright © 2018 AmTrust. All rights reserved.
//

import UIKit

class SearchSwipeDismissInteractionController: UIPercentDrivenInteractiveTransition {
    // MARK: - Public Properties
    var interactionInProgress = false
    
    // MARK: - Private Properties
    private var shouldCompleteTransition = false
    private weak var viewController: UIViewController!
    
    init(viewController: UIViewController, view: UIView) {
        super.init()
        self.viewController = viewController
        setupGestureRecognizer(in: view)
    }
}

// MARK: - Setup
extension SearchSwipeDismissInteractionController {
    private func setupGestureRecognizer(in view: UIView) {
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(handleGesture(_:)))
        view.addGestureRecognizer(gesture)
    }
}

// MARK: - Gesture Recognizers
extension SearchSwipeDismissInteractionController {
    @objc func handleGesture(_ gestureRecognizer: UIPanGestureRecognizer) {
        // 1
        let translation = gestureRecognizer.translation(in: gestureRecognizer.view!.superview!)
        var progress = (translation.y / 200)
        progress = CGFloat(fminf(fmaxf(Float(progress), 0.0), 1.0))
        
        switch gestureRecognizer.state {
            
        // 2
        case .began:
            interactionInProgress = true
            viewController.navigationController?.popViewController(animated: true)
 
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
