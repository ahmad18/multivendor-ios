//
//  BigOfferCollectionViewCell.swift
//  Multivendor
//
//  Created by Tintash on 15/01/2018.
//  Copyright © 2018 multivendor. All rights reserved.
//

import UIKit

class BigOfferCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var categoryName: UILabel!
    @IBOutlet weak var categoryImage: UIImageView!
    
    lazy var lazyImage: LazyImage = LazyImage()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func setupCell(catID: Int) {
        if let data = UserManager.shared.categories[catID] {
            categoryName.text = data.0
            lazyImage.showWithSpinner(imageView: categoryImage, url: data.1) {
                (error:LazyImageError?) in
            }
        }
    }
    
    func setupCell(vendor: VendorModel) {
        categoryName.text = vendor.name ?? " "
        lazyImage.showWithSpinner(imageView: categoryImage, url: vendor.image) {
            (error:LazyImageError?) in
        }
    }
}
