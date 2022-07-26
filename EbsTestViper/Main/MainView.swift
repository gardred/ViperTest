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

protocol MainViewProtocol {
    
    var presenter: MainPresenterProtocol? { get set }
    var isFetchingData: Bool { get set }
    var hasNoMorePages: Bool { get set }
    func fetchProductsSuccess(productsArray: [Product])
    func failedToFetchProducts()
}

class MainViewController: BaseViewController, MainViewProtocol {
    
    enum CellType {
        case horizontal(Product)
        case vertical
    }
    
    // MARK: - UIElements
    @IBOutlet private weak var productsCollectionView: UICollectionView!
    @IBOutlet private weak var cartView: UIView!
    @IBOutlet private weak var cartCountLabel: UILabel!
    @IBOutlet private weak var cartButton: UIButton!
    private let refreshControl = UIRefreshControl()
    
    // MARK: - Variables
    private var products: [Product] = []
    private var changeCell: Bool = false
    private var cells: [CellType] = []
    
    public var hasNoMorePages = false
    public var isFetchingData = false
    public var presenter: MainPresenterProtocol?
    // MARK: - Lifecycle
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        productsCollectionView.reloadData()
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupNavigationBar()
        presenter?.startFetchingProducts()
        configureCollectionView()
    }
    
    // MARK: - Functions
    
    private func configureCollectionView() {
        
        productsCollectionView.register(SquareProductsCollectionViewCell.nib(), forCellWithReuseIdentifier: SquareProductsCollectionViewCell.identifier)
        productsCollectionView.register(ProductsCollectionViewCell.nib(), forCellWithReuseIdentifier: ProductsCollectionViewCell.identifier)
        
        productsCollectionView.delegate = self
        productsCollectionView.dataSource = self
        productsCollectionView.refreshControl = refreshControl
        
        refreshControl.addTarget(self, action: #selector(pullUpRefreshControl), for: .valueChanged)
    }
    
    public func fetchProductsSuccess(productsArray: [Product]) {
        
        products = productsArray
        
        cells = []
        cells.append(contentsOf: products.map({ .horizontal($0) }))
        
        DispatchQueue.main.async { [weak self] in
            self?.productsCollectionView.reloadData()
        }
    }
    
    public func failedToFetchProducts() {
        
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
    
    // MARK: - IBActions
    
    @IBAction func squareCellSize(_ sender: UIButton) {
//        viewMode = .vertical
        productsCollectionView.reloadData()
        
    }
    
    @IBAction func horizontalCell(_ sender: Any) {
//        viewMode = .horizontal
        productsCollectionView.reloadData()
    }
    
}

// MARK: - Colletion View Extension

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cells.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch cells[indexPath.row] {
            
        case .horizontal:
            
            let cell = productsCollectionView.dequeueReusableCell(withReuseIdentifier: ProductsCollectionViewCell.identifier, for: indexPath) as! ProductsCollectionViewCell
            
            let product = products[indexPath.row]
            cell.configure(with: product, isFavorite: RealmService.shared.checkRealmElements(products: product))
            
            self.presenter?.cacheImage(cell.productImageView)
            cell.addToFavoriteProduct = { [weak self] (id) in
                self?.presenter?.toggleFavorite(id: id)
            }
            return cell
            
        case .vertical:
            
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
        if indexPath.row == lastProduct && !isFetchingData && hasNoMorePages {
            DispatchQueue.main.async { [weak self] in
                self?.isFetchingData = true
                self?.presenter?.startFetchingProducts()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var width: CGFloat = 0
        var height: CGFloat = 0
        
        switch cells[indexPath.row] {
            
        case .horizontal:
            
            width = view.frame.width
            height = 213
            
            return CGSize(width: width, height: height)
            
        case .vertical:
            
            width = (view.frame.width / 2) - 20
            height = 255
            
            return CGSize(width: width, height: height)
        }
    }
}
