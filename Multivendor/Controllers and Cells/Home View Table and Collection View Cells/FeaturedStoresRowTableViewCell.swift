//
//  FeaturedStoresRowTableViewCell.swift
//  Multivendor
//
//  Created by Tintash on 10/01/2018.
//  Copyright © 2018 multivendor. All rights reserved.
//

import UIKit

class FeaturedStoresRowTableViewCell: UITableViewCell {
    
    @IBOutlet weak var featuredStore1View: UIView!
    @IBOutlet weak var featuredStore2View: UIView!
    @IBOutlet weak var store1Name: UILabel!
    @IBOutlet weak var store1Offer: UILabel!
    @IBOutlet weak var store1ImageView: UIImageView!
    @IBOutlet weak var store2Name: UILabel!
    @IBOutlet weak var store2Offer: UILabel!
    @IBOutlet weak var store2ImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func store1Pressed(_ sender: Any) {
    }
    
    @IBAction func store2Pressed(_ sender: Any) {
    }
    
}
