//
//  CartPresenter.swift
//  EbsTestViper
//
//  Created by Сережа Присяжнюк on 27.07.2022.
//

import Foundation

protocol CartPresenterProtocol {
    var view: CartViewProtocol? { get set }
    var router: CartRouterProtocol? { get set }
    var interactor: CartInteractorProtocol? { get set }
}

class CartPresenter: CartPresenterProtocol {
    
    var view: CartViewProtocol?
    
    var router: CartRouterProtocol?
    
    var interactor: CartInteractorProtocol?
    
}
