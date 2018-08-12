//
//  ListViewModel.swift
//  ProjectX
//
//  Created by Bruce Colby on 8/9/18.
//  Copyright © 2018 AmTrust. All rights reserved.
//

import UIKit

struct ListViewModel {
    let image: UIImage
    let url:   String?
    let isGif: Bool
    
    init(image: UIImage, url: String?, isGif: Bool) {
        self.image = image
        self.url   = url
        self.isGif = isGif
    }
}
