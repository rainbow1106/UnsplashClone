//
//  UIApplicationExtensions.swift
//  UnsplashClone
//
//  Created by 박병준 on 6/26/20.
//  Copyright © 2020 박병준. All rights reserved.
//

import UIKit

extension UIApplication {
    
    class func popToRootEnd(vc: UIViewController? = nil){
        
        guard let topVC = UIApplication.topViewController() else{
            return
        }
        
        var rVc = topVC
        if let uVC = vc {
            rVc = uVC
        }
        
        if rVc.isModal == true {
            rVc.dismiss(animated: false, completion: {
                
                if let uVc = UIApplication.topViewController(){
                    UIApplication.popToRootEnd(vc: uVc)
                }
                
                
            })
        }else{
            rVc.navigationController?.popToRootViewController(animated: true)
        }
        
    }
    class func topViewController(_ base: UIViewController? = UIApplication.shared.windows.first?.rootViewController) -> UIViewController? {

        if let nav = base as? UINavigationController {
            return topViewController(nav.visibleViewController)
        }

        if let tab = base as? UITabBarController {
            let moreNavigationController = tab.moreNavigationController

            if let top = moreNavigationController.topViewController{
                return topViewController(top)
            } else if let selected = tab.selectedViewController {
                return topViewController(selected)
            }
        }

        if let presented = base?.presentedViewController {
            return topViewController(presented)
        }

        return base
    }
    
}
