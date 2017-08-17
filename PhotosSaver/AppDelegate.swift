//
//  AppDelegate.swift
//  PhotosSaver
//
//  Created by kkolontay on 8/14/17.
//  Copyright © 2017 kkolontay.com. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  var navController: UINavigationController?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    navController = UINavigationController()
    navController?.navigationBar.isTranslucent = true
    let viewController: ViewController = ViewController()
    navController?.pushViewController(viewController, animated: false)
    window = UIWindow(frame: UIScreen.main.bounds)
    window?.backgroundColor = UIColor.white
    window?.rootViewController = navController
    window?.makeKeyAndVisible()
    _ = PhotosCollection.instance.fetchCollectionForAlbum()
    return true
  }
}
