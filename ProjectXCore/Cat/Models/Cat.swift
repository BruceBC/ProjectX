//
//  Cat.swift
//  ProjectXCore
//
//  Created by Bruce Colby on 8/10/18.
//  Copyright © 2018 AmTrust. All rights reserved.
//

import Foundation
import SWXMLHash

public struct Cat {
    public let images: [CatImage]
    
    enum CodingKeys: String, CodingKey {
        case images
        case response
        case data
    }
    
    static func make(images: XMLIndexer) -> Cat {
        let catImages: [CatImage] = images.all.map { CatImage.make(image: $0) }
        
        return Cat(images: catImages)
    }
}
