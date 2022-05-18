//
//  ProductsTableViewCell.swift
//  EbsTestViper
//
//  Created by Сережа Присяжнюк on 03.05.2022.
//

import UIKit
import RealmSwift
class ProductsTableViewCell: UITableViewCell {
  
  static let identifier = "ProductsTableViewCell"
  
  @IBOutlet weak var productImageView: UIImageView!
  @IBOutlet weak var productName: UILabel!
  @IBOutlet weak var productDetails: UILabel!
  @IBOutlet weak var productPrice: UILabel!
  @IBOutlet weak var productSalePrice: UILabel!
  @IBOutlet weak var favButton: UIButton!
  @IBOutlet weak var cartButton: UIButton!
  
  var addToFavoriteProduct: ((_ id: Int) -> Void) = { _ in }
  var id: Int = 0
  
  override func awakeFromNib() {
    super.awakeFromNib()
    selectionStyle = .none
    
  }
  static func nib() -> UINib {
    return UINib(nibName: "ProductsTableViewCell", bundle: nil)
  }
  
  @IBAction func favoriteButtonTap(_ sender: UIButton) {
    addToFavoriteProduct(id)
    if favButton.isSelected == false {
      favButton.isSelected = true
      favButton.backgroundColor = hexStringToUIColor(hex: "#FAF0D8")
    } else {
      favButton.isSelected = false
      favButton.backgroundColor = .white
    }
  }
  
  public func configure(with model: Product, isFavorite: Bool) {
      self.id = model.id
      self.productName.text = model.name
      self.productDetails.text = model.details
      self.productPrice.text = "$\(model.price)"
      self.productSalePrice.text = "$\(model.price)"
      self.productImageView.sd_setImage(with: URL(string: model.main_image))
    
    if isFavorite {
      favButton.isSelected = true
      favButton.backgroundColor = hexStringToUIColor(hex: "#FAF0D8")
    } else {
      favButton.isSelected = false
      favButton.backgroundColor = .white
    }
  }
}
