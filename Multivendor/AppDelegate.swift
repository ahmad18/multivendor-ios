//
//  AppDelegate.swift
//  Multivendor
//
//  Created by Tintash on 06/01/2018.
//  Copyright © 2018 multivendor. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import DrawerController

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window                      : UIWindow?
    var drawerController            : DrawerController!
    var centerHomeViewController    : UIViewController?

    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        IQKeyboardManager.sharedManager().enable = true

        
        if let cartData = UserDefaults.standard.data(forKey: "cart") {
            let cartArray = try! JSONDecoder().decode([CartItemModel].self, from: cartData)
            UserManager.shared.cart = cartArray
        }
        
        if let favsData = UserDefaults.standard.data(forKey: "favs") {
            let favsArray = try! JSONDecoder().decode([ProductModel].self, from: favsData)
            UserManager.shared.favs = favsArray
        }
        
        if let login = UserDefaults.standard.object(forKey: "isLoggedIn") as? String {
            if login == "true" {
                UserManager.shared.isLoggedIn = true
            }
            else {
                UserManager.shared.isLoggedIn = false
            }
        }
        
        if let userData = UserDefaults.standard.object(forKey: "userData") as? [String] {
            UserManager.shared.address = userData[0]
            UserManager.shared.contact = userData[1]
            UserManager.shared.email = userData[2]
            UserManager.shared.userID = Int(userData[3])!
            UserManager.shared.name = userData[4]
        }
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        let cartData = try! JSONEncoder().encode(UserManager.shared.cart)
        UserDefaults.standard.set(cartData, forKey: "cart")
        let favsData = try! JSONEncoder().encode(UserManager.shared.favs)
        UserDefaults.standard.set(favsData, forKey: "favs")
        if UserManager.shared.isLoggedIn {
            UserDefaults.standard.set("true", forKey: "isLoggedIn")
        }
        else {
            UserDefaults.standard.set("false", forKey: "isLoggedIn")
        }
        let userData = [UserManager.shared.address, UserManager.shared.contact, UserManager.shared.email, "\(UserManager.shared.userID)", UserManager.shared.name]
        UserDefaults.standard.set(userData, forKey: "userData")
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        
    }


}

//for hamburger menu shit
extension AppDelegate {
    
    func showMainNavigationController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let centerViewController = storyboard.instantiateViewController(withIdentifier: "MainTabBarController") as! UITabBarController
        let leftViewController = storyboard.instantiateViewController(withIdentifier: "MenuViewController") as UIViewController
        
        drawerController = DrawerController(centerViewController: centerViewController, leftDrawerViewController: leftViewController, rightDrawerViewController: nil)
        drawerController.showsShadows = true
        centerHomeViewController = centerViewController
        drawerController.restorationIdentifier = "Drawer"
        drawerController.maximumRightDrawerWidth = 10.0
        drawerController.openDrawerGestureModeMask = .all
        drawerController.closeDrawerGestureModeMask = .all
        
        
        UIView.transition(with: self.window!, duration: 0.5, options: .transitionCrossDissolve, animations: {
            self.window?.rootViewController = self.drawerController
        }, completion: nil)
    }

}
