//
//  MainPresenter.swift
//  EbsTestViper
//
//  Created by Сережа Присяжнюк on 03.05.2022.
//

import Foundation
import UIKit
import Network
// View <------> PRESENTER ------> Router
//               PRESENTER <-----> Interactor

protocol MainPresenterProtocol {
  var view: MainViewProtocol? { get set}
  var router: MainRouterProtocol? { get set }
  var interactor: MainInteractorProtocol? { get set}
  
  var products: [Products] { get set}
  var current_page: Int {get set }
  
  func startFetchingProducts()
  func asynchronouslyDownloadImages(from url: URL) 
  func fetchProductsSuccess(products: [Products])
  
  func pushDetailsViewController(navigationController: UINavigationController, productId: Int)
  func pushFavoriteViewController(navigationController: UINavigationController)
  func pushAuthentiocationViewController(navigationController: UINavigationController)

  func toggleFavorite(id: Int)
}

class MainPresenter: MainPresenterProtocol {

  func toggleFavorite(id: Int) {
    if let product = RealmService.shared.findProduct(id: id) {
      RealmService.shared.deleteElement(products: product)
    } else {
      let product = products.first(where: { $0.id == id })
      RealmService.shared.addProduct(with: product!)
    }
  }

  var current_page: Int = 1
  var router: MainRouterProtocol?
  var interactor: MainInteractorProtocol?
  var view: MainViewProtocol?
  var products = [Products]()

  func startFetchingProducts() {
    interactor?.getProducts(atPage: current_page, completion: { [weak self] (result) in
      guard let self = self else { return }
      switch result {
      case .success(let getProd):
        self.products.append(contentsOf: getProd)
        self.current_page += 1
        self.view?.isFetchingData = false
        self.view?.fetchProductsSuccess(productsArray: self.products)
      case .failure:
        self.view?.checkNetworkConnection()
      }
    })
  }
  
  func asynchronouslyDownloadImages(from url: URL) {
    interactor?.getData(from: url, completion: { data, response, error in
      guard let data = data, error == nil else {
        return
      }
      print(response?.suggestedFilename ?? url.lastPathComponent)
    })
  }

  func fetchProductsSuccess(products: [Products]) {
    view?.fetchProductsSuccess(productsArray: products)
  }
  
  func pushFavoriteViewController(navigationController: UINavigationController) {
    router?.pushFavoriteScreen(navigationController: navigationController)
  }
  
  func pushAuthentiocationViewController(navigationController: UINavigationController) {
    router?.pushAuthentiocationScreen(navigationController: navigationController)
  }
  
  func pushDetailsViewController(navigationController: UINavigationController, productId: Int) {
    router?.pushDetailsScreen(navigationController: navigationController, productId: productId )
  }
}
