//
//  PersonDetail.swift
//  ProjectX
//
//  Created by Bruce Colby on 8/24/18.
//  Copyright © 2018 AmTrust. All rights reserved.
//

import UIKit

struct PersonDetailViewModel {
    let name:        String
    let state:       String
    let description: String
    let image:       UIImage
    
    init(name: String, state: String, description: String, image: UIImage) {
        self.name        = name
        self.state       = state
        self.description = description
        self.image       = image
    }
}

class PersonDetail: UIView {
    // MARK: - IBOutlets
    @IBOutlet weak var followButton:     UIButton!
    @IBOutlet weak var nameLabel:        UILabel!
    @IBOutlet weak var stateLabel:       UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var followerView: UIView!
    @IBOutlet weak var bottomView: UIView!
    
    
    // MARK: Properties
    var defaultFollowButtonWidth = CGFloat(167.5)
    var defaultFollowButtonHeight = CGFloat(45)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupBottomView()
        setupButtons()
        setupLabels()
        setupFollowerView()
    }
}

// MARK: - Setup
extension PersonDetail {
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
    
    func setup(with model: PersonDetailViewModel) {
        nameLabel.text        = model.name
        stateLabel.text       = model.state
        descriptionLabel.text = model.description
    }
}

// MARK: - Animation
extension PersonDetail {
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
extension PersonDetail {
    static func getFromNib() -> PersonDetail? {
        guard let personDetailView = UINib.init(nibName: "PersonDetail", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? PersonDetail else { return nil }
        return personDetailView
    }
}
