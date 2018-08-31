//
//  SearchDetailPresentTransitionViewModel.swift
//  ProjectX
//
//  Created by Bruce Colby on 8/31/18.
//  Copyright © 2018 AmTrust. All rights reserved.
//

import UIKit

struct SearchDetailPresentTransitionViewModel {
    let name:        String
    let location:    String
    let description: String
    let image:       UIImage
    
    init(name: String, location: String, description: String, image: UIImage) {
        self.name        = name
        self.location    = location
        self.description = description
        self.image       = image
    }
}
