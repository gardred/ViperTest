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
    let realm = try? Realm()
    
    func addProduct(with model: Product) {
        do {
            try? realm?.write {
                realm?.add(model)
            }
        } catch {
            return
        }
    }
    
    func removeProduct(productToDelete: Product) {
        do {
            try? self.realm?.write({
                self.realm?.delete(productToDelete)
            })
        } catch {
            return
        }
    }
    
    func checkRealmElements(products: Product) -> Bool {
        let contains = realm?.objects(Product.self).contains(where: { favoriteObjects in
            return favoriteObjects.id == products.id
        })
        return contains ?? false
    }
    
    func findProduct(id: Int) -> Product? {
        let contains = realm?.objects(Product.self).first(where: { product in
            return id == product.id
        })
        return contains
    }
    
    
    
}
