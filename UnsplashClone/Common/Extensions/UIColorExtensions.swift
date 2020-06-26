//
//  UIColorExtensions.swift
//  UnsplashClone
//
//  Created by 박병준 on 6/25/20.
//  Copyright © 2020 박병준. All rights reserved.
//

import Foundation

import UIKit

extension UIColor {
    
    @nonobjc class var keyColor: UIColor {
        return UIColorFromRGB("00c1b8")
    }
    @nonobjc class var keyRed: UIColor {
        return UIColorFromRGB("ff3b3b")
    }
    
    @nonobjc class var psGray: UIColor {
        return UIColorFromRGB("f2f2f2")
    }
    
    @nonobjc class var grayLine: UIColor {
        return UIColorFromRGB("dcdcdc")
    }
    @nonobjc class var keyGreen: UIColor {
        return UIColorFromRGB("00baa6")
    }
    
    
    
    @nonobjc class var psRandom: UIColor {
        
        let index = arc4random() % 4
        
        var rColor = UIColor()
        switch index{
        case 0:
            rColor = UIColorFromRGB("7accb8", 0.1)
            break
        case 1:
            rColor = UIColorFromRGB("ff3b3b", 0.1)
            break
        case 2:
            rColor = UIColorFromRGB("00baa6", 0.1)
            break
            
        case 3:
            rColor = UIColorFromRGB("fefc81", 0.1)
            break
            
        default:
            rColor = UIColorFromRGB("00baa6", 0.1)
            break
        }
        
        return rColor
    }
    
    
    
    convenience init(hex: String) {
        let scanner = Scanner(string: hex)
        var rgbValue: UInt32 = 0
        
        scanner.scanLocation = 0
        scanner.scanHexInt32(&rgbValue)
        
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: 1.0)
    }
    
    convenience init(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat, _ alpha: CGFloat = 1) {
        self.init(red: r / 255, green: g / 255, blue: b / 255, alpha: alpha)
    }
    


    
}


func UIColorFromRGB(_ hex:String, _ a:Float = 1.0) -> UIColor {
    let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
    var int = UInt32()
    Scanner(string: hex).scanHexInt32(&int)
    
    let r, g, b: UInt32
    switch hex.count {
    case 3: // RGB (12-bit)
        (r, g, b) = ((int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
    case 6: // RGB (24-bit)
        (r, g, b) = (int >> 16, int >> 8 & 0xFF, int & 0xFF)
    default:
        (r, g, b) = (1, 1, 0)
    }
    
    return UIColor(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(255 * a) / 255)
}
