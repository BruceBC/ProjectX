//
//  ViewController.swift
//  ProjectX
//
//  Created by Bruce Colby on 7/10/18.
//  Copyright © 2018 AmTrust. All rights reserved.
//

import UIKit
import ProjectXCore
import Alamofire

fileprivate enum Interactor {
    case userSuccess(User)
}

class SearchViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var followerView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var bottomInnerView: UIView!
    @IBOutlet weak var followerStackView: UIStackView!
    @IBOutlet weak var followerCountLabel: UILabel!
    @IBOutlet weak var followerLabel: UILabel!
    @IBOutlet weak var postCountLabel: UILabel!
    @IBOutlet weak var postLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var followButtonWidthConstraint:  NSLayoutConstraint!
    @IBOutlet weak var followButtonHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomViewBottomConstraint:   NSLayoutConstraint!
    @IBOutlet weak var bottomInnerViewTopConstraint: NSLayoutConstraint!
    
    // MARK: - Properties
    typealias userGetterInteractor = UserGetterInteractor
    var swipeInteractionController: SearchSwipePresentInteractionController?
    var searchDetailViewController: SearchDetailViewController?
    var currentIndex = 0
    var defaultFollowButtonWidth = CGFloat(167.5)
    var defaultFollowButtonHeight = CGFloat(45)
    
    // MARK: - Computed Properties
    override var prefersStatusBarHidden: Bool { return true }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTransitions()
        setupNotifications()
        setupFollowerView()
        setupLabels(user: StateManager.shared.users.first) // Call before bottomView
        setupBottomView()
        setupButtons()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        updateFollowingState()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    // MARK: - IBActions
    @IBAction func followAction(_ sender: Any) {
        let user                                                    = StateManager.shared.users[currentIndex]
        let isFollowing                                             = !user.twitter.isFollowing
        StateManager.shared.users[currentIndex].twitter.isFollowing = isFollowing
        
        if isFollowing {
            followerAddedAnimation()
        } else {
            followerRemovedAnimation()
        }
    }
    
}

// MARK: - Setup
extension SearchViewController {
    func setupTransitions() {
        // push/pop
        //https://stackoverflow.com/questions/45693684/the-navigation-controller-delegate-method-is-not-getting-a-call
        self.navigationController?.delegate = self
        swipeInteractionController = SearchSwipePresentInteractionController(from: self, to: SegueIdentifiers.showSearchDetailViewController, view: bottomView)
    }
    
    func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(didSwipe(_:)), name: .didSwipe, object: nil)
    }
    
    func setupFollowerView() {
        followerView.blur(.dark)
    }
    
    func setupBottomView() {
        bottomView.layer.masksToBounds = true
        bottomView.roundCorners(corners: [.topLeft, .topRight], size: 35)
        
        // Hide bottom view
        bottomViewBottomConstraint.constant = -bottomView.frame.height
        self.view.layoutIfNeeded()
        
        // Animate
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            if let tc = self.tabBarController as? HomeTabBarViewController, let customTabBar = tc.customTabBar {
                self.bottomViewBottomConstraint.constant = (customTabBar.frame.height / 2) - 50

                let animation = {self.view.layoutIfNeeded()}
                let completion = {(_:Bool) in self.setupUser()}

                UIView.animate(withDuration: 1,
                               delay: 0,
                               usingSpringWithDamping: 0.5,
                               initialSpringVelocity: 1,
                               options: .curveEaseInOut,
                               animations: animation,
                               completion: completion)
            }
        }
    }
    
    func setupLabels(user: User?) {
        guard let user                = user else { return }
        self.nameLabel.text           = "\(user.firstName.capitalizingFirstLetter()) \(user.lastName.capitalizingFirstLetter())"
        self.locationLabel.text       = user.address.state.capitalizeEveryFirstLetter()
        self.followerCountLabel.text  = user.twitter.followers.prettyCount
        self.followerLabel.text       = user.twitter.followers.title
        self.postCountLabel.text      = user.twitter.posts.prettyCount
        self.postLabel.text           = user.twitter.posts.title
        self.followingCountLabel.text = user.twitter.following.prettyCount
        self.followingLabel.text      = user.twitter.following.title
    }
    
    func setupButtons() {
        followButton.layer.masksToBounds = true
        followButton.layer.borderWidth = 2
        followButton.layer.borderColor = followButton.titleColor(for: .normal)?.cgColor
        followButton.layer.cornerRadius = defaultFollowButtonHeight / 2
    }
    
    func setupUser() {
        //getUser()
    }
}

