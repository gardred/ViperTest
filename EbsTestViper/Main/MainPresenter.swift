//
//  MainPresenter.swift
//  EbsTestViper
//
//  Created by Сережа Присяжнюк on 03.05.2022.
//

import Foundation
import UIKit
import Network
import RealmSwift

protocol MainPresenterProtocol {
    
    var view: MainViewProtocol? { get set}
    var router: MainRouterProtocol? { get set }
    var interactor: MainInteractorProtocol? { get set}
    
    var products: [Product] { get set}
    var current_page: Int {get set }
    
    func startFetchingProducts()
    func fetchProductsSuccess(products: [Product])
    func cacheImage(_ imageView: UIImageView)
    func toggleProductState(id: Int, realm: Realm)
    
    func pushDetailsViewController(navigationController: UINavigationController, productId: Int)
    func pushFavoriteViewController(navigationController: UINavigationController)
    func pushAuthenticationViewController(navigationController: UINavigationController)
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
    
    public func toggleProductState(id: Int, realm: Realm) {
       
        if let product = RealmService.shared.findProduct(id: id, realm: realm) {
            RealmService.shared.removeProduct(productToDelete: product, realm: realm)
        } else {
            guard let product = products.first(where: { $0.id == id }) else { return }
            RealmService.shared.addProduct(with: product, realm: realm)
        }
    }

    public func fetchProductsSuccess(products: [Product]) {
        view?.fetchProductsSuccess(productsArray: products)
    }
    
    public func pushFavoriteViewController(navigationController: UINavigationController) {
        router?.pushFavoriteScreen(navigationController: navigationController)
    }
    
    public func pushAuthenticationViewController(navigationController: UINavigationController) {
        router?.pushAuthenticationScreen(navigationController: navigationController)
    }
    
    public func pushDetailsViewController(navigationController: UINavigationController, productId: Int) {
        router?.pushDetailsScreen(navigationController: navigationController, productId: productId )
    }
    
    public func pushCartViewController(navigationController: UINavigationController) {
        router?.pushCartScreen(navigationController: navigationController)
    }
}
