//
//  SearchManagerViewController.swift
//  Multivendor
//
//  Created by Tintash on 12/02/2018.
//  Copyright © 2018 multivendor. All rights reserved.
//

import UIKit

class SearchManagerViewController: UIViewController, UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var searchController: UISearchController!
    var searchResultsVC: SearchResultsViewController!
    var productForDetailController: ProductModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        
        searchResultsVC = SearchResultsViewController()
        searchResultsVC.tableView.delegate = self
        searchController = UISearchController(searchResultsController: searchResultsVC)
        searchController.searchResultsUpdater = self
        searchController.searchBar.sizeToFit()
        searchController.delegate = self
        searchController.searchBar.delegate = self
        
        tableView.tableHeaderView = searchController.searchBar
        //searchController.hidesNavigationBarDuringPresentation = true
        self.definesPresentationContext = true
        searchController.searchBar.becomeFirstResponder()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

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
        tableView.tableHeaderView = searchController.searchBar
        self.navigationController?.isNavigationBarHidden = false
        navigationController?.popViewController(animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (tableView == searchResultsVC.tableView) {
            productForDetailController = searchResultsVC.products?[indexPath.row]
            performSegue(withIdentifier: "searchManagerToDetail", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "searchManagerToDetail" {
            let destinationVC = segue.destination as! ProductDetailViewController
            destinationVC.product = productForDetailController
        }
        else if segue.identifier == "searchManagerToProductsView" {
            let destinationVC = segue.destination as! ProductsViewController
            destinationVC.viewControllerStyle = .ShowSearchResult
            if let subCat = sender as? String {
                destinationVC.apiParams = [subCat]
            }
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        performSegue(withIdentifier: "searchManagerToProductsView", sender: searchBar.text)
    }
    

}
