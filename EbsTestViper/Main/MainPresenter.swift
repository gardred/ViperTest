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
//    func checkNetworkConnection()
    
    func pushDetailsViewController(navigationController: UINavigationController, productId: Int)
    func pushFavoriteViewController(navigationController: UINavigationController)
    func pushAuthentiocationViewController(navigationController: UINavigationController)
}

class MainPresenter: MainPresenterProtocol {
    
    let monitor = NWPathMonitor()
    var current_page: Int = 1
    var router: MainRouterProtocol?
    var interactor: MainInteractorProtocol?
    var view: MainViewProtocol?
    var products = [Product]()
    private var url = URL(string: Constansts.baseURL)
    
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
                self.view?.failedToFetchProducts()
            }
        })
    }
    
    func cacheImage(_ imageView: UIImageView) {
        guard let url = url else { return }
        interactor?.downloadImage(url: url, completion: { image in
            imageView.image = image
        })
    }

    func toggleFavorite(id: Int) {
        if let product = RealmService.shared.findProduct(id: id) {
            RealmService.shared.removeProduct(productToDelete: product)
        } else {
            guard let product = products.first(where: { $0.id == id }) else { return }
            RealmService.shared.addProduct(with: product)
        }
    }
    
    func fetchProductsSuccess(products: [Product]) {
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
