//
//  Examples.swift
//  ProjectX
//
//  Created by Bruce Colby on 7/13/18.
//  Copyright © 2018 AmTrust. All rights reserved.
//

import UIKit

/*
 * Add a blur effect to a view and a vibrancy effect to it's controls
 */
fileprivate func setupMainView() {
    // ====   Setup   ====
    let mainView =     UIView() // Example: UIViewController().view
    let controlsView = UIView() // Example mainView.stackView
    // ==== Setup End ====
    
    let controls = [
        VibrancyControls(view: controlsView) { (view, vibrancyView) in
            NSLayoutConstraint.activate([
                NSLayoutConstraint(item: view, attribute: .height,   relatedBy: .equal, toItem: nil, attribute: .height,   multiplier: 1, constant: 35),
                NSLayoutConstraint(item: view, attribute: .top,      relatedBy: .equal, toItem: vibrancyView, attribute: .top,  multiplier: 1, constant: 15),
                NSLayoutConstraint(item: view, attribute: .leading,  relatedBy: .equal, toItem: vibrancyView, attribute: .leading,  multiplier: 1, constant: 25),
                NSLayoutConstraint(item: view, attribute: .trailing, relatedBy: .equal, toItem: vibrancyView, attribute: .trailing, multiplier: 1, constant: -25)
                ])
        }
    ]
    
    mainView.blur(.dark, controls: controls)
}
