//
//  OfferCollectionViewCell.swift
//  Multivendor
//
//  Created by Tintash on 10/01/2018.
//  Copyright © 2018 multivendor. All rights reserved.
//

import UIKit

class OfferCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var offerImageView: UIImageView!
    @IBOutlet weak var brandName: UILabel!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var discountLabel: UILabel!
    @IBOutlet weak var discountHeight: NSLayoutConstraint!
    
    lazy var lazyImage: LazyImage = LazyImage()
    var product: ProductModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupCell() {
        if let prod = product {
            lazyImage.showWithSpinner(imageView: offerImageView, url: prod.image) {
                (error:LazyImageError?) in
            }
            brandName.text = UserManager.shared.getBrandName(prod.brand_id ?? "")
            productName.text = prod.name
            price.text = "AED \(prod.price ?? " ")"
            let or = UIColor.init(red: 255.0/255.0, green: 80.0/255.0, blue: 0.0/255.0, alpha: 1)
            discountLabel.layer.borderWidth = 0.7
            discountLabel.layer.borderColor =  or.cgColor
            if prod.discount != nil && prod.discount != "0" {
                discountLabel.text = " " + prod.discount! + "% off "
                discountLabel.isHidden = false
                discountHeight.constant = 12.0
            }
            else {
                discountLabel.isHidden = true
                discountHeight.constant = 0.0
            }
        }
    }
}
