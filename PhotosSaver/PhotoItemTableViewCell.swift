//
//  PhotoItemTableViewCell.swift
//  PhotosSaver
//
//  Created by kkolontay on 8/15/17.
//  Copyright © 2017 kkolontay.com. All rights reserved.
//

import UIKit

enum NameButton: String {
  case id = "Add new Photo"
  case certificate = "Add new Certificate"
}

enum NameCell: String {
  case cellButton = "button"
  case cellImages = "label"
}

class PhotoItemTableViewCell: UITableViewCell {
  var button: UIButton?
  var imageViewCell: UIImageView?
  var isIdPhoto: Bool = false
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    var viewDict: Dictionary<String, Any>?
    if (reuseIdentifier?.contains(NameCell.cellButton.rawValue))! {
      button = UIButton()
      button?.isUserInteractionEnabled = false
      button?.translatesAutoresizingMaskIntoConstraints = false
      contentView.addSubview(button!)
      viewDict = ["item": button ?? UIButton()] as [String: Any]
    } else {
      imageViewCell = UIImageView()
      imageViewCell?.translatesAutoresizingMaskIntoConstraints = false
      contentView.addSubview(imageViewCell!)
      viewDict = [ "item": imageViewCell ?? UIImageView()] as [String: Any]
    }
    contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[item]-|", options: [], metrics: nil, views: viewDict!))
    contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[item]-|", options: [], metrics: nil, views: viewDict!))
  }
  
  func setImageFromPath(_ path: String) {
    if imageViewCell != nil {
      imageViewCell?.contentMode = .scaleAspectFit
      let url = URL(string: path)
      if   let data = NSData(contentsOf: url!) {
        imageViewCell?.image = UIImage(data: data as Data)
      } else {
        searchPath((url?.lastPathComponent)!)
      }
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  func searchPath(_ path: String) {
    let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
    let photoURL          = NSURL(fileURLWithPath: documentDirectory)
    let localPath         = photoURL.appendingPathComponent(path)
    if let data = NSData(contentsOf: localPath!) {
      imageViewCell?.image = UIImage(data: data as Data)
    }
    
  }
  func setTitleButton(_ title: String) {
    if button != nil {
      button?.setTitleColor(UIColor.blue, for: .normal)
      button?.setTitle(title, for: .normal)
    }
  }
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
}