// MARK: - UI Updates
extension SearchViewController {
    private func updateFollowingState() {
        let user = StateManager.shared.users[self.currentIndex]
        
        if user.twitter.isFollowing {
            self.isFollowingButton()
        } else {
            self.isNotFollowingButton()
        }
        
        // Update follower counter
        self.followerCountLabel.text = StateManager.shared.users[currentIndex].twitter.followers.prettyCount
    }
}

// MARK: Network Handlers
extension SearchViewController {
    func getUser() {
        userGetterInteractor.getUser { result in
            switch result {
            case .success(let user):
                self.onSuccess(Interactor.userSuccess(user))
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    fileprivate func onSuccess(_ interactor: Interactor) {
        switch interactor {
        case .userSuccess(let user):
            getUserSuccess(user)
        }
    }
    
    private func getUserSuccess(_ user: User) {
        // (Harcoded: b/c otherwise it won't keep its original position if user swipes really fast)
        let bottomInnerViewTop: CGFloat = 40 // bottomInnerViewTopConstraint.constant
        let (followerViewShrink, followerViewEnlarge) = followViewAnimations()

        // (Harcoded: b/c otherwise it won't keep its original position if user swipes really fast)
        bottomInnerViewTopConstraint.constant = 60 // bottomInnerView.frame.size.height
        
        // Define Animations
        let shrink = {
            self.bottomInnerView.alpha = 0
            
            followerViewShrink()
            
            self.view.layoutIfNeeded()
        }
        
        let enlarge = {
            self.bottomInnerView.alpha = 1

            followerViewEnlarge()
            
            self.view.layoutIfNeeded()
        }
        
        let shrinkCompletion = { (done: Bool) in
            self.setupLabels(user: user)
            self.bottomInnerViewTopConstraint.constant = bottomInnerViewTop
            UIView.animate(withDuration: 0.3, animations: enlarge)
        }
        
        // Begin Animation
        UIView.animate(withDuration: 0.3, animations: shrink, completion: shrinkCompletion)
    }
    
    private func followViewAnimations() -> (VoidAction, VoidAction) {
        let y: CGFloat = 15

        // Define Animations
        let shrink = {
            // Alpha
            self.followerCountLabel.alpha  = 0
            self.followerLabel.alpha       = 0
            self.postCountLabel.alpha      = 0
            self.postLabel.alpha           = 0
            self.followingCountLabel.alpha = 0
            self.followingLabel.alpha      = 0
            
            // Y Position
            self.followerCountLabel.center.y  = self.followerCountLabel.center.y + y
            self.followerLabel.center.y       = self.followerLabel.center.y + y
            self.postCountLabel.center.y      = self.postCountLabel.center.y + y
            self.postLabel.center.y           = self.postLabel.center.y + y
            self.followingCountLabel.center.y = self.followingCountLabel.center.y + y
            self.followingLabel.center.y      = self.followingLabel.center.y + y

            self.view.layoutIfNeeded()
        }
        
        let enlarge = {
            // Alpha
            self.followerCountLabel.alpha  = 1
            self.followerLabel.alpha       = 1
            self.postCountLabel.alpha      = 1
            self.postLabel.alpha           = 1
            self.followingCountLabel.alpha = 1
            self.followingLabel.alpha      = 1
            
            // Y Position
            self.followerCountLabel.center.y  = self.followerCountLabel.center.y - y
            self.followerLabel.center.y       = self.followerLabel.center.y - y
            self.postCountLabel.center.y      = self.postCountLabel.center.y - y
            self.postLabel.center.y           = self.postLabel.center.y - y
            self.followingCountLabel.center.y = self.followingCountLabel.center.y - y
            self.followingLabel.center.y      = self.followingLabel.center.y - y
            
            self.view.layoutIfNeeded()
        }
        
        return (shrink, enlarge)
    }
}

// MARK: - Listeners
extension SearchViewController {
    @objc func didSwipe(_ notification: Notification) {
        guard
            let user  = notification.userInfo?["user"] as? User,
            let index = notification.userInfo?["index"] as? Int
        else { return }
        currentIndex = index
        getUserSuccess(user)
    }
}

// MARK: Navigation
extension SearchViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIdentifiers.showSearchDetailViewController {
            guard let vc               = segue.destination as? SearchDetailViewController else { return }
            vc.transitioningDelegate   = self // modal
            vc.model                   = searchDetailPresentTransitionModel
            vc.index                   = currentIndex
            searchDetailViewController = vc
        }
    }
}

// MARK: Modal Transition Delegate - This will only be fired when a modal or it's equivalent is presented or dismissed
extension SearchViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        var frame = bottomView.frame
        frame.origin.y = followerView.frame.origin.y
        return SearchDetailPresentAnimationController(bottomView.frame, model: searchDetailPresentTransitionModel, index: currentIndex, interactionController: self.swipeInteractionController)
    }
}

