//
//  FavoriteInteractor.swift
//  EbsTestViper
//
//  Created by Сережа Присяжнюк on 03.05.2022.
//

import Foundation
import Network

protocol FavoriteInteracorProtocol {
    var presenter: FavoritePresenterProtocol? { get set }
    
    func getSingleProduct (id: Int, completion: @escaping (Result<Product, Error>) -> Void)
}

class FavoriteInteracor: FavoriteInteracorProtocol {
    
    public var presenter: FavoritePresenterProtocol?
    private let monitor = NWPathMonitor()
    
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
                
            } else if let error = error {
                
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
