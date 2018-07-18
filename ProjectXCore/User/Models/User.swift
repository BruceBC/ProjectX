//
//  UserResponse.swift
//  ProjectXCore
//
//  Created by Bruce Colby on 7/10/18.
//  Copyright © 2018 AmTrust. All rights reserved.
//

import Foundation

public enum JSONError: Error {
    case empty(String)
}

public struct User {
    public let id:        String
    public let username:  String
    public let gender:    Gender
    public let firstName: String
    public let lastName:  String
    public let email:     String
    public let age:       Int
    public let dob:       Date
    public let phone:     String
    public let address:   Address
    public let picture:   Picture
    public var twitter:   Twitter
}

extension User: Decodable {
    public init(from decoder: Decoder) throws {
        let rawResponse = try RawUserResponse(from: decoder)
        guard let result = rawResponse.results.first else { throw JSONError.empty("No results") }
        
        id        = result.login.uuid
        username  = result.login.username
        gender    = result.gender
        firstName = result.name.first
        lastName  = result.name.last
        email     = result.email
        age       = result.dob.age
        dob       = result.dob.date
        phone     = result.phone
        address   = result.location
        picture   = result.picture
        
        let followers = TwitterTally(title: "followers", count: Double(arc4random_uniform(2000)))
        let posts     = TwitterTally(title: "posts",     count: Double(arc4random_uniform(2000)))
        let following = TwitterTally(title: "following", count: Double(arc4random_uniform(2000)))

        twitter = Twitter(followers: followers, posts: posts, following: following)
    }
}

// MARK: - Raw Response
fileprivate struct RawUserResponse: Decodable {
    
    struct Results: Decodable {
        
        struct Name: Decodable {
            let first: String
            let last:  String
        }

        struct Login: Decodable {
            let uuid:     String
            let username: String
        }

        struct DOB: Decodable {
            let date: Date
            let age:  Int
        }

        let gender:   Gender
        let email:    String
        let phone:    String
        let location: Address
        let picture:  Picture
        let name:     Name
        let login:    Login
        let dob:      DOB
//
    }
    
    let results: [Results]
}
