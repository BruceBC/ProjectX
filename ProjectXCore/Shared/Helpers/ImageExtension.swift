//
//  ImageExtension.swift
//  ProjectXCore
//
//  Created by Bruce Colby on 8/10/18.
//  Copyright © 2018 AmTrust. All rights reserved.
//

import UIKit
import SwiftyGif

enum ImageExtension {
    case standard(String)
    case gif(String)
    
    static func get(_ url: String) -> ImageExtension {
        if url.split(separator: ".").last == "gif" {
            return ImageExtension.gif(url)
        }
        
        return ImageExtension.standard(url)
    }
    
    func image(_ completion: @escaping ImageCompletion) {
        switch self {
        case .standard(let url):
            return stanardImage(url, completion: completion)
        case .gif(let url):
            return gifImage(url, completion: completion)
        }
    }
    
    private func stanardImage(_ url: String, completion: @escaping ImageCompletion) {
        loadImageUrlAsync(url) { data in
            DispatchQueue.main.async {
                guard let image = UIImage(data: data) else {
                    completion(self.error("Image not found."))
                    return
                }
                
                completion(ImageResult.success(image, false))
            }
        }
    }
    
    private func gifImage(_ url: String, completion: @escaping ImageCompletion) {
        loadImageUrlAsync(url) { data in
            DispatchQueue.main.async {
                completion(ImageResult.success(UIImage(gifData: data), true))
            }
        }
    }
}

extension ImageExtension {
    private func loadImageUrlAsync(_ url: String, completion: @escaping DataCompletion) {
        guard let imageUrl = URL(string: url) else { return }
        URLSession.shared.dataTask(with: imageUrl) { (data, response, error) in
            guard let data = data else {
                if let error = error { print(error.localizedDescription) }
                return
            }
            completion(data)
            }.resume()
    }
    
    private func error(_ message: String) -> ImageResult {
        return ImageResult.failure(ImageError.empty(message))
    }
}
