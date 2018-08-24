//
//  PersonDetailViewController.swift
//  ProjectX
//
//  Created by Bruce Colby on 8/23/18.
//  Copyright © 2018 AmTrust. All rights reserved.
//

import UIKit

struct PhotoViewModel {
    let image: UIImage
    
    init(image: UIImage) {
        self.image = image
    }
}

class PersonDetailViewController: UIViewController {
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
    var personDetailModel: PersonDetailViewModel?
    lazy var photos = self.loadModels()
    var defaultFollowButtonWidth = CGFloat(167.5)
    var defaultFollowButtonHeight = CGFloat(45)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTransition()
        setupFollowerView()
        setupBottomView()
        setupButtons()
        setupTabBar()
        setupPersonDetailModel()
    }
}

// MARK: - Setup
extension PersonDetailViewController {
    private func setupTransition() {
//        self.transitioningDelegate = self
    }
    
    private func loadModels() -> [PhotoViewModel] {
        var photos: [PhotoViewModel] = []
        
        for _ in 0..<10 {
            photos.append(PhotoViewModel(image: #imageLiteral(resourceName: "trainGuy")))
        }
        
        return photos
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
    
    private func setupTabBar() {
        guard let customTabBar = CustomTabBar.getFromNib() else { return }
        self.view.addSubview(customTabBar)
        customTabBar.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: customTabBar, attribute: .height,  relatedBy: .equal, toItem: nil, attribute: .height,  multiplier: 1, constant: customTabBar.frame.height),
            NSLayoutConstraint(item: customTabBar, attribute: .leading,  relatedBy: .equal, toItem: view, attribute: .leading,  multiplier: 1, constant: 0),
            NSLayoutConstraint(item: customTabBar, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: customTabBar, attribute: .bottom,   relatedBy: .equal, toItem: view, attribute: .bottom,   multiplier: 1, constant: 0)
        ])
    }
    
    private func setupPersonDetailModel() {
        guard let model = personDetailModel else { return }
        nameLabel.text        = model.name
        stateLabel.text       = model.state
        descriptionLabel.text = model.description
        imageView.image       = model.image
    }
}

// MARK: Collection View
extension PersonDetailViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    var photoReuseIdentifier: String {
        return "photoCell"
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: photoReuseIdentifier, for: indexPath) as? PhotoCell else { return UICollectionViewCell() }
        cell.imageView.image = nil
        
        let model = photos[indexPath.row]
        cell.setup(model)
        
        return cell
    }
}

// MARK: Transition Delegate
//extension PersonDetailViewController: UIViewControllerTransitioningDelegate {
//    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        return DetailPresentAnimationController(bottomView)
//    }
//}
