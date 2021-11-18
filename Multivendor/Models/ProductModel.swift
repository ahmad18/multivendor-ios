//
//  ProductModel.swift
//  Multivendor
//
//  Created by Tintash on 29/01/2018.
//  Copyright © 2018 multivendor. All rights reserved.
//

import Foundation

class ProductModel: Codable {
    
    var id: Int?
    var vendor_id: String?
    var name: String?
    var price: String?
    var description: String?
    var code: String?
    var detail: String?
    var quantity: Int?
    var colour: String?
    var weight: String?
    var is_deleted: String?
    var cat_id: String?
    var sub_cat_id: String?
    var brand_id: String?
    var discount: String?
    var stars: Double?
    var totalReviews: Int?
    var image: String?
    var image1: String?
    var image2: String?
    var image3: String?
    
    var roundedStarsInt = 0
    
    convenience init(withDictionary dict: NSDictionary){
        self.init()
        id = dict.object(forKey: "id") as? Int
        vendor_id = dict.object(forKey: "vendor_id") as? String
        name = dict.object(forKey: "name") as? String
        price = dict.object(forKey: "price") as? String
        description = dict.object(forKey: "description") as? String
        code = dict.object(forKey: "code") as? String
        detail = dict.object(forKey: "detail") as? String
        quantity = dict.object(forKey: "quantity") as? Int
        colour = dict.object(forKey: "colour") as? String
        weight = dict.object(forKey: "weight") as? String
        is_deleted = dict.object(forKey: "is_deleted") as? String
        image = dict.object(forKey: "image") as? String
        image1 = dict.object(forKey: "image1") as? String
        image2 = dict.object(forKey: "image2") as? String
        image3 = dict.object(forKey: "image3") as? String
        cat_id = dict.object(forKey: "cat_id") as? String
        brand_id = dict.object(forKey: "brand_id") as? String
        discount = dict.object(forKey: "disc") as? String
        stars = dict.object(forKey: "star") as? Double
        totalReviews = dict.object(forKey: "totalReview") as? Int
        
        if let st = stars {
            if (st > 0.0) {
                let fixed = (st > 5.0) ? 5.0 : st
                roundedStarsInt = (Int(fixed.rounded()))
            }
        }
        
    }
}
