//
//  ListDetailViewController.swift
//  ProjectX
//
//  Created by Bruce Colby on 9/4/18.
//  Copyright © 2018 AmTrust. All rights reserved.
//

import UIKit

class ListDetailViewController: UIViewController {
    // MARK: IBOutlets
    @IBOutlet weak var scrollView:     UIScrollView!
    @IBOutlet weak var imageView:      UIImageView!
    @IBOutlet weak var ghostImageView: UIImageView!
    @IBOutlet weak var cancelButton:   UIButton!
    
    // MARK: - Public Properties
    var image: UIImage?
    var isGif = false
    
    // MARK: - Overriden Properties
    override var prefersStatusBarHidden: Bool { return true }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScrollView()
        setupButtons()
        setupImageViews()
    }
    
    // MARK: - IBActions
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: Setup
extension ListDetailViewController {
    private func setupScrollView() {
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 6.0
    }
    
    private func setupButtons() {
        cancelButton.setImageColor(.white)
    }
    
    private func setupImageViews() {
        guard let image = image else { return }
        
        if isGif {
            imageView.setGifImage(image)
            ghostImageView.setGifImage(image)
        } else {
            imageView.image      = image
            ghostImageView.image = image
        }
        
        ghostImageView.alpha = 0.5
    }
}

// MARK: UIScrollViewDelegate
extension ListDetailViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
