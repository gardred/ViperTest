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

  func addProduct(name: String, icon: String, details: String, price: Int, id: Int) {
    do {
      try? realm?.write {
        let favorites = FavoriteList()
        favorites.id = id
        favorites.name = name
        favorites.main_image = icon
        favorites.details = details
        favorites.price = price
        favorites.salePrice = price
        realm?.add(favorites)
      }
    } catch let error {
      print(error.localizedDescription)
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
  
}
