//
//  SplashScreenViewController.swift
//  Multivendor
//
//  Created by Tintash on 07/01/2018.
//  Copyright © 2018 multivendor. All rights reserved.
//

import UIKit
import Foundation

class SplashScreenViewController: UIViewController {
    
    var loaderCount = 6

    override func viewDidLoad() {
        super.viewDidLoad()
        showLoader(true)
        getCategoriesFromApi()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func showFirstView() {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        delegate.showMainNavigationController()
        //self.performSegue(withIdentifier: "splashToFirstScreen", sender: nil)
    }
    
    func getCategoriesFromApi() {
        NetworkManager.sharedManager.downloadJsonAtURL("getCategories" as NSString, params: nil, completion: {(result, statusCode) in
            if let resultDict = result.value as? NSDictionary, result.isSuccess {
                print(resultDict)
                if let dict = resultDict.object(forKey: "success") as? NSArray {
                    for cat in dict {
                        if let catArr = cat as? NSDictionary {
                            UserManager.shared.categories.updateValue(((catArr.object(forKey: "names") as? String)!, (catArr.object(forKey: "image") as? String)!, (catArr.object(forKey: "icon") as? String)!), forKey: (catArr.object(forKey: "id") as? Int)!)
                        }
                    }
                }
                self.getSubCategoriesFromApi()
            }
            else{
                
                //error
            }
        })
    }
    
    func getSubCategoriesFromApi() {
        NetworkManager.sharedManager.downloadJsonAtURL("getallSubCategories" as NSString, params: nil, completion: {(result, statusCode) in
            if let resultDict = result.value as? NSDictionary, result.isSuccess {
                print(resultDict)
                if let dict = resultDict.object(forKey: "success") as? NSArray {
                    for cat in dict {
                        if let subcatArr = cat as? NSDictionary {
                            let subID = subcatArr.object(forKey: "id") as? Int
                            let subName = subcatArr.object(forKey: "name") as? String
                            guard let catID = subcatArr.object(forKey: "category_id") as? String else {
                                return
                            }
                            if let val = (subID, subName) as? (Int, String) {
                                let catId = Int(catID)!
                                if UserManager.shared.subCategories[catId] != nil {
                                    var tempTupArr = UserManager.shared.subCategories[catId]
                                    tempTupArr?.append(val)
                                    UserManager.shared.subCategories.updateValue(tempTupArr!, forKey: catId)
                                }
                                else {
                                    UserManager.shared.subCategories.updateValue([val], forKey: catId)
                                }
                            }
                        }
                    }
                }
                self.getSliderImagesFromApi()
            }
            else{
                
                //error
            }
        })
    }
    
    func getSliderImagesFromApi() {
        NetworkManager.sharedManager.downloadJsonAtURL("slider" as NSString, params: nil, completion: {(result, statusCode) in
            if let resultDict = result.value as? NSDictionary, result.isSuccess {
                if let dict = resultDict.object(forKey: "success") as? NSDictionary {
                    UserManager.shared.homePageSliderData.append(dict.value(forKey: "image1") as! String)
                    UserManager.shared.homePageSliderData.append(dict.value(forKey: "image2") as! String)
                    UserManager.shared.homePageSliderData.append(dict.value(forKey: "image3") as! String)
                    UserManager.shared.homePageSliderData.append(dict.value(forKey: "image4") as! String)
                    UserManager.shared.homePageSliderData.append(dict.value(forKey: "image5") as! String)
                }
                self.getVendorsForHomeFromApi()
            }
        })
    }
    
    func getVendorsForHomeFromApi() {
        NetworkManager.sharedManager.downloadJsonAtURL("getvendors" as NSString, params: nil, completion: {
            (result, statusCode) in
            if let resultDict = result.value as? NSDictionary, result.isSuccess {
                if let vendArr = resultDict.object(forKey: "success") as? NSArray {
                    UserManager.shared.vendors.removeAll()
                    for vendor in vendArr {
                        UserManager.shared.vendors.append(VendorModel.init(withDictionary: vendor as! NSDictionary))
                    }
                }
                self.getBrandsForHomeFromApi()
            }
        })
    }
    
    func getBrandsForHomeFromApi() {
        NetworkManager.sharedManager.downloadJsonAtURL("brand" as NSString, params: nil, completion: {
            (result, statusCode) in
            if let resultDict = result.value as? NSDictionary, result.isSuccess {
                if let brandsArr = resultDict.object(forKey: "success") as? NSArray {
                    UserManager.shared.brands.removeAll()
                    for brand in brandsArr {
                        UserManager.shared.brands.append(BrandModel.init(withDictionary: brand as! NSDictionary))
                    }
                }
                self.getDiscountedProductsForHomeFromApi()
            }
        })
    }
    
    func getDiscountedProductsForHomeFromApi() {
        NetworkManager.sharedManager.downloadJsonAtURL("topdiscount" as NSString, params: nil, completion: {
            (result, statusCode) in
            if let resultDict = result.value as? NSDictionary, result.isSuccess {
                if let prodsArr = resultDict.object(forKey: "success") as? NSArray {
                    UserManager.shared.discountedProducts.removeAll()
                    for prod in prodsArr {
                        UserManager.shared.discountedProducts.append(ProductModel.init(withDictionary: prod as! NSDictionary))
                    }
                }
            }
            showLoader(false)
            self.perform(#selector(SplashScreenViewController.showFirstView), with: nil, afterDelay: 0)
        })
    }

}
