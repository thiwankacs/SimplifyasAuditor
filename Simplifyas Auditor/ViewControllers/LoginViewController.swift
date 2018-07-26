//
//  LoginViewController.swift
//  Simplifyas Auditor
//
//  Created by Thiwanka Nawarathne on 7/24/18.
//  Copyright © 2018 Simplifya. All rights reserved.
//

import UIKit
import KeychainSwift

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var forgetPasswordView: UIView!
    @IBOutlet weak var loginEmailAddressField: InputField!
    @IBOutlet weak var loginPasswordField: InputField!
    @IBOutlet weak var btnSignIn: ButtonBlue!
    
    let simplifya = Simplifya()
    let keychain = KeychainSwift()
    let authService = AuthService()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        forgetPasswordView.isHidden = true
        self.keychainDataToFields()
        
        //Check Network Rechability
        self.checkNetworkStatus()
        
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

    // MARK: - Button Actions
    
    @IBAction func btnSignInClicks(_ sender: ButtonBlue) {
        if let UserName = loginEmailAddressField.text{
            keychain.set(UserName, forKey: "UserEmail")
        }
        
        NetworkManager.isUnreachable(completed: {_ in
            self.ErrorMessage(title: "title_sorry".localized(), message: "connection_unavailable_in_login".localized())
        })
        
        NetworkManager.isReachable(completed: {_ in
            self.authService.loginWithUserName(userName: self.loginEmailAddressField.text!, password: self.loginPasswordField.text!){
                connectionResult in
                if connectionResult {
                    print("success")
                }
                else{
                    print("failure")
                }
            }
        })
        
        
    }
    
    @IBAction func btnfogetPasswordClicks(_ sender: ButtonLabel) {
        loginView.isHidden = true
        forgetPasswordView.isHidden = false
    }
    
    @IBAction func btnBackToLoginClicks(_ sender: ButtonLabel) {
        forgetPasswordView.isHidden = true
        loginView.isHidden = false
    }
    
    // MARK: - Delegation Methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true);
        
        if textField.restorationIdentifier == "LoginEmailField" {
            self.loginPasswordField.becomeFirstResponder()
            return false
        }
        
        btnSignIn.sendActions(for: .touchUpInside)
        
        return false;
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
