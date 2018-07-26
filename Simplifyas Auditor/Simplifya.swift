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
    let SERVICEURL          = "http://34.211.220.152/api/"
    
    //LOGIN DETAILS
    let GRANDTYPE           = "password"
    let CLIENTID            = "client2id"
    let CLIENTSECRET        = "client2secret"
    
    //APPOINTMENTS STATES
    let PENDING             = 1
    let READY               = 2
    let INPROGRESS          = 3
    let COMPLETE            = 4
    let DISABLED            = 5
    
    //RegX
    let REGEX_EMAIL = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
}
