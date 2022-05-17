//
//  DetailsPresenter.swift
//  EbsTestViper
//
//  Created by Сережа Присяжнюк on 03.05.2022.
//

import Foundation
import SkeletonView
import UIKit
// MARK: - Protocol
protocol DetailsPresenterProtocol {
  var view: DetailsViewProtocol? { get set }
  var interactor: DetailsInteractorProtocol? { get set }
  var router: DetailsRouterProtocol? { get set }
  
  var id: Int { get set }
  var singleProduct: Products! { get set }
  
  func getSingleProduct()
  func setup(productId: Int)
  
  func pushFavoriteViewController(navigationController: UINavigationController)
  
}
 // MARK: - Class
class DetailsPresenter: DetailsPresenterProtocol {
  var singleProduct: Products!
  var id: Int = 0
  
  var view: DetailsViewProtocol?
  var interactor: DetailsInteractorProtocol?
  var router: DetailsRouterProtocol?
  
  func setup(productId: Int) {
    self.id = productId
  }
  
  func getSingleProduct() {
    interactor?.getSingleProduct(id: id, completion: { [weak self] (result) in
      guard let self = self else { return }
      switch result {
      case .success(let product):
        self.singleProduct = product
        self.view?.getSingleProductSuccess(singleProduct: self.singleProduct)
      case .failure:
        let alert = UIAlertController(title: "Error", message: "Failed to get product!", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(cancel)
        alert.present(alert, animated: true)
      }
    })
  }
  
  func pushFavoriteViewController(navigationController: UINavigationController) {
    router?.pushFavoriteScreen(navigationController: navigationController)
  }

}
