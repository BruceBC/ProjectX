//
//  CatService.swift
//  ProjectXCore
//
//  Created by Bruce Colby on 8/10/18.
//  Copyright © 2018 AmTrust. All rights reserved.
//

import Foundation
import Alamofire

public typealias CatServiceCompletion = (XMLResult<Cat>) -> Void

public protocol CatService {
    static func getImages(completion: @escaping CatServiceCompletion)
}
