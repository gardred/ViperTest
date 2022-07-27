//
//  CartInteractor.swift
//  EbsTestViper
//
//  Created by Сережа Присяжнюк on 27.07.2022.
//

import Foundation

protocol CartInteractorProtocol {
    var presenter: CartPresenterProtocol? { get set }
}

class CartInteractor: CartInteractorProtocol {
    var presenter: CartPresenterProtocol?
    
}
