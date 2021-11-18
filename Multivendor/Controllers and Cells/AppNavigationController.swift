//
//  AppNavigationController.swift
//  Multivendor
//
//  Created by Tintash on 30/01/2018.
//  Copyright © 2018 multivendor. All rights reserved.
//

import UIKit
import Material

class AppNavigationController: NavigationController {
    open override func prepare() {
        super.prepare()
        isMotionEnabled = true
        
        guard let v = navigationBar as? NavigationBar else {
            return
        }
        
        v.depthPreset = .none
        v.dividerColor = Color.orange.base
        
    }
}
