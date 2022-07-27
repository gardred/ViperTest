//
//  CartRouter.swift
//  EbsTestViper
//
//  Created by Сережа Присяжнюк on 27.07.2022.
//

import UIKit

protocol CartRouterProtocol {
    
    static func createCartModule() -> CartVC
//    func pushDetailsScreen(navigationController: UINavigationController)
}

class CartRouter: CartRouterProtocol {
    
    static func createCartModule() -> CartVC {
        
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let view = storyboard.instantiateViewController(withIdentifier: "CartVC") as! CartVC
        
        var presenter: CartPresenterProtocol = CartPresenter()
        var interactor: CartInteractorProtocol = CartInteractor()
        let router: CartRouterProtocol = CartRouter()
        
        view.presenter = presenter
        
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        
        interactor.presenter = presenter
        
        return view
    }
}
