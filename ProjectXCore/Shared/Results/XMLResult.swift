//
//  XMLResult.swift
//  ProjectXCore
//
//  Created by Bruce Colby on 8/10/18.
//  Copyright © 2018 AmTrust. All rights reserved.
//

import Foundation

public enum XMLResult<T> {
    case success(T)
    case error(Error)
}
