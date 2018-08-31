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
    @IBOutlet weak var followButton:          UIButton!
    @IBOutlet weak var nameLabel:             UILabel!
    @IBOutlet weak var stateLabel:            UILabel!
    @IBOutlet weak var descriptionLabel:      UILabel!
    @IBOutlet weak var followerView:          UIView!
    @IBOutlet weak var bottomView:            UIView!
    @IBOutlet weak var placeholder1ImageView: UIImageView!
    @IBOutlet weak var placeholder2ImageView: UIImageView!
    @IBOutlet weak var placeholder3ImageView: UIImageView!
    @IBOutlet weak var placeholder4ImageView: UIImageView!
    
    // MARK: Properties
    var defaultFollowButtonWidth = CGFloat(167.5)
    var defaultFollowButtonHeight = CGFloat(45)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupBottomView()
        setupButtons()
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
        followButton.layer.masksToBounds = true
        followButton.layer.borderWidth   = 2
        followButton.layer.borderColor   = followButton.titleColor(for: .normal)?.cgColor
        followButton.layer.cornerRadius  = defaultFollowButtonHeight / 2
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
    
    func setup(with model: SearchDetailPresentTransitionViewModel) {
        nameLabel.text        = model.name
        stateLabel.text       = model.location
        descriptionLabel.text = model.description
    }
}

// MARK: - Animation
extension SearchDetailPresentTransitionView {
    func showDescription(duration: TimeInterval) {
        UIView.animate(withDuration: duration) {
            self.descriptionLabel.alpha = 1
        }
    }
    
    func hideDescription(duration: TimeInterval) {
        UIView.animate(withDuration: duration) {
            self.descriptionLabel.alpha = 0
        }
    }
}

// MARK: - Helpers
extension SearchDetailPresentTransitionView {
    static func getFromNib() -> SearchDetailPresentTransitionView? {
        guard let searchDetailPresentTransitionView = UINib.init(nibName: "SearchDetailPresentTransitionView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? SearchDetailPresentTransitionView else { return nil }
        return searchDetailPresentTransitionView
    }
}
