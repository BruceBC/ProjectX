//
//  CustomTabBar.swift
//  ProjectX
//
//  Created by Bruce Colby on 7/12/18.
//  Copyright © 2018 AmTrust. All rights reserved.
//

import UIKit

typealias VoidAction = () -> Void

enum Tapped {
    case cloud(VoidAction)
    case search(VoidAction)
    case circlePlus(VoidAction)
    case notification(VoidAction)
    case message(VoidAction)
    
    func tap() {
        switch self {
        case .cloud(let action):
            action()
        case .search(let action):
            action()
        case .circlePlus(let action):
            action()
        case .notification(let action):
            action()
        case .message(let action):
            action()
        }
    }
}

class CustomTabBar: UIView {
    // MARK: - IBOutlets
    @IBOutlet weak var cloudButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var plusCircleButton: UIButton!
    @IBOutlet weak var notificationButton: UIButton!
    @IBOutlet weak var messageButton: UIButton!
    
    // MARK: - Properties
    var actions: [Tapped] = [.cloud({}), .search({}), .circlePlus({}), .notification({}), .message({})] {
        didSet {
            tap(1) // Set selected
        }
    }
    
    private var selected: UIColor {
        return #colorLiteral(red: 0.8392156863, green: 0.1882352941, blue: 0.1921568627, alpha: 1)
    }
    
    static func getFromNib() -> CustomTabBar? {
        guard let tabBarView = UINib.init(nibName: "CustomTabBar", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? CustomTabBar else { return nil }
        return tabBarView
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
        setupButtons()
    }
    
    // MARK: - IBActions
    @IBAction func cloudAction(_ sender: Any) {
        tap(0)
    }
    
    @IBAction func searchAction(_ sender: Any) {
        tap(1)
    }
    
    @IBAction func circlePlusAction(_ sender: Any) {
        tap(2)
    }
    
    @IBAction func notifcationAction(_ sender: Any) {
        tap(3)
    }
    
    @IBAction func messageAction(_ sender: Any) {
        tap(4)
    }
}

extension CustomTabBar {
    func setupViews() {
        self.roundCorners(corners: [.topLeft, .topRight], size: 35)
    }
    
    private func setupButtons() {
        defaultButtonColors()
        setCirclePlusButtonShadow()
    }
    
    private func defaultButtonColors() {
        cloudButton.setButtonColor()
        searchButton.setButtonColor()
        plusCircleButton.setButtonColor(.red)
        notificationButton.setButtonColor()
        messageButton.setButtonColor()
    }
    
    private func setCirclePlusButtonShadow() {
        plusCircleButton.layer.cornerRadius = plusCircleButton.frame.width / 2;
        plusCircleButton.layer.masksToBounds = false;
        plusCircleButton.layer.shadowColor = UIColor.red.cgColor
        plusCircleButton.layer.shadowOpacity = 0.2;
        plusCircleButton.layer.shadowRadius = 4;
        plusCircleButton.layer.shadowOffset = CGSize(width: 0, height: 8);
    }
    
    private func tap(_ index: Int) {
        guard let action = actions.find(index) else { return }
        switch action {
            case .cloud:
                defaultButtonColors()
                cloudButton.setButtonColor(selected)
            case .search:
                defaultButtonColors()
                searchButton.setButtonColor(selected)
            case .circlePlus:
                break
            case .notification:
                defaultButtonColors()
                notificationButton.setButtonColor(selected)
            case .message:
                defaultButtonColors()
                messageButton.setButtonColor(selected)
        }
        action.tap()
    }
}

fileprivate extension UIButton {
    func setButtonColor(_ color: UIColor = #colorLiteral(red: 0.568627451, green: 0.5647058824, blue: 0.5647058824, alpha: 1)) {
        self.setImageColor(color)
    }
}
