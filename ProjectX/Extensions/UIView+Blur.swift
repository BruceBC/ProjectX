//
//  UIView+Extensions.swift
//  ProjectX
//
//  Created by Bruce Colby on 7/13/18.
//  Copyright © 2018 AmTrust. All rights reserved.
//

import UIKit

typealias VibrancyEffectConstraints = (_ view: UIView, _ vibrancyView: UIVisualEffectView) -> Void

class VibrancyControls {
    let view: UIView
    let constraints: VibrancyEffectConstraints
    
    init(view: UIView, constraints: @escaping VibrancyEffectConstraints) {
        self.view = view
        self.constraints = constraints
    }
}

extension UIView {
    func blur(_ effectStyle: UIBlurEffectStyle = .light, controls: [VibrancyControls] = []) {
        // Check accessibility
        guard UIAccessibilityIsReduceTransparencyEnabled() == false else { return }
        
        // Blur
        self.backgroundColor = .clear
        let blurEffect = UIBlurEffect(style: effectStyle)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        self.insertSubview(blurView, at: 0)
        
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: blurView, attribute: .top,  relatedBy: .equal, toItem: self, attribute: .top,  multiplier: 1, constant: 0),
            NSLayoutConstraint(item: blurView, attribute: .leading,  relatedBy: .equal, toItem: self, attribute: .leading,  multiplier: 1, constant: 0),
            NSLayoutConstraint(item: blurView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: blurView, attribute: .bottom,   relatedBy: .equal, toItem: self, attribute: .bottom,   multiplier: 1, constant: 0)
        ])
        
        controls.forEach { $0.view.vibrancy(blurEffect, blurView: blurView, constraints: $0.constraints) }
    }
    
    private func vibrancy(_ blurEffect: UIBlurEffect, blurView: UIVisualEffectView, constraints: @escaping VibrancyEffectConstraints) {
        // Vibrancy
        let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)
        let vibrancyView = UIVisualEffectView(effect: vibrancyEffect)
        vibrancyView.translatesAutoresizingMaskIntoConstraints = false
        vibrancyView.contentView.addSubview(self)
        blurView.contentView.addSubview(vibrancyView)
        
        NSLayoutConstraint.activate([
            vibrancyView.heightAnchor.constraint(equalTo:  blurView.contentView.heightAnchor),
            vibrancyView.widthAnchor.constraint(equalTo:   blurView.contentView.widthAnchor),
            vibrancyView.centerXAnchor.constraint(equalTo: blurView.contentView.centerXAnchor),
            vibrancyView.centerYAnchor.constraint(equalTo: blurView.contentView.centerYAnchor)
        ])
        
        // Apply constraints
        constraints(self, vibrancyView)
    }
}
