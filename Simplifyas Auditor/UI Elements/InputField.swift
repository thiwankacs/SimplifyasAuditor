//
//  InputField.swift
//  Simplifyas Auditor
//
//  Created by Thiwanka Nawarathne on 7/23/18.
//  Copyright © 2018 Simplifya. All rights reserved.
//

import UIKit

@IBDesignable class InputField : UITextField{
    let fontFace = UIFont(name: "Roboto-Regular", size: 15)
    
    override func draw(_ rect: CGRect) {
        self.textColor = UIColor.black
        self.font = fontFace
        
        // Enables Clear Button On Text Field
        self.clearButtonMode = .always
        self.clearButtonMode = .whileEditing
    }
}
