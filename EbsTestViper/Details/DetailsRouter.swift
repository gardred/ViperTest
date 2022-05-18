//
//  DetailsRouter.swift
//  EbsTestViper
//
//  Created by Сережа Присяжнюк on 03.05.2022.
//

import Foundation
import UIKit

protocol DetailsRouterProtocol {
    static func createDetailsModule() -> DetailsView
    func pushFavoriteScreen(navigationController: UINavigationController)
}

class DetailsRouter: DetailsRouterProtocol {
    
    func pushFavoriteScreen(navigationController: UINavigationController) {
        let router = FavoriteRouter.self
        let favorite = router.createFavoriteModule()
        navigationController.pushViewController(favorite, animated: true)
    }
    
    static func createDetailsModule() -> DetailsView {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let view = storyboard.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsView
        var interactor: DetailsInteractorProtocol = DetailsInteractor()
        var presenter: DetailsPresenterProtocol = DetailsPresenter()
        let router: DetailsRouterProtocol = DetailsRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        interactor.presenter = presenter
        return view
    }
}
