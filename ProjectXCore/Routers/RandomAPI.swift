//
//  Router.swift
//  ProjectXCore
//
//  Created by Bruce Colby on 7/10/18.
//  Copyright © 2018 AmTrust. All rights reserved.
//

import Foundation
import Alamofire

enum RandomAPI: Routable {
    
    case person
    
    // MARK: - Base URL
    var baseUrl: String {
        return "https://randomuser.me"
    }
    
    // MARK: - HTTPMethod
    var method: HTTPMethod {
        switch self {
        case .person:
            return .get
        }
    }
    
    // MARK: - Path
    var path: String {
        switch self {
        case .person:
            return "/api/"
        }
    }
    
    // MARK: - Parameters
    var parameters: Parameters? {
        switch self {
        case .person:
            return nil
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = try baseUrl.asURL()
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        
        // HTTP Method
        urlRequest.httpMethod = method.rawValue
        
        // Common Headers
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.acceptType.rawValue)
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        
        // Parameters
        if let parameters = parameters {
            do {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
            } catch {
                throw AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))
            }
        }
        
        return urlRequest
    }
}
