//
//  CartTVC.swift
//  EbsTestViper
//
//  Created by Сережа Присяжнюк on 27.07.2022.
//

import UIKit

class CartTVC: UITableViewCell {

    static let identifier = "CartTVC"
    
    @IBOutlet private weak var productImage: UIImageView!
    @IBOutlet private weak var productName: UILabel!
    @IBOutlet private weak var productDetails: UILabel!
    @IBOutlet private weak var productPrice: UILabel!
    @IBOutlet private weak var productSalePrice: UILabel!
    @IBOutlet public weak var numberOfProducts: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    public func configure(with model: Product) {
        self.productName.text = model.name
        self.productDetails.text = model.details
        self.productPrice.text = "$\(model.price)"
        self.productSalePrice.text = "$\(model.price)"
        self.productImage.sd_setImage(with: URL(string: model.main_image))
        
    }
}
