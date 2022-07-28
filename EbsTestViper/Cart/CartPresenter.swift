//
//  CartPresenter.swift
//  EbsTestViper
//
//  Created by Сережа Присяжнюк on 27.07.2022.
//

import Foundation

protocol CartPresenterProtocol {
    var view: CartViewProtocol? { get set }
    var router: CartRouterProtocol? { get set }
    var interactor: CartInteractorProtocol? { get set }
    
    var id: Int { get set }
    var products: [Product] { get set }
    
    func toggleCartItem(id: Int)
}

class CartPresenter: CartPresenterProtocol {
    var products: [Product] = [Product]()
    

    var id: Int = 0
    
    
    var view: CartViewProtocol?
    
    var router: CartRouterProtocol?
    
    var interactor: CartInteractorProtocol?
    
    func toggleCartItem(id: Int) {
        if let product = RealmService.shared.findProduct(id: id, realm: RealmService.shared.cartRealm) {
            RealmService.shared.removeProduct(productToDelete: product, realm: RealmService.shared.cartRealm)
        } else {
            guard let product = products.first(where: { $0.id == id}) else { return }
            RealmService.shared.addProduct(with: product, realm: RealmService.shared.cartRealm)
        }
    }
    
}
