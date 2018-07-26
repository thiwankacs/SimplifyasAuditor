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
    
    // MARK: - View On KeyBoard Appearence
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= (keyboardSize.size.height / 1.5)
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
        if self.view.frame.origin.y != 0{
            self.view.frame.origin.y += (keyboardSize.size.height / 1.5)
        }
        }
    }
}

extension UITableView {
    
    func hasRowAtIndexPath(indexPath: NSIndexPath) -> Bool {
        return indexPath.section < self.numberOfSections && indexPath.row < self.numberOfRows(inSection: indexPath.section)
    }
}

