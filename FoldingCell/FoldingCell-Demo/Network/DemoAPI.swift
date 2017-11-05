//
//  DemoAPI.swift
//  FoldingCell-Demo
//
//  Created by Ruiji Wang on 04/11/2017.
//  Copyright © 2017 Alex K. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

class DemoAPI: NSObject {
    
    static let urlString = "https://service.us.apiconnect.ibmcloud.com/gws/apigateway/api/f111b7428d4a0f9d4d050e668e42edc63568c784c21a81c9251e143b2bfb36a0/all_api/all_api?"
    
    static func getAllResponse(ID: String, completionHandler: @escaping (GetAllResponse?) -> Void) {
        let parameters = ["uname": ID]
        Alamofire.request(urlString, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                let allResponse = GetAllResponse(JSON: response.result.value as! [String:Any])
                completionHandler(allResponse)
            case .failure(let error):
                print(error)
                completionHandler(nil)
            }
        }

    }
}
