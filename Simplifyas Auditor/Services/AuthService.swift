//
//  AuthService.swift
//  Simplifyas Auditor
//
//  Created by Thiwanka Nawarathne on 7/25/18.
//  Copyright © 2018 Simplifya. All rights reserved.
//

import Alamofire
import SwiftyJSON
import KeychainSwift

class AuthService {
    
    let simplifya = Simplifya()
    let keychain = KeychainSwift()
    var isLoggedIn = false
    
    func loginWithUserName(userName : String, password : String, completion : @escaping (Bool)->()) {
        let Request = simplifya.SERVICEURL + "authenticate"
        
        let parameters = ["username" : userName,
                          "password" : password,
                          "grant_type" : simplifya.GRANDTYPE,
                          "client_id" : simplifya.CLIENTID,
                          "client_secret" : simplifya.CLIENTSECRET
        ]
        
        Alamofire.request(Request, method: .post, parameters: parameters,encoding: JSONEncoding.default, headers: nil).responseJSON {
            response in
            switch response.result {
            case .success:
                if let jsonValue = response.result.value {
                    let responceData = JSON(jsonValue)
                    //print(responceData)
                    
                    if !(responceData["token"] == JSON.null) {
                        if !(responceData["token"]["access_token"] == JSON.null) {
                            self.keychain.set(responceData["token"]["access_token"].string!, forKey: "AccessToken")
                        }
                        completion(true)
                    }
                    else{
                        completion(false)
                    }
                }
                 
                break
            case .failure:
                completion(false)
            }
        }
    }
}
