//
//  CatsAPI.swift
//  ProjectXCore
//
//  Created by Bruce Colby on 8/10/18.
//  Copyright © 2018 AmTrust. All rights reserved.
//

import Foundation
import Alamofire

enum CatsAPI: Routable {
    case images
    
    var baseUrl: String {
        return "http://thecatapi.com/api/images"
    }
    
    var method: HTTPMethod {
        switch self {
        case .images:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .images:
            return "/get"
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .images:
            return [
                "format"          : "xml",
                "results_per_page": 20
            ]
        }
    }
    
    // MARK: - Encoding
    var encoding: ParameterEncoding {
        switch method {
        case .get:
            return URLEncoding.default
        default:
            return JSONEncoding.default
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = try baseUrl.asURL()
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        
        // HTTP Method
        urlRequest.httpMethod = method.rawValue
        
        // Common Headers
        urlRequest.setValue(ContentType.xml.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        
        // Parameters
        switch method {
        case .get:
            urlRequest = try encoding.encode(urlRequest, with: parameters)
        default:
            // TODO: Check if I need this when posting data
            if let parameters = parameters {
                do {
                    urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
                } catch {
                    throw AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))
                }
            }
        }
        
        return urlRequest
    }
}
