//
//  MainRouter.swift
//  EbsTestViper
//
//  Created by Сережа Присяжнюк on 03.05.2022.
//

import Foundation
import UIKit

// Router ------> Presenter

protocol MainRouterProtocol {
    static func start() -> MainViewController
    func pushDetailsScreen(navigationController: UINavigationController, productId: Int)
    func pushFavoriteScreen(navigationController: UINavigationController)
    func pushAuthentiocationScreen(navigationController: UINavigationController)
}

class MainRouter: MainRouterProtocol {
    
    public func pushAuthentiocationScreen(navigationController: UINavigationController) {
        let router = AuthentiocationRouter.self
        let authentication = router.createAuthentiocationModule()
        navigationController.pushViewController(authentication, animated: true)
    }
    
   public func pushFavoriteScreen(navigationController: UINavigationController) {
        let router = FavoriteRouter.self
        let favorite = router.createFavoriteModule()
        navigationController.pushViewController(favorite, animated: true)
    }
    
    public func pushDetailsScreen(navigationController: UINavigationController, productId: Int) {
        let router = DetailsRouter.self
        let details = router.createDetailsModule()
        details.presenter?.setup(productId: productId)
        navigationController.pushViewController(details, animated: true)
    }
    
    static func start() -> MainViewController {
        
        let view = storyboard.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
        
        var presenter: MainPresenterProtocol = MainPresenter()
        var interactor: MainInteractorProtocol = MainInteractor()
        let router: MainRouterProtocol = MainRouter()
        
        view.presenter = presenter
        
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        
        interactor.presenter = presenter
        
        return view
    }
    
    static var storyboard: UIStoryboard {
        return UIStoryboard(name: "Main", bundle: nil)
    }
}
