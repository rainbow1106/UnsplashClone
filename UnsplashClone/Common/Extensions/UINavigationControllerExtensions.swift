//
//  UINavigationControllerExtensions.swift
//  UnsplashClone
//
//  Created by 박병준 on 6/26/20.
//  Copyright © 2020 박병준. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationController{
    func popViewController(animated: Bool,
                           completion: @escaping () -> Void) {
        
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        
        self.popViewController(animated: animated)
        
        CATransaction.commit()
    }
}
