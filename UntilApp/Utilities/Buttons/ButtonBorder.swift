//
//  ButtonBorder.swift
//  UntilApp
//
//  Created by Spencer Paciello on 8/7/20.
//

import UIKit

@IBDesignable class ButtonBorder: UIButton {

    
//     Only override draw() if you perform custom drawing.
//     An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        self.layer.borderWidth = 2;
        self.layer.borderColor = UIColor.white.cgColor
    }
    

}
