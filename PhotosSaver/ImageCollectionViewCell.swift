//
//  ImageCollectionViewCell.swift
//  PhotosSaver
//
//  Created by kkolontay on 8/16/17.
//  Copyright © 2017 kkolontay.com. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
  private var imageView: UIImageView?
  var image: UIImage {
    get {
      return (imageView?.image)!
    }
    set {
      imageView?.image = newValue
    }
  }
  public override init(frame: CGRect) {
    super.init(frame: frame)
    imageView = UIImageView()
    imageView?.translatesAutoresizingMaskIntoConstraints = false
    contentView.addSubview(imageView!)
    contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[item]-|", options: [], metrics: nil, views: ["item": imageView!]))
    contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[item]-|", options: [], metrics: nil, views: ["item": imageView!]))
    
  }
  
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

}
