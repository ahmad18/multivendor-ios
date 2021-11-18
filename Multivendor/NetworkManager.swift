//
//  NetworkManager.swift
//  Multivendor
//
//  Created by Ahmad Shakir on 07/01/2018.
//  Copyright © 2018 multivendor. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD
import Foundation

extension Request {
    public func debugLog() -> Self {
        #if DEBUG
            debugPrint(self)
        #endif
        return self
    }
}

class NetworkManager {
    
    static let sharedManager = NetworkManager()
    
    /**
     Its only called for calling the SignIn or Registration API's
     */
    func downloadJsonAtURL(_ fileURL:NSString, params:AnyObject? = nil, showHud:Bool = false, completion: @escaping (Result<Any>, Int?) -> Void){
        
        var string : NSString = ""
        
        string = NSString(format:"%@%@", GlobalData.baseAPIurl, fileURL)
        
        var httpMethod = HTTPMethod.post
        if params == nil{
            httpMethod = HTTPMethod.get
        }
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if(showHud){
            showLoader(true)
        }
        
        let handler: (DataResponse<Any>) -> Void = {(dataResponse) in
            #if DEBUG
                debugPrint(dataResponse)
            #endif
            if(showHud){
                showLoader(false)
            }
            
            let result = dataResponse.result
            let statusCode = dataResponse.response?.statusCode
            let resultValueDict = result.value as? NSDictionary
            let bHasErrorInDict = (resultValueDict?.object(forKey: "error") != nil)
            
            return completion(result, statusCode)
        }
        
        if let dictParams = params as? [String: AnyObject] {
            Alamofire.request(string as String, method: httpMethod, parameters: dictParams).debugLog().responseJSON(options: [], completionHandler: handler)
        } else {
            Alamofire.request(string as String, method: httpMethod, parameters: nil).debugLog().responseJSON(options: [], completionHandler: handler)
        }
    }
    
    func downloadDataForAPIAtURL(_ fileURL:NSString, withErrorMessage: String? = nil, showHud:Bool = false, params:[String: AnyObject]? = nil, method: Alamofire.HTTPMethod? = nil, fromController:UIViewController?, completion: @escaping (Result<Any>, Int?) -> Void, errorHandler : (() -> Void)? = nil) {
        
        //let isTokenValid = TokenManager.sharedManager.isTokenValid()
        let window = UIApplication.shared.windows[0]
        
        if (true) { //check token validity in this if clause
            
            
            let string = NSMutableString(format:"%@%@",GlobalData.baseAPIurl,fileURL)
            
            var httpMethod = HTTPMethod.post
            if params == nil{
                httpMethod = HTTPMethod.get
            }
            if(method != nil){
                httpMethod = method!
            }
            
            if(httpMethod == .put || httpMethod == .delete){
                // To handle card cancel request
                if let parameters = params {
                    for (key,value) in parameters {
                        string.appendFormat("?%@=%@", key as NSString, value as! NSString)
                    }
                }
            }
            
            let handler: (DataResponse<Any>) -> Void = {(dataResponse) in
                #if DEBUG
                    debugPrint(dataResponse)
                #endif
                let result = dataResponse.result
                
                if(showHud) {
                    showLoader(false)
                }
                
                if(httpMethod == .put || httpMethod == .delete){
                    // to handle PUT requests in the my card section which doesn't return valid json. And DELETE for deleting pending Doctor Request.
                    return completion(result, dataResponse.response?.statusCode)
                }
                if result.isSuccess{
                    return completion(result, dataResponse.response?.statusCode)
                }
                else{
                    var errorMessage = ""
                    if let error = result.error  {
                        errorMessage = error.localizedDescription
                    }
                    else{
                        errorMessage = result.error.debugDescription
                    }
                    
                    if let customMessage = withErrorMessage {
                        errorMessage = customMessage
                    }
                    /*if(errorMessage){
                        showAlertInViewController(fromController, titleStr: "Error", messageStr: errorMessage , okButtonTitle: "OK", cancelButtonTitle: nil)
                    }*/
                    
                    if let error = errorHandler{
                        return error()
                    }
                }
            }
            Alamofire.request(string as String, method: httpMethod, parameters: params, encoding:JSONEncoding.default, headers: nil).debugLog().responseJSON(options: [], completionHandler: handler)
        }
        else{
            // Token Has expired user must re-logIn
        }
    }
}
