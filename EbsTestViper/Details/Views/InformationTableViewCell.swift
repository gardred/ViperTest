//
//  InformationTableViewCell.swift
//  EbsTestViper
//
//  Created by Сережа Присяжнюк on 03.05.2022.
//

import UIKit
import SkeletonView
class InformationTableViewCell: UITableViewCell {
  
  static let identifier = "InformationTableViewCell"
  
  @IBOutlet weak var informationLabel: UILabel!
  @IBOutlet weak var productInformation: UILabel!
  
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    informationLabel.isSkeletonable = true
    informationLabel.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: .silver), animation: nil, transition: .crossDissolve(0.25))
    
    productInformation.isSkeletonable = true
    productInformation.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: .silver), animation: nil, transition: .crossDissolve(0.25))
  }
  
  static func nib() -> UINib {
    return UINib(nibName: "InformationTableViewCell", bundle: nil)
  }
  
  public func configure(with model: Products) {
      self.productInformation.text = model.details
      self.informationLabel.stopSkeletonAnimation()
      self.informationLabel.hideSkeleton()
      
      self.productInformation.stopSkeletonAnimation()
      self.productInformation.hideSkeleton()
  }
}
