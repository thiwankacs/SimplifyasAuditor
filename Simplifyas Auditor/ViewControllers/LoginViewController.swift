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
        self._toggleKeyBoardBasedView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // Scroll the View on keyboard Appear
        self._toggleKeyBoardBasedView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func _toggleKeyBoardBasedView(){
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func keychainDataToFields()
    {
        if let retrievedUserName: String = keychain.get("UserEmail"){
            self.loginEmailAddressField.text = retrievedUserName
        }
        
        if let _: String = keychain.get("AccessToken"){
            //print(retrievedAccessToken)
        }
    }

    // MARK: - Button Actions
    
    @IBAction func btnSignInClicks(_ sender: ButtonBlue) {
        if self.checkConnection() {
            if userActions.validateForLogin(email: loginEmailAddressField.text!, password: loginPasswordField.text!){
                if let UserName = loginEmailAddressField.text{
                    keychain.set(UserName, forKey: "UserEmail")
                }
                
                NetworkManager.isReachable(completed: {_ in
                    UIApplication.shared.isNetworkActivityIndicatorVisible = true
                    
                    self.HUDShow()
                    
                    self.authService.loginWithUserName(userName: self.loginEmailAddressField.text!, password: self.loginPasswordField.text!){
                        connectionResult in
                        
                        self.HUDHide()
                        
                        if connectionResult {
                            UIApplication.shared.isNetworkActivityIndicatorVisible = false
                            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                            let newViewController = storyBoard.instantiateViewController(withIdentifier: "AppointmentsViewController")
                            self.present(newViewController, animated: true, completion: nil)
                        }
                        else{
                            UIApplication.shared.isNetworkActivityIndicatorVisible = false
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
                    UIApplication.shared.isNetworkActivityIndicatorVisible = true
                    
                    self.HUDShow()
                    
                    self.authService.forgotPassword(email: self.forgetPasswordEmailAddressField.text!){
                        connectionResult in
                        
                        self.HUDHide()
                        
                        if connectionResult {
                            UIApplication.shared.isNetworkActivityIndicatorVisible = false
                            print("success reset password")
                            self.forgetPasswordEmailAddressField.text = ""
                            //self.ShowAlert(title: "title_congratulations".localized(), message: "Login Successfull and proceed forward.")
                        }
                        else{
                            UIApplication.shared.isNetworkActivityIndicatorVisible = false
                            self.forgetPasswordEmailAddressField.text = ""
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
    
    func showUpdateAlert(title: String, message: String, updateUrl : String) {
        self.ShowUpdateAlert(title: title, message: message, updateUrl : updateUrl)
    }
    
    func showForceUpdateAlert(title: String, message: String, updateUrl: String) {
        self.ShowForceUpdateAlert(title: title, message: message, updateUrl: updateUrl)
    }
}
