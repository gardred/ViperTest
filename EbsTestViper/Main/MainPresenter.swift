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
    
    var products: [Product] { get set}
    var current_page: Int {get set }
    
    func startFetchingProducts()
    func fetchProductsSuccess(products: [Product])
    func cacheImage(_ imageView: UIImageView)
    func toggleFavorite(id: Int)
    func toggleCart(id: Int)
    
    func pushDetailsViewController(navigationController: UINavigationController, productId: Int)
    func pushFavoriteViewController(navigationController: UINavigationController)
    func pushAuthentiocationViewController(navigationController: UINavigationController)
    func pushCartViewController(navigationController: UINavigationController)
}

class MainPresenter: MainPresenterProtocol {
  
    
   
    // MARK: - Variables
    
    private let monitor = NWPathMonitor()
    private var url = URL(string: Constansts.baseURL)
    
    public var current_page: Int = 1
    public var router: MainRouterProtocol?
    public var interactor: MainInteractorProtocol?
    public var view: MainViewProtocol?
    public var products: [Product] = []
    
    // MARK: - Functions
    
    public func startFetchingProducts() {
        
        interactor?.getProducts(atPage: current_page, completion: { [weak self] (result) in
            
            guard let self = self else { return }
            
            switch result {
                
            case .success(let getProd):
                
                self.products.append(contentsOf: getProd)
                self.current_page += 1
                self.view?.isFetchingData = false
                self.view?.hasNoMorePages = getProd.count > 0 
                self.view?.fetchProductsSuccess(productsArray: self.products)
                
            case .failure:
                self.view?.failedToFetchProducts()
            }
        })
    }
    
    public func cacheImage(_ imageView: UIImageView) {
        guard let url = url else { return }
        interactor?.downloadImage(url: url, completion: { image in
            imageView.image = image
        })
    }
    
    public func toggleFavorite(id: Int) {
       
        if let product = RealmService.shared.findProduct(id: id, realm: RealmService.shared.realm) {
            RealmService.shared.removeProduct(productToDelete: product, realm: RealmService.shared.realm)
        } else {
            guard let product = products.first(where: { $0.id == id }) else { return }
            RealmService.shared.addProduct(with: product, realm: RealmService.shared.realm)
        }
    }
    
    func toggleCart(id: Int) {
        if let product = RealmService.shared.findProduct(id: id, realm: RealmService.shared.cartRealm) {
            RealmService.shared.removeProduct(productToDelete: product, realm: RealmService.shared.cartRealm)
        } else {
            guard let product = products.first(where: { $0.id == id }) else { return }
            RealmService.shared.addProduct(with: product, realm: RealmService.shared.cartRealm)
        }
    }

    public func fetchProductsSuccess(products: [Product]) {
        view?.fetchProductsSuccess(productsArray: products)
    }
    
    public func pushFavoriteViewController(navigationController: UINavigationController) {
        router?.pushFavoriteScreen(navigationController: navigationController)
    }
    
    public func pushAuthentiocationViewController(navigationController: UINavigationController) {
        router?.pushAuthentiocationScreen(navigationController: navigationController)
    }
    
    public func pushDetailsViewController(navigationController: UINavigationController, productId: Int) {
        router?.pushDetailsScreen(navigationController: navigationController, productId: productId )
    }
    
    public func pushCartViewController(navigationController: UINavigationController) {
        router?.pushCartScreen(navigationController: navigationController)
    }
}
