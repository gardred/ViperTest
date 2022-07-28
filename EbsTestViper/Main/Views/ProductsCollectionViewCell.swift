//
//  ProductsCollectionViewCell.swift
//  EbsTestViper
//
//  Created by Сережа Присяжнюк on 20.05.2022.
//

import UIKit
import SDWebImage

class ProductsCollectionViewCell: UICollectionViewCell {
    
    // MARK: - UIElements
    @IBOutlet public weak var productImageView: UIImageView!
    @IBOutlet private weak var productName: UILabel!
    @IBOutlet private weak var productDetails: UILabel!
    @IBOutlet private weak var productPrice: UILabel!
    @IBOutlet private weak var productSalePrice: UILabel!
    @IBOutlet private weak var favButton: UIButton!
    @IBOutlet private weak var cartButton: UIButton!
    
    // MARK: - Variables
    static let identifier = "ProductsCollectionViewCell"
    
    public var addToFavoriteProduct: ((_ id: Int) -> Void) = { _ in }
    public var addToCartProduct: ((_ id: Int) -> Void) = { _ in }
    public var id: Int = 0
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    // MARK: - IBActions
    @IBAction func markAsFavorite(_ sender: UIButton) {
        
        self.addToFavoriteProduct(self.id)
        configureButton(button: favButton, color: "#FAF0D8")
    }
    
    @IBAction func addToCart(_ sender: UIButton) {
        
        self.addToCartProduct(self.id)
        configureButton(button: cartButton, color: "#07195C")
    }
    
    private func toggleButton(button: UIButton, color: String, state: Bool) {
        
        if state {
            button.isSelected = true
            button.backgroundColor = hexStringToUIColor(hex: color)
        } else {
            button.isSelected = false
            button.backgroundColor = .white
        }
    }
    
    // MARK: - Functions 
    public func configure(with model: Product, isFavorite: Bool, isAddedToCart: Bool) {
        
        id = model.id
        productName.text = model.name
        productDetails.text = model.details
        productPrice.text = "$\(model.price)"
        productSalePrice.text = "$\(model.price)"
        productImageView.sd_setImage(with: URL(string: model.main_image))
        
        toggleButton(button: favButton, color: "#FAF0D8", state: isFavorite)
        toggleButton(button: cartButton, color: "#07195C", state: isAddedToCart)
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "ProductsCollectionViewCell", bundle: nil)
    }
}
