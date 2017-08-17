//
//  PhotosListTableView.swift
//  PhotosSaver
//
//  Created by kkolontay on 8/15/17.
//  Copyright © 2017 kkolontay.com. All rights reserved.
//

import UIKit

protocol FetchDataImageDelegate: class {
  func renewDataTable()
}

class PhotosListTableView: UITableView {
  var collectionView: PhotosCollectionViewController?
  
  let sections: Array<String> = ["User ID Photos", "Certificate Photos"]
  var  userIdPhotosList: Array<PhotoItem>?
  var certificatePhotosList: Array<PhotoItem>?
  
 override init(frame: CGRect, style: UITableViewStyle) {
    super.init(frame: frame, style: style)
  userIdPhotosList = DataInstance.instance.fetchPhotosId()
  certificatePhotosList = DataInstance.instance.fetchPhotoCertificate()
    delegate = self
    dataSource = self
  }
  
  func sequeToCollectionView(_ isIdPhoto: Bool, photoItem: PhotoItem? = nil) {
    let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    layout.itemSize = CGSize(width: 90, height: 90)
    if collectionView == nil {
     collectionView = PhotosCollectionViewController(collectionViewLayout: layout)
    }
    collectionView?.isIdPhoto = isIdPhoto
    collectionView?.editingItem = photoItem
    let delegate = UIApplication.shared.delegate as! AppDelegate
    let controllers = delegate.navController?.viewControllers
    for  controller in controllers! {
      if controller is ViewController {
        controller.navigationController?.pushViewController(collectionView!, animated: true)
      }
    }
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension PhotosListTableView: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if section == 0 {
      if userIdPhotosList != nil  {
        return (userIdPhotosList?.count)! + 1
      }
      return 1
    } else {
      if certificatePhotosList != nil {
        return (certificatePhotosList?.count)! + 1
      }
      return 1
    }
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return sections[section]
  }
  public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    var cell: PhotoItemTableViewCell?
    if indexPath.row == 0 {
      cell = PhotoItemTableViewCell(style: .default, reuseIdentifier: NameCell.cellButton.rawValue)
      if indexPath.section == 0 {
        cell?.setTitleButton(NameButton.id.rawValue)
        cell?.isIdPhoto = true
      } else {
        cell?.setTitleButton(NameButton.certificate.rawValue)
        cell?.isIdPhoto = false
      }
    } else {
      cell = PhotoItemTableViewCell(style: .default, reuseIdentifier: NameCell.cellImages.rawValue)
      if indexPath.section == 0 {
      cell?.setImageFromPath((userIdPhotosList?[indexPath.row - 1].photoPath)!)
      } else {
        cell?.setImageFromPath((certificatePhotosList?[indexPath.row - 1].photoPath)!)
      }
    }
    return cell!
  }
  
   public func numberOfSections(in tableView: UITableView) -> Int {
    return sections.count
  }
}

extension PhotosListTableView: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      return 75
  }
  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
  {
    if (indexPath.row == 0 && indexPath.section ==  0) || (indexPath.row == 0 && indexPath.section == 1) {
      return false
    }
    return true
  }
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
   
    if editingStyle == .delete {
      if indexPath.section == 0 {
        let item = userIdPhotosList?[indexPath.row - 1]
        DataInstance.instance.delete(item!)
        userIdPhotosList?.remove(at: indexPath.row - 1)
      } else {
        DataInstance.instance.delete((certificatePhotosList?[indexPath.row - 1])!)
        certificatePhotosList?.remove(at: indexPath.row - 1)
      }
      reloadData()
    }
    
  }
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if indexPath.section == 0 && indexPath.row == 0 {
      sequeToCollectionView(true)
      return
    }
    if indexPath.section == 1 && indexPath.row == 0 {
      sequeToCollectionView(false)
      return
    }
    if indexPath.section == 0 {
      sequeToCollectionView(true, photoItem: userIdPhotosList?[indexPath.row - 1])
    } else {
      sequeToCollectionView(false, photoItem: certificatePhotosList?[indexPath.row - 1])
    }
  }
}
