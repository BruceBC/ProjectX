//
//  UIImageView+Extensions.swift
//  ProjectX
//
//  Created by Bruce Colby on 7/13/18.
//  Copyright © 2018 AmTrust. All rights reserved.
//

import UIKit

extension UIImageView {
    func setColor(_ color: UIColor) {
        let image = self.image?.withRenderingMode(.alwaysTemplate)
        self.image = image
        self.tintColor = color
    }
}
