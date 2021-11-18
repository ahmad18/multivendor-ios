//
//  SignInViewController.swift
//  Multivendor
//
//  Created by Tintash on 07/01/2018.
//  Copyright © 2018 multivendor. All rights reserved.
//

import UIKit
import Material

class SignInViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    fileprivate var menuButton: IconButton!
    fileprivate var searchButton: IconButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signInButtonPressed(_ sender: Any) {
        let dict = ["email":emailField.text, "password":passwordField.text]
        
        NetworkManager.sharedManager.downloadJsonAtURL("login" as NSString, params: dict as AnyObject?, completion: {(result, statusCode) in
            if let resultDict = result.value as? NSDictionary, result.isSuccess {
                if let userDict = resultDict.object(forKey: "user") as? NSDictionary {
                    UserManager.shared.address = userDict.object(forKey: "address") as? String ?? ""
                    UserManager.shared.contact = userDict.object(forKey: "contact") as? String ?? ""
                    UserManager.shared.email = userDict.object(forKey: "email") as? String ?? ""
                    UserManager.shared.userID = userDict.object(forKey: "id") as? Int ?? -1
                    UserManager.shared.name = userDict.object(forKey: "name") as? String ?? ""
                    UserManager.shared.isLoggedIn = true
                    let delegate = UIApplication.shared.delegate as! AppDelegate
                    delegate.showMainNavigationController()
                }
            }
            else{
                
                //error
            }
        })
    }
}
