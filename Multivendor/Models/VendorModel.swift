//
//  VendorModel.swift
//  Multivendor
//
//  Created by Tintash on 15/02/2018.
//  Copyright © 2018 multivendor. All rights reserved.
//

import Foundation

class VendorModel {
    
    var id: Int?
    var name: String?
    var email: String?
    var address: String?
    var contact: String?
    var image: String?
    
    convenience init(withDictionary dict: NSDictionary){
        self.init()
        id = dict.object(forKey: "id") as? Int
        name = dict.object(forKey: "name") as? String
        email = dict.object(forKey: "email") as? String
        address = dict.object(forKey: "address") as? String
        contact = dict.object(forKey: "contact") as? String
        image = dict.object(forKey: "image") as? String
    }
}
