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
    func checkNetworkConnection()
}

class MainViewController: BaseViewController, MainViewProtocol {
    
    // UIElements
    @IBOutlet weak var productsTableView: UITableView!
    @IBOutlet weak var cartView: UIView!
    @IBOutlet weak var cartCountLabel: UILabel!
    private let refreshControl = UIRefreshControl()
    
    // Variables
    private var products: [Product] = [Product]()
    var isFetchingData = false
    var presenter: MainPresenterProtocol?
    let monitor = NWPathMonitor()
    // Lifecycle
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        productsTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        downloadImage()
        presenter?.startFetchingProducts()
        
        productsTableView.register(ProductsTableViewCell.nib(), forCellReuseIdentifier: ProductsTableViewCell.identifier)
        productsTableView.delegate = self
        productsTableView.dataSource = self
        productsTableView.refreshControl = refreshControl
        
        refreshControl.addTarget(self, action: #selector(pullUpRefreshControl), for: .valueChanged)
    }
    
    // Get product list
    func fetchProductsSuccess(productsArray: [Product]) {
        products = productsArray
        DispatchQueue.main.async { [weak self] in
            self?.productsTableView.reloadData()
        }
    }
    
   private func setupNavigationBar() {
        setRightBarButtonHeart()
        setLogo()
        setLeftBarButtonPreson()
        navigationItem.leftBarButtonItem?.action = #selector(navigationToAuthentiocationScreen)
        navigationItem.rightBarButtonItem?.action = #selector(navigationToFavoriteScreen)
    }
    
    @objc private func navigationToFavoriteScreen() {
        presenter?.pushFavoriteViewController(navigationController: navigationController!)
    }
    
    @objc private func navigationToAuthentiocationScreen() {
        presenter?.pushAuthentiocationViewController(navigationController: navigationController!)
    }
    
    @objc private func pullUpRefreshControl(_ sender: UIRefreshControl) {
        presenter?.products.removeAll()
        presenter?.current_page = 1
        isFetchingData = false
        presenter?.startFetchingProducts()
        refreshControl.endRefreshing()
    }
    
    func checkNetworkConnection() {
        monitor.pathUpdateHandler = { pathUpdateHandler in
            if pathUpdateHandler.status == .satisfied {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Success", message: "", preferredStyle: .alert)
                    let cancel = UIAlertAction(title: "Cancel", style: .cancel)
                    alert.addAction(cancel)
                    self.present(alert, animated: true)
                }
            } else {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Error", message: "No internet", preferredStyle: .alert)
                    let cancel = UIAlertAction(title: "Cancel", style: .cancel)
                    alert.addAction(cancel)
                    self.present(alert, animated: true)
                }
            }
        }
        monitor.start(queue: DispatchQueue.global())
    }
    
    func downloadImage() {
        let url = URL(string: Constansts.baseURL)!
        presenter?.asynchronouslyDownloadImages(from: url)
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = productsTableView.dequeueReusableCell(withIdentifier: ProductsTableViewCell.identifier, for: indexPath) as? ProductsTableViewCell else {return UITableViewCell()}
        let product = products[indexPath.row]
        cell.configure(with: product, isFavorite: RealmService.shared.checkRealmElements(products: product))
        cell.addToFavoriteProduct = {[weak self] (id) in
                self?.presenter?.toggleFavorite(id: id)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.pushDetailsViewController(navigationController: navigationController!, productId: products[indexPath.row].id)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastProduct = products.count - 1
        if indexPath.row == lastProduct && !isFetchingData {
            DispatchQueue.main.async { [weak self] in
                self?.isFetchingData = true
                self?.presenter?.startFetchingProducts()
            }
        }
    }
}
