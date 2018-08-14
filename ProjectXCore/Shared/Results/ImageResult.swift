//
//  ImageResult.swift
//  ProjectXCore
//
//  Created by Bruce Colby on 8/14/18.
//  Copyright © 2018 AmTrust. All rights reserved.
//

import Foundation

public enum ImageResult {
    case success(UIImage, Bool)
    case failure(Error)
}
