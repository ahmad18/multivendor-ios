//
//  MosaicImagesTableViewCell.swift
//  Multivendor
//
//  Created by Tintash on 10/01/2018.
//  Copyright © 2018 multivendor. All rights reserved.
//

import UIKit
import ImageSlideshow

class MosaicImagesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var bannerSliderView: ImageSlideshow!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupImageSlider(UserManager.shared.homePageSliderData)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupImageSlider(_ imageUrls: [String]) {
        
        var alamofireSource = [AlamofireSource]()
        for imgUrl in imageUrls {
            alamofireSource.append(AlamofireSource(urlString: imgUrl)!)
        }
        
        bannerSliderView.backgroundColor = UIColor.white
        bannerSliderView.slideshowInterval = 4.0
        bannerSliderView.pageControlPosition = PageControlPosition.insideScrollView
        bannerSliderView.pageControl.currentPageIndicatorTintColor = UIColor.lightGray
        bannerSliderView.pageControl.pageIndicatorTintColor = UIColor.black
        bannerSliderView.contentScaleMode = UIViewContentMode.scaleToFill
        
        // optional way to show activity indicator during image load (skipping the line will show no activity indicator)
        bannerSliderView.activityIndicator = DefaultActivityIndicator()
        bannerSliderView.currentPageChanged = { page in
            print("current page:", page)
        }
        
        bannerSliderView.setImageInputs(alamofireSource)
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(MosaicImagesTableViewCell.didTap))
        bannerSliderView.addGestureRecognizer(recognizer)
    }
    
    @objc func didTap() {
        
    }
    
}
