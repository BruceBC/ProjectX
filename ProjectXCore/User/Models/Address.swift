//
//  Address.swift
//  ProjectXCore
//
//  Created by Bruce Colby on 7/10/18.
//  Copyright © 2018 AmTrust. All rights reserved.
//

import Foundation

public struct Address {
    public let street: String
    public let city:   String
    public let state:  String
    public let zip:    String
    
    enum CodingKeys: String, CodingKey
    {
        case street
        case city
        case state
        case zip = "postcode"
    }
}

extension Address: Decodable {
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        street = try values.decode(String.self, forKey: .street)
        city = try values.decode(String.self, forKey: .city)
        state = try values.decode(String.self, forKey: .state)
        zip = try values.decode(String.self, forKey: .state)
    }
}
