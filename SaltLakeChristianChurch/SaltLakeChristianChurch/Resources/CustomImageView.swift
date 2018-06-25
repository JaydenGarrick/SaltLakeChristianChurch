//
//  CustomImageView.swift
//  SaltLakeChristianChurch
//
//  Created by Jayden Garrick on 4/12/18.
//  Copyright © 2018 Jayden Garrick. All rights reserved.
//

import UIKit

var imageCache = NSCache<NSString, UIImage>()

class CustomImageView: UIImageView {
    
    var lastURLUsedToLoadImage: String?
    func loadImage(urlString: String) {
        
        // Caching Image
        if let cachedImage = imageCache.object(forKey: NSString(string: urlString)) {
            self.image = cachedImage
            return
        }
        
        lastURLUsedToLoadImage = urlString // Last used Url
        guard let url = URL(string: urlString) else { return }
        
        if url.absoluteString != lastURLUsedToLoadImage {
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                print("Error fetching image: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else { return }
            guard let photoimage = UIImage(data: data) else { return }
            
            
            imageCache.setObject(photoimage, forKey: NSString(string: urlString))
            
            DispatchQueue.main.async {
                self.image = photoimage
            }
            
            }.resume()
        
    }
}
