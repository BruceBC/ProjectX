//
//  UIButton+Extensions.swift
//  ProjectX
//
//  Created by Bruce Colby on 7/13/18.
//  Copyright © 2018 AmTrust. All rights reserved.
//

import UIKit

extension UIButton {
    func setImageColor(_ color: UIColor, for state: UIControlState = .normal) {
        let image = self.image(for: state)?.withRenderingMode(.alwaysTemplate)
        self.setImage(image, for: state)
        self.tintColor = color
    }
    
    func simulateTouch() {
        self.addTarget(self, action: #selector(pressed), for: .touchDown)
        self.addTarget(self, action: #selector(released), for: .touchUpInside)
        self.addTarget(self, action: #selector(released), for: .touchUpOutside)
    }
    
    @objc private func pressed() {
        UIView.animate(withDuration: 0.3) {
            self.alpha = 0.5
        }
    }
    
    @objc private func released() {
        UIView.animate(withDuration: 0.3) {
            self.alpha = 1
        }
    }
}
