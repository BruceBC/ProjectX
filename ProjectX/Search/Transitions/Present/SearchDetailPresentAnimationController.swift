//
//  DetailPresentAnimationController.swift
//  ProjectX
//
//  Created by Bruce Colby on 8/23/18.
//  Copyright © 2018 AmTrust. All rights reserved.
//

import UIKit

class SearchDetailPresentAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    // MARK: - Properties
    let originalFrame: CGRect
    let model:         SearchDetailPresentTransitionViewModel
    
    init(_ originalFrame: CGRect, model: SearchDetailPresentTransitionViewModel) {
        self.originalFrame = originalFrame
        self.model = model
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 2
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let fromVC           = transitionContext.viewController(forKey: .from),
            let toVC             = transitionContext.viewController(forKey: .to),
            let snapshot         = toVC.view.snapshotView(afterScreenUpdates: true),
            let personDetailView = SearchDetailPresentTransitionView.getFromNib()
        else {
            return
        }
        
        let containerView = transitionContext.containerView

        let height = containerView.frame.size.height / 1.5
        
        containerView.addSubview(toVC.view)
        containerView.addSubview(snapshot)
        containerView.addSubview(personDetailView)
        toVC.view.isHidden = true
        
        snapshot.alpha = 0
        personDetailView.translatesAutoresizingMaskIntoConstraints = false
        
        // Setup
        setupPersonDetailView(personDetailView)
        
        let bottomConstraint = NSLayoutConstraint(item: personDetailView, attribute: .bottom,   relatedBy: .equal, toItem: containerView.safeAreaLayoutGuide, attribute: .bottom,   multiplier: 1, constant: height - originalFrame.height - 80)
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: personDetailView, attribute: .height,  relatedBy: .equal, toItem: nil, attribute: .height,  multiplier: 1, constant: height),
            NSLayoutConstraint(item: personDetailView, attribute: .leading,  relatedBy: .equal, toItem: containerView, attribute: .leading,  multiplier: 1, constant: 0),
            NSLayoutConstraint(item: personDetailView, attribute: .trailing, relatedBy: .equal, toItem: containerView, attribute: .trailing, multiplier: 1, constant: 0),
            bottomConstraint
        ])
        
        containerView.layoutIfNeeded()
        bottomConstraint.constant = 0
        
        let animation = {
            containerView.layoutIfNeeded()
        }
        
        let completion = { (_:Bool) in
            toVC.view.isHidden = false
            snapshot.removeFromSuperview()
            personDetailView.removeFromSuperview()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        
        // Animatate
        let duration: TimeInterval = 0.6
        personDetailView.showDescription(duration: duration)
        UIView.animate(withDuration: duration, animations: animation, completion: completion)
    }
}

// MARK: - Setup
extension SearchDetailPresentAnimationController {
    private func setupPersonDetailView(_ view: SearchDetailPresentTransitionView) {
        view.setup(with: model)
    }
}
