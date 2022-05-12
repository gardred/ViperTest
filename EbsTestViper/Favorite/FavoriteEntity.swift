//
//  FavoriteEntity.swift
//  EbsTestViper
//
//  Created by Сережа Присяжнюк on 03.05.2022.
//

import Foundation
import RealmSwift

class FavoriteList: Object {
  @Persisted var id: Int = 0
  @Persisted var main_image: String = ""
  @Persisted var name: String = ""
  @Persisted var details: String = ""
  @Persisted var price: Int = 0
  @Persisted var salePrice: Int = 0
}
