//
//  CartVC.swift
//  EbsTestViper
//
//  Created by Сережа Присяжнюк on 27.07.2022.
//

import UIKit
import RealmSwift

protocol CartViewProtocol {
    var presenter: CartPresenterProtocol? { get set }
}

class CartVC: BaseViewController, CartViewProtocol {
    
    // MARK: - UIElements
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var cartCount: UILabel!
    
    @IBOutlet weak var productsPrice: UILabel!
    @IBOutlet weak var totalPrice: UILabel!
    // MARK: - Variables
    public var presenter: CartPresenterProtocol?
    
    private let realm = try? Realm(configuration: RealmService.shared.favoriteDataConfiguration(with: "cart.realm"))
    private var cartList: Results<Product>!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cartList = self.realm?.objects(Product.self)
        
        setupNavigationBar()
        
        configureTableView()
    }
    
    // MARK: - Functions
    
    func setupNavigationBar() {
        setBackButton()
        setLogo()
        setHeartFillButton()
    }
    
    private func configureUI() {
        cartCount.text = String(cartList.count)
        cartCount.layer.cornerRadius = cartCount.frame.height / 2
    }
    
    private func configureTableView() {
        
        tableView.register(UINib(nibName: "CartTVC", bundle: nil), forCellReuseIdentifier: CartTVC.identifier)
        tableView.dataSource = self
        
    }
}

extension CartVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CartTVC.identifier, for: indexPath) as? CartTVC else { return UITableViewCell() }
        let product = cartList[indexPath.row]
        cell.configure(with: product)
        
        self.productsPrice.text = "\(cartList.count)"
        self.totalPrice.text = "\(cartList.count * product.price)"
        return cell
    }
}

extension CartVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 192
    }
}
