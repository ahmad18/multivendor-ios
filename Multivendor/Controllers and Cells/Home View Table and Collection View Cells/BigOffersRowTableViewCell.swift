//
//  BigOffersRowTableViewCell.swift
//  Multivendor
//
//  Created by Tintash on 15/01/2018.
//  Copyright © 2018 multivendor. All rights reserved.
//

import UIKit

enum typeOfCell {
    case Categories
    case Vendors
}

class BigOffersRowTableViewCell: UITableViewCell {

    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var cellType: typeOfCell?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCell() {
        collectionView.reloadData()
    }

}

extension BigOffersRowTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (cellType == .Categories) ? UserManager.shared.categories.count : UserManager.shared.vendors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BigOfferCollectionViewCell", for: indexPath) as! BigOfferCollectionViewCell
        if (cellType == .Categories) {
            cell.setupCell(catID: Array(UserManager.shared.categories)[indexPath.row].key)
        }
        else {
            cell.setupCell(vendor: UserManager.shared.vendors[indexPath.row])
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (cellType == .Categories) {
            let infoDict = ["catID": Array(UserManager.shared.categories)[indexPath.row].key]
            NotificationCenter.default.post(name: Notification.Name("HomeToCategoriesProducts"), object: nil, userInfo: infoDict)
        }
        else {
            let infoDict = ["venID" : UserManager.shared.vendors[indexPath.row].id]
            NotificationCenter.default.post(name: Notification.Name("HomeToVendorsProducts"), object: nil, userInfo: infoDict)
        }
        
        
    }
    
}
