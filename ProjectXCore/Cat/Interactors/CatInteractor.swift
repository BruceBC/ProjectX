//
//  CatInteractor.swift
//  ProjectXCore
//
//  Created by Bruce Colby on 8/10/18.
//  Copyright © 2018 AmTrust. All rights reserved.
//

import Foundation
import Alamofire
import SWXMLHash

public class CatInteractor: CatService {
    public static func getImages(completion: @escaping CatServiceCompletion) {
        request(CatsAPI.images).response { (response: DefaultDataResponse) in
            if let data = response.data {
                let xml = SWXMLHash.parse(data)
                let images = xml["response"]["data"]["images"]["image"]
                let cat = Cat.make(images: images)
                let result = XMLResult.success(cat)
                completion(result)
            } else if let error = response.error {
                let result = XMLResult<Cat>.error(error)
                completion(result)
            } else {
                let error = XMLError.empty("Could not get cat images. Uh-Oh!!!!")
                let result = XMLResult<Cat>.error(error)
                completion(result)
            }
        }
    }
}
