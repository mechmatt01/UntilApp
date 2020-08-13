//
//  UIFonts.swift
//  UntilApp
//
//  Created by Matthew Mech on 8/13/20.
//

import Foundation
import UIKit

extension UIFont {
    
    static func bungeeShadeRegular(size : CGFloat) -> UIFont {
        return UIFont(name: "BungeeShade-Regular", size: size) ??
            UIFont.systemFont(ofSize: size)
    }
    
    static func pacifico(size : CGFloat) -> UIFont {
        return UIFont(name: "Pacifico", size: size) ??
            UIFont.systemFont(ofSize: size)
    }
    
    static func sfProRoundedBold(size : CGFloat) -> UIFont {
        return UIFont(name: "SF-Pro-Rounded-Bold", size: size) ??
            UIFont.systemFont(ofSize: size)
    }
    
    static func sfProRoundedMedium(size : CGFloat) -> UIFont {
        return UIFont(name: "SF-Pro-Rounded-Medium", size: size) ??
            UIFont.systemFont(ofSize: size)
    }
    
    static func sfProRoundedRegular(size : CGFloat) -> UIFont {
        return UIFont(name: "SF-Pro-Rounded-Regular", size: size) ??
            UIFont.systemFont(ofSize: size)
    }
    
    static func sfProRoundedSemiBold(size : CGFloat) -> UIFont {
        return UIFont(name: "SF-Pro-Rounded-Semibold", size: size) ??
            UIFont.systemFont(ofSize: size)
    }
}
