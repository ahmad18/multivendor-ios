//
//  HomeViewController.swift
//  Multivendor
//
//  Created by Ahmad Shakir on 07/01/2018.
//  Copyright © 2018 multivendor. All rights reserved.
//

import UIKit
import Material

var homeVCRef: HomeViewController?

class HomeViewController: UIViewController {
    
    fileprivate var menuButton: IconButton!
    fileprivate var searchButton: IconButton!
    
    var searchController: UISearchController!
    var searchResultsVC: SearchResultsViewController!
    var productForDetailController: ProductModel?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        homeVCRef = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.homeToCategoriesProducts(notification:)), name: Notification.Name("HomeToCategoriesProducts"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.homeToVendorsProducts(notification:)), name: Notification.Name("HomeToVendorsProducts"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.homeToBrandsProducts(notification:)), name: Notification.Name("HomeToBrandsProducts"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.homeToProductDetail(notification:)), name: Notification.Name("HomeToProductDetail"), object: nil)
        
        searchResultsVC = SearchResultsViewController()
        searchResultsVC.tableView.delegate = self
        searchController = UISearchController(searchResultsController: searchResultsVC)
        searchController.searchResultsUpdater = self
        searchController.searchBar.sizeToFit()
        searchController.delegate = self
        searchController.searchBar.delegate = self
        prepareMenuButton()
        prepareSearchButton()
        prepareNavigationItem()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func menuBarButtonPressed(_ sender: Any) {
        self.evo_drawerController?.toggleDrawerSide(.left, animated: true, completion: nil)
    }
    
}

extension HomeViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MosaicImagesTableViewCell") as! MosaicImagesTableViewCell
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "EmptySpaceTableViewCell") as! EmptySpaceTableViewCell
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "BigOffersRowTableViewCell") as! BigOffersRowTableViewCell
            cell.cellType = .Categories
            cell.setupCell()
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SectionNameTableViewCell") as! SectionNameTableViewCell
            cell.setupCell(sectionTitle: "Brands of the week")
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ShopsOfWeekTableViewCell") as! ShopsOfWeekTableViewCell
            return cell
        case 5:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SectionNameTableViewCell") as! SectionNameTableViewCell
            cell.setupCell(sectionTitle: "Vendors of the week")
            return cell
        case 6:
            let cell = tableView.dequeueReusableCell(withIdentifier: "BigOffersRowTableViewCell") as! BigOffersRowTableViewCell
            cell.cellType = .Vendors
            cell.setupCell()
            return cell
        case 7:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MegaOffersTableViewCell") as! MegaOffersTableViewCell
            return cell
        case 8:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SectionNameTableViewCell") as! SectionNameTableViewCell
            cell.setupCell(sectionTitle: "Recommended Products")
            return cell
        case 9:
            let cell = tableView.dequeueReusableCell(withIdentifier: "OffersRowTableViewCell") as! OffersRowTableViewCell
            return cell
            /*case 5:
             let cell = tableView.dequeueReusableCell(withIdentifier: "SectionNameTableViewCell") as! SectionNameTableViewCell
             cell.setupCell(sectionTitle: "FEATURED STORES")
             return cell
             case 9:
             let cell = tableView.dequeueReusableCell(withIdentifier: "MegaOffersTableViewCell") as! MegaOffersTableViewCell
             return cell*/
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "EmptySpaceTableViewCell") as! EmptySpaceTableViewCell
            return cell
        }
    }
    
}

