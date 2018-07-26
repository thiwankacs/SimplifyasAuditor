//
//  LoginViewController.swift
//  Simplifyas Auditor
//
//  Created by Thiwanka Nawarathne on 7/24/18.
//  Copyright © 2018 Simplifya. All rights reserved.
//

import UIKit
import KeychainSwift

class LoginViewController: UIViewController, UITextFieldDelegate, UserActionsDelegate, AuthServiceDelegate {

    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var forgetPasswordView: UIView!
    @IBOutlet weak var loginEmailAddressField: InputField!
    @IBOutlet weak var loginPasswordField: InputField!
    @IBOutlet weak var btnSignIn: ButtonBlue!
    @IBOutlet weak var forgetPasswordEmailAddressField: InputField!
    @IBOutlet weak var btnForgetPassword: ButtonBlue!
    
    let simplifya = Simplifya()
    let keychain = KeychainSwift()
    let authService = AuthService()
    let userActions = UserActions()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        userActions.delegate = self
        authService.delegate = self
        
        forgetPasswordView.isHidden = true
        self.keychainDataToFields()
        
        //Check Network Rechability
        //self.checkNetworkStatus()
        
        // Scroll the View on keyboard Appear
        //NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        //NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func keychainDataToFields()
    {
        if let retrievedUserName: String = keychain.get("UserEmail"){
            self.loginEmailAddressField.text = retrievedUserName
        }
        
        if let retrievedAccessToken: String = keychain.get("AccessToken"){
            print(retrievedAccessToken)
        }
    }
    
//    func checkConnection(){
//        
//    }

    // MARK: - Button Actions
    
    @IBAction func btnSignInClicks(_ sender: ButtonBlue) {
        if self.checkConnection() {
            if userActions.validateForLogin(email: loginEmailAddressField.text!, password: loginPasswordField.text!){
                if let UserName = loginEmailAddressField.text{
                    keychain.set(UserName, forKey: "UserEmail")
                }
                
                NetworkManager.isReachable(completed: {_ in
                    self.authService.loginWithUserName(userName: self.loginEmailAddressField.text!, password: self.loginPasswordField.text!){
                        connectionResult in
                        if connectionResult {
                            print("success login")
                            self.ShowAlert(title: "title_congratulations".localized(), message: "Login Successfull and proceed forward.")
                        }
                    }
                })
            }
        }
    }
    
    @IBAction func btnfogetPasswordClicks(_ sender: ButtonLabel) {
        loginView.isHidden = true
        forgetPasswordView.isHidden = false
    }
    
    @IBAction func btnBackToLoginClicks(_ sender: ButtonLabel) {
        forgetPasswordView.isHidden = true
        loginView.isHidden = false
    }
    
    @IBAction func forgetPasswordRequest(_ sender: ButtonBlue) {
        if self.checkConnection() {
            if userActions.validateForForgetPassword(email: forgetPasswordEmailAddressField.text!){
                NetworkManager.isReachable(completed: {_ in
                    self.authService.forgotPassword(email: self.forgetPasswordEmailAddressField.text!){
                        connectionResult in
                        if connectionResult {
                            print("success reset password")
                            self.forgetPasswordEmailAddressField.text = ""
                            //self.ShowAlert(title: "title_congratulations".localized(), message: "Login Successfull and proceed forward.")
                        }
                    }
                })
            }
        }
    }
    
    // MARK: - Delegation Methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true);
        
        if textField.restorationIdentifier == "LoginEmailField" {
            self.loginPasswordField.becomeFirstResponder()
            return false
        }
        
        if textField.restorationIdentifier == "forgetPasswordEmailAddressField" {
            btnForgetPassword.sendActions(for: .touchUpInside)
            return false
        }
        else{
            btnSignIn.sendActions(for: .touchUpInside)
        }
        
        return false;
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func didProcessLoginData(title: String, message: String) {
        self.ShowAlert(title: title, message: message)
    }
    
    func didfogetpasswordProcess(title: String, message: String) {
        self.ShowAlert(title: title, message: message)
    }
    
    func didProcessCredientials(title: String, message: String) {
        self.ShowAlert(title: title, message: message)
    }
}
