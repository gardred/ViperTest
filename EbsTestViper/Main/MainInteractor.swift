//
//  MainInteractor.swift
//  EbsTestViper
//
//  Created by Сережа Присяжнюк on 03.05.2022.
//

import Foundation
import UIKit
import SDWebImage
import Network
// Presenter <------->  Interactor ----> API

protocol MainInteractorProtocol {
    var presenter: MainPresenterProtocol? { get set }
    
    func getProducts(atPage page: Int, completion: @escaping (Result<[Product], Error >) -> Void)
    func downloadImage(url: URL, completion: @escaping (UIImage?) -> Void)
}

class MainInteractor: MainInteractorProtocol {
    let monitor = NWPathMonitor()
    
    func getProducts(atPage page: Int, completion: @escaping (Result<[Product], Error>) -> Void) {
        guard let url = URL(string: "\(Constansts.baseURL)?page=\(page)&page_size=10") else { return }
        let dataTast = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            if let data = data {
                do {
                    let results = try JSONDecoder().decode(ProductsResponse.self, from: data)
                    self.presenter?.fetchProductsSuccess(products: results.results)
                    completion(.success(results.results))
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
        dataTast.resume()
    }
    
    var presenter: MainPresenterProtocol?
    var imageCache = NSCache<NSString, UIImage>()
    // API Errors
    enum APIError: Error {
        case failedToGetData
    }
    
    // API Call to get all products
    //    func getProducts(atPage page: Int, completion: @escaping (Result<[Product], Error>) -> Void) {
    //        guard let url = URL(string: "\(Constansts.baseURL)?page=\(page)&page_size=10") else { return }
    //        let dataTask = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
    //            guard let data = data else {
    //                return
    //            }
    //            do {
    //                if error == nil {
    //                    let results = try JSONDecoder().decode(ProductsResponse.self, from: data)
    //                    self.presenter?.fetchProductsSuccess(products: results.results)
    //                    completion(.success(results.results))
    //                }
    //            } catch is APIError {
    //                completion(.failure(APIError.failedToGetData))
    //            } catch {
    //                self.presenter?.view?.checkNetworkConnection()
    //            }
    //        }
    //        dataTask.resume()
    //    }
    // Cache image
    
    func downloadImage(url: URL, completion: @escaping (UIImage?) -> Void) {
        if let cachedImage = imageCache.object(forKey: url.absoluteString  as NSString) {
            completion(cachedImage)
        } else {
            let request = URLRequest(url: url, cachePolicy: URLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 10)
            let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
                guard error == nil, data != nil ,
                      let response = response as? HTTPURLResponse,
                      response.statusCode == 200
                else {
                    return
                }
                guard let data = data else { return }
                guard let image = UIImage(data: data) else { return }
                self.imageCache.setObject(image, forKey: url.absoluteString as NSString)
                
                DispatchQueue.main.async {
                    completion(image)
                }
            }
            dataTask.resume()
        }
        
    }
}
