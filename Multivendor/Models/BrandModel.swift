//
//  BrandModel.swift
//  Multivendor
//
//  Created by Tintash on 15/02/2018.
//  Copyright © 2018 multivendor. All rights reserved.
//

import Foundation

class BrandModel {
    
    var brand_id: String?
    var category_id: String?
    var vendor_id: String?
    var brand_name: String?
    var description: String?
    var image: String?
    
    convenience init(withDictionary dict: NSDictionary){
        self.init()
        brand_id = dict.object(forKey: "brand_id") as? String
        category_id = dict.object(forKey: "category_id") as? String
        vendor_id = dict.object(forKey: "vendor_id") as? String
        brand_name = dict.object(forKey: "brand_name") as? String
        description = dict.object(forKey: "description") as? String
        image = dict.object(forKey: "image") as? String
    }
}
