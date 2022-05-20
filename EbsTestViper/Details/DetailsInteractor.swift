//
//  DetailsInteractor.swift
//  EbsTestViper
//
//  Created by Сережа Присяжнюк on 03.05.2022.
//

import Foundation
import UIKit
import Network
// MARK: - Protocol
protocol DetailsInteractorProtocol {
    var presenter: DetailsPresenterProtocol? { get set }
    
    func getSingleProduct(id: Int, completion: @escaping (Result< Product, Error >) -> Void)
}
// MARK: - Class
class DetailsInteractor: DetailsInteractorProtocol {
    var presenter: DetailsPresenterProtocol?
    let monitor = NWPathMonitor()
    
    // API Call
    func getSingleProduct (id: Int, completion: @escaping (Result<Product, Error>) -> Void) {
        guard let url = URL(string: "\(Constansts.baseURL)/\(id)") else { return }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            if let data = data {
                do {
                    let results = try JSONDecoder().decode(Product.self, from: data)
                    completion(.success(results))
                } catch {
                    completion(.failure(APIError.failedToGetData))
                }
            }  else if let error = error {
                self.monitor.pathUpdateHandler = { pathUpdateHandler in
                    if pathUpdateHandler.status == .satisfied {
                        APIError.failedToGetData
                    } else {
                        print("Error Internet connection")
                    }
                }
            }
        }
        task.resume()
    }
}
