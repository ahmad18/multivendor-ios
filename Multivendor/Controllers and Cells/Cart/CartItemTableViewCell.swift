//
//  CartItemTableViewCell.swift
//  Multivendor
//
//  Created by Tintash on 01/02/2018.
//  Copyright © 2018 multivendor. All rights reserved.
//

import UIKit

class CartItemTableViewCell: UITableViewCell {

    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productQuantity: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var brandName: UILabel!
    
    lazy var lazyImage: LazyImage = LazyImage()
    var cartItem = CartItemModel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCell() {
        lazyImage.showWithSpinner(imageView: productImage, url: cartItem.product?.image) {
            (error:LazyImageError?) in
        }
        productName.text = cartItem.product?.name != nil ? cartItem.product?.name : "-"
        productQuantity.text = "\(cartItem.quantity!)"
        productPrice.text = cartItem.product?.price != nil ? cartItem.product?.price : "-"
        brandName.text = UserManager.shared.getBrandName(cartItem.product?.brand_id ?? "")
    }
    
    @IBAction func decQuantityButtonPressed(_ sender: Any) {
        let curr = Int(productQuantity!.text!)
        if (curr! > 1) {
            cartItem.quantity = curr! - 1
            UserManager.shared.addToCart(product: cartItem.product!, qty: cartItem.quantity!)
            productQuantity.text = "\(cartItem.quantity!)"
            NotificationCenter.default.post(name: Notification.Name("UpdateCartViewControllerLabels"), object: nil, userInfo: nil)
        }
        
    }
    
    @IBAction func incQuantityButtonPressed(_ sender: Any) {
        let curr = Int(productQuantity!.text!)
        if (curr! <= 50) {
            cartItem.quantity = curr! + 1
            UserManager.shared.addToCart(product: cartItem.product!, qty: cartItem.quantity!)
            productQuantity.text = "\(cartItem.quantity!)"
            NotificationCenter.default.post(name: Notification.Name("UpdateCartViewControllerLabels"), object: nil, userInfo: nil)
            
        }
    }
    
    @IBAction func deleteButtonPressed(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name("DeleteProductFromCart"), object: nil, userInfo: ["productID" : cartItem.product?.id])
    }
    
    
    
}
