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
        case vertical(Product)
    }
    
    enum ViewMode {
        case horizontal
        case vertical
    }
    
    // MARK: - UIElements
    @IBOutlet private weak var productsCollectionView: UICollectionView!
    @IBOutlet private weak var cartView: UIView!
    @IBOutlet private weak var cartCountLabel: UILabel!
    @IBOutlet private weak var cartButton: UIButton!
    @IBOutlet private weak var filterButton: UIButton!
    private let refreshControl = UIRefreshControl()
    
    // MARK: - Variables
    private var products: [Product] = []
    private var changeCell: Bool = false
    private var cells: [CellType] = []
    private var viewMode: ViewMode = .horizontal
   
    public var hasNoMorePages = false
    public var isFetchingData = false
    public var presenter: MainPresenterProtocol?
  
    private var cartList: Results<Product>!
    private let realm = try? Realm(configuration: RealmService.shared.favoriteDataConfiguration(with: "cart.realm"))
    // MARK: - Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        productsCollectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cartList = self.realm?.objects(Product.self)
        
        configureUI()
        setupNavigationBar()
        presenter?.startFetchingProducts()
        configureCollectionView()
    }
    
    // MARK: - Functions
    
    private func setupNavigationBar() {
        
        setRightBarButtonHeart()
        setLogo()
        setLeftBarButtonPreson()
        navigationItem.leftBarButtonItem?.action = #selector(navigationToAuthentiocationScreen)
        navigationItem.rightBarButtonItem?.action = #selector(navigationToFavoriteScreen)
    }
    
    private func configureUI() {
        cartCountLabel.text = String(cartList.count)
        cartButton.setTitle("MY CART".localized(), for: .normal)
        filterButton.setTitle("FILTER".localized(), for: .normal)
    }
    
    private func configureCollectionView() {
        
        productsCollectionView.register(SquareProductsCollectionViewCell.nib(), forCellWithReuseIdentifier: SquareProductsCollectionViewCell.identifier)
        productsCollectionView.register(ProductsCollectionViewCell.nib(), forCellWithReuseIdentifier: ProductsCollectionViewCell.identifier)
        
        productsCollectionView.delegate = self
        productsCollectionView.dataSource = self
        productsCollectionView.refreshControl = refreshControl
        
        refreshControl.addTarget(self, action: #selector(pullUpRefreshControl), for: .valueChanged)
    }
    
    private func prepareStructure(with viewMode: ViewMode) {
       
        self.viewMode = viewMode
        
        switch viewMode {
            
        case .horizontal:
            
            cells = []
            cells.append(contentsOf: products.map({ .horizontal($0) }))
        
        case .vertical:
            
            cells = []
            cells.append(contentsOf: products.map({ .vertical($0) }))
        }
        
        DispatchQueue.main.async {
            self.productsCollectionView.reloadData()
        }
        
    }
    
    public func fetchProductsSuccess(productsArray: [Product]) {
        
        products = productsArray
        prepareStructure(with: self.viewMode)
    }
    
    public func failedToFetchProducts() {
        showAlert(title: "Error", body: "Failed to fetch products")
    }
    
    @objc private func navigationToFavoriteScreen() {
        guard let navigationController = navigationController else { return }
        presenter?.pushFavoriteViewController(navigationController: navigationController)
    }
    
    @objc private func navigationToAuthentiocationScreen() {
        guard let navigationController = navigationController else { return }
        presenter?.pushAuthenticationViewController(navigationController: navigationController)
    }
    
    @objc private func pullUpRefreshControl(_ sender: UIRefreshControl) {
        
        presenter?.products.removeAll()
        presenter?.current_page = 1
        isFetchingData = false
        presenter?.startFetchingProducts()
        refreshControl.endRefreshing()
    }
    
    // MARK: - IBActions
    
    @IBAction func cartAction(_ sender: UIButton) {
        guard let navigationController = navigationController else { return }
        presenter?.pushCartViewController(navigationController: navigationController)
    }
    
    @IBAction func squareCellSize(_ sender: UIButton) {
        prepareStructure(with: .vertical)
    }
    
    @IBAction func horizontalCell(_ sender: Any) {
        prepareStructure(with: .horizontal)
    }
}

// MARK: - Colletion View Extension Data Source

extension MainViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cells.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch cells[indexPath.row] {
            
        case .horizontal:
            
            let cell = productsCollectionView.dequeueReusableCell(withReuseIdentifier: ProductsCollectionViewCell.identifier, for: indexPath) as! ProductsCollectionViewCell
            
            let product = products[indexPath.row]
            
            cell.configure(with: product,
                           isFavorite: RealmService.shared.checkRealmElements(products: product, realm: RealmService.shared.realm),
                           isAddedToCart: RealmService.shared.checkRealmElements(products: product, realm: RealmService.shared.cartRealm))
            
            self.presenter?.cacheImage(cell.productImageView)
            
            cell.addToFavoriteProduct = { [weak self] (id) in
                guard let self = self else { return }
                self.presenter?.toggleProductState(id: id, realm: RealmService.shared.realm)
            }
            
            cell.addToCartProduct = { [weak self] (id) in
                guard let self = self else { return }
                self.cartCountLabel.text = String(self.cartList.count)
                self.presenter?.toggleProductState(id: id, realm: RealmService.shared.cartRealm)
            }
            return cell
            
        case .vertical:
            
            let cell = productsCollectionView.dequeueReusableCell(withReuseIdentifier: SquareProductsCollectionViewCell.identifier, for: indexPath) as! SquareProductsCollectionViewCell
            
            let product = products[indexPath.row]
            cell.configure(with: product, isFavorite: RealmService.shared.checkRealmElements(products: product, realm: RealmService.shared.realm))
            
            self.presenter?.cacheImage(cell.productImageView)
            
            cell.addToFavoriteProduct = { [weak self] (id) in
                guard let self = self else { return }
                self.presenter?.toggleProductState(id: id, realm: RealmService.shared.realm)
            }
            
            cell.addProductToCart = { [weak self] (id) in
                guard let self = self else { return }
                self.presenter?.toggleProductState(id: id, realm: RealmService.shared.cartRealm)
            }
            
            return cell
        }
    }
}

// MARK: - UICollectionView Delegate

extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let navigationController = navigationController else { return }
        presenter?.pushDetailsViewController(navigationController: navigationController, productId: products[indexPath.row].id)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        let lastProduct = products.count - 1
        if indexPath.row == lastProduct && !isFetchingData && hasNoMorePages {
            DispatchQueue.main.async { [weak self] in
//                guard let self = self else { return }
                self?.isFetchingData = true
                self?.presenter?.startFetchingProducts()
            }
        }
    }
}

// MARK: - UICollectionView FlowLayout

extension MainViewController: UICollectionViewDelegateFlowLayout {
    
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
            height = 265
            
            return CGSize(width: width, height: height)
        }
    }
}
