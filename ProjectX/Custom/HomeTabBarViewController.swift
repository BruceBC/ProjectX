//
//  HomeTabBarViewController.swift
//  ProjectX
//
//  Created by Bruce Colby on 7/12/18.
//  Copyright © 2018 AmTrust. All rights reserved.
//

import UIKit

class HomeTabBar: UITabBar {
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var size = super.sizeThatFits(size)
        size.height = size.height + 25
        return size
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.barTintColor = .white
        self.roundCorners(corners: [.topLeft, .topRight], size: 35)
    }
}

class HomeTabBarViewController: UITabBarController {
    // MARK: IBOutlets
    lazy var customTabBar = CustomTabBar.getFromNib()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clear
        tabBar.isHidden = true
        
        if let customTabBar = customTabBar {
            self.view.addSubview(customTabBar)
            setupTabBarAutoLayout()
            customTabBar.actions = [
                .cloud({self.selectedIndex = 0}),
                .search({self.selectedIndex = 1}),
                .circlePlus({}),
                .notification({self.selectedIndex = 2}),
                .message({self.selectedIndex = 3})
            ]
        }
    }
}

// MARK: - Setup
extension HomeTabBarViewController {
    private func setupTabBarAutoLayout() {
        customTabBar?.translatesAutoresizingMaskIntoConstraints = false

        if let customTabBar = customTabBar {
            NSLayoutConstraint.activate([
                NSLayoutConstraint(item: customTabBar, attribute: .height,  relatedBy: .equal, toItem: nil, attribute: .height,  multiplier: 1, constant: customTabBar.frame.height),
                NSLayoutConstraint(item: customTabBar, attribute: .leading,  relatedBy: .equal, toItem: view, attribute: .leading,  multiplier: 1, constant: 0),
                NSLayoutConstraint(item: customTabBar, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: customTabBar, attribute: .bottom,   relatedBy: .equal, toItem: view, attribute: .bottom,   multiplier: 1, constant: 0)
            ])
        }
    }
}

extension UIView {
    func roundCorners(corners:UIRectCorner, size:CGFloat){
        let path = UIBezierPath(roundedRect:self.bounds,
                                byRoundingCorners:corners,
                                cornerRadii: CGSize(width: size, height:  size))
        
        let maskLayer = CAShapeLayer()
        
        maskLayer.path = path.cgPath
        self.layer.mask = maskLayer
    }
}
