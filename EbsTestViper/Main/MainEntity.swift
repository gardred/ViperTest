//
//  MainEntity.swift
//  EbsTestViper
//
//  Created by Сережа Присяжнюк on 03.05.2022.
//

import Foundation


struct ProductsResponse: Codable {
    let results: [Products]
}

struct Products: Codable {
  var id: Int
    let name: String
    let main_image: String
    let details: String
    let price: Int
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

