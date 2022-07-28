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
    @IBOutlet weak var deliveryPrice: UILabel!
    
    // MARK: - Variables
    public var presenter: CartPresenterProtocol?
    
    private let realm = try? Realm(configuration: RealmService.shared.favoriteDataConfiguration(with: "cart.realm"))
    private var cartList: Results<Product>!
    private var notificationToken: NotificationToken?
    
    private let deliveryCost = 400
    private var productCost: Int?
    private var totalCost: Int?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cartList = self.realm?.objects(Product.self)
        configureUI()
        setupNavigationBar()
        configureTableView()
        updateTableView()
        
        
    }
    
    // MARK: - Functions
    
    private func updateTableView() {
        notificationToken = cartList.observe({ [weak self] (changes) in
            guard let self = self else { return }
            guard let tableView = self.tableView else { return }
            
            switch changes {
                
            case .initial:
                tableView.reloadData()
            case .update(_, deletions: let deletions, insertions: let insertions, modifications: let modifications):
                tableView.performBatchUpdates {
                    tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0) }), with: .automatic)
                    tableView.insertRows(at: insertions.map({IndexPath(row: $0, section: 0)}), with: .automatic)
                    tableView.reloadRows(at: modifications.map({IndexPath(row: $0, section: 0)}), with: .automatic)
                }
            case .error:
                break
            }
        })
    }
    
    private func setupNavigationBar() {
        setBackButton()
        setLogo()
        setHeartFillButton()
    }
    
    private func configureUI() {
        
        cartCount.text = String(cartList.count)
        cartCount.layer.cornerRadius = cartCount.frame.height / 2
        
        deliveryPrice.text = "$\(deliveryCost)"
        
        let sum: Int = realm!.objects(Product.self).sum(ofProperty: "price")
        productsPrice.text = "$\(sum)"
        
        totalCost = sum + deliveryCost
        totalPrice.text = "$\(totalCost!)"
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
        cell.id = product.id
        cell.configure(with: product)
        
        cell.removeFromCartProduct = { [weak self ] (id) in
            guard let self = self else { return }
            self.presenter?.toggleCartItem(id: id)
        }
        
        return cell
    }
}

extension CartVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 192
    }
}
