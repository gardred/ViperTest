//
//  AuthenticationInteractor.swift
//  EbsTestViper
//
//  Created by Сережа Присяжнюк on 03.05.2022.
//

import Foundation

protocol AuthenticationInteractorProtocol {
    var presenter: AuthenticationPresenterProtocol? { get set }
}

class AuthenticationInteractor: AuthenticationInteractorProtocol {
    var presenter: AuthenticationPresenterProtocol?
}
