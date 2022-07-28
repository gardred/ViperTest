//
//  SquareProductsCollectionViewCell.swift
//  EbsTestViper
//
//  Created by Сережа Присяжнюк on 20.05.2022.
//

import UIKit

class SquareProductsCollectionViewCell: UICollectionViewCell {
    
    // MARK: - UIElements
    @IBOutlet public weak var productImageView: UIImageView!
    @IBOutlet private weak var productName: UILabel!
    @IBOutlet private weak var productDetails: UILabel!
    @IBOutlet private weak var productPrice: UILabel!
    @IBOutlet private weak var productSalePrice: UILabel!
    @IBOutlet private weak var favButton: UIButton!
    @IBOutlet private weak var cartButton: UIButton!
    
    // MARK: - Variables
    static let identifier = "SquareProductsCollectionViewCell"
    public var addToFavoriteProduct: ((_ id: Int) -> Void) = { _ in }
    public var addProductToCart: ( (_ id: Int) -> Void) = { _ in }
    public var id: Int = 0
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    // MARK: - IBActions
    @IBAction func favButtonTap(_ sender: UIButton) {
        
        self.addToFavoriteProduct(self.id)
        configureButton(button: favButton, color: "#FAF0D8")
    }
    
    @IBAction func cartAction(_ sender: UIButton) {
        
        self.addProductToCart(self.id)
        configureButton(button: cartButton, color: "#07195C")
    }
    // MARK: - Functions
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
            self.favButton.layer.cornerRadius = self.favButton.frame.height / 2
        } else {
            self.favButton.isSelected = false
            self.favButton.backgroundColor = .white
            self.favButton.layer.cornerRadius = self.favButton.frame.height / 2
        }
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "SquareProductsCollectionViewCell", bundle: nil)
    }
}
