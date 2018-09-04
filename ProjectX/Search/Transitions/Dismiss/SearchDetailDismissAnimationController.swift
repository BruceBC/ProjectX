//
//  SearchDetailDismissAnimationController.swift
//  ProjectX
//
//  Created by Bruce Colby on 8/31/18.
//  Copyright © 2018 AmTrust. All rights reserved.
//

import UIKit

class SearchDetailDismissAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    let bottomView:       UIView
    let followView:       UIView
    let descriptionLabel: UILabel
    
    init(bottomView: UIView, followView: UIView, descriptionLabel: UILabel) {
        self.bottomView       = bottomView
        self.followView       = followView
        self.descriptionLabel = descriptionLabel
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.6
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let toVC = transitionContext.viewController(forKey: .to) as? SearchViewController
        else {
            return
        }
        
        let containerView = transitionContext.containerView
        containerView.insertSubview(toVC.view, at: 0)
        
        let toBottomY = self.bottomView.frame.size.height - (toVC.bottomView.frame.size.height + 35)
        let toFollowY = toBottomY - 75
        
        let animation = {
            self.bottomView.frame.origin.y = toBottomY
            self.followView.frame.origin.y = toFollowY
            self.descriptionLabel.alpha    = 0
        }
        let completion = { (_:Bool) in
            if transitionContext.transitionWasCancelled {
                toVC.view.removeFromSuperview()
            }
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        
        UIView.animate(withDuration: 0.6, animations: animation, completion: completion)
    }
}
