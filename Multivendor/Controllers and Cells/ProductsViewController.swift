//
//  ProductsViewController.swift
//  Multivendor
//
//  Created by Tintash on 15/01/2018.
//  Copyright © 2018 multivendor. All rights reserved.
//

import UIKit

enum CollectionViewStyle {
    case List
    case Grid
}

enum ProductsViewControllerStyle {
    case ShowCategory
    case ShowSubCategory
    case ShowSearchResult
    case ShowVendorProducts
    case ShowBrandsProducts
}

class ProductsViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var switchGridModeButton: UIButton!
    
    var currentProductView: CollectionViewStyle = .Grid
    var viewControllerStyle: ProductsViewControllerStyle = .ShowSubCategory
    
    var products = [ProductModel]()
    var apiParams = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupProductsViewScene()
        
        navigationItem.backButton.tintColor = UIColor.orange
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        collectionView.reloadData()
    }
    
    func setupProductsViewScene() {
        var urlStr = ""
        switch viewControllerStyle {
        case .ShowSearchResult:
            navigationItem.titleLabel.text = "Search Results"
            urlStr = "searchproductbyname/" + apiParams[0]
            
        case .ShowSubCategory:
            navigationItem.titleLabel.text = apiParams[1]
            urlStr = "anyproduct?subcategory_id=" + apiParams[0]
            
        case .ShowCategory:
            navigationItem.titleLabel.text = apiParams[1]
            urlStr = "anyproduct?Category_id=" + apiParams[0]
            
        case .ShowVendorProducts:
            navigationItem.titleLabel.text = UserManager.shared.getVendorName(apiParams[0])
            urlStr = "anyproduct?vendor_id=" + apiParams[0]
            
        case .ShowBrandsProducts:
            navigationItem.titleLabel.text = UserManager.shared.getBrandName(apiParams[0])
            urlStr = "anyproduct?brand_id=" + apiParams[0]
        }
        
        NetworkManager.sharedManager.downloadJsonAtURL(urlStr as NSString, params: nil, showHud: true, completion:{(result, statusCode) in
            if let jsonDict = result.value as? NSDictionary
            {
                if let productsDict = jsonDict.object(forKey: "success") as? NSArray {
                    for product in productsDict {
                        self.products.append(ProductModel.init(withDictionary: product as! NSDictionary))
                    }
                    let productGridFlowLayout = ProductGridFlowLayout()
                    self.collectionView.collectionViewLayout.invalidateLayout()
                    self.collectionView.setCollectionViewLayout(productGridFlowLayout, animated: false)
                    self.collectionView.reloadData()
                }
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func switchGridModeButtonPressed(_ sender: Any) {
        
        if (currentProductView == .Grid) {
            currentProductView = .List
            let productListFlowLayout = ProductListFlowLayout()
            self.collectionView.collectionViewLayout.invalidateLayout()
            self.collectionView.setCollectionViewLayout(productListFlowLayout, animated: false)
            switchGridModeButton.setImage(UIImage(named: "list"), for: .normal)
            collectionView.reloadData()
        }
        else {
            currentProductView = .Grid
            let productGridFlowLayout = ProductGridFlowLayout()
            self.collectionView.collectionViewLayout.invalidateLayout()
            self.collectionView.setCollectionViewLayout(productGridFlowLayout, animated: false)
            switchGridModeButton.setImage(UIImage(named: "grid"), for: .normal)
            collectionView.reloadData()
        }
    }
}

extension ProductsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell: ProductCell
        
        switch currentProductView {
        case .List:
            cell = productListCell(indexPath)
        case .Grid:
            cell = productGridCell(indexPath)
        }
        
        //fetchNextPageProducts(indexPath)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "productsViewToProductDetail", sender: indexPath.row)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "productsViewToProductDetail" {
            let destinationVC = segue.destination as! ProductDetailViewController
            if let index = sender as? Int {
                destinationVC.product = products[index]
            }
        }
    }
    
    func productListCell(_ indexPath: IndexPath) -> ProductCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductListCell", for: indexPath) as! ProductCell
        cell.product = products[indexPath.row]
        cell.setupCell()
        return cell
    }
    
    func productGridCell(_ indexPath: IndexPath) -> ProductCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductGridCell", for: indexPath) as! ProductCell
        cell.product = products[indexPath.row]
        cell.setupCell()
        return cell
    }
}

