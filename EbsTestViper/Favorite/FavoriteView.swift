//
//  FavoriteView.swift
//  EbsTestViper
//
//  Created by Сережа Присяжнюк on 03.05.2022.
//

import Foundation
import UIKit
import RealmSwift

protocol FavoriteViewProtocol {
    var presenter: FavoritePresenterProtocol? { get set }
}

class FavoriteView: BaseViewController, FavoriteViewProtocol {
    
    let realm = try? Realm()
    var presenter: FavoritePresenterProtocol?
    var favoriteList: Results<Product>!
    var notificationToken: NotificationToken?
    
    // UIElements
    @IBOutlet weak var favoriteProductsTableView: UITableView!
    @IBOutlet weak var favoriteProductsCount: UILabel!
    @IBOutlet weak var favoriteLabel: UILabel!
    
    @IBOutlet weak var sortByLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        setupNavigationBar()
        
        favoriteList = self.realm?.objects(Product.self)
        configureUI()
        configureTableView()
       
        notificationToken = favoriteList.observe({ [weak self] changes in
            guard let tableView = self?.favoriteProductsTableView else { return }
            switch changes {
            case .initial:
                tableView.reloadData()
            case .update(_, deletions: let deletions, insertions: let insertions, modifications: let modifications):
                tableView.performBatchUpdates {
                    tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0) }), with: .automatic)
                    tableView.insertRows(at: insertions.map({IndexPath(row: $0, section: 0)}), with: .automatic)
                    tableView.reloadRows(at: modifications.map({IndexPath(row: $0, section: 0)}), with: .automatic)
                }
            case .error: break
            }
        })
        favoriteProductsTableView.reloadData()
    }
    
    private func configureUI() {
        favoriteLabel.text = "FAVORITES".localized()
        sortByLabel.text = "SORT BY".localized()
        
        favoriteProductsCount.text = "\(favoriteList.count)"
        favoriteProductsCount.layer.cornerRadius = favoriteProductsCount.frame.height / 2
    }
    
    private func configureTableView() {
        
        favoriteProductsTableView.register(ProductsTableViewCell.nib(), forCellReuseIdentifier: ProductsTableViewCell.identifier)
        favoriteProductsTableView.dataSource = self
        favoriteProductsTableView.delegate = self
    }
    
    func setupNavigationBar() {
        setBackButton()
        setLogo()
        setHeartFillButton()
    }
}

extension FavoriteView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = favoriteProductsTableView.dequeueReusableCell(withIdentifier: ProductsTableViewCell.identifier, for: indexPath) as? ProductsTableViewCell else {
            return UITableViewCell()
        }
        let product = favoriteList[indexPath.row]
        cell.id = product.id
        cell.configure(with: product, isFavorite: RealmService.shared.checkRealmElements(products: product))
        cell.addToFavoriteProduct = { [weak self] (id) in
            guard let self = self else { return}
            self.presenter?.toggleFavorite(id: id)
            self.favoriteProductsCount.text = "\(self.favoriteList.count)"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let product = favoriteList[indexPath.row]
        guard let navigationController = navigationController else { return }
        presenter?.pushDetailsViewController(navigationController: navigationController, productId: product.id)
    }
}
