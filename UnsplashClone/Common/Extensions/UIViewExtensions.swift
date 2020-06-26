//
//  UIViewExtensions.swift
//  UnsplashClone
//
//  Created by 박병준 on 6/26/20.
//  Copyright © 2020 박병준. All rights reserved.
//

import Foundation
import UIKit

extension UIView{
    func showSubviews(){
        
        guard isDev == true else{
            return 
        }
        self.layer.borderColor = UIColor.red.cgColor
        self.layer.borderWidth = 1
        
        self.subviews.forEach {
            $0.layer.borderColor = UIColor.black.cgColor
            $0.layer.borderWidth = 1
        }
        
    }
    
    func VibrateAnimation(repeatCount: Float = 4, duration: Double = 0.03) {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = duration
        animation.repeatCount = repeatCount
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 3.0, y: self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 3.0, y: self.center.y))
        self.layer.add(animation, forKey: "position")
    }
    
    func makeRoundShadow(radius: CGFloat, shadowOffset: CGSize){
        
        guard let superV = self.superview else{
            return
        }
        
        self.do {
            $0.clipsToBounds = true
            $0.layer.masksToBounds = true
            $0.layer.cornerRadius = radius
        }
        
        superV.do {
            $0.backgroundColor = .clear
            $0.layer.shadowColor = UIColor.black.cgColor
            $0.layer.shadowOffset = shadowOffset
            $0.layer.shadowOpacity = 0.1
            $0.layer.shadowRadius = 2
        }
    }
    func asImage() -> UIImage{
        
        let renderer = UIGraphicsImageRenderer(bounds: self.bounds)
        return renderer.image { [weak self](imgContext) in
            guard let `self` = self else{
                return
            }
            self.layer.render(in: imgContext.cgContext)
        }
        
    }

}
