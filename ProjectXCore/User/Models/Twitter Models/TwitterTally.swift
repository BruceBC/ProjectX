//
//  TwitterTally.swift
//  ProjectXCore
//
//  Created by Bruce Colby on 7/18/18.
//  Copyright © 2018 AmTrust. All rights reserved.
//

import Foundation

public class TwitterTally {
    public var title: String
    public var count: Double
    
    public init(title: String, count: Double) {
        self.title = title
        self.count = count
    }
    
    public var prettyCount: String {
        return count.toString()
    }
}

fileprivate extension Double {
    func toString() -> String {
        if self >= 1000 && self <= 9999 {
            return "\(String(format: "%.1f", Double(self/1000).roundTo(places: 3)))k" // "2.8k"
        }
        
        return "\(Int(self))"
    }
    
    func roundTo(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
