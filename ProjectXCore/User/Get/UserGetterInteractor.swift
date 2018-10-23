//
//  UserGetterInteractor.swift
//  ProjectXCore
//
//  Created by Bruce Colby on 7/10/18.
//  Copyright © 2018 AmTrust. All rights reserved.
//

import Foundation
import Alamofire

public class UserGetterInteractor: UserGetter {
    public static func getUser(completion: @escaping UserGetterCompletion) {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .iso8601
        AF.request(RandomAPI.person).responseJSONDecodable(decoder: jsonDecoder) { (response: DataResponse<User>) in
            completion(response.result)
        }
    }
}
