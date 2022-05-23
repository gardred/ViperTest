//
//  MainView.swift
//  EbsTestViper
//
//  Created by Сережа Присяжнюк on 03.05.2022.
//

import Foundation
import UIKit
import RealmSwift
import Network
// View <------> Presenter
protocol MainViewProtocol {
    var presenter: MainPresenterProtocol? { get set }
    var isFetchingData: Bool { get set }
    
    func fetchProductsSuccess(productsArray: [Product])
    func failedToFetchProducts()
}

class MainViewController: BaseViewController, MainViewProtocol {
    
    enum CellType {
        case horizontal
        case vertical
    }
    
    // UIElements
    @IBOutlet weak var productsCollectionView: UICollectionView!
    @IBOutlet weak var cartView: UIView!
    @IBOutlet weak var cartCountLabel: UILabel!
    private let refreshControl = UIRefreshControl()
    @IBOutlet weak var cartButton: UIButton!
    
    // Variables
    private var products: [Product] = [Product]()
    var isFetchingData = false
    var presenter: MainPresenterProtocol?
    var changeCell: Bool = false
    var cells: [CellType] = []
    // Lifecycle
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        productsCollectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        presenter?.startFetchingProducts()
       
        productsCollectionView.register(SquareProductsCollectionViewCell.nib(), forCellWithReuseIdentifier: SquareProductsCollectionViewCell.identifier)
        productsCollectionView.register(ProductsCollectionViewCell.nib(), forCellWithReuseIdentifier: ProductsCollectionViewCell.identifier)
        
        productsCollectionView.delegate = self
        productsCollectionView.dataSource = self
        productsCollectionView.refreshControl = refreshControl
        
        refreshControl.addTarget(self, action: #selector(pullUpRefreshControl), for: .valueChanged)
    }
    
    // Get product list
    func fetchProductsSuccess(productsArray: [Product]) {
        products = productsArray
        DispatchQueue.main.async { [weak self] in
            self?.productsCollectionView.reloadData()
        }
    }
    
    @IBAction func squareCellSize(_ sender: UIButton) {
        changeCell = true
        productsCollectionView.reloadData()
        
    }
    @IBAction func horizontalCell(_ sender: Any) {
        changeCell = false
        productsCollectionView.reloadData()
    }
 
    func failedToFetchProducts() {
        let alert = UIAlertController(title: "error", message: "Failed to get products", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(cancel)
        self.present(alert, animated: true)
    }
    
    private func setupNavigationBar() {
        setRightBarButtonHeart()
        setLogo()
        setLeftBarButtonPreson()
        navigationItem.leftBarButtonItem?.action = #selector(navigationToAuthentiocationScreen)
        navigationItem.rightBarButtonItem?.action = #selector(navigationToFavoriteScreen)
    }
    
    @objc private func navigationToFavoriteScreen() {
        guard let navigationController = navigationController else { return }
        presenter?.pushFavoriteViewController(navigationController: navigationController)
    }
    
    @objc private func navigationToAuthentiocationScreen() {
        guard let navigationController = navigationController else { return }
        presenter?.pushAuthentiocationViewController(navigationController: navigationController)
    }
    
    @objc private func pullUpRefreshControl(_ sender: UIRefreshControl) {
        presenter?.products.removeAll()
        presenter?.current_page = 1
        isFetchingData = false
        presenter?.startFetchingProducts()
        refreshControl.endRefreshing()
    }
  
}

// MARK: ColletionView Extension
extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if !changeCell {
            let cell = productsCollectionView.dequeueReusableCell(withReuseIdentifier: ProductsCollectionViewCell.identifier, for: indexPath) as! ProductsCollectionViewCell
            let product = products[indexPath.row]
            cell.configure(with: product, isFavorite: RealmService.shared.checkRealmElements(products: product))
            self.presenter?.cacheImage(cell.productImageView)
            cell.addToFavoriteProduct = { [weak self] (id) in
                self?.presenter?.toggleFavorite(id: id)
            }
            return cell
        } else {
            let cell = productsCollectionView.dequeueReusableCell(withReuseIdentifier: SquareProductsCollectionViewCell.identifier, for: indexPath) as! SquareProductsCollectionViewCell
            let product = products[indexPath.row]
            cell.configure(with: product, isFavorite: RealmService.shared.checkRealmElements(products: product))
            self.presenter?.cacheImage(cell.productImageView)
            cell.addToFavoriteProduct = { [weak self] (id) in
                self?.presenter?.toggleFavorite(id: id)
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let navigationController = navigationController else { return }
        presenter?.pushDetailsViewController(navigationController: navigationController, productId: products[indexPath.row].id)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let lastProduct = products.count - 1
        if indexPath.row == lastProduct && !isFetchingData {
            DispatchQueue.main.async { [weak self] in
                self?.isFetchingData = true
                self?.presenter?.startFetchingProducts()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var width: CGFloat = 0
        var height: CGFloat = 0
        
        if !changeCell {
            width = view.frame.width
            height = 213
        } else {
            width = (view.frame.width / 2) - 20
            height = 255
        }
        
        return CGSize(width: width, height: height)
    }
    
}
