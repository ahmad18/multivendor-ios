//
//  FavTableViewCell.swift
//  Multivendor
//
//  Created by Tintash on 14/02/2018.
//  Copyright © 2018 multivendor. All rights reserved.
//

import UIKit

class FavTableViewCell: UITableViewCell {

    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productBrand: UILabel!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var favImage: UIImageView!
    @IBOutlet weak var favButton: UIButton!
    
    var product: ProductModel?
    lazy var lazyImage: LazyImage = LazyImage()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCell() {
        if let prod = product {
            lazyImage.showWithSpinner(imageView: productImage, url: prod.image ?? "") {
                (error:LazyImageError?) in
            }
            productBrand.text = UserManager.shared.getBrandName(prod.brand_id ?? "")
            productName.text = prod.name ?? ""
            productPrice.text = "AED \(prod.price ?? "-")"
            favImage.image = UIImage.init(named: "red_heart")
        }
    }
    
    @IBAction func buyNowPressed(_ sender: Any) {
        UserManager.shared.addToCart(product: product!, qty: 1)
        NotificationCenter.default.post(name: Notification.Name("BuyNowFavsCell"), object: nil, userInfo: nil)
    }
    
    @IBAction func favButtonPressed(_ sender: Any) {
        var ind = 0
        var deleteFromFavs = false
        for prod in UserManager.shared.favs {
            if prod.id == self.product?.id {
                deleteFromFavs = true
                break
            }
            ind = ind + 1
        }
        if deleteFromFavs {
            UserManager.shared.favs.remove(at: ind)
        }
        favImage.image = UIImage.init(named: "grey_heart")
        NotificationCenter.default.post(name: Notification.Name("RefreshFavsTable"), object: nil, userInfo: nil)
    }
    
    
}
