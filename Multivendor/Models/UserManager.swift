//
//  UserData.swift
//  Multivendor
//
//  Created by Tintash on 02/02/2018.
//  Copyright © 2018 multivendor. All rights reserved.
//

import Foundation

class UserManager {
    
    static let shared = UserManager()
    
    var name = ""
    var email = ""
    var address = ""
    var contact = ""
    var userID = -1
    var isLoggedIn = false
    var paymentToken: String?
    
    var categories = [Int:(String, String, String)]()   //[cat_id, (cat_name, cat_image_url, cat_icon)]
    var subCategories = [Int:[(Int, String)]]() //[cat_id, (sub_cat_id, sub_cat_name)]
    var homePageSliderData = [String]()
    var vendors = [VendorModel]()
    var brands = [BrandModel]()
    var discountedProducts = [ProductModel]()
    
    var cart = [CartItemModel]()
    var favs = [ProductModel]()
    
    
    func addToCart(product: ProductModel, qty: Int) {
        if (cart.count != 0) {
            for item in cart {
                if item.product?.id == product.id {
                    item.quantity = qty
                    return
                }
            }
        }
        let cartItem = CartItemModel()
        cartItem.product = product
        cartItem.quantity = qty
        cart.append(cartItem)
        
    }
    
    func deleteFromCart(productID: Int) {
        
        var index = 0
        var delete = false
        for item in cart {
            if item.product?.id == productID {
                delete = true
                break
            }
            index = index + 1
        }
        if delete {
            cart.remove(at: index)
        }
    }
    
    func totalItemsQtyInCart() -> Int {
        var count = 0
        for item in cart {
            count = count + item.quantity!
        }
        return count
    }
    
    func totalItemsPriceInCart() -> Int {
        var count = 0
        for item in cart {
            count = count + (item.quantity! * Int((item.product?.price)!)!)
        }
        return count
    }
    
    func getBrandName(_ id: String) -> String {
        for brand in brands {
            if brand.brand_id == id {
                return brand.brand_name ?? "Unknown Brand"
            }
        }
        return "Unknown Brand"
    }
    
    func getVendorName(_ id: String) -> String {
        var res = "Unknown Vendor"
        if let venId = Int(id) {
            for vendor in vendors {
                if vendor.id == venId {
                    res = vendor.name ?? "Unknown Vendor"
                }
            }
        }
        return res
    }
    
    func hasBought(_ prodId: Int) -> Bool {
        return true
    }
}

