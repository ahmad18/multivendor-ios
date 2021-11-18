//
//  ResultTableViewCell.swift
//  Multivendor
//
//  Created by Tintash on 31/01/2018.
//  Copyright © 2018 multivendor. All rights reserved.
//

import UIKit

class ResultTableViewCell: UITableViewCell {

    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productCategory: UILabel!
    
    lazy var lazyImage: LazyImage = LazyImage()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
