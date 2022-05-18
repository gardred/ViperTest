//
//  DetailsView.swift
//  EbsTestViper
//
//  Created by Сережа Присяжнюк on 03.05.2022.
//

import Foundation
import UIKit
import SkeletonView
import RealmSwift
// MARK: Protocol
protocol DetailsViewProtocol {
    var presenter: DetailsPresenterProtocol? { get set }
    var products: Product? { get set }
    
    var id: Int! { get set }
    
    func getSingleProductSuccess(singleProduct: Product)
}
// MARK: Class
class DetailsView: BaseViewController, DetailsViewProtocol {
    
    // UIElements
    @IBOutlet weak var productDetails: UITableView!
    
    // Variables
    var cells: [CellType] = []
    var id: Int!
    var products: Product?
    var presenter: DetailsPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        checkFavoriteElements()
        presenter?.getSingleProduct()
    
        productDetails.register(ProductImageTableViewCell.nib(), forCellReuseIdentifier: ProductImageTableViewCell.identifier)
        productDetails.register(DetailsTableViewCell.nib(), forCellReuseIdentifier: DetailsTableViewCell.identifier)
        productDetails.register(InformationTableViewCell.nib(), forCellReuseIdentifier: InformationTableViewCell.identifier)
        productDetails.delegate = self
        productDetails.dataSource = self
    }
    
    private func setupNavigationBar() {
        setBackButton()
        setRightBarButtonHeart()
        setLogo()
        navigationItem.rightBarButtonItem?.action = #selector(markAsFavorite)
    }
    @objc func markAsFavorite() {
        if let id = presenter?.id {
            navigationItem.rightBarButtonItem?.image = UIImage(systemName: "heart.fill")
            presenter?.toggleFavorite(id: id)
        }
    }
    
    private func checkFavoriteElements() {
        if let products = products {
            let isFavorite = RealmService.shared.checkRealmElements(products: products)
            if isFavorite {
                navigationItem.rightBarButtonItem?.image = UIImage(systemName: "heart.fill")
            } else {
                navigationItem.rightBarButtonItem?.image = UIImage(systemName: "heart")
            }
        } else {
            print("Object was not found")
        }
    }
    
    func getSingleProductSuccess(singleProduct: Product) {
        products = singleProduct
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.cells = [.imageView(self.products?.main_image ?? "Error", isSkeleton: false), .details(self.products, isSkeleton: false), .information(self.products, isSkeleton: false)]
            self.productDetails.reloadData()
        }
    }
}

// MARK: - Extension TableView
extension DetailsView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch cells[indexPath.row] {
        case .imageView:
            let cell = productDetails.dequeueReusableCell(withIdentifier: ProductImageTableViewCell.identifier, for: indexPath) as! ProductImageTableViewCell
            cell.showSkeleton()
            cell.productImageView.sd_setImage(with: URL(string: products?.main_image ?? "Error"))
            
            return cell
        case .details:
            let cell = productDetails.dequeueReusableCell(withIdentifier: DetailsTableViewCell.identifier, for: indexPath) as! DetailsTableViewCell
            cell.showSkeleton()
            cell.configure(with: products!)
            
            return cell
        case .information:
            let cell = productDetails.dequeueReusableCell(withIdentifier: InformationTableViewCell.identifier, for: indexPath) as! InformationTableViewCell
            cell.showSkeleton()
            cell.configure(with: products!)
            
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch cells[indexPath.row] {
        case .imageView:
            return 300
        case .details:
            return UITableView.automaticDimension
        case .information:
            return UITableView.automaticDimension
        }
    }
}
