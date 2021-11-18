//
//  ProductGridFlowLayout.swift
//  Multivendor
//
//  Created by Ahmad Shakir
//  Copyright © 2018 Multivendor All rights reserved.
//

import UIKit

class ProductGridFlowLayout: UICollectionViewFlowLayout {
    
    var itemWidth: CGFloat {
        return collectionView!.frame.width / 2
    }
    
    var itemHeight: CGFloat {
        return 340
    }
    
    override init() {
        super.init()
        
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupLayout()
    }
    
    func setupLayout() {
        scrollDirection = .vertical
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        sectionInset = UIEdgeInsetsMake(1, 0, 0, 0)
    }
    
    override var itemSize: CGSize {
        get {
            return CGSize(width: itemWidth, height: itemHeight)
        }
        set {
            self.itemSize = CGSize(width: itemWidth, height: itemHeight)
        }
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
        return collectionView!.contentOffset
    }
}

