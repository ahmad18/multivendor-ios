//
//  CartViewController.swift
//  Multivendor
//
//  Created by Tintash on 01/02/2018.
//  Copyright © 2018 multivendor. All rights reserved.
//

import UIKit

class CartViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var checkoutButton: UIButton!
    @IBOutlet weak var itemsCountLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.deleteProductFromCart(notification:)), name: Notification.Name("DeleteProductFromCart"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateLabels), name: Notification.Name("UpdateCartViewControllerLabels"), object: nil)
        setupCart()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func deleteProductFromCart(notification: Notification) {
        UserManager.shared.deleteFromCart(productID: notification.userInfo?["productID"] as! Int)
        updateLabels()
        UIView.transition(with: self.tableView, duration: 0.5, options: .transitionCurlUp, animations: {self.tableView.reloadData()}, completion: nil)
    }
    
    @objc func updateLabels() {
        itemsCountLabel.text = "Total (\(UserManager.shared.totalItemsQtyInCart()))"
        totalPriceLabel.text = "AED \(UserManager.shared.totalItemsPriceInCart())"
    }
    
    func setupCart(){
        itemsCountLabel.text = "Total (\(UserManager.shared.totalItemsQtyInCart()))"
        totalPriceLabel.text = "AED \(UserManager.shared.totalItemsPriceInCart())"
        
    }
    
    @IBAction func checkoutButtonPressed(_ sender: Any) {
        if UserManager.shared.isLoggedIn {
            if UserManager.shared.cart.count > 0 {
                NetworkManager.sharedManager.downloadDataForAPIAtURL("generatedTocken" as NSString, showHud: true, params: nil, method: .post, fromController: self, completion:{(result, statusCode) in
                    if let jsonDict = result.value as? NSDictionary
                    {
                        UserManager.shared.paymentToken = jsonDict.object(forKey: "success") as? String
                        self.performSegue(withIdentifier: "cartToShipping", sender: nil)
                    }
                })
            }
            else {
                showAlertInViewController(self, titleStr: "No item in cart", messageStr: "Add at least one product in your cart before checking out", okButtonTitle: "Okay", cancelButtonTitle: nil)
            }
        }
        else {
            showAlertInViewController(self, titleStr: "Login to continue", messageStr: "You need to log in to Multivendor in order to continue placing your ordder", okButtonTitle: "Okay", cancelButtonTitle: nil)
        }
    }
    
    
}

extension CartViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UserManager.shared.cart.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartItemTableViewCell") as! CartItemTableViewCell
        cell.cartItem = UserManager.shared.cart[indexPath.row]
        cell.setupCell()
        return cell
        
    }
}

