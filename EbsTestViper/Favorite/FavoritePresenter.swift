//
//  FavoritePresenter.swift
//  EbsTestViper
//
//  Created by Сережа Присяжнюк on 03.05.2022.
//

import Foundation
import RealmSwift

protocol FavoritePresenterProtocol {
  var view: FavoriteViewProtocol? { get set }
  var interactor: FavoriteInteracorProtocol? { get set }
  var router: FavoriteRouterProtocol? { get set }
  
  var id: Int { get set }
  var singleProduct: Products? { get set }
  
  func getSingleProduct()
  func setup(productId: Int)
  func pushDetailsViewController(navigationController: UINavigationController, productId: Int)
}

class FavoritePresenter: FavoritePresenterProtocol {
  var view: FavoriteViewProtocol?
  
  var interactor: FavoriteInteracorProtocol?
  
  var router: FavoriteRouterProtocol?
  
  var id: Int = 0
  
  var singleProduct: Products?
  
  func setup(productId: Int) {
    self.id = productId
  }
  
  func getSingleProduct() {
    interactor?.getSingleProduct(id: id, completion: { [weak self] (result) in
      guard let self = self else { return }
      switch result {
      case .success(let product):
        self.singleProduct = product
//        self.view?.getSingleProductSuccess(singleProduct: self.singleProduct)
      case .failure:
        let alert = UIAlertController(title: "Error", message: "Failed to get product!", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(cancel)
        alert.present(alert, animated: true)
      }
    })
  }
  
  func pushDetailsViewController(navigationController: UINavigationController, productId: Int) {
    router?.pushDetailsScreen(navigationController: navigationController, productId: productId )
  }
}
