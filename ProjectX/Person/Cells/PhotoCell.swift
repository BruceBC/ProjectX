//
//  PhotoCell.swift
//  ProjectX
//
//  Created by Bruce Colby on 8/23/18.
//  Copyright © 2018 AmTrust. All rights reserved.
//

import UIKit

class PhotoCell: UICollectionViewCell {
    // MARK: - IBOutlets
    @IBOutlet weak var imageView: UIImageView!
}

// MARK: - Setup
extension PhotoCell {
    func setup(_ model: PhotoViewModel) {
        imageView.image = model.image
    }
}
