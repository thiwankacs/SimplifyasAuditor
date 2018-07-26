//
//  UserActions.swift
//  Simplifyas Auditor
//
//  Created by Thiwanka Nawarathne on 7/26/18.
//  Copyright © 2018 Simplifya. All rights reserved.
//

import Foundation

protocol UserActionsDelegate {
    func didProcessLoginData(title : String, message : String)
    func didfogetpasswordProcess(title : String, message : String)
}

class UserActions{
    
    var delegate : UserActionsDelegate?
    let simplifya = Simplifya()
    
    func validateForLogin(email : String, password : String) -> Bool{
        if (email.count < 1) {
            delegate?.didProcessLoginData(title: "title_sorry".localized(), message: "empty_fields".localized())
            return false
        }
        else if (password.count < 1){
            delegate?.didProcessLoginData(title: "title_sorry".localized(), message: "empty_fields".localized())
            return false
        }
        else if (!self.isValidEmail(email: email)){
            delegate?.didProcessLoginData(title: "title_sorry".localized(), message: "email_incorrct".localized())
            return false
        }
        else{
            return true
        }
    }
    
    func validateForForgetPassword(email : String) -> Bool{
        if isValidEmail(email: email){
            return true
        }
        else{
            delegate?.didfogetpasswordProcess(title: "title_sorry".localized(), message: "email_incorrct".localized())
            return false
        }
    }
    
    func isValidEmail(email:String) -> Bool {
        let emailRegEx = simplifya.REGEX_EMAIL
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
}
