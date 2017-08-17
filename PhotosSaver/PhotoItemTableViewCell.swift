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
      //button?.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
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
  
//  func buttonPressed(_ button: UIButton) {
//    let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
//    layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
//    layout.itemSize = CGSize(width: 90, height: 90)
//    let collectionView = PhotosCollectionViewController(collectionViewLayout: layout)
//    collectionView.isIdPhoto = isIdPhoto
//    let delegate = UIApplication.shared.delegate as! AppDelegate
//    let controllers = delegate.navController?.viewControllers
//    for  controller in controllers! {
//      if controller is ViewController {
//        controller.navigationController?.pushViewController(collectionView, animated: true)
//      }
//    }
//  }
  func setImageFromPath(_ path: String) {
    if imageViewCell != nil {
      imageViewCell?.contentMode = .scaleAspectFit
      let url = URL(string: path)
      if   let data = NSData(contentsOf: url!) {
     // let image = UIImage(contentsOfFile: path)

      imageViewCell?.image = UIImage(data: data as Data)
      }
    }
  }
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
  func setTitleButton(_ title: String) {
    if button != nil {
      button?.setTitleColor(UIColor.blue, for: .normal)
      button?.setTitle(title, for: .normal)
    }
  }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
