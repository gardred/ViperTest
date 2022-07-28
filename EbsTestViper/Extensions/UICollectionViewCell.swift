//
//  UICollectionViewCell.swift
//  EbsTestViper
//
//  Created by Сережа Присяжнюк on 28.07.2022.
//

import UIKit

extension UICollectionViewCell {
    
    public func configureButton(button: UIButton, color: String) {
        
        if button.isSelected == false {
            button.isSelected = true
            button.backgroundColor = hexStringToUIColor(hex: color)
            button.layer.cornerRadius = button.frame.height / 2
        } else {
            button.isSelected = false
            button.backgroundColor = .white
        }
    }
}
