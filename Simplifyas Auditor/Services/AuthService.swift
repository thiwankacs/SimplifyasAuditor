//
//  AuthService.swift
//  Simplifyas Auditor
//
//  Created by Thiwanka Nawarathne on 7/25/18.
//  Copyright © 2018 Simplifya. All rights reserved.
//

import Alamofire
import SwiftyJSON

protocol AuthServiceDelegate {
    func didProcessCredientials(title : String, message : String)
    func didfogetpasswordProcess(title : String, message : String)
    func showUpdateAlert(title : String, message : String, updateUrl : String)
    func showForceUpdateAlert(title : String, message : String, updateUrl : String)
}

class AuthService {
    
    let simplifya = Simplifya()
    var isLoggedIn = false
    var delegate : AuthServiceDelegate?
    
    func loginWithUserName(userName : String, password : String, completion : @escaping (Bool)->()) {
        let Request = simplifya.SERVICEURL + "authenticate"
        
        let parameters = ["username" : userName,
                          "password" : password,
                          "grant_type" : simplifya.GRANDTYPE,
                          "client_id" : simplifya.CLIENTID,
                          "client_secret" : simplifya.CLIENTSECRET
        ]
        
        
        let headers : HTTPHeaders = [
            "Accept": "application/json",
            "Content-Type" : "application/json",
            "appVersion" : simplifya.version(),
            "deviceType" : simplifya.DEVICE_TYPE,
            "User-Agent" : "Simplifya/" + simplifya.version() + " (" + simplifya.DEVICE_TYPE + ";" + simplifya.DEVICE + ")"
        ]
            
        Alamofire.request(Request, method: .post, parameters: parameters,encoding: JSONEncoding.default, headers: headers).responseJSON {
            response in
            
            var responceHeaders = [String:String]()
            if let ResponceHeaders = response.response?.allHeaderFields {
                let jsonResponceHeaders = JSON(ResponceHeaders)
                for (key, object) in jsonResponceHeaders {
                     responceHeaders[key] = object.stringValue
                }
            }
            
            if(responceHeaders["X-Simplifya-Message"] != nil){
                self.delegate?.showUpdateAlert(title: "app_name".localized(), message: responceHeaders["X-Simplifya-Message"]!, updateUrl : self.simplifya.UPDATE_URL)
                completion(false)
            }
            else{
                switch response.result {
                case .success:
                    if let jsonValue = response.result.value {
                        let responceData = JSON(jsonValue)
                        //print(responceData)
                        
                        if !(responceData["token"] == JSON.null) {
                            if !(responceData["token"]["access_token"] == JSON.null) {
                                UserDefaults.standard.setValue(responceData["token"]["access_token"].string!, forKey: "AccessToken")
                            }
                            completion(true)
                        }
                        else{
                            if !(responceData["status_code"] == JSON.null) {
                                if(responceData["status_code"] == 426){
                                    if !(responceData["message"] == JSON.null) {
                                        self.delegate?.showForceUpdateAlert(title: "app_name".localized(), message: responceData["message"].string!, updateUrl: self.simplifya.UPDATE_URL)
                                    }
                                }else{
                                    if !(responceData["message"] == JSON.null) {
                                        self.delegate?.didProcessCredientials(title: "title_sorry".localized(), message: responceData["message"].string!)
                                    }
                                }
                            }
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
    
    func forgotPassword(email : String, completion : @escaping (Bool)->()){
        let Request = simplifya.SERVICEURL + "forgotPassword"
        let parameters = ["email" : email]
        
        Alamofire.request(Request, method: .post, parameters: parameters,encoding: JSONEncoding.default, headers: nil).responseJSON {
            response in
             
            switch response.result {
            case .success:
                if let jsonValue = response.result.value{
                    let responceData = JSON(jsonValue)
                    
                    if !(responceData["success"] == JSON.null){
                        let successCode = Bool(responceData["success"].string!)
                        if successCode! {
                            if !(responceData["email"] == JSON.null) {
                                self.delegate?.didfogetpasswordProcess(title: "app_name".localized() , message: "An email has been sent to " + responceData["email"].string! + " with instructions to reset password.")
                            }
                            completion(true)
                        }
                        else{
                            if !(responceData["message"] == JSON.null) {
                                self.delegate?.didfogetpasswordProcess(title: "title_sorry".localized(), message: responceData["message"].string!)
                            }
                            completion(false)
                        }
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
