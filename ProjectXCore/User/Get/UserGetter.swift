//
//  UserGetter.swift
//  ProjectXCore
//
//  Created by Bruce Colby on 7/10/18.
//  Copyright © 2018 AmTrust. All rights reserved.
//

import Foundation
import Alamofire

public typealias UserGetterCompletion = (Result<User>) -> Void

public protocol UserGetter {
    static func getUser(completion: @escaping UserGetterCompletion)
}
