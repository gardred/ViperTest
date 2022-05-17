//
//  MainView.swift
//  EbsTestViper
//
//  Created by Сережа Присяжнюк on 03.05.2022.
//

import Foundation
import UIKit
import RealmSwift
// View <------> Presenter
protocol MainViewProtocol {
  var presenter: MainPresenterProtocol? { get set }
  var isFetchingData: Bool { get set }
  
  func fetchProductsSuccess(productsArray: [Products])
  func fetchProductsError()
  func checkNetworkConnection()
}

class MainViewController: BaseViewController, MainViewProtocol {
  let realm = try? Realm()
  var presenter: MainPresenterProtocol?
  var favoriteList: Results<FavoriteList>!
  // UIElements
  @IBOutlet weak var productsTableView: UITableView!
  @IBOutlet weak var cartView: UIView!
  @IBOutlet weak var cartCountLabel: UILabel!
  private let refreshControl = UIRefreshControl()
  // Variables
  var isFetchingData = false
  private var products: [Products] = [Products]()
  private var singleProduct: Products!
  // Lifecycle
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    productsTableView.reloadData()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    presenter?.startFetchingProducts()
    checkNetworkConnection()
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
  
  func fetchProductsError() {
    let alert = UIAlertController(title: "Alert", message: "Problem Fetching Products", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
    self.present(alert, animated: true, completion: nil)
  }
  
  @objc func pullUpRefreshControl(_ sender: UIRefreshControl) {
    presenter?.products.removeAll()
    presenter?.current_page = 1
    isFetchingData = false
    presenter?.startFetchingProducts()
    refreshControl.endRefreshing()
  }
  
  func checkNetworkConnection() {
    presenter?.checkForNetwork()
  }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return products.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = productsTableView.dequeueReusableCell(withIdentifier: ProductsTableViewCell.identifier, for: indexPath) as? ProductsTableViewCell else {return UITableViewCell()}
    cell.selectionStyle = .none
    let product = products[indexPath.row]
    
    let contains = realm?.objects(FavoriteList.self).contains { favoriteObject in
      if favoriteObject.id == product.id {
        cell.favButton.isSelected = true
        cell.favButton.backgroundColor = hexStringToUIColor(hex: "#FAF0D8")
      }
      return false
    }
    cell.configure(with: product, isFavorite: contains!)
   
    cell.addToFavoriteProduct = {
      if cell.favButton.isSelected == false {
        RealmService.shared.addProduct(name: product.name,
                                       icon: product.main_image,
                                       details: product.details,
                                       price: product.price,
                                       id: product.id)
      } else {
        cell.favButton.backgroundColor = .white
        cell.favButton.isSelected = false
        let configure = self.realm?.objects(FavoriteList.self).contains { favoriteObject in
          if favoriteObject.id == product.id {
            RealmService.shared.removeProduct(productToDelete: favoriteObject)
            self.productsTableView.reloadData()
          }
          return false
      }
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
