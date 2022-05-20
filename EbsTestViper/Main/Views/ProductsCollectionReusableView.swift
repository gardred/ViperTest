//
//  ProductsCollectionReusableView.swift
//  EbsTestViper
//
//  Created by Сережа Присяжнюк on 20.05.2022.
//

import UIKit

class ProductsCollectionReusableView: UICollectionReusableView {
    @IBOutlet weak var filtersButton: UIButton!
    
    @IBOutlet weak var horizontalCells: UIButton!
    
    @IBOutlet weak var verticalCells: UIButton!
    
    var squareCells: (() -> Void ) = {}
    
    @IBAction func horizontalCells(_ sender: UIButton) {
        squareCells()
    }
}
