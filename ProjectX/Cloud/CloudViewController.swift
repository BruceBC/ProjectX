//
//  CloudViewController.swift
//  ProjectX
//
//  Created by Bruce Colby on 8/31/18.
//  Copyright © 2018 AmTrust. All rights reserved.
//

import UIKit

class CloudViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
}
