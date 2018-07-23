//
//  InputFieldsWrapper.swift
//  Simplifyas Auditor
//
//  Created by Thiwanka Nawarathne on 7/23/18.
//  Copyright © 2018 Simplifya. All rights reserved.
//

import UIKit

@IBDesignable class InputFieldsWrapper : UIView{
    let ViewBackgroundColor = UIColor(red:0.96, green:0.96, blue:0.96, alpha:1.0)
    let ViewBorderColor = UIColor(red:0.91, green:0.91, blue:0.91, alpha:1.0)
    let cornerRadius : CGFloat = 4.0
    
    override func draw(_ rect: CGRect) {
        self.layer.backgroundColor = ViewBackgroundColor.cgColor
        self.layer.borderColor = ViewBorderColor.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = true
        
    }
}
