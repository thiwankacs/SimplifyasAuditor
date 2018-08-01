//
//  AppDelegate.swift
//  Simplifyas Auditor
//
//  Created by Thiwanka Nawarathne on 7/23/18.
//  Copyright © 2018 Simplifya. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

extension String {
    func localized(withComment comment: String? = nil) -> String {
        return NSLocalizedString(self, comment: comment ?? "")
    }
}

extension UIViewController{
    
    /*override public var traitCollection: UITraitCollection {
     if UIDevice.current.userInterfaceIdiom == .pad && UIDevice.current.orientation.isPortrait {
     return UITraitCollection(traitsFrom: [UITraitCollection(horizontalSizeClass: .compact), UITraitCollection(verticalSizeClass: .regular)])
     //return UITraitCollection(traitsFromCollections:[UITraitCollection(horizontalSizeClass: .compact), UITraitCollection(verticalSizeClass: .Regular)])
     }
     return super.traitCollection
     }*/
    
    func HUDShow(){
        var HUD : MBProgressHUD = MBProgressHUD()
        HUD = MBProgressHUD.showAdded(to: self.view, animated: true)
        HUD.mode = MBProgressHUDModeCustomView
        HUD.labelText = nil
        HUD.labelColor = UIColor.black
        HUD.detailsLabelText = nil
        HUD.color = UIColor.clear
        HUD.tag = 99999
        self.view.addSubview(HUD)
        
        
        let frame : CGRect = CGRect(x: 0, y: 0, width: 100, height: 100)
        let loadingView : LoadingView = LoadingView.init(frame: frame)
        loadingView.backgroundColor = UIColor.clear
        HUD.dimBackground = true
        HUD.customView = loadingView
        HUD.addSubview(loadingView)
    }
    
    func HUDHide(){
        if let viewWithTag = self.view.viewWithTag(99999) {
            viewWithTag.removeFromSuperview()
        }
    }
    
    func checkNetworkStatus(){
        let network: NetworkManager = NetworkManager.sharedInstance
        
        network.reachability.whenReachable = {_ in
            self.ShowAlert(title: "title_congratulations".localized(), message: "connection_available_now".localized())
        }
        
        network.reachability.whenUnreachable = {_ in
            self.ShowAlert(title: "title_sorry".localized(), message: "connection_unavailable_now".localized())
        }
    }
    
    func checkConnection() -> Bool {
        var isReachable = true
        
        NetworkManager.isUnreachable(completed: {_ in
            self.ShowAlert(title: "title_sorry".localized(), message: "connection_unavailable_in_login".localized())
            isReachable = false
        })
        
        return isReachable
    }
    
    func ShowAlert(title : String, message : String){
        let refreshAlert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        refreshAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(refreshAlert, animated: true, completion: nil)
    }
    
    func ShowUpdateAlert(title : String, message : String, updateUrl : String){
        let refreshAlert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        refreshAlert.addAction(UIAlertAction(title: "Update", style: .default, handler: { action in
            
            if let url = URL(string: updateUrl),
                UIApplication.shared.canOpenURL(url)
            {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
            
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "AppointmentsViewController")
            self.present(newViewController, animated: true, completion: nil)
        }))
        
        present(refreshAlert, animated: true, completion: nil)
    }
    
    func ShowForceUpdateAlert(title : String, message : String, updateUrl : String){
        let refreshAlert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
            
            if let url = URL(string: updateUrl),
                UIApplication.shared.canOpenURL(url)
            {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
            
        }))
        
        present(refreshAlert, animated: true, completion: nil)
    }
    
    // MARK: - View On KeyBoard Appearence
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= (keyboardSize.size.height / 2.5)
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += (keyboardSize.size.height / 2.5)
            }
            
            self.view.frame.origin.y = 0
        }
    }
}

extension UITableView {
    
    func hasRowAtIndexPath(indexPath: NSIndexPath) -> Bool {
        return indexPath.section < self.numberOfSections && indexPath.row < self.numberOfRows(inSection: indexPath.section)
    }
}

