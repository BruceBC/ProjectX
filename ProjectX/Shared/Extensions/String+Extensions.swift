//
//  String+Extensions.swift
//  ProjectX
//
//  Created by Bruce Colby on 7/16/18.
//  Copyright © 2018 AmTrust. All rights reserved.
//

import Foundation

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
    
    func capitalizeEveryFirstLetter() -> String {
        return components(separatedBy: " ").map { $0.capitalizingFirstLetter() }.joined(separator: " ")
    }
}
