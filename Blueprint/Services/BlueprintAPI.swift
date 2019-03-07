//
//  BlueprintAPI.swift
//  Blueprint
//
//  Created by Jay Lees on 26/02/2019.
//  Copyright © 2019 Manhattan. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireSwiftyJSON

public class BlueprintAPI {
    private static let baseURL = "http://smithwjv.ddns.net"
    private static let authenticateURL = "\(baseURL):8000/api/v1"
    private static let progressURL = "\(baseURL):8003/api/v1"

    public class func login(username: String, password: String, callback: @escaping (Result<Void, String>) -> Void) {
        let params = ["username": username, "password": password]
        
        Alamofire.request("\(authenticateURL)/authenticate", method: HTTPMethod.post, parameters: params, encoding: JSONEncoding.default).responseSwiftyJSON { response in
            switch response.result {
            case .success(let data):
                guard let refreshToken = data["refresh"].string, let accessToken = data["access"].string, let accountType = data["account_type"].string else {
                    callback(.failure(data["error"].string ?? "An unknown error occurred"))
                    return
                }
                
                guard AccountType(rawValue: accountType) == AccountType.developer else {
                    callback(.failure("This tool is restricted to internal use only"))
                    return
                }
                
                KeychainManager.accessToken = accessToken
                KeychainManager.refreshToken = refreshToken
                callback(Result.success(Void()))
                
            case .failure(let error):
                callback(.failure(error.localizedDescription))
            }
        }
    }
}
