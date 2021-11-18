//
//  CategoryTableViewCell.swift
//  Multivendor
//
//  Created by Tintash on 10/01/2018.
//  Copyright © 2018 multivendor. All rights reserved.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {

    @IBOutlet weak var categoryName: UILabel!
    @IBOutlet weak var categoryImage: UIImageView!
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
