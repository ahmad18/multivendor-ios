//
//  UtilityFunctions.swift
//  Multivendor
//
//  Created by Ahmad Shakir on 07/01/2018.
//  Copyright © 2018 multivendor. All rights reserved.
//

import UIKit
import MBProgressHUD

func showLoader(_ shouldShow: Bool) {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    if shouldShow {
        let loadingNotification = MBProgressHUD.showAdded(to: appDelegate.window!, animated: true)
        loadingNotification.mode = MBProgressHUDMode.indeterminate
    } else {
        MBProgressHUD.hideAllHUDs(for: appDelegate.window!, animated: false)
    }
    
}

func showAlertInViewController(_ controller :UIViewController, titleStr :String?, messageStr :String?, okButtonTitle :String?, cancelButtonTitle :String?, response :((_ dismissedWithCancel: Bool) -> Void)? = nil) {
    
    let alertController: UIAlertController = UIAlertController(title: titleStr, message: messageStr, preferredStyle: .alert)
    let ok = UIAlertAction(title: okButtonTitle, style: .default, handler: {(action) in
        alertController.dismiss(animated: true, completion: nil)
        if let okResponse = response {
            okResponse(false)
        }
    })
    alertController.addAction(ok)
    if (cancelButtonTitle != nil) {
        let cancel = UIAlertAction(title: cancelButtonTitle! , style: .cancel, handler: {(cancel) in
            alertController.dismiss(animated: true, completion: nil)
            if let cancelResponse = response {
                cancelResponse(true)
            }
        })
        alertController.addAction(cancel)
    }
    
    controller.present(alertController, animated: true, completion: nil)
}

