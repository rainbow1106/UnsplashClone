//
//  CommonVManager.swift
//  UnsplashClone
//
//  Created by 박병준 on 6/26/20.
//  Copyright © 2020 박병준. All rights reserved.
//

import Foundation
import UIKit
import ALLoadingView
import Toast_Swift

final class CommonVManager{
    
    class func showErrorMsg(error: Error){
        
        guard let msg = (error as NSError).userInfo["result_msg"] as? String else{
            return
        }
        self.showMsg(msg: msg)
        
    }
    
    class func showMsg(msg: String){

        guard let v = UIApplication.topViewController()?.view else{
            return
        }
        v.endEditing(true)
        v.hideAllToasts()
        v.makeToast(msg)
        
    }
    
    class func showLoadingV(){
        
        guard ALLoadingView.manager.isPresented == false else{
            return
        }
        ALLoadingView.manager.showLoadingView(ofType: ALLVType.basic, windowMode: .fullscreen)
    }
    class func hideLoadingV(){
        ALLoadingView.manager.hideLoadingView(withDelay: 0.2, completionBlock: nil)
    }
    
    

}
