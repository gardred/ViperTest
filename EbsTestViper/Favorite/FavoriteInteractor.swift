//
//  FavoriteInteractor.swift
//  EbsTestViper
//
//  Created by Сережа Присяжнюк on 03.05.2022.
//

import Foundation

protocol FavoriteInteracorProtocol {
  var presenter: FavoritePresenterProtocol? { get set }
  
  func getSingleProduct (id: Int, completion: @escaping (Result<Products, Error>) -> Void)
}

class FavoriteInteracor: FavoriteInteracorProtocol {
  var presenter: FavoritePresenterProtocol?
  
  func getSingleProduct (id: Int, completion: @escaping (Result<Products, Error>) -> Void) {
    guard let url = URL(string: "\(Constansts.baseURL)/\(id)") else { return }
    let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
      guard let data = data, error == nil else { return }
      do {
        let results = try JSONDecoder().decode(Products.self, from: data)
//        self.presenter?.getSingleProductSuccess(products: results)
        completion(.success(results))
      } catch {
        completion(.failure(APIError.failedToGetData))
      }
    }
    task.resume()
  }
}
