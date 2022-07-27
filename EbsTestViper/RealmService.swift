//
//  RealmService.swift
//  EbsTestViper
//
//  Created by Сережа Присяжнюк on 11.05.2022.
//

import Foundation
import RealmSwift

class RealmService {
    
    static let shared = RealmService()
    
    var realm: Realm = { () -> Realm in
        var config = Realm.Configuration()
        config.fileURL = config.fileURL?.deletingLastPathComponent().appendingPathComponent("favorite.realm")
        let favorite = try? Realm(configuration: config)
        return favorite!
    }()
    
    var cartRealm: Realm = { () -> Realm in
        var config = Realm.Configuration()
        config.fileURL = config.fileURL?.deletingLastPathComponent().appendingPathComponent("cart.realm")
        let cart = try? Realm(configuration: config)
        return cart!
    }()
    
    func addProduct(with model: Product, realm: Realm) {
        do {
            try realm.write {
                realm.create(Product.self, value: model, update: .all)
            }
        } catch {
            return
        }
    }
    
    func removeProduct(productToDelete: Product, realm: Realm) {
        do {
            try realm.write({
                realm.delete(productToDelete)
            })
        } catch {
            return
        }
    }
    
    func checkRealmElements(products: Product, realm: Realm) -> Bool {
        let contains = realm.objects(Product.self).contains(where: { favoriteObjects in
            return favoriteObjects.id == products.id
        })
        return contains ?? false
    }
    
    func findProduct(id: Int, realm: Realm) -> Product? {
        let contains = realm.objects(Product.self).first(where: { product in
            return id == product.id
        })
        return contains
    }
    
    func favoriteDataConfiguration(with url: String) -> Realm.Configuration {
        var config = Realm.Configuration()
        config.fileURL = config.fileURL?.deletingLastPathComponent().appendingPathComponent(url)
        return config
    }
}
