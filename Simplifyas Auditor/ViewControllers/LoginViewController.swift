//
//  LoginViewController.swift
//  Simplifyas Auditor
//
//  Created by Thiwanka Nawarathne on 7/24/18.
//  Copyright © 2018 Simplifya. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var forgetPasswordView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        forgetPasswordView.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func btnfogetpasswordClicks(_ sender: ButtonLabel) {
        loginView.isHidden = true
        forgetPasswordView.isHidden = false
    }
    
    @IBAction func btnfogetPasswordClicks(_ sender: ButtonLabel) {
        forgetPasswordView.isHidden = true
        loginView.isHidden = false
    }
    
}
