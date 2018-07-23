//
//  ButtonBlue.swift
//  Simplifyas Auditor
//
//  Created by Thiwanka Nawarathne on 7/23/18.
//  Copyright © 2018 Simplifya. All rights reserved.
//

import UIKit

@IBDesignable class ButtonBlue: UIButton {
    
    let padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10);
    let cornerRadius : CGFloat = 4.0
    let BtnBackgroundColor = UIColor(red:0.32, green:0.55, blue:0.74, alpha:1.0)
    let fontFace = UIFont(name: "Roboto-Regular", size: 15)
    
    override func draw(_ rect: CGRect) {
        self.setTitleColor(UIColor.white, for: .normal)
        //let btnText = self.titleLabel?.text
        //self.setTitle(btnText?.uppercased(), for: .normal)
        //self.titleLabel?.text = self.titleLabel?.text?.uppercased()
        
        self.layer.backgroundColor = BtnBackgroundColor.cgColor
        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = true
        
        self.titleLabel?.font = fontFace
    }
}
