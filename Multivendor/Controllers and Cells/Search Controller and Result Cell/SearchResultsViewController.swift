//
//  SearchResultsViewController.swift
//  Multivendor
//
//  Created by Tintash on 31/01/2018.
//  Copyright © 2018 multivendor. All rights reserved.
//

import UIKit

class SearchResultsViewController: UITableViewController {
    
    
    var products: [ProductModel]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "ResultTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "ResultTableViewCell")
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let productsArr = products {
            return productsArr.count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let product = products![indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResultTableViewCell") as! ResultTableViewCell
        cell.productName.text = product.name != nil ? product.name : "-"
        cell.productPrice.text = product.price != nil ? "AED \(product.price!)" : "-"
        cell.productCategory.text = UserManager.shared.categories[Int(product.cat_id!)!]!.0
        let ind = Int(product.cat_id!)!
        cell.productCategory.text = "-"
        for subCat in UserManager.shared.subCategories[ind]! {
            if "\(subCat.0)" == product.sub_cat_id {
                cell.productCategory.text = subCat.1
            }
        }

        cell.lazyImage.showWithSpinner(imageView: cell.productImage, url: product.image) {
            (error:LazyImageError?) in
        }
        cell.selectionStyle = .none
        return cell
    }
}

