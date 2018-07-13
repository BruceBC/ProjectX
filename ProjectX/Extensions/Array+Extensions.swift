//
//  Array+Extensions.swift
//  ProjectX
//
//  Created by Bruce Colby on 7/13/18.
//  Copyright © 2018 AmTrust. All rights reserved.
//

import Foundation

extension Array {
    func find(_ index: Int) -> Element? {
        return self.enumerated().first { $0.offset == index }?.element
    }
}
