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
  
  var monitor: NWPathMonitor { get set}
  var isConnected: Bool { get set }
  var connectionType: ConnectionType { get set}
  
  func startFetchingProducts()
  func fetchProductsSuccess(products: [Products])

  func pushDetailsViewController(navigationController: UINavigationController, productId: Int)
  func pushFavoriteViewController(navigationController: UINavigationController)
  func pushAuthentiocationViewController(navigationController: UINavigationController)
  
  func startMonitoring()
  func stopMonitoring()
  func getConnectionType(_ path: NWPath)
  func checkForNetwork()
}

class MainPresenter: MainPresenterProtocol {

  var current_page: Int = 1
  var router: MainRouterProtocol?
  var interactor: MainInteractorProtocol?
  var view: MainViewProtocol?
  var products = [Products]()
  
  var monitor: NWPathMonitor
  
  var isConnected: Bool = false
  
  var connectionType: ConnectionType = .unknown
  
  init() {
    monitor = NWPathMonitor()
  }
  
  func startFetchingProducts() {
    interactor?.getProducts(atPage: current_page, completion: { [weak self] (result) in
      guard let self = self else { return }
      switch result {
      case .success(let getProd):
        self.products.append(contentsOf: getProd)
        self.current_page += 1
        self.view?.isFetchingData = false
        self.view?.fetchProductsSuccess(productsArray: self.products)
      case .failure(let error):
        print(error.localizedDescription)
      }
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
  
  func startMonitoring() {
    monitor.start(queue: DispatchQueue.global())
    monitor.pathUpdateHandler = { [weak self] path in
      self?.isConnected = path.status == .satisfied
      self?.getConnectionType(path)
    }
  }
  
  func stopMonitoring() {
    monitor.cancel()
  }
  
  func getConnectionType(_ path: NWPath) {
    if path.usesInterfaceType(.wifi) {
      connectionType = .wifi
    } else if path.usesInterfaceType(.cellular) {
      connectionType = .cellular
    } else if path.usesInterfaceType(.wiredEthernet) {
      connectionType = .ethernet
    } else {
      connectionType = .unknown
    }
  }
  func checkForNetwork() {
    if isConnected == false {
      
    } else {
      
      let alert = UIAlertController(title: "Failure", message: "You are not connected to the internet", preferredStyle: .alert)
      let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
      alert.addAction(cancelAction)
      alert.present(alert, animated: true)
    }
  }
}
