//
//  AuthenticationPreseneter.swift
//  EbsTestViper
//
//  Created by Сережа Присяжнюк on 03.05.2022.
//

import Foundation
import GoogleSignIn
import FBSDKLoginKit
protocol AuthenticationPresenterProtocol {
  var interactor: AuthenticationInteractorProtocol? { get set }
  var view: AuthenticationViewProtocol? { get set}
  var router: AuthentiocationRouterProtocol? { get set }
  
  func loginWithGoogle()
  func loginWithFacebook()
}

class AuthenticationPresenter: AuthenticationPresenterProtocol {
  let signInConfig = GIDConfiguration.init(clientID: "222842387933-8mhtquavgll9o5lstcnl25md0l73q9eh.apps.googleusercontent.com")
  
  var interactor: AuthenticationInteractorProtocol?
  
  var view: AuthenticationViewProtocol?
  
  var router: AuthentiocationRouterProtocol?
  
  func loginWithGoogle() {
    GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: AuthenticationView()) { _, error in
        guard error == nil else { return }
    }
  }
  
  func loginWithFacebook() {
    if let token = AccessToken.current,
       !token.isExpired {
      let token = token.tokenString
      
      let request = FBSDKCoreKit.GraphRequest(graphPath: "me", parameters: ["fields": "email , name"], tokenString: token, version: nil, httpMethod: .get)
      request.start(completion: { _, _, _ in
        
      })
    } else {
      print("Error")
    }
  }
}
