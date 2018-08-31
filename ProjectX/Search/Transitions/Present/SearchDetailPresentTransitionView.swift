//
//  PersonDetail.swift
//  ProjectX
//
//  Created by Bruce Colby on 8/24/18.
//  Copyright © 2018 AmTrust. All rights reserved.
//

import UIKit

class SearchDetailPresentTransitionView: UIView {
    // MARK: - IBOutlets
    @IBOutlet weak var followButton:                 UIButton!
    @IBOutlet weak var followerView:                 UIView!
    @IBOutlet weak var bottomView:                   UIView!
    @IBOutlet weak var nameLabel:                    UILabel!
    @IBOutlet weak var stateLabel:                   UILabel!
    @IBOutlet weak var descriptionLabel:             UILabel!
    @IBOutlet weak var followerLabel:                UILabel!
    @IBOutlet weak var followerCountLabel:           UILabel!
    @IBOutlet weak var postsLabel:                   UILabel!
    @IBOutlet weak var postsCountLabel:              UILabel!
    @IBOutlet weak var followingLabel:               UILabel!
    @IBOutlet weak var followingCountLabel:          UILabel!
    @IBOutlet weak var placeholder1ImageView:        UIImageView!
    @IBOutlet weak var placeholder2ImageView:        UIImageView!
    @IBOutlet weak var placeholder3ImageView:        UIImageView!
    @IBOutlet weak var placeholder4ImageView:        UIImageView!
    @IBOutlet weak var followButtonWidthConstraint:  NSLayoutConstraint!
    @IBOutlet weak var followButtonHeightConstraint: NSLayoutConstraint!
    
    // MARK: Properties
    var index: Int?
    var defaultFollowButtonWidth  = CGFloat(167.5)
    var defaultFollowButtonHeight = CGFloat(45)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupBottomView()
        setupLabels()
        setupFollowerView()
        setupImageViews()
    }
}

// MARK: - Setup
extension SearchDetailPresentTransitionView {
    private func setupBottomView() {
        bottomView.layer.masksToBounds = true
        bottomView.roundCorners(corners: [.topLeft, .topRight], size: 35)
    }
    
    private func setupButtons() {
        guard let index = self.index else { return }
        let user = StateManager.shared.users[index]
        
        if user.twitter.isFollowing {
            self.isFollowingButton()
        } else {
            self.isNotFollowingButton()
        }
    }
    
    private func setupLabels() {
        descriptionLabel.alpha = 0
    }
    
    private func setupFollowerView() {
        followerView.blur(.dark)
    }
    
    private func setupImageViews() {
        placeholder1ImageView.layer.cornerRadius  = 7
        placeholder2ImageView.layer.cornerRadius  = 7
        placeholder3ImageView.layer.cornerRadius  = 7
        placeholder4ImageView.layer.cornerRadius  = 7
        
        placeholder1ImageView.layer.masksToBounds = true
        placeholder2ImageView.layer.masksToBounds = true
        placeholder3ImageView.layer.masksToBounds = true
        placeholder4ImageView.layer.masksToBounds = true
    }
    
    public func setup(with model: SearchDetailPresentTransitionViewModel, index: Int) {
        nameLabel.text           = model.name
        stateLabel.text          = model.location
        descriptionLabel.text    = model.description
        followerLabel.text       = model.followerTitle
        followerCountLabel.text  = model.followerCount
        postsLabel.text          = model.postTitle
        postsCountLabel.text     = model.postCount
        followingLabel.text      = model.followingTitle
        followingCountLabel.text = model.followingCount
        
        self.index = index
        setupButtons()
    }
}

// MARK: - Animation
extension SearchDetailPresentTransitionView {
    public func showDescription(duration: TimeInterval) {
        UIView.animate(withDuration: duration) {
            self.descriptionLabel.alpha = 1
        }
    }
    
    public func hideDescription(duration: TimeInterval) {
        UIView.animate(withDuration: duration) {
            self.descriptionLabel.alpha = 0
        }
    }
}

// MARK: - Helpers
extension SearchDetailPresentTransitionView {
    public static func getFromNib() -> SearchDetailPresentTransitionView? {
        guard let searchDetailPresentTransitionView = UINib.init(nibName: "SearchDetailPresentTransitionView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? SearchDetailPresentTransitionView else { return nil }
        return searchDetailPresentTransitionView
    }
    
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
        self.layoutIfNeeded()
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
        self.layoutIfNeeded()
    }
}
