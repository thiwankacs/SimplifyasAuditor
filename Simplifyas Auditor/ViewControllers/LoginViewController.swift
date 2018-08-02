//
//  LoginViewController.swift
//  Simplifyas Auditor
//
//  Created by Thiwanka Nawarathne on 7/24/18.
//  Copyright © 2018 Simplifya. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate, UserActionsDelegate, AuthServiceDelegate {
    
    // MARK: - Properties
    var passwordItems: [KeychainPasswordItem] = []
    let biometricIDAuth = BiometricIDAuth()
    
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var forgetPasswordView: UIView!
    @IBOutlet weak var loginEmailAddressField: InputField!
    @IBOutlet weak var loginPasswordField: InputField!
    @IBOutlet weak var btnSignIn: ButtonBlue!
    @IBOutlet weak var forgetPasswordEmailAddressField: InputField!
    @IBOutlet weak var btnForgetPassword: ButtonBlue!
    @IBOutlet weak var touchIDButton: UIButton!
    
    let simplifya = Simplifya()
    let authService = AuthService()
    let userActions = UserActions()
    var delay : Float = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        userActions.delegate = self
        authService.delegate = self
        
        forgetPasswordView.isHidden = true
        self.keychainAndBiometricIDAuth()
        
        //Check Network Rechability
        //self.checkNetworkStatus()
        
        // Scroll the View on keyboard Appear
        self._toggleKeyBoardBasedView()
        
        /*
        if let AccessToken = UserDefaults.standard.value(forKey: "AccessToken") as? String {
            print(AccessToken)
        }
        print(UserDefaults.standard.dictionaryRepresentation())
        */
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateBiometricIDAuth), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        //NotificationCenter.default.addObserver(self, selector: #selector(self.update), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let touchBool = biometricIDAuth.canEvaluatePolicy()
        let hasLogin = UserDefaults.standard.bool(forKey: "hasLoginKey")
        
        if (touchBool && hasLogin) {
            self.touchIDLoginAction()
        }
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
    
    func keychainAndBiometricIDAuth(){
        let hasLogin = UserDefaults.standard.bool(forKey: "hasLoginKey")
        
        if hasLogin {
            btnSignIn.tag = 1
            if biometricIDAuth.canEvaluatePolicy() {
                touchIDButton.isHidden = false
            }
        } else {
            btnSignIn.tag = 0
            touchIDButton.isHidden = true
        }
        
        if let storedUsername = UserDefaults.standard.value(forKey: "username") as? String {
            loginEmailAddressField.text = storedUsername
        }
    
        //touchIDButton.isHidden = !biometricIDAuth.canEvaluatePolicy()
        
        if #available(iOS 11.0, *) {
            switch biometricIDAuth.biometricType() {
            case .faceID:
                touchIDButton.setImage(UIImage(named: "FaceIcon"),  for: .normal)
                break
            default:
                touchIDButton.setImage(UIImage(named: "TouchIcon"),  for: .normal)
                break
            }
        } else {
            touchIDButton.isHidden = true
        }
    }
    
    @objc func updateBiometricIDAuth(){
        let touchBool = biometricIDAuth.canEvaluatePolicy()
        let hasLogin = UserDefaults.standard.bool(forKey: "hasLoginKey")
        
        if (touchBool && hasLogin) {
            self.keychainAndBiometricIDAuth()
            self.touchIDLoginAction()
        }
    }
    
    // MARK: - Button Actions
    
    @IBAction func touchIDLoginAction() {
        if #available(iOS 11.0, *) {
            biometricIDAuth.authenticateUser() { [weak self] message, show, dissabled  in
                if let message = message {
                    if dissabled {
                        DispatchQueue.main.async {
                            self?.touchIDButton.isHidden = true
                        }
                    }
                    
                    if show {
                        // if the completion is not nil show an alert
                        let alertView = UIAlertController(title: "Error",
                                                          message: message,
                                                          preferredStyle: .alert)
                        
                        let okAction = UIAlertAction(title: "Ok", style: .default)
                        alertView.addAction(okAction)
                        self?.present(alertView, animated: true)
                    }
                }
                else {
                    
                    if let storedUsername = UserDefaults.standard.value(forKey: "username") as? String {
                        self?.loginEmailAddressField.text = storedUsername
                    }
                    
                    do {
                        let passwordItem = KeychainPasswordItem(service: (self?.simplifya.serviceName)!,
                                                                account: (self?.loginEmailAddressField.text)!,
                                                                accessGroup: self?.simplifya.accessGroup)
                        let keychainPassword = try passwordItem.readPassword()
                        self?.loginPasswordField.text = keychainPassword
                        self?.btnSignIn.sendActions(for: .touchUpInside)
                    }
                    catch {
                        self?.ShowAlert(title: "title_sorry".localized(), message: "Error reading password from keychain - \(error)")
                    }
                }
            }
        } else {
            // Fallback on earlier versions
        }
    }
    
    @IBAction func btnSignInClicks(_ sender: ButtonBlue) {
        
        if self.checkConnection() {
            if userActions.validateForLogin(email: loginEmailAddressField.text!, password: loginPasswordField.text!){
                let hasLoginKey = UserDefaults.standard.bool(forKey: "hasLoginKey")
                let newAccountName = loginEmailAddressField.text
                let newPassword = loginPasswordField.text
                
                
                // This is a new account, create a new keychain item with the account name.
                let passwordItem = KeychainPasswordItem(service: self.simplifya.serviceName,
                                                        account: newAccountName!,
                                                        accessGroup: self.simplifya.accessGroup)
                
                switch self.biometricIDAuth.biometricType(){
                case .touchID:
                    self.delay = 0.5
                case .faceID:
                    self.delay = 0.8
                default:
                    self.delay = 0.0
                }
                
                NetworkManager.isReachable(completed: {_ in
                    UIApplication.shared.isNetworkActivityIndicatorVisible = true
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + Double(self.delay)) {
                        self.HUDShow()
                        
                        self.authService.loginWithUserName(userName: self.loginEmailAddressField.text!, password: self.loginPasswordField.text!){
                            connectionResult in
                            
                            self.HUDHide()
                            
                            if connectionResult {
                                //print("connectionResult")
                                
                                if !hasLoginKey && self.loginEmailAddressField.hasText {
                                    UserDefaults.standard.setValue(self.loginEmailAddressField.text, forKey: "username")
                                }
                                
                                do {
                                    // Save the password for the new item.
                                    try passwordItem.savePassword(newPassword!)
                                } catch {
                                    self.ShowAlert(title: "title_sorry".localized(), message: error.localizedDescription)
                                }
                                
                                if sender.tag == 0 {
                                    UserDefaults.standard.set(true, forKey: "hasLoginKey")
                                    self.btnSignIn.tag = 1
                                }
                                
                                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                                let newViewController = storyBoard.instantiateViewController(withIdentifier: "AppointmentsViewController")
                                self.present(newViewController, animated: true, completion: nil)
                            }
                            else{
                                self.btnSignIn.tag = 0
                                self.touchIDButton.isHidden = true
                                self.loginPasswordField.text = ""
                                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                                UserDefaults.standard.removeObject(forKey: "hasLoginKey")
                                UserDefaults.standard.removeObject(forKey: "username")
                                
                                do {
                                    // Remove The Password Item.
                                    try passwordItem.deleteItem()
                                } catch {
                                    self.ShowAlert(title: "title_sorry".localized(), message: error.localizedDescription)
                                }
                            }
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
