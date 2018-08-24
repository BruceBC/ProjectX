//
//  DetailPresentAnimationController.swift
//  ProjectX
//
//  Created by Bruce Colby on 8/23/18.
//  Copyright © 2018 AmTrust. All rights reserved.
//

import UIKit

class DetailPresentAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    // MARK: - Properties
    let originalFrame: CGRect
    let model:         PersonDetailViewModel
    
    init(_ originalFrame: CGRect, model: PersonDetailViewModel) {
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
            let personDetailView = PersonDetail.getFromNib(),
            let customTabBar     = CustomTabBar.getFromNib()
        else {
            return
        }
        
        let containerView = transitionContext.containerView

        let height = containerView.frame.size.height / 1.5
        
        containerView.addSubview(toVC.view)
        containerView.addSubview(snapshot)
        containerView.addSubview(personDetailView)
        containerView.addSubview(customTabBar)
        toVC.view.isHidden = true
        
        snapshot.alpha = 0
        personDetailView.translatesAutoresizingMaskIntoConstraints = false
        
        // Setup
        setupPersonDetailView(personDetailView)
        
        // Pin custom tab bar to bottom of view
        customTabBar.translatesAutoresizingMaskIntoConstraints = false
        let customTabBarConstraints = setupTabBarAutoLayout(customTabBar, to: containerView)
        NSLayoutConstraint.activate(customTabBarConstraints)
        
        var bottomConstraint = NSLayoutConstraint(item: personDetailView, attribute: .bottom,   relatedBy: .equal, toItem: containerView.safeAreaLayoutGuide, attribute: .bottom,   multiplier: 1, constant: height - originalFrame.height - 80)
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
            customTabBar.removeFromSuperview()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        
        // Animatate
        let duration: TimeInterval = 0.6
        personDetailView.showDescription(duration: duration)
        UIView.animate(withDuration: duration, animations: animation, completion: completion)
    }
}

// MARK: - Setup
extension DetailPresentAnimationController {
    private func setupTabBarAutoLayout(_ customTabBar: CustomTabBar, to view: UIView) -> [NSLayoutConstraint] {
        return [
            NSLayoutConstraint(item: customTabBar, attribute: .height,  relatedBy: .equal, toItem: nil, attribute: .height,  multiplier: 1, constant: customTabBar.frame.height),
            NSLayoutConstraint(item: customTabBar, attribute: .leading,  relatedBy: .equal, toItem: view, attribute: .leading,  multiplier: 1, constant: 0),
            NSLayoutConstraint(item: customTabBar, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: customTabBar, attribute: .bottom,   relatedBy: .equal, toItem: view, attribute: .bottom,   multiplier: 1, constant: 0)
        ]
    }
    
    private func setupPersonDetailView(_ view: PersonDetail) {
        view.setup(with: model)
    }
}
