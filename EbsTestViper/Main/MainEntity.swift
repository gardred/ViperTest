//
//  MainEntity.swift
//  EbsTestViper
//
//  Created by Сережа Присяжнюк on 03.05.2022.
//

import Foundation
import RealmSwift
struct ProductsResponse: Codable {
  let results: [Products]
}

class Products: Object, Codable {
  @Persisted(primaryKey: true)  var id: Int
  @Persisted var name: String
  @Persisted var main_image: String
  @Persisted var details: String
  @Persisted var price: Int
}

struct Constansts {
  static let baseURL = "http://mobile-shop-api.hiring.devebs.net/products"
}

enum ConnectionType {
  case wifi
  case cellular
  case ethernet
  case unknown
}
