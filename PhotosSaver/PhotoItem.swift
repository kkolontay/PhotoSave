//
//  PhotoItem.swift
//  PhotosSaver
//
//  Created by kkolontay on 8/15/17.
//  Copyright © 2017 kkolontay.com. All rights reserved.
//

import RealmSwift

class PhotoItem: Object {
  dynamic var isIdPhoto: Bool = false
  dynamic var photoPath: String = ""
}
