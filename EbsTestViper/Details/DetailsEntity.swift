//
//  DetailsEntity.swift
//  EbsTestViper
//
//  Created by Сережа Присяжнюк on 03.05.2022.
//

import Foundation

enum CellType {
  case imageView(String, isSkeleton: Bool)
  case details(Product?, isSkeleton: Bool)
  case information(Product?, isSkeleton: Bool)
}

enum APIError: Error {
  case failedToGetData
}
