//
//  ImageViewExtension.swift
//  Evaluation2021
//
//  Created by Sanat Salian on 13/02/21.
//  Copyright © 2021 Sanat Salian. All rights reserved.
//

import UIKit
extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
    
    func maskCircle(anyImage: UIImage) {
        self.contentMode = UIView.ContentMode.scaleAspectFill
        self.layer.cornerRadius = self.frame.height / 2
        self.layer.masksToBounds = false
        self.clipsToBounds = true
        
        self.image = anyImage
    }
    
    public func imageFromURL(urlString: String) {

        let activityIndicator = UIActivityIndicatorView(style: .large)
           activityIndicator.frame = CGRect.init(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
           activityIndicator.startAnimating()
           if self.image == nil{
               self.addSubview(activityIndicator)
           }

           URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL, completionHandler: { (data, response, error) -> Void in

               if error != nil {
                   print(error ?? "No Error")
                   return
               }
               DispatchQueue.main.async(execute: { () -> Void in
                   let image = UIImage(data: data!)
                   activityIndicator.removeFromSuperview()
                   self.image = image
               })

           }).resume()
       }
}
