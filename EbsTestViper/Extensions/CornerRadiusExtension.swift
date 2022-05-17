//
//  CornerRadiusExtension.swift
//  EbsTestViper
//
//  Created by Сережа Присяжнюк on 04.05.2022.
//

import Foundation
import UIKit

extension UIView {

  /// Радиус гараницы
  @IBInspectable var cornerRadius: CGFloat {
    get { return layer.cornerRadius }
    set { layer.cornerRadius = newValue }
  }
  /// Толщина границы
  @IBInspectable var borderWidth: CGFloat {
    get { return layer.borderWidth }
    set { layer.borderWidth = newValue }
  }
  /// Смещение тени
  @IBInspectable var shadowRadius: CGFloat {
    get { return layer.shadowRadius }
    set { layer.shadowRadius = newValue }
  }

  @IBInspectable var shadowOpacity: CGFloat {
    get { return CGFloat(layer.shadowOpacity) }
    set { layer.shadowOpacity = Float(newValue) }
  }

  @IBInspectable var shadowOffset: CGSize {
    get { return layer.shadowOffset }
    set { layer.shadowOffset = newValue }
  }

  @IBInspectable var shadowColor: UIColor? {
    get {
      guard let cgColor = layer.shadowColor else {
        return nil
      }
      return UIColor(cgColor: cgColor)
    }
    set { layer.shadowColor = newValue?.cgColor }
  }
  /// Отсекание по границе
  @IBInspectable var _clipsToBounds: Bool {
    get { return clipsToBounds }
    set { clipsToBounds = newValue }
  }
}
