//
//  BaseViewController.swift
//  EbsTestViper
//
//  Created by Сережа Присяжнюк on 06.05.2022.
//

import UIKit

class BaseViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.navigationController?.navigationBar.tintColor = .white
  }
  
  func setRightBarButtonHeart() {
    navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "heart"),
                                                        style: .plain,
                                                        target: self,
                                                        action: nil)
  }
  func setLeftBarButtonPreson() {
    navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "person"),
                                                       style: .plain,
                                                       target: self,
                                                       action: nil)
  }
  
  func setHeartFillButton() {
    navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "heart.fill"),
                                                        style: .plain,
                                                        target: self,
                                                        action: nil)
  }
  
  func setLogo() {
    let logo = UIImage(named: "Logo")
    let imageView = UIImageView(image: logo)
    imageView.contentMode = .scaleAspectFit
    imageView.sizeToFit()
    navigationItem.titleView = imageView
  }
  
  func setBackButton() {
    navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.left"),
                                                       style: .plain,
                                                       target: self,
                                                       action: #selector(popViewController))
  }
  
  @objc func popViewController() {
    self.navigationController?.popViewController(animated: true)
  }
  
}
