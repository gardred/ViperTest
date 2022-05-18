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

  func addProduct(/*name: String, icon: String, details: String, price: Int, id: Int*/ with model: Products) {
    do {
      try? realm?.write {
        let favorites = FavoriteList()
        favorites.id = model.id
        favorites.name = model.name
        favorites.main_image = model.main_image
        favorites.price = model.price
        favorites.salePrice = model.price
        favorites.details = model.details
        realm?.add(favorites)
      }
    } catch  {
      return
    }
  }
  
  func removeProduct(productToDelete: FavoriteList) {
    do {
      try? self.realm?.write({
        self.realm?.delete(productToDelete)
      })
    } catch {
      return
    }
  }
  
  func deleteElement(products: Products) {
   let contains = realm?.objects(FavoriteList.self).contains(where: { favoriteObjects in
      if favoriteObjects.id == products.id {
        RealmService.shared.removeProduct(productToDelete: favoriteObjects)
      }
      return false
    })
  }
  
  func checkRealmElements(products: Products) -> Bool {
    let contains = realm?.objects(FavoriteList.self).contains(where: { favoriteObjects in
      return favoriteObjects.id == products.id
    })
    return contains ?? false
  }
  
  func findProduct(id: Int) -> Products? {
    let contains = realm?.objects(Products.self).first(where: { product in
      return id == product.id
    })
    return contains
  }
  
}
