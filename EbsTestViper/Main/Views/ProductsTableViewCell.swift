//
//  ProductsTableViewCell.swift
//  EbsTestViper
//
//  Created by Сережа Присяжнюк on 03.05.2022.
//

import UIKit

class ProductsTableViewCell: UITableViewCell {
  
  static let identifier = "ProductsTableViewCell"
  
  @IBOutlet weak var productImageView: UIImageView!
  @IBOutlet weak var productName : UILabel!
  @IBOutlet weak var productDetails : UILabel!
  @IBOutlet weak var productPrice : UILabel!
  @IBOutlet weak var productSalePrice : UILabel!
  @IBOutlet weak var favButton : UIButton!
  @IBOutlet weak var cartButton : UIButton!
  
  var addToFavoriteProduct: (() -> Void) = {}
  var removeFavoriteProduct: (()->Void) = {}
  var isFav: Bool = false
  var products: Products!
  private let defaults = UserDefaults.standard
  
  override func awakeFromNib() {
    super.awakeFromNib()
    NotificationCenter.default.addObserver(self, selector: #selector(changeFavButton), name: NSNotification.Name("cell"), object: nil)
  }
  static func nib() -> UINib {
    return UINib(nibName: "ProductsTableViewCell", bundle: nil)
  }
  
  @objc func changeFavButton() {
    favButton.setImage(UIImage(systemName: "heart"), for: .normal)
    favButton.backgroundColor = .white
  }
  
  @IBAction func favoriteButtonTap(_ sender: UIButton) {
    
      addToFavoriteProduct()
      favButton.backgroundColor = hexStringToUIColor(hex: "#FAF0D8")
      favButton.isSelected = true
    
  }
  
  @IBAction func removeFavoriteProduct(_ sender: UIButton) {
    removeFavoriteProduct()
  }
  
  
  public func configure(with model : Products, isFavorite: Bool) {
    DispatchQueue.main.async { [weak self] in
      guard let self = self else { return }
      self.productName.text = model.name
      self.productDetails.text = model.details
      self.productPrice.text = "$\(model.price)"
      self.productSalePrice.text = "$\(model.price)"
      self.productImageView.sd_setImage(with: URL(string: model.main_image))
      
    }
  }
}
