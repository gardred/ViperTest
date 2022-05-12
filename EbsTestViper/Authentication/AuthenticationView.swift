//
//  AuthenticationView.swift
//  EbsTestViper
//
//  Created by Сережа Присяжнюк on 03.05.2022.
//

import Foundation
import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import GoogleSignIn

protocol AuthenticationViewProtocol {
  var presenter: AuthenticationPresenterProtocol? { get set }
  var data: String { get set }
  
  
}

class AuthenticationView: BaseViewController,AuthenticationViewProtocol {
 
  var presenter: AuthenticationPresenterProtocol?
  
  @IBOutlet weak var userNameLabel: UILabel!
  @IBOutlet weak var userEmail: UILabel!
  
  
  var data: String = ""
  
  override func viewDidLoad() {
    setupNavigationBar()
    
    let loginButton = FBLoginButton(frame: CGRect(x: 0, y: 0, width: 250, height: 60))
    loginButton.delegate = self
    loginButton.center = view.center
    loginButton.permissions = ["public_profile", "email"]
    view.addSubview(loginButton)
    
    presenter?.loginWithFacebook()
    userNameLabel.text = ""
  }
  
  func setupNavigationBar() {
    setBackButton()
    setLogo()
    setRightBarButtonHeart()
  }
}

extension AuthenticationView : LoginButtonDelegate {
  func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
    let token = result?.token?.tokenString
    
    let request = FBSDKCoreKit.GraphRequest(graphPath: "me", parameters: ["fields": "email,name"], tokenString: token, version: nil, httpMethod: .get)
    request.start(completion: {[weak self] connection , result , error in
      guard let self = self else { return }
      self.userNameLabel.text = "\(result!)"
      
    })
  }
  
  func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
    
  }
}
