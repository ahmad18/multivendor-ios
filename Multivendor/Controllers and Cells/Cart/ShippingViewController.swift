//
//  ShippingViewController.swift
//  Multivendor
//
//  Created by Tintash on 01/02/2018.
//  Copyright © 2018 multivendor. All rights reserved.
//

import UIKit
import BraintreeDropIn
import Braintree
import SkyFloatingLabelTextField

class ShippingViewController: UIViewController {

    @IBOutlet weak var shippingAddress: UITextField!
    @IBOutlet weak var totalItemsLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var fname: SkyFloatingLabelTextField!
    @IBOutlet weak var lname: SkyFloatingLabelTextField!
    @IBOutlet weak var contact: SkyFloatingLabelTextField!
    
    //private let customerContext: STPCustomerContext
    //private let paymentContext: STPPaymentContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let or = UIColor.init(red: 255.0/255.0, green: 80.0/255.0, blue: 0.0/255.0, alpha: 1)
        shippingAddress.layer.borderWidth = 1.0
        shippingAddress.layer.borderColor =  or.cgColor
        
        totalItemsLabel.text = "Total (\(UserManager.shared.totalItemsQtyInCart()))"
        totalPriceLabel.text = "AED \(UserManager.shared.totalItemsPriceInCart())"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func continueToPayButtonPressed(_ sender: Any) {
        if (!(shippingAddress.text?.isEmpty)! && !(fname.text?.isEmpty)! && !(contact.text?.isEmpty)!) {
            if UserManager.shared.paymentToken != nil {
                showDropIn(clientTokenOrTokenizationKey: UserManager.shared.paymentToken!)
            }
        }
        else {
            showAlertInViewController(self, titleStr: "Fill Shipping Info", messageStr: "Please fill the shipping information form first", okButtonTitle: "Okay", cancelButtonTitle: nil)
        }
        
    }
    func showDropIn(clientTokenOrTokenizationKey: String) {
        let request =  BTDropInRequest()
        let dropIn = BTDropInController(authorization: clientTokenOrTokenizationKey, request: request)
        { (controller, result, error) in
            if (error != nil) {
                print("ERROR")
            } else if (result?.isCancelled == true) {
                print("CANCELLED")
            } else if let result = result {
                // Use the BTDropInResult properties to update your UI
                // result.paymentOptionType
                // result.paymentMethod
                // result.paymentIcon
                // result.paymentDescription
                var prods = [AnyObject]()
                for item in UserManager.shared.cart {
                    let prod = ["productID":item.product?.id, "productQty":item.quantity, "vendorID":item.product?.vendor_id] as [String : AnyObject]
                    prods.append(prod as AnyObject)
                }
                let lastN = (self.lname.text?.isEmpty)! ? "" : self.lname.text
                var params = ["customerID":UserManager.shared.userID, "totalPrice": UserManager.shared.totalItemsPriceInCart(), "fname":self.fname.text, "lname":lastN, "payment_method_nonce":result.paymentMethod?.nonce, "contact":self.contact.text, "address":self.shippingAddress.text, "products":prods] as [String : AnyObject]
                NetworkManager.sharedManager.downloadDataForAPIAtURL("completeOrder" as NSString, showHud: true, params: params, method: .post, fromController: self, completion:{(result, statusCode) in
                    if let jsonDict = result.value as? NSDictionary
                    {
                        if let status = jsonDict.object(forKey: "success") as? String {
                            if status == "Success" {
                                showAlertInViewController(self, titleStr: "Success", messageStr: "Your order has successfully been placed", okButtonTitle: "Okay", cancelButtonTitle: nil)
                                UserManager.shared.cart.removeAll()
                            }
                        }
                    }
                })
            }
            controller.dismiss(animated: true, completion: nil)
        }
        self.present(dropIn!, animated: true, completion: nil)
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
