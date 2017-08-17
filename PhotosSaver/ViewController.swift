//
//  ViewController.swift
//  PhotosSaver
//
//  Created by kkolontay on 8/14/17.
//  Copyright © 2017 kkolontay.com. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  var tableView: PhotosListTableView?

  override func viewDidLoad() {
    super.viewDidLoad()
    let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
    let verticalConstraint = barHeight
    tableView = PhotosListTableView(frame: CGRect.zero, style: .plain)
    tableView?.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(tableView!)
    let dictionaryConstraint: [String: Any] = ["item": tableView ?? PhotosListTableView(frame: CGRect.zero, style: .plain)]
    view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-\(verticalConstraint)-[item]-|", options: [], metrics: nil, views: dictionaryConstraint))
   view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(-5)-[item]-(-5)-|", options: [], metrics: nil, views: dictionaryConstraint))
    NotificationCenter.default.addObserver(self, selector: #selector(reloadDataTable), name: NSNotification.Name("DataChanged"), object: nil)
  }

    deinit {
    NotificationCenter.default.removeObserver(self)
  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    reloadDataTable()
  }

  func reloadDataTable() {
    tableView?.userIdPhotosList = DataInstance.instance.fetchPhotosId()
    tableView?.certificatePhotosList = DataInstance.instance.fetchPhotoCertificate()
    tableView?.reloadData()
  }
}

