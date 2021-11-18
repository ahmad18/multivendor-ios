//
//  ProductCell.swift
//  Multivendor
//
//  Created by Tintash on 15/01/2018.
//  Copyright © 2018 multivendor. All rights reserved.
//

import UIKit

class ProductCell: UICollectionViewCell {
    
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productDescription: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var brandName: UILabel!
    @IBOutlet weak var discount: UILabel!
    @IBOutlet var ratingStars: [UIImageView]!
    @IBOutlet weak var ratingsCount: UILabel!
    @IBOutlet weak var heartImage: UIImageView!
    @IBOutlet weak var discountHeight: NSLayoutConstraint!
    
    var product = ProductModel()
    lazy var lazyImage: LazyImage = LazyImage()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupCell() {
        
        if let imgUrl = product.image {
            lazyImage.showWithSpinner(imageView: productImage, url: imgUrl) {
                (error:LazyImageError?) in
            }
        }
        heartImage.image = UIImage.init(named: "grey_heart")
        for prod in UserManager.shared.favs {
            if prod.id == self.product.id {
                heartImage.image = UIImage.init(named: "red_heart")
            }
        }
        productName.text = product.name != nil ? product.name! : "-"
        productDescription.text = product.description != nil ? product.description! : "-"
        productPrice.text = product.price != nil ? "AED \(product.price!)" : "-"
        let or = UIColor.init(red: 255.0/255.0, green: 80.0/255.0, blue: 0.0/255.0, alpha: 1)
        discount.layer.borderWidth = 0.7
        discount.layer.borderColor =  or.cgColor
        if product.discount != nil && product.discount != "0" {
            discount.text = " " + product.discount! + "% off "
            discount.isHidden = false
            discountHeight.constant = 12.0
        }
        else {
            discount.isHidden = true
            discountHeight.constant = 0.0
        }
        brandName.text = UserManager.shared.getBrandName(product.brand_id!)
        
        for star in ratingStars {
            star.image = UIImage.init(named: "grey_star")
        }
        if (product.roundedStarsInt > 0) {
            for index in 1...product.roundedStarsInt {
                ratingStars[index-1].image = UIImage.init(named: "yellow_star")
            }
        }
        ratingsCount.text = "(\(product.totalReviews ?? 0))"
    }
    
    @IBAction func addToSavedProducts(_ sender: Any) {
        
        if (heartImage.image == UIImage.init(named: "grey_heart")) {
            UserManager.shared.favs.append(product)
            heartImage.image = UIImage.init(named: "red_heart")
        }
        else {
            var ind = 0
            var deleteFromFavs = false
            for prod in UserManager.shared.favs {
                if prod.id == self.product.id {
                    deleteFromFavs = true
                    break
                }
                ind = ind + 1
            }
            if deleteFromFavs {
                UserManager.shared.favs.remove(at: ind)
            }
            heartImage.image = UIImage.init(named: "grey_heart")
        }
        
    }
    
    
}
