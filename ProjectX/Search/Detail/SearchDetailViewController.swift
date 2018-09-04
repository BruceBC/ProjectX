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
    @IBOutlet weak var followerView:                 UIView!
    @IBOutlet weak var bottomView:                   UIView!
    @IBOutlet weak var followButton:                 UIButton!
    @IBOutlet weak var nameLabel:                    UILabel!
    @IBOutlet weak var stateLabel:                   UILabel!
    @IBOutlet weak var descriptionLabel:             UILabel!
    @IBOutlet weak var followerLabel:                UILabel!
    @IBOutlet weak var followerCountLabel:           UILabel!
    @IBOutlet weak var postsLabel:                   UILabel!
    @IBOutlet weak var postsCountLabel:              UILabel!
    @IBOutlet weak var followingLabel:               UILabel!
    @IBOutlet weak var followingCountLabel:          UILabel!
    @IBOutlet weak var imageView:                    UIImageView!
    @IBOutlet weak var followButtonWidthConstraint:  NSLayoutConstraint!
    @IBOutlet weak var followButtonHeightConstraint: NSLayoutConstraint!
    
    // MARK: - Computed Properties
    override var prefersStatusBarHidden: Bool { return true }
    
    // MARK: Properties
    var model: SearchDetailPresentTransitionViewModel?
    var index: Int?
    var defaultFollowButtonWidth  = CGFloat(167.5)
    var defaultFollowButtonHeight = CGFloat(45)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTransition()
        setupFollowerView()
        setupBottomView()
        setupButtons()
        setupLabels()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    // MARK: - IBActions
    @IBAction func followAction(_ sender: Any) {
        guard let index = index else { return }
        let user                                                    = StateManager.shared.users[index]
        let isFollowing                                             = !user.twitter.isFollowing
        StateManager.shared.users[index].twitter.isFollowing  = isFollowing
        
        if isFollowing {
            followerAddedAnimation()
        } else {
            followerRemovedAnimation()
        }
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
        
        // Setup gesture recognizer
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapBottomView))
        bottomView.addGestureRecognizer(gestureRecognizer)
    }
    
    private func setupButtons() {
        guard let index = index else { return }
        let user = StateManager.shared.users[index]
        
        if user.twitter.isFollowing {
            self.isFollowingButton()
        } else {
            self.isNotFollowingButton()
        }
    }
    
    private func setupLabels() {
        guard let model = model else { return }
        nameLabel.text           = model.name
        stateLabel.text          = model.location
        descriptionLabel.text    = model.description
        followerLabel.text       = model.followerTitle
        followerCountLabel.text  = model.followerCount
        postsLabel.text          = model.postTitle
        postsCountLabel.text     = model.postCount
        followingLabel.text      = model.followingTitle
        followingCountLabel.text = model.followingCount
        imageView.image          = model.image
    }
}

// MARK: - Gesture Actions
extension SearchDetailViewController {
    @objc func didTapBottomView() {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - Helpers
extension SearchDetailViewController {
    private func isFollowingButton() {
        let width = CGFloat(35)
        followButton.setTitle(nil, for: .normal)
        followButton.backgroundColor = .red
        followButton.setTitleColor(.red, for: .normal)
        followButton.layer.borderColor = UIColor.red.cgColor
        followButton.layer.cornerRadius = width / 2
        followButtonHeightConstraint.constant = width
        followButtonWidthConstraint.constant = width
        followButton.setImage(#imageLiteral(resourceName: "person"), for: .normal)
        followButton.setImageColor(.white)
        followButton.imageView?.alpha = 1
        followButton.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5)
        view.layoutIfNeeded()
    }
    
    private func isNotFollowingButton() {
        let width = defaultFollowButtonWidth
        let height = defaultFollowButtonHeight
        let red = #colorLiteral(red: 0.8392156863, green: 0.1882352941, blue: 0.1921568627, alpha: 1)
        followButton.setTitle("FOLLOW", for: .normal)
        followButton.setTitleColor(red, for: .normal)
        followButton.setImage(nil, for: .normal)
        followButton.backgroundColor = .clear
        followButton.layer.masksToBounds = true
        followButton.layer.borderWidth = 2
        followButton.layer.borderColor = red.cgColor
        followButton.layer.cornerRadius = height / 2
        followButtonHeightConstraint.constant = height
        followButtonWidthConstraint.constant = width
        view.layoutIfNeeded()
    }
    
    private func followerAddedAnimation() {
        guard let index = index else { return }
        followButton.setTitle(nil, for: .normal)
        let width = CGFloat(35)
        let animation = {
            self.followButton.backgroundColor = .red
            self.followButton.setTitleColor(.red, for: .normal)
            self.followButton.layer.borderColor = UIColor.red.cgColor
            self.followButton.layer.cornerRadius = width / 2
            self.followButtonHeightConstraint.constant = width
            self.followButtonWidthConstraint.constant = width
            self.view.layoutIfNeeded()
        }
        let completion = { (_:Bool) in
            self.followButton.setImage(#imageLiteral(resourceName: "person"), for: .normal)
            self.followButton.setImageColor(.white)
            self.followButton.imageView?.alpha = 0
            self.followButton.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5)
            
            let animation: VoidAction = {
                self.followButton.imageView?.alpha = 1
            }
            
            let completion = { (_:Bool) in
                self.followerCountLabel.fadeTransition(0.4)
                self.followerCountLabel.text = StateManager.shared.users[index].twitter.followers.prettyCount
            }
            
            UIView.animate(withDuration: 0.3, animations: animation, completion: completion)
        }
        
        UIView.animate(withDuration: 0.6, animations: animation, completion: completion)
    }
    
    private func followerRemovedAnimation() {
        guard let index = index else { return }
        let width = defaultFollowButtonWidth
        let height = defaultFollowButtonHeight
        let red = #colorLiteral(red: 0.8392156863, green: 0.1882352941, blue: 0.1921568627, alpha: 1)
        self.followButton.setTitleColor(.clear, for: .normal)
        
        let animation: VoidAction = {
            self.followButton.imageView?.alpha = 0
        }
        
        let completion = { (_:Bool) in
            self.followButton.setImage(nil, for: .normal)
            
            let animation = {
                self.followButton.backgroundColor = .clear
                self.followButton.layer.masksToBounds = true
                self.followButton.layer.borderWidth = 2
                self.followButton.layer.borderColor = red.cgColor
                self.followButton.layer.cornerRadius = height / 2
                self.followButtonHeightConstraint.constant = height
                self.followButtonWidthConstraint.constant = width
                self.view.layoutIfNeeded()
            }
            let completion = { (_:Bool) in
                self.followButton.setTitle("FOLLOW", for: .normal)
                
                let animation = {
                    self.followButton.setTitleColor(red, for: .normal)
                }
                
                let completion = { (_:Bool) in
                    self.followerCountLabel.fadeTransition(0.4)
                    self.followerCountLabel.text = StateManager.shared.users[index].twitter.followers.prettyCount
                }
                
                UIView.animate(withDuration: 0.3, animations: animation, completion: completion)
            }
            
            UIView.animate(withDuration: 0.6, animations: animation, completion: completion)
        }
        
        UIView.animate(withDuration: 0.3, animations: animation, completion: completion)
    }
}
