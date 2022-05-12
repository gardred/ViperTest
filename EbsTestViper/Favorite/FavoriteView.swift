//
//  FavoriteView.swift
//  EbsTestViper
//
//  Created by Сережа Присяжнюк on 03.05.2022.
//

import Foundation
import UIKit
import RealmSwift

protocol FavoriteViewProtocol {
  var presenter: FavoritePresenterProtocol? { get set }
}


class FavoriteView: BaseViewController , FavoriteViewProtocol {
  
  let realm = try! Realm()
  var presenter: FavoritePresenterProtocol?
  
  var favoriteList: Results<FavoriteList>!
  
  //UIElements
  
  @IBOutlet weak var favoriteProductsTableView : UITableView!
  @IBOutlet weak var favoriteProductsCount : UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupNavigationBar()
    
    favoriteList = self.realm.objects(FavoriteList.self)
    
    favoriteProductsTableView.register(ProductsTableViewCell.nib(), forCellReuseIdentifier: ProductsTableViewCell.identifier)
    favoriteProductsTableView.dataSource = self
    favoriteProductsTableView.delegate = self
    favoriteProductsCount.text = "\(favoriteList.count)"
    favoriteProductsCount.layer.cornerRadius = favoriteProductsCount.frame.height / 2
    favoriteProductsTableView.reloadData()
  }
  
  func setupNavigationBar() {
    setBackButton()
    setLogo()
    setHeartFillButton()
  }
  
}

extension FavoriteView : UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return favoriteList.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = favoriteProductsTableView.dequeueReusableCell(withIdentifier: ProductsTableViewCell.identifier, for: indexPath) as? ProductsTableViewCell else {
      return UITableViewCell()
    }
    cell.favButton.backgroundColor = hexStringToUIColor(hex: "#FAF0D8")
    cell.favButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
    
    let product = favoriteList[indexPath.row]
    cell.productName?.text = product.name
    cell.productDetails?.text = product.details
    cell.productPrice?.text = "$\(product.price)"
    cell.productSalePrice?.text = "$\(product.price)"
    cell.productImageView.sd_setImage(with: URL(string: product.main_image))
    
    cell.removeFavoriteProduct = { [weak self] in
      guard let self = self else { return}
      RealmService.shared.removeProduct(productToDelete: self.favoriteList[indexPath.row])
      NotificationCenter.default.post(name: NSNotification.Name("cell"), object: nil)
      self.favoriteProductsCount.text = "\(self.favoriteList.count)"
      self.favoriteProductsTableView.reloadData()
    }
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let product = favoriteList[indexPath.row]
    presenter?.pushDetailsViewController(navigationController: navigationController!, productId: product.id )
  }
  
  
}
