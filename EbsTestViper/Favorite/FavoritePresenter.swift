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
    var products: [Product] { get set}
    
    func toggleFavorite(id: Int)
    func pushDetailsViewController(navigationController: UINavigationController, productId: Int)
}

class FavoritePresenter: FavoritePresenterProtocol {
    var view: FavoriteViewProtocol?
    var interactor: FavoriteInteracorProtocol?
    var router: FavoriteRouterProtocol?
    var products = [Product]()
    var id: Int = 0
    
    func toggleFavorite(id: Int) {
        if let product = RealmService.shared.findProduct(id: id, realm: RealmService.shared.realm) {
            RealmService.shared.removeProduct(productToDelete: product, realm: RealmService.shared.realm)
        } else {
            guard let product = products.first(where: { $0.id == id}) else { return }
            RealmService.shared.addProduct(with: product, realm: RealmService.shared.realm)
        }
    }
    
    func pushDetailsViewController(navigationController: UINavigationController, productId: Int) {
        router?.pushDetailsScreen(navigationController: navigationController, productId: productId )
    }
}
