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
}

class AuthenticationView: BaseViewController, AuthenticationViewProtocol {
    
    var presenter: AuthenticationPresenterProtocol?
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var googleButton: UIButton!
    
    let signInConfig = GIDConfiguration.init(clientID: "222842387933-8mhtquavgll9o5lstcnl25md0l73q9eh.apps.googleusercontent.com")
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    @IBAction func googleSignIn(_ sender: Any) {
        GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: self) { user, error in
            guard error == nil else { return }
            guard let user = user else { return }
            let userName = user.profile?.name
            self.userNameLabel.text = "\(userName ?? "")"
        }
    }
}

extension AuthenticationView: LoginButtonDelegate {
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        let token = result?.token?.tokenString
        
        let request = FBSDKCoreKit.GraphRequest(graphPath: "me", parameters: ["fields": "email,name"], tokenString: token, version: nil, httpMethod: .get)
        request.start(completion: {[weak self] _, result, _ in
            guard let self = self else { return }
            self.userNameLabel.text = "\(result ?? " ")"
        })
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        
    }
}
