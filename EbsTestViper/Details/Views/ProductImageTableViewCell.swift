//
//  ProductImageTableViewCell.swift
//  EbsTestViper
//
//  Created by Сережа Присяжнюк on 03.05.2022.
//

import UIKit
import SkeletonView
class ProductImageTableViewCell: UITableViewCell {
  
  static let identifier = "ProductImageTableViewCell"
  @IBOutlet weak var productImageView : UIImageView!
  
  
  override func awakeFromNib() {
    super.awakeFromNib()
    productImageView.isSkeletonable = true
    productImageView.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: .silver), animation: nil, transition: .crossDissolve(0.25))
    
   
  }
  
  static func nib() -> UINib {
    return UINib(nibName: "ProductImageTableViewCell", bundle: nil)
  }
  
  public func configure(with model: Products ) {
    self.productImageView.sd_setImage(with: URL(string: model.main_image))

  }
}
