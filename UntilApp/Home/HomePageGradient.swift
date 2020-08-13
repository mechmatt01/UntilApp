//
//  HomePageGradient.swift
//  UntilApp
//
//  Created by Spencer Paciello on 8/1/20.
//

import UIKit
@IBDesignable
class HomePageGradient: UIView {
    
    
    var startColor: UIColor = UIColor(red: 186/255, green: 228/255, blue: 186/255, alpha: 1)
    var endColor: UIColor = UIColor(red: 70/255, green: 153/255, blue: 147/255, alpha: 1)
    
    override func draw(_ rect: CGRect) {
        
        let context = UIGraphicsGetCurrentContext()!
        let colors = [startColor.cgColor, endColor.cgColor]
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        let colorLocations: [CGFloat] = [0.0, 1.0]
        
        let gradient = CGGradient(colorsSpace: colorSpace,
                                  colors: colors as CFArray,
                                  locations: colorLocations)!
        
        let startPoint = CGPoint.init(x: self.layer.frame.maxX, y: 0)
        let endPoint = CGPoint(x: 0, y: bounds.height)
        context.drawLinearGradient(gradient,
                                   start: startPoint,
                                   end: endPoint,
                                   options: [CGGradientDrawingOptions(rawValue: 0)])
    }
    
    
}
