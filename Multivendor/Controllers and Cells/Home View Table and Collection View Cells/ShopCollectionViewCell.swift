//
//  ShopCollectionViewCell.swift
//  Multivendor
//
//  Created by Tintash on 10/01/2018.
//  Copyright © 2018 multivendor. All rights reserved.
//

import UIKit

class ShopCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var shopImageView: UIImageView!
    
    lazy var lazyImage: LazyImage = LazyImage()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func shopImagePressed(_ sender: Any) {
    }
    
}
