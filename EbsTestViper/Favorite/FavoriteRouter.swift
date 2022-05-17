//
//  FavoriteRouter.swift
//  EbsTestViper
//
//  Created by Сережа Присяжнюк on 03.05.2022.
//

import Foundation
import UIKit

protocol FavoriteRouterProtocol {
  static func createFavoriteModule() -> FavoriteView
  func pushDetailsScreen(navigationController: UINavigationController, productId: Int)
}

class FavoriteRouter: FavoriteRouterProtocol {
 
  func pushDetailsScreen(navigationController: UINavigationController, productId: Int) {
    let router = DetailsRouter.self
    let details = router.createDetailsModule()
    details.presenter?.setup(productId: productId)
    navigationController.pushViewController(details, animated: true)
  }
  
  static func createFavoriteModule() -> FavoriteView {
    let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    let view = storyboard.instantiateViewController(withIdentifier: "FavoriteViewController") as! FavoriteView
    
    var presenter: FavoritePresenterProtocol = FavoritePresenter()
    var interactor: FavoriteInteracorProtocol = FavoriteInteracor()
    let router: FavoriteRouterProtocol = FavoriteRouter()
    
    view.presenter = presenter
    
    presenter.view = view
    presenter.router = router
    presenter.interactor = interactor
    
    interactor.presenter = presenter
    
    return view
  }
}
