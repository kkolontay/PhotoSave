//
//  Extensions.swift
//  PhotosSaver
//
//  Created by kkolontay on 8/17/17.
//  Copyright © 2017 kkolontay.com. All rights reserved.
//

import UIKit
extension UIViewController {
  
  func alertMessage(_ message: String) {
    let alert = UIAlertController(title: "Warning", message: message, preferredStyle: UIAlertControllerStyle.alert)
    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
    self.present(alert, animated: true, completion: nil)
  }
}
