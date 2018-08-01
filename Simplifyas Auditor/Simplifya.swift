//
//  Simplifya.swift
//  Simplifyas Auditor
//
//  Created by Thiwanka Nawarathne on 7/25/18.
//  Copyright © 2018 Simplifya. All rights reserved.
//

import Foundation

struct Simplifya {
    
    //LIVE SERVER
    let SERVICEURL          = "http://54.149.102.182/api/"
    
    //LOGIN DETAILS
    let GRANDTYPE           = "password"
    let CLIENTID            = "client2id"
    let CLIENTSECRET        = "client2secret"
    let DEVICE              = "tablet"
    let DEVICE_TYPE         = "ios"
    
    //APPOINTMENTS STATES
    let PENDING             = 1
    let READY               = 2
    let INPROGRESS          = 3
    let COMPLETE            = 4
    let DISABLED            = 5
    
    //RegX
    let REGEX_EMAIL = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    
    //App Update Url
    let UPDATE_URL = "itms-apps://itunes.apple.com/lk/app/simplifya/id1166952462?mt=8"
    
    
    let dictionary = Bundle.main.infoDictionary!
    func version() -> String {
        let version = dictionary["CFBundleShortVersionString"] as! String
        return version
    }
    
    func build() -> String{
        let build = dictionary["CFBundleVersion"] as! String
        return build
    }
}
