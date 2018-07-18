//
//  LaunchViewController.swift
//  ProjectX
//
//  Created by Bruce Colby on 7/18/18.
//  Copyright © 2018 AmTrust. All rights reserved.
//

import UIKit

class LaunchViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNotifications()
    }
}

// MARK: - Setup
extension LaunchViewController {
    func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(didFetchUsers), name: .didFetchUsers, object: nil)
    }
}

// MARK: - Listeners
extension LaunchViewController {
    @objc func didFetchUsers() {
        performSegue(withIdentifier: SegueIdentifiers.showHomeTabBarViewController, sender: self)
    }
}

// MARK: - Navigation {
extension LaunchViewController {
    private struct SegueIdentifiers {
        static let showHomeTabBarViewController = "showHomeTabBarViewController"
    }
}
