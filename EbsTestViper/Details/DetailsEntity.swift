//
//  DetailsEntity.swift
//  EbsTestViper
//
//  Created by Сережа Присяжнюк on 03.05.2022.
//

import Foundation

enum CellType {
    case imageView(String)
    case details(Products)
    case information(Products)
}

enum APIError: Error {
  case failedToGetData
  case noInternetConnection(Error)
}
