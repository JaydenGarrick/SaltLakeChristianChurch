//
//  extensions.swift
//  SaltLakeChristianChurch
//
//  Created by Jayden Garrick on 1/29/18.
//  Copyright © 2018 Jayden Garrick. All rights reserved.
//

import UIKit
import Firebase

extension UIViewController {
    func hideKeyboardWhenTappedAroundAndSetNavBar() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        navigationController?.navigationBar.barTintColor = UIColor(named: "Primary")
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func presentAlertControllerWithOkayAction(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(okayAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
}

extension UIImage {
    func scale(newWidth: CGFloat) -> UIImage {
        
        // Make sure the given widths is different from the existing one
        if self.size.width == newWidth {
            return self
        }
        
        // Calculate the scaling factor
        let scaleFactor = newWidth / self.size.width
        let newHeight = self.size.height * scaleFactor
        let newSize = CGSize(width: newWidth, height: newHeight)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        self.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage ?? self
    }
    
    func tabBarImageWithCustomTint(tintColor: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        let context: CGContext = UIGraphicsGetCurrentContext()!
        context.translateBy(x: 0, y: self.size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        context.setBlendMode(CGBlendMode(rawValue: 1)!)
        let rect: CGRect = CGRect(x: 0, y: 0, width:  self.size.width, height: self.size.height)
        context.clip(to: rect, mask: self.cgImage!)
        tintColor.setFill()
        context.fill(rect)
        var newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        newImage = newImage.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        return newImage
    }
}








