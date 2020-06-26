//
//  NaviManager.swift
//  UnsplashClone
//
//  Created by 박병준 on 6/26/20.
//  Copyright © 2020 박병준. All rights reserved.
//

import Foundation
import UIKit

final class NaviManager{
    static let shared = NaviManager()
    
    public func initMainVC(){
        
        let naviC = UINavigationController()
        let vc = ListVC()
//        let vc = TestVC()
        
        UIApplication.shared.windows.first?.rootViewController = naviC
        naviC.viewControllers.append(vc)
    }
}
