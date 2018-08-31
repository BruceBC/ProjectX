//
//  PersonDetailViewController.swift
//  ProjectX
//
//  Created by Bruce Colby on 8/23/18.
//  Copyright © 2018 AmTrust. All rights reserved.
//

import UIKit

class SearchDetailViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var imageView:      UIImageView!
    @IBOutlet weak var followerView:   UIView!
    @IBOutlet weak var bottomView:     UIView!
    @IBOutlet weak var followButton:   UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    // MARK: - Computed Properties
    override var prefersStatusBarHidden: Bool { return true }
    
    // MARK: Properties
    var model: SearchDetailPresentTransitionViewModel?
    var defaultFollowButtonWidth  = CGFloat(167.5)
    var defaultFollowButtonHeight = CGFloat(45)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTransition()
        setupFollowerView()
        setupBottomView()
        setupButtons()
        setupPersonDetailModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
}

// MARK: - Setup
extension SearchDetailViewController {
    private func setupTransition() {
//        self.transitioningDelegate = self
    }
    
    private func setupFollowerView() {
        followerView.blur(.dark)
    }
    
    private func setupBottomView() {
        bottomView.layer.masksToBounds = true
        bottomView.roundCorners(corners: [.topLeft, .topRight], size: 35)
    }
    
    private func setupButtons() {
        followButton.layer.masksToBounds = true
        followButton.layer.borderWidth = 2
        followButton.layer.borderColor = followButton.titleColor(for: .normal)?.cgColor
        followButton.layer.cornerRadius = defaultFollowButtonHeight / 2
    }
    
    private func setupPersonDetailModel() {
        guard let model = model else { return }
        nameLabel.text        = model.name
        stateLabel.text       = model.state
        descriptionLabel.text = model.description
        imageView.image       = model.image
    }
}

// MARK: Transition Delegate
//extension SearchDetailViewController: UIViewControllerTransitioningDelegate {
//    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        var frame = bottomView.frame
//        frame.origin.y = followerView.frame.origin.y
//        return DetailPresentAnimationController(bottomView.frame, model: PersonDetailViewModel(name: "Bruce Colby", state: "Ohio", description: "No one cares...", image: #imageLiteral(resourceName: "trainGuy")))
//    }
//}
