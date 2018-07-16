//
//  ImageViewController.swift
//  ProjectX
//
//  Created by Bruce Colby on 7/13/18.
//  Copyright © 2018 AmTrust. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    // MARK: Properties
    var profile: ProfileViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButtons()
        setupImageView()
    }
}

// MARK: - Setup
extension ImageViewController {
    func setupButtons() {
        profileButton.setImageColor(.white)
        cancelButton.setImageColor(.white)
    }
    
    func setupImageView() {
        guard let profile = profile else { return }
        imageView.image = profile.image
    }
}
