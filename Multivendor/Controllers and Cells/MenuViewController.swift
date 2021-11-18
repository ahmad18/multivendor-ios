//
//  MenuViewController.swift
//  Multivendor
//
//  Created by Tintash on 07/01/2018.
//  Copyright © 2018 multivendor. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    
    @IBOutlet weak var categoriesTableView: UITableView!
    
    var isExpanded = false
    var expandedCell = 0
    var subCellsCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    /*override func viewWillAppear(_ animated: Bool) {
     super.viewWillAppear(animated)
     
     UIApplication.shared.isStatusBarHidden = true
     }
     
     override func viewWillDisappear(_ animated: Bool) {
     super.viewWillDisappear(animated)
     
     UIApplication.shared.isStatusBarHidden = false
     }*/
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension MenuViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isExpanded {
            let catID = Array(UserManager.shared.categories)[expandedCell].key
            return UserManager.shared.categories.count + (UserManager.shared.subCategories[catID]?.count)!
        }
        else {
            return UserManager.shared.categories.count
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isExpanded {
            if (indexPath.row == expandedCell) {
                isExpanded = false
            }
            else if (indexPath.row < expandedCell) {
                //normal behavior
                isExpanded = true
                expandedCell = indexPath.row
                let catID = Array(UserManager.shared.categories)[expandedCell].key
                subCellsCount = (UserManager.shared.subCategories[catID]?.count)!
            }
            else if (indexPath.row > expandedCell && indexPath.row <= expandedCell+subCellsCount) {
                self.evo_drawerController?.toggleDrawerSide(.left, animated: false, completion: nil)
                let updatedIndex = indexPath.row - expandedCell - 1
                let catID = Array(UserManager.shared.categories)[expandedCell].key
                let subCatId = UserManager.shared.subCategories[catID]![updatedIndex].0
                let subCatName = UserManager.shared.subCategories[catID]![updatedIndex].1
                if (homeVCRef?.tabBarController?.selectedIndex != 0) {
                    homeVCRef?.tabBarController?.selectedIndex = 0
                }
                homeVCRef!.performSegue(withIdentifier: "homeToSubCatProductsView", sender: ["\(subCatId)", subCatName])
            }
            else {
                isExpanded = true
                let updatedIndex = indexPath.row - subCellsCount
                expandedCell = updatedIndex
                let catID = Array(UserManager.shared.categories)[expandedCell].key
                subCellsCount = (UserManager.shared.subCategories[catID]?.count)!
            }
        }
        else {
            isExpanded = true
            expandedCell = indexPath.row
            let catID = Array(UserManager.shared.categories)[expandedCell].key
            subCellsCount = (UserManager.shared.subCategories[catID]?.count)!
        }
        UIView.transition(with: tableView, duration: 0.5, options: .transitionFlipFromLeft, animations: {tableView.reloadData()}, completion: nil)
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryTableViewCell") as! CategoryTableViewCell
        if isExpanded {
            if (indexPath.row <= expandedCell) {
                cell.categoryImage.isHidden = false
                cell.lazyImage.showWithSpinner(imageView: cell.categoryImage, url: Array(UserManager.shared.categories)[indexPath.row].value.2) {
                    (error:LazyImageError?) in
                }
                cell.categoryName.text = Array(UserManager.shared.categories)[indexPath.row].value.0
            }
            else if (indexPath.row > expandedCell && indexPath.row <= expandedCell+subCellsCount) {
                let updatedIndex = indexPath.row - expandedCell - 1
                let catID = Array(UserManager.shared.categories)[expandedCell].key
                let subCatName = UserManager.shared.subCategories[catID]![updatedIndex].1
                cell.categoryImage.isHidden = true
                cell.categoryName.text = subCatName
            }
            else {
                let updatedIndex = indexPath.row - subCellsCount
                cell.categoryImage.isHidden = false
                cell.lazyImage.showWithSpinner(imageView: cell.categoryImage, url: Array(UserManager.shared.categories)[updatedIndex].value.2) {
                    (error:LazyImageError?) in
                }
                cell.categoryName.text = Array(UserManager.shared.categories)[updatedIndex].value.0
            }
        }
        else {
            cell.categoryImage.isHidden = false
            cell.lazyImage.showWithSpinner(imageView: cell.categoryImage, url: Array(UserManager.shared.categories)[indexPath.row].value.2) {
                (error:LazyImageError?) in
            }
            cell.categoryName.text = Array(UserManager.shared.categories)[indexPath.row].value.0
        }
        return cell
    }
}
