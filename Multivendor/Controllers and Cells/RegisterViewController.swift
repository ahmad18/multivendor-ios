//
//  RegisterViewController.swift
//  Multivendor
//
//  Created by Tintash on 07/01/2018.
//  Copyright © 2018 multivendor. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class RegisterViewController: UIViewController {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var contactField: SkyFloatingLabelTextField!
    @IBOutlet weak var addressField: SkyFloatingLabelTextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func registerButtonPressed(_ sender: Any) {
        let dict = ["email":emailField.text, "password":passwordField.text, "name":nameField.text, "c_password":confirmPasswordField.text, "contact":contactField.text, "address":addressField.text]
        
        NetworkManager.sharedManager.downloadJsonAtURL("register" as NSString, params: dict as AnyObject?, completion: {(result, statusCode) in
            if let resultDict = result.value, result.isSuccess {
                print(resultDict)
                let delegate = UIApplication.shared.delegate as! AppDelegate
                delegate.showMainNavigationController()
            }
            else{
                
                //error
            }
    })
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
