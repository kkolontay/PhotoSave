//
//  PhotosCollection.swift
//  PhotosSaver
//
//  Created by kkolontay on 8/16/17.
//  Copyright © 2017 kkolontay.com. All rights reserved.
//

import Photos

class PhotosCollection: NSObject {
  static let albumName = "PhotosSaver"
  static let instance = PhotosCollection()
  var imageListCollection: Array<Dictionary<String, AnyObject>>?
  var assetCollection: PHAssetCollection?
  var fetchImage: Array<Dictionary<String, AnyObject>> {
    return imageListCollection!
  }
  var delegateObject: FetchedImageDelegate?
  private override init() {
    super.init()
    if PHPhotoLibrary.authorizationStatus() != PHAuthorizationStatus.authorized {
      PHPhotoLibrary.requestAuthorization({ (status: PHAuthorizationStatus) -> Void in
        ()
      })
    }
    if PHPhotoLibrary.authorizationStatus() != PHAuthorizationStatus.authorized {
      PHPhotoLibrary.requestAuthorization(requestAuthorizationHandler)
    }
    assetCollection = fetchCollectionForAlbum()
  }
  
  func requestAuthorizationHandler(status: PHAuthorizationStatus) {
    if PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.authorized {
        self.createAlbum()
    }
  }
  
  func createAlbum() {
    PHPhotoLibrary.shared().performChanges({
      PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: PhotosCollection.albumName)
    }) { success, error in
      if success {
        self.assetCollection = self.fetchCollectionForAlbum()
      } else {
        print("error \(String(describing: error))")
      }
    }
  }
  
  func fetchCollectionForAlbum() -> PHAssetCollection? {
    let fetchOptions = PHFetchOptions()
    fetchOptions.predicate = NSPredicate(format: "title = %@", PhotosCollection.albumName)
    let collection = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
    guard let object = collection.firstObject else {
      return nil
    }
    return object
  }
  
  func fetchImageList() {
    imageListCollection = Array<Dictionary<String, AnyObject>>()
    if assetCollection == nil {
      return
    }
    let photoAssets = PHAsset.fetchAssets(in: assetCollection!, options: nil)
    let imageManager = PHImageManager.default()
    photoAssets.enumerateObjects({
      (object: AnyObject!, count: Int, stop: UnsafeMutablePointer<ObjCBool>) in
      if object is PHAsset {
        let asset = object as! PHAsset
        let imageSize = CGSize(width: asset.pixelWidth, height: asset.pixelHeight)
        let options = PHImageRequestOptions()
        options.deliveryMode = .fastFormat
        options.isSynchronous = true
        imageManager.requestImage(for: asset, targetSize: imageSize, contentMode: .aspectFit, options: options, resultHandler: {
          (image, info) -> Void in
          var realPath: String = ""
          if  let path = info?["PHImageFileURLKey"] as? NSURL {
            print(path)
            realPath = self.getRealUrl(path, image: image!)
          }
          let dictionary = ["image": image!, "path": realPath] as [String : Any]
          self.imageListCollection?.append(dictionary as [String : AnyObject])
          self.delegateObject?.imageListChanged(self.imageListCollection!)
          print("Info image \(String(describing: (info?["PHImageFileURLKey"])!))")
        })
      }
    })
  }
  func getRealUrl(_ url: NSURL, image: UIImage) -> String {
   // let imageUrl          = info[UIImagePickerControllerReferenceURL] as? NSURL
    let imageName         = url.lastPathComponent
    let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
    let photoURL          = NSURL(fileURLWithPath: documentDirectory)
    let localPath         = photoURL.appendingPathComponent(imageName!)
    if !FileManager.default.fileExists(atPath: localPath!.path) {
      do {
        try UIImageJPEGRepresentation(image, 1.0)?.write(to: localPath!)
        }catch {
        print("error saving file")
      }
    }
    return (localPath?.absoluteString)!
  }
  func save(image: UIImage) {
    if assetCollection == nil {
      return
    }
    PHPhotoLibrary.shared().performChanges({
      let assetChangeRequest = PHAssetChangeRequest.creationRequestForAsset(from: image)
      let assetPlaceHolder = assetChangeRequest.placeholderForCreatedAsset
      let albumChangeRequest = PHAssetCollectionChangeRequest(for: self.assetCollection!)
      let enumeration: NSArray = [assetPlaceHolder!]
      albumChangeRequest!.addAssets(enumeration)
      
    }, completionHandler: { Void in
      self.fetchImageList()
    })
  }
}
