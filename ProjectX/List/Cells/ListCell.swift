//
//  ListCell.swift
//  ProjectX
//
//  Created by Bruce Colby on 8/9/18.
//  Copyright © 2018 AmTrust. All rights reserved.
//

import UIKit

class ListCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
}

extension ListCell {
    func setup(with model: ListViewModel) {
        imageView.image = model.image
    }
}