extension HomeViewController: UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating, UITableViewDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        if let searchStr = searchController.searchBar.text {
            if (searchStr.count >= 1) {
                var products = [ProductModel]()
                let urlStr = "searchproductbyname/" + searchStr
                NetworkManager.sharedManager.downloadJsonAtURL(urlStr as NSString, params: nil, showHud: false, completion:{(result, statusCode) in
                    if let jsonDict = result.value as? NSDictionary
                    {
                        if let productsDict = jsonDict.object(forKey: "success") as? NSArray {
                            for product in productsDict {
                                products.append(ProductModel.init(withDictionary: product as! NSDictionary))
                                if let resultsController = searchController.searchResultsController as? SearchResultsViewController {
                                    resultsController.products = products
                                    resultsController.tableView.reloadData()
                                }
                            }
                        }
                    }
                })
            }
        }
    }
    
    func willDismissSearchController(_ searchController: UISearchController) {
        
        UIView.animate(withDuration: 0.6, animations: {
            self.tableView.tableHeaderView = nil
        }, completion: { finished in
            
        })
    }
    
    @objc func searchButtonPressed() {
        
        tableView.tableHeaderView = searchController.searchBar
        searchController.hidesNavigationBarDuringPresentation = true
        self.definesPresentationContext = true
        searchController.searchBar.becomeFirstResponder()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (tableView == searchResultsVC.tableView) {
            productForDetailController = searchResultsVC.products?[indexPath.row]
            performSegue(withIdentifier: "searchToProductDetail", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "searchToProductDetail" {
            let destinationVC = segue.destination as! ProductDetailViewController
            destinationVC.product = productForDetailController
        }
        else if segue.identifier == "searchToProductsView" {
            let destinationVC = segue.destination as! ProductsViewController
            destinationVC.viewControllerStyle = .ShowSearchResult
            if let subCat = sender as? String {
                destinationVC.apiParams = [subCat]
            }
        }
        else if segue.identifier == "homeToSubCatProductsView" {
            let destinationVC = segue.destination as! ProductsViewController
            destinationVC.viewControllerStyle = .ShowSubCategory
            if let subCat = sender as? [String] {
                destinationVC.apiParams = subCat
            }
        }
        else if segue.identifier == "homeToCategoriesProductsSegue" {
            let destinationVC = segue.destination as! ProductsViewController
            destinationVC.viewControllerStyle = .ShowCategory
            if let catID = sender as? Int {
                destinationVC.apiParams = ["\(catID)", UserManager.shared.categories[catID]?.0 ?? "Category Products"]
            }
        }
        else if segue.identifier == "homeToVendorsProductsSegue" {
            let destinationVC = segue.destination as! ProductsViewController
            destinationVC.viewControllerStyle = .ShowVendorProducts
            if let venID = sender as? Int {
                destinationVC.apiParams = ["\(venID)"]
            }
        }
        else if segue.identifier == "homeToBrandsProductsSegue" {
            let destinationVC = segue.destination as! ProductsViewController
            destinationVC.viewControllerStyle = .ShowBrandsProducts
            if let brandID = sender as? String {
                destinationVC.apiParams = [brandID]
            }
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        performSegue(withIdentifier: "searchToProductsView", sender: searchBar.text)
    }
}

extension HomeViewController {
    fileprivate func prepareMenuButton() {
        menuButton = IconButton(image: Icon.cm.menu)
        menuButton.addTarget(self, action: #selector(menuBarButtonPressed), for: .touchUpInside)
    }
    
    fileprivate func prepareSearchButton() {
        searchButton = IconButton(image: Icon.cm.search)
        searchButton.addTarget(self, action: #selector(searchButtonPressed), for: .touchUpInside)
    }
    
    fileprivate func prepareNavigationItem() {
        navigationItem.titleLabel.text = "Multivendor"
        navigationItem.detailLabel.text = "Online Store"
        
        navigationItem.leftViews = [menuButton]
        navigationItem.rightViews = [searchButton]
    }
    
    @objc func homeToCategoriesProducts(notification: Notification){
        if let cat_id = notification.userInfo?["catID"] as? Int {
            performSegue(withIdentifier: "homeToCategoriesProductsSegue", sender: cat_id)
        }
    }
    
    @objc func homeToVendorsProducts(notification: Notification){
        if let ven_id = notification.userInfo?["venID"] as? Int {
            performSegue(withIdentifier: "homeToVendorsProductsSegue", sender: ven_id)
        }
    }
    
    @objc func homeToBrandsProducts(notification: Notification){
        if let brand_id = notification.userInfo?["brandID"] as? String {
            performSegue(withIdentifier: "homeToBrandsProductsSegue", sender: brand_id)
        }
    }
    
    @objc func homeToProductDetail(notification: Notification){
        if let index = notification.userInfo?["discountIndex"] as? Int {
            self.productForDetailController = UserManager.shared.discountedProducts[index]
            performSegue(withIdentifier: "searchToProductDetail", sender: nil)
        }
    }
    
}
