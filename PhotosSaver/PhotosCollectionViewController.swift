//
//  PhotosCollectionViewController.swift
//  PhotosSaver
//
//  Created by kkolontay on 8/15/17.
//  Copyright © 2017 kkolontay.com. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

protocol FetchedImageDelegate: class {
  func imageListChanged(_ list: Array<Dictionary<String, AnyObject>>)
}

class PhotosCollectionViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  var imagePicker: UIImagePickerController?
  var imageList: Array<Dictionary<String, AnyObject>>?
  var isIdPhoto: Bool = false
  var editingItem: PhotoItem?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "SelectPhoto"
    PhotosCollection.instance.delegateObject = self
    PhotosCollection.instance.fetchImageList()
    imageList = Array<Dictionary<String, AnyObject>>()
    collectionView?.backgroundColor = UIColor.white
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(goToPhotoMaker(_:)))
    self.collectionView!.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    imageList = PhotosCollection.instance.fetchImage
  }
  
  func goToPhotoMaker(_ sender: Any) {
    imagePicker = UIImagePickerController()
    imagePicker?.delegate = self
    imagePicker?.sourceType = .camera
    present(imagePicker!, animated: true, completion: nil)
    
  }
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return (imageList?.count)!
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ImageCollectionViewCell
    cell.image = (imageList?[indexPath.row]["image"])! as! UIImage
    return cell
  }
  
  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if let path: String = imageList![indexPath.row]["path"] as? String {
      if  DataInstance.instance.search(path) == nil {
        if editingItem == nil {
          DataInstance.instance.save(isIdPhoto, photoPath: path )
        } else {
          DataInstance.instance.edit(path, item: editingItem!)
        }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DataChanged"), object: nil)
        navigationController?.popViewController(animated: true)
      } else {
        self.alertMessage("You have this photo, please choose another.")
      }
    }
  }
  
  // Uncomment this method to specify if the specified item should be highlighted during tracking
  override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
    return true
  }
  
  
  
  // Uncomment this method to specify if the specified item should be selected
  override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
    return true
  }
  
  
  /*
   // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
   override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
   return false
   }
   
   override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
   return false
   }
   
   override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
   
   }
   */
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    imagePicker?.dismiss(animated: true, completion: nil)
    let image = info[UIImagePickerControllerOriginalImage] as? UIImage
    PhotosCollection.instance.save(image: image!)
    imagePicker = nil
  }
}

extension PhotosCollectionViewController: FetchedImageDelegate {
  func imageListChanged(_ list: Array<Dictionary<String, AnyObject>>) {
    imageList = list
    DispatchQueue.main.async {
      self.collectionView?.reloadData()
    }
  }
}
