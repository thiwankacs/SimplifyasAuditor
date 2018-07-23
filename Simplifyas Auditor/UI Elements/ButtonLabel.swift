//
//  ButtonLabel.swift
//  Simplifyas Auditor
//
//  Created by Thiwanka Nawarathne on 7/23/18.
//  Copyright © 2018 Simplifya. All rights reserved.
//

import UIKit

@IBDesignable class ButtonLabel: UIButton {
    
    let BtnTextColor = UIColor(red:0.39, green:0.38, blue:0.38, alpha:1.0)
    let fontFace = UIFont(name: "Roboto-Bold", size: 15)
    
    override func draw(_ rect: CGRect) {
        self.setTitleColor(BtnTextColor, for: .normal)
        
        self.layer.masksToBounds = true
        self.titleLabel?.font = fontFace
    }
}
