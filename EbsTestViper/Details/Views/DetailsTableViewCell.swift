//
//  DetailsTableViewCell.swift
//  EbsTestViper
//
//  Created by Сережа Присяжнюк on 03.05.2022.
//

import UIKit
import SkeletonView
class DetailsTableViewCell: UITableViewCell {
  static let identifier = "DetailsTableViewCell"
  @IBOutlet weak var productName: UILabel!
  @IBOutlet weak var productDetails: UILabel!
  @IBOutlet weak var productPrice: UILabel!
  @IBOutlet weak var productSalePrice: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    productName.isSkeletonable = true
    productName.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: .silver), animation: nil, transition: .crossDissolve(0.25))
    
    productDetails.isSkeletonable = true
    productDetails.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: .silver), animation: nil, transition: .crossDissolve(0.25))
    
    productPrice.isSkeletonable = true
    productPrice.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: .silver), animation: nil, transition: .crossDissolve(0.25))
    
    productSalePrice.isSkeletonable = true
    productSalePrice.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: .silver), animation: nil, transition: .crossDissolve(0.25))
  }
  
  static func nib() -> UINib {
    return UINib(nibName: "DetailsTableViewCell", bundle: nil)
  }
  
  public func configure(with model: Products) {
    
    self.productName.text = model.name
    self.productName.stopSkeletonAnimation()
    self.productName.hideSkeleton()
    
    self.productDetails.text = model.details
    self.productDetails.stopSkeletonAnimation()
    self.productDetails.hideSkeleton()
    
    self.productPrice.text = "$\(model.price)"
    self.productPrice.stopSkeletonAnimation()
    self.productPrice.hideSkeleton()
    
    self.productSalePrice.text = "$\(model.price)"
    self.productSalePrice.stopSkeletonAnimation()
    self.productSalePrice.hideSkeleton()
  }
}
