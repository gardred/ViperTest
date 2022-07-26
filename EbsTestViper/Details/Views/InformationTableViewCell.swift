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
    
    @IBOutlet private weak var informationLabel: UILabel!
    @IBOutlet private weak var productInformation: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "InformationTableViewCell", bundle: nil)
    }
    
    public func configure(with model: Product) {
        
        self.informationLabel.stopSkeletonAnimation()
        self.informationLabel.hideSkeleton()
        
        self.productInformation.text = model.details
        self.productInformation.hideSkeleton()
    }
    
    public func presentSkeleton() {
        
        self.informationLabel.isSkeletonable = true
        self.informationLabel.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: .silver), animation: nil, transition: .crossDissolve(0.25))
        
        self.productInformation.isSkeletonable = true
        self.productInformation.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: .silver), animation: nil, transition: .crossDissolve(0.25))
    }
}
