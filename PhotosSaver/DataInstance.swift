//
//  DataInstance.swift
//  PhotosSaver
//
//  Created by kkolontay on 8/15/17.
//  Copyright © 2017 kkolontay.com. All rights reserved.
//

import UIKit
import RealmSwift

class DataInstance: NSObject {
  private var _realm: Realm?
  static let instance = DataInstance()
  
  private  override init() {
    super.init()
    do {
      _realm = try Realm()
    } catch let error as NSError {
      print(error.localizedDescription)
    }
  }
  
  func save(_ isIdPhoto: Bool, photoPath: String) {
    do {
      try _realm?.write {
        _realm?.create(PhotoItem.self, value: [isIdPhoto, photoPath])
      }
    }catch let error as NSError {
      print(error.localizedDescription)
      
    }
  }
  
  func save(_ item: PhotoItem) {
    do { try _realm?.write {
      _realm!.add(item)
      }
    } catch let error as NSError {
      print(error.localizedDescription)
    }
  }
  
  func edit(_ path: String, item: PhotoItem) {
    do {
      try _realm?.write {
        item.photoPath = path
      }
    } catch let error as NSError {
      print(error.localizedDescription)
    }
  }
  
  func delete(_ item: PhotoItem) {
    do { try _realm?.write {
      _realm?.delete(item)
      }
    } catch let error as NSError {
      print(error.localizedDescription)
    }
  }
  
  func search(_ path: String) -> PhotoItem? {
    guard let item = _realm?.objects(PhotoItem.self).filter("photoPath contains \'\(path)\'").first else {
      return nil
    }
    return item
  }
  
  func fetchPhotosId() -> Array<PhotoItem>? {
    guard let items = _realm?.objects(PhotoItem.self).filter("isIdPhoto == true") else {
      return nil
    }
    return Array(items)
  }
  
  func fetchPhotoCertificate() -> Array<PhotoItem>? {
    guard let items = _realm?.objects(PhotoItem.self).filter("isIdPhoto == false") else {
      return nil
    }
    return Array(items)
  }
  
  func countPhotosId() -> Int {
    guard let count = _realm?.objects(PhotoItem.self).filter("isIdPhoto == true").count else {
      return 0
    }
    return count
  }
  
  func countPhotosCertificate() -> Int {
    guard let count = _realm?.objects(PhotoItem.self).filter("isIdPhoto == false").count else {
      return 0
    }
    return count
  }
}