// MARK: - Navigation Transition Delegate - This will only be fired when a view controller is pushed or popped
//https://stackoverflow.com/questions/45910210/how-to-apply-custom-transition-animation-in-uinavigationcontrollerdelegate-to-sp
extension SearchViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch operation {
        case .none:
            return nil
        case .push:
            if toVC is SearchDetailViewController {
                var frame = bottomView.frame
                frame.origin.y = followerView.frame.origin.y
                return SearchDetailPresentAnimationController(bottomView.frame, model: searchDetailPresentTransitionModel, index: currentIndex, interactionController: self.swipeInteractionController)
            }
            return nil
        case .pop:
            if toVC is SearchViewController {
                guard
                    let vc                     = searchDetailViewController,
                    let bottomView             = vc.bottomView,
                    let followView             = vc.followerView,
                    let descriptionLabel       = vc.descriptionLabel
                else { return nil }
                let interactionController  = vc.swipeInteractionController
                return SearchDetailDismissAnimationController(bottomView: bottomView, followView: followView, descriptionLabel: descriptionLabel, interactionController: interactionController)
            }
            return nil
        }
    }
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        // Present
        if let animator = animationController as? SearchDetailPresentAnimationController {
            guard
                let interactionController = animator.interactionController,
                interactionController.interactionInProgress
            else {
                return nil
            }
            
            return interactionController
        }
        
        // Dismiss
        if let animator = animationController as? SearchDetailDismissAnimationController {
            guard
                let interactionController = animator.interactionController,
                interactionController.interactionInProgress
            else {
                return nil
            }
            
            return interactionController
        }
        
        return nil
    }
}

// MARK: - Models
extension SearchViewController {
    var searchDetailPresentTransitionModel: SearchDetailPresentTransitionViewModel {
        let user = StateManager.shared.users[currentIndex]
        // TODO: These images shouldn't be hardcoded, but should be gotten from ImagePageViewController somehow
        let profileViewModel = [#imageLiteral(resourceName: "trainGuy"), #imageLiteral(resourceName: "sunglassesGirl"), #imageLiteral(resourceName: "cityBoy"), #imageLiteral(resourceName: "uncomfortableGirl")]
            .map { ImageViewModel(image: $0) }[currentIndex]
        
        return SearchDetailPresentTransitionViewModel.makeModel(
            user:        user,
            description: "Photographer at 'Le Monde', blogger and freelance journalist",
            image:       profileViewModel.image
        )
    }
}

// MARK: - Helpers
extension SearchViewController {
    func isFollowingButton() {
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
    
    func isNotFollowingButton() {
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
    
    func followerAddedAnimation() {
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
                self.followerCountLabel.text = StateManager.shared.users[self.currentIndex].twitter.followers.prettyCount
            }
            
            UIView.animate(withDuration: 0.3, animations: animation, completion: completion)
        }
        
        UIView.animate(withDuration: 0.6, animations: animation, completion: completion)
    }
    
    func followerRemovedAnimation() {
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
                    self.followerCountLabel.text = StateManager.shared.users[self.currentIndex].twitter.followers.prettyCount
                }
                
                UIView.animate(withDuration: 0.3, animations: animation, completion: completion)
            }
            
            UIView.animate(withDuration: 0.6, animations: animation, completion: completion)
        }
        
        UIView.animate(withDuration: 0.3, animations: animation, completion: completion)
    }
}
