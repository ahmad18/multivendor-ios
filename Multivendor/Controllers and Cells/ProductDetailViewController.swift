//
//  ProductDetailViewController.swift
//  Multivendor
//
//  Created by Tintash on 17/01/2018.
//  Copyright © 2018 multivendor. All rights reserved.
//

import UIKit
import ImageSlideshow

class ProductDetailViewController: UIViewController {

    @IBOutlet weak var imageGalleryView: ImageSlideshow!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productDescription: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productDetails: UILabel!
    @IBOutlet weak var addToCartButton: UIButton!
    @IBOutlet weak var goToCart: UIButton!
    @IBOutlet weak var buyNowButton: UIButton!
    @IBOutlet weak var vendorName: UILabel!
    @IBOutlet weak var brandName: UILabel!
    @IBOutlet var ratingsStar: [UIImageView]!
    @IBOutlet weak var ratingsCount: UILabel!
    @IBOutlet weak var heartImage: UIImageView!
    
    
    var product: ProductModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupProduct()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setupProduct()
    }
    
    func setupProduct() {
        if let item = product {
            
            productName.text = item.name != nil ? item.name! : "-"
            productDescription.text = item.description != nil ? item.description! : "-"
            productPrice.text = item.price != nil ? "AED \(item.price!)" : "-"
            productDetails.text = item.detail != nil ? item.detail! : "-"
            brandName.text = UserManager.shared.getBrandName(product!.brand_id ?? "")
            vendorName.text = UserManager.shared.getVendorName(product!.vendor_id ?? "")
            
            let inCart = isProductInCart()
            goToCart.isHidden = !inCart
            addToCartButton.isHidden = inCart
            
            var imageUrls = [String]()
            if let  _ = item.image {
                imageUrls.append(item.image!)
            }
            if let  _ = item.image1 {
                imageUrls.append(item.image1!)
            }
            if let  _ = item.image2 {
                imageUrls.append(item.image2!)
            }
            if let  _ = item.image3 {
                imageUrls.append(item.image3!)
            }
            self.setupImageSlider(imageUrls)
        }
        
        for star in ratingsStar {
            star.image = UIImage.init(named: "grey_star")
        }
        if (product!.roundedStarsInt > 0) {
            for index in 1...product!.roundedStarsInt {
                ratingsStar[index-1].image = UIImage.init(named: "yellow_star")
            }
        }
        ratingsCount.text = "(\(product!.totalReviews ?? 0))"
        heartImage.image = UIImage.init(named: "grey_heart")
        for prod in UserManager.shared.favs {
            if prod.id == self.product!.id {
                heartImage.image = UIImage.init(named: "red_heart")
            }
        }
    }
    
    func isProductInCart() -> Bool {
        for item in UserManager.shared.cart {
            if item.product?.id == product?.id {
                return true
            }
        }
        return false
    }
    
    func setupImageSlider(_ imageUrls: [String]) {
        
        var alamofireSource = [AlamofireSource]()
        for imgUrl in imageUrls {
            alamofireSource.append(AlamofireSource(urlString: imgUrl)!)
        }
    
        imageGalleryView.backgroundColor = UIColor.white
        imageGalleryView.slideshowInterval = 5.0
        imageGalleryView.pageControlPosition = PageControlPosition.underScrollView
        imageGalleryView.pageControl.currentPageIndicatorTintColor = UIColor.lightGray
        imageGalleryView.pageControl.pageIndicatorTintColor = UIColor.black
        imageGalleryView.contentScaleMode = UIViewContentMode.scaleAspectFit
        
        // optional way to show activity indicator during image load (skipping the line will show no activity indicator)
        imageGalleryView.activityIndicator = DefaultActivityIndicator()
        imageGalleryView.currentPageChanged = { page in
            print("current page:", page)
        }
        
        imageGalleryView.setImageInputs(alamofireSource)
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(ProductDetailViewController.didTap))
        imageGalleryView.addGestureRecognizer(recognizer)
    }
    
    @objc func didTap() {
        let fullScreenController = imageGalleryView.presentFullScreenController(from: self)
        fullScreenController.slideshow.activityIndicator = DefaultActivityIndicator(style: .white, color: nil)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func addToCartButtonPressed(_ sender: Any) {
        UserManager.shared.addToCart(product: product!, qty: 1)
        addToCartButton.isHidden = true
        goToCart.isHidden = false
    
    }
    
    @IBAction func goToCartButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "productDetailToCart", sender: self)
    }
    
    @IBAction func buyNowButtonPressed(_ sender: Any) {
        UserManager.shared.addToCart(product: product!, qty: 1)
        performSegue(withIdentifier: "productDetailToCart", sender: self)
    }
    
    @IBAction func addToFavs(_ sender: Any) {
        if (heartImage.image == UIImage.init(named: "grey_heart")) {
            UserManager.shared.favs.append(product!)
            heartImage.image = UIImage.init(named: "red_heart")
        }
        else {
            var ind = 0
            var deleteFromFavs = false
            for prod in UserManager.shared.favs {
                if prod.id == self.product!.id {
                    deleteFromFavs = true
                    break
                }
                ind = ind + 1
            }
            if deleteFromFavs {
                UserManager.shared.favs.remove(at: ind)
            }
            heartImage.image = UIImage.init(named: "grey_heart")
        }
    }
    
    @IBAction func rateThisProductPressed(_ sender: Any) {
        if UserManager.shared.isLoggedIn {
            if (UserManager.shared.hasBought(product!.id!)) {
                //enter rating
            }
            else {
                showAlertInViewController(self, titleStr: "Attention", messageStr: "You need to buy this product before you can rate it", okButtonTitle: "Okay", cancelButtonTitle: nil)
            }
        }
        else {
            showAlertInViewController(self, titleStr: "Log in to continue", messageStr: "You need to log in to Multivendor for rating a product", okButtonTitle: "Okay", cancelButtonTitle: nil)
        }
    }
    
    @IBAction func viewProductsByThisVendorPressed(_ sender: Any) {
        performSegue(withIdentifier: "productDetailToVendorProducts", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "productDetailToVendorProducts" {
            let destinationVC = segue.destination as! ProductsViewController
            destinationVC.viewControllerStyle = .ShowVendorProducts
            destinationVC.apiParams = [(product?.vendor_id)!]
        }
    }
}


