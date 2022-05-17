//
//  AuthenticationRouter.swift
//  EbsTestViper
//
//  Created by Сережа Присяжнюк on 03.05.2022.
//

import Foundation
import UIKit

protocol AuthentiocationRouterProtocol {
  static func createAuthentiocationModule() -> AuthenticationView
}

class AuthentiocationRouter: AuthentiocationRouterProtocol {
  
  static func createAuthentiocationModule() -> AuthenticationView {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let view = storyboard.instantiateViewController(withIdentifier: "AuthenticationView") as! AuthenticationView
    
    var presenter: AuthenticationPresenterProtocol = AuthenticationPresenter()
    var interactor: AuthenticationInteractorProtocol = AuthenticationInteractor()
    let router: AuthentiocationRouterProtocol = AuthentiocationRouter()
    
    view.presenter = presenter
    
    presenter.view = view
    presenter.router = router
    presenter.interactor = interactor
    
    interactor.presenter = presenter
    
    return view
  }
}
