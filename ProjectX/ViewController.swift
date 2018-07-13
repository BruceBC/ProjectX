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

class ViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var followerView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var followerStackView: UIStackView!
    @IBOutlet weak var followerCountLabel: UILabel!
    @IBOutlet weak var followerLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var bottomViewBottomConstraint: NSLayoutConstraint!
    
    // MARK: - Properties
    typealias userGetterInteractor = UserGetterInteractor
    
    // MARK: - Computed Properties
    override var prefersStatusBarHidden: Bool { return true }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFollowerView()
        setupBottomView()
        setupLabels()
        setupButtons()
    }
}

// MARK: - Setup
extension ViewController {
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
    
    func setupLabels() {
    
    }
    
    func setupButtons() {
        followButton.layer.masksToBounds = true
        followButton.layer.borderWidth = 2
        followButton.layer.borderColor = followButton.titleColor(for: .normal)?.cgColor
        followButton.layer.cornerRadius = followButton.frame.width / 8
        
        profileButton.setImageColor(.white)
        cancelButton.setImageColor(.white)
    }
    
    func setupUser() {
        getUser()
    }
}

// MARK: Network Handlers
extension ViewController {
    
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
        let (x1, x2) = (self.nameLabel.center.x, self.locationLabel.center.x)
        
        // Define Animations
        let shrink = {
            self.nameLabel.center.x = -self.nameLabel.frame.width
            self.locationLabel.center.x = -self.locationLabel.frame.width
            self.view.layoutIfNeeded()
        }
        
        let enlarge = {
            self.nameLabel.center.x = x1
            self.locationLabel.center.x = x2
            self.view.layoutIfNeeded()
        }
        
        let completion = { (_: Bool) in
            self.nameLabel.text     = "\(user.firstName.capitalizingFirstLetter()) \(user.lastName.capitalizingFirstLetter())"
            self.locationLabel.text = user.address.state.capitalizeEveryFirstLetter()
            UIView.animate(withDuration: 0.6, animations: enlarge)
        }
        
        // Begin Animation
        UIView.animate(withDuration: 0.6, animations: shrink, completion: completion)
    }
}

extension UIView {
    func fadeTransition(_ duration: CFTimeInterval) {
        let animation = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name:
            kCAMediaTimingFunctionEaseInEaseOut)
        animation.type = kCATransitionFade
        animation.duration = duration
        layer.add(animation, forKey: kCATransitionFade)
    }
}

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
    
    func capitalizeEveryFirstLetter() -> String {
        return components(separatedBy: " ").map { $0.capitalizingFirstLetter() }.joined(separator: " ")
    }
}
