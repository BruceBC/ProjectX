//
//  Shared.swift
//  ProjectX
//
//  Created by Bruce Colby on 7/16/18.
//  Copyright © 2018 AmTrust. All rights reserved.
//

import Foundation
import ProjectXCore

class StateManager {
    // MARK: - Properties
    static let shared = StateManager()
    
    // MARK: -
    var users: [User] = []
}
