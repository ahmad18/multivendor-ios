//
//  OffersRowTableViewCell.swift
//  Multivendor
//
//  Created by Tintash on 10/01/2018.
//  Copyright © 2018 multivendor. All rights reserved.
//

import UIKit

class OffersRowTableViewCell: UITableViewCell {

    @IBOutlet weak var offersCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension OffersRowTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return UserManager.shared.discountedProducts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OfferCollectionViewCell", for: indexPath) as! OfferCollectionViewCell
        cell.product = UserManager.shared.discountedProducts[indexPath.row]
        cell.setupCell()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let infoDict = ["discountIndex" : indexPath.row]
        NotificationCenter.default.post(name: Notification.Name("HomeToProductDetail"), object: nil, userInfo: infoDict)
    }
}
