//
//  UIAlert.swift
//  EbsTestViper
//
//  Created by Сережа Присяжнюк on 28.07.2022.
//

import Foundation
import UIKit

extension UIViewController {
    
    public func showAlert(title: String, body: String) {
        let alert = UIAlertController(title: title, message: body, preferredStyle: .alert)
        UIAlertAction(title: "Cancel", style: .cancel)
        self.present(alert, animated: true)
    }
}
