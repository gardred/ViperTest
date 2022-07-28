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
    
    @IBOutlet private weak var deleteButton: UIButton!
    @IBOutlet private weak var addProduct: UIButton!
    @IBOutlet private weak var deleteProduct: UIButton!
    
    private var numberOfProductsInCart = 1
    public var id = 0
    
    public var removeFromCartProduct: ( (_ id: Int) -> Void) = { _ in}
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        deleteButton.layer.cornerRadius = deleteButton.frame.height / 2
    }
    
    @IBAction func deleteProductAction(_ sender: UIButton) {
        removeFromCartProduct(id)
    }
    
    @IBAction func addProductAction(_ sender: UIButton) {
        
        numberOfProductsInCart += 1
        numberOfProducts.text = "\(numberOfProductsInCart)"
    }
    
    @IBAction func removeProductAction(_ sender: UIButton) {
        
        if numberOfProductsInCart > 1 {
            numberOfProductsInCart -= 1
            numberOfProducts.text = "\(numberOfProductsInCart)"
        } else {
            removeFromCartProduct(id)
        }
    }
    
    public func configure(with model: Product) {
        productName.text = model.name
        productDetails.text = model.details
        productPrice.text = "$\(model.price)"
        productSalePrice.text = "$\(model.price)"
        productImage.sd_setImage(with: URL(string: model.main_image))
        numberOfProducts.text = "\(numberOfProductsInCart)"
    }
}
