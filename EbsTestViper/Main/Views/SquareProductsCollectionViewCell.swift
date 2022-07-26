//
//  SquareProductsCollectionViewCell.swift
//  EbsTestViper
//
//  Created by Сережа Присяжнюк on 20.05.2022.
//

import UIKit

class SquareProductsCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "SquareProductsCollectionViewCell"
    
    @IBOutlet public weak var productImageView: UIImageView!
    @IBOutlet private weak var productName: UILabel!
    @IBOutlet private weak var productDetails: UILabel!
    @IBOutlet private weak var productPrice: UILabel!
    @IBOutlet private weak var productSalePrice: UILabel!
    @IBOutlet private weak var favButton: UIButton!
    @IBOutlet private weak var cartButton: UIButton!
    
    public var addToFavoriteProduct: ((_ id: Int) -> Void) = { _ in }
    public var id: Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    @IBAction func favButtonTap(_ sender: UIButton) {
        self.addToFavoriteProduct(self.id)
        
        if self.favButton.isSelected == false {
            self.favButton.isSelected = true
            self.favButton.backgroundColor = hexStringToUIColor(hex: "#FAF0D8")
        } else {
            self.favButton.isSelected = false
            self.favButton.backgroundColor = .white
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
            self.favButton.isSelected = true
            self.favButton.backgroundColor = hexStringToUIColor(hex: "#FAF0D8")
        } else {
            self.favButton.isSelected = false
            self.favButton.backgroundColor = .white
        }
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "SquareProductsCollectionViewCell", bundle: nil)
    }

}
