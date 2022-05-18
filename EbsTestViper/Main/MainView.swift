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
  var singleProduct: Products! { get set }
  
  func fetchProductsSuccess(productsArray: [Products])
  func checkNetworkConnection()
}

class MainViewController: BaseViewController, MainViewProtocol {

  // UIElements
  @IBOutlet weak var productsTableView: UITableView!
  @IBOutlet weak var cartView: UIView!
  @IBOutlet weak var cartCountLabel: UILabel!
  private let refreshControl = UIRefreshControl()
  
  // Variables
  var isFetchingData = false
  private var products: [Products] = [Products]()
  var singleProduct: Products!
  let realm = try? Realm()
  var presenter: MainPresenterProtocol?
  var favoriteList: Results<FavoriteList>!
  let monitor = NWPathMonitor()
  // Lifecycle
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    productsTableView.reloadData()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    checkNetworkConnection()
    downloadImage()
    presenter?.startFetchingProducts()
    
    setupNavigationBar()
    
    productsTableView.register(ProductsTableViewCell.nib(), forCellReuseIdentifier: ProductsTableViewCell.identifier)
    productsTableView.delegate = self
    productsTableView.dataSource = self
    productsTableView.refreshControl = refreshControl
    
    refreshControl.addTarget(self, action: #selector(pullUpRefreshControl), for: .valueChanged)
    
  }
  
  // Get product list
  func fetchProductsSuccess(productsArray: [Products]) {
    products = productsArray
    DispatchQueue.main.async { [weak self] in
      self?.productsTableView.reloadData()
    }
  }
  
  func setupNavigationBar() {
    setRightBarButtonHeart()
    setLogo()
    setLeftBarButtonPreson()
    navigationItem.leftBarButtonItem?.action = #selector(navigationToAuthentiocationScreen)
    navigationItem.rightBarButtonItem?.action = #selector(navigationToFavoriteScreen)
  }
  
  @objc func navigationToFavoriteScreen() {
    presenter?.pushFavoriteViewController(navigationController: navigationController!)
  }
  
  @objc func navigationToAuthentiocationScreen() {
    presenter?.pushAuthentiocationViewController(navigationController: navigationController!)
  }
  
  @objc func pullUpRefreshControl(_ sender: UIRefreshControl) {
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
      if cell.favButton.isSelected == false {
        self?.presenter?.toggleFavorite(id: id)
      } else {
        RealmService.shared.deleteElement(products: product)
      }
    }
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    presenter?.pushDetailsViewController(navigationController: navigationController!, productId: products[indexPath.row].id)
  }
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    let lastProduct = products.count - 1
    if indexPath.row == lastProduct && !isFetchingData {
      DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: { [weak self] in
        self?.isFetchingData = true
        self?.presenter?.startFetchingProducts()
      })
    }
  }
}
