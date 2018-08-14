//
//  CatImage.swift
//  ProjectXCore
//
//  Created by Bruce Colby on 8/10/18.
//  Copyright © 2018 AmTrust. All rights reserved.
//

import UIKit
import SWXMLHash

public struct CatImage: Codable {
    public let id:        String
    public let url:       String
    public let sourceUrl: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case url
        case sourceUrl = "source_url"
    }
    
    static func make(image: XMLIndexer) -> CatImage {
        guard
            let id        = image["id"].element?.text,
            let url       = image["url"].element?.text,
            let sourceUrl = image["source_url"].element?.text
        else {
            return CatImage.empty()
        }
        
        return CatImage(id: id, url: url, sourceUrl: sourceUrl)
    }
    
    static func empty() -> CatImage {
        return CatImage(id: "", url: "", sourceUrl: "")
    }
    
    public func imageAsync(completion: @escaping ImageCompletion) {
        ImageExtension.get(url).image(completion)
    }
}
