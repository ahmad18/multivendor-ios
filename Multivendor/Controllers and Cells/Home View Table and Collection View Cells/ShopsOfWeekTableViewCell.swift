//
//  ShopsOfWeekTableViewCell.swift
//  Multivendor
//
//  Created by Tintash on 10/01/2018.
//  Copyright © 2018 multivendor. All rights reserved.
//

import UIKit

class ShopsOfWeekTableViewCell: UITableViewCell {

    @IBOutlet weak var shopsOfWeekCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension ShopsOfWeekTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return UserManager.shared.brands.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let brand = UserManager.shared.brands[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShopCollectionViewCell", for: indexPath) as! ShopCollectionViewCell
        cell.lazyImage.showWithSpinner(imageView: cell.shopImageView, url: brand.image) {
            (error:LazyImageError?) in
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let infoDict = ["brandID" : UserManager.shared.brands[indexPath.row].brand_id]
        NotificationCenter.default.post(name: Notification.Name("HomeToBrandsProducts"), object: nil, userInfo: infoDict)
    }
    
}

