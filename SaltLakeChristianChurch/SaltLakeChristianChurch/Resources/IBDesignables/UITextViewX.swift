//
//  UITextViewX.swift
//  Root
//
//  Created by Jayden Garrick on 1/17/18.
//  Copyright © 2018 Jayden Garrick. All rights reserved.
//

import UIKit

@IBDesignable class UITextViewX: UITextView {

    @IBInspectable var cornerRadius: CGFloat = 0 {
        
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        
        didSet {
            
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        
        didSet {
            
            self.layer.borderColor = borderColor.cgColor
        }
    }

}
        
        

