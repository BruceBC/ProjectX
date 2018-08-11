//
//  ImageExtension.swift
//  ProjectXCore
//
//  Created by Bruce Colby on 8/10/18.
//  Copyright © 2018 AmTrust. All rights reserved.
//

import UIKit

enum ImageExtension {
    case standard(String)
    case gif(String)
    
    func image() -> UIImage? {
        switch self {
        case .standard(let url):
            return stanardImage(url)
        case .gif(let url):
            return gifImage(url)
        }
    }
    
    static func get(_ url: String) -> ImageExtension {
        if url.split(separator: ".").last == "gif" {
            return ImageExtension.gif(url)
        }
        
        return ImageExtension.standard(url)
    }
    
    private func stanardImage(_ url: String) -> UIImage? {
        guard
            let imageUrl  = URL(string: url),
            let imageData = try? Data(contentsOf: imageUrl),
            let image     = UIImage(data: imageData)
            else { return nil }
        
        
        
//        URLSession.shared.dataTask(with: imageUrl) { (data, response, error) in
//            guard error == nil else { return }
//            
//            DispatchQueue.main.async {
//                
//            }
//        }
        
        
        return image
    }
    
    private func gifImage(_ url: String) -> UIImage? {
        return UIImage.gifImageWithURL(url)
    }
}
