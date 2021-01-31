//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {
    let openMarketAPIManager = OpenMarketAPIManager(session: URLSession(configuration: .default))
    var productList = [Product]()
    let productListTableView = UITableView()
    
    let testProductName = ["mac mini","iphone","ipad"]
    let testProductThumbnail = [UIImage(named: "default"),UIImage(named: "default"),UIImage(named: "default")]
    let testProductPrice = ["10000","20000","30000"]
    let testProductStock = ["1","2","3"]
    
    let listPresentingStyleSelection = ["LIST","GRID"]
    lazy var addProductButton: UIBarButtonItem = {
        let button =  UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped(_:)))
        return button
    }()
    lazy var listPresentingStyleSegmentControl: UISegmentedControl = {
        let control = UISegmentedControl(items: listPresentingStyleSelection)
        control.selectedSegmentIndex = 0
        control.layer.borderColor = UIColor.systemBlue.cgColor
        control.tintColor = .systemBlue
        control.selectedSegmentTintColor = .systemBlue
        control.addTarget(self, action: #selector(handleSegmentedControlValueChanged(_:)), for: .valueChanged)
        return control
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        productListTableView.delegate = self
        productListTableView.dataSource = self
        productListTableView.rowHeight = 50
        productListTableView.register(ProductInformationCell.self, forCellReuseIdentifier: ProductInformationCell.identifier)
        view.addSubview(productListTableView)
        setUpProductListView()
        self.navigationItem.titleView = listPresentingStyleSegmentControl
        self.navigationItem.rightBarButtonItem = addProductButton
        
        
        self.openMarketAPIManager.fetchProductList(of: 1) { (result) in
            switch result {
            case .success(let productList):
                for i in 0..<productList.items.count {
                    self.productList.append(productList.items[i])
                }
                
                DispatchQueue.main.async {
                    self.productListTableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    private func setUpProductListView() {
        productListTableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            productListTableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            productListTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            productListTableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            productListTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
}
extension ViewController: UITableViewDelegate {
    
}
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProductInformationCell.identifier) as? ProductInformationCell else {
            return UITableViewCell()
        }
        
        cell.thumbnailImageView.image = UIImage(named:"\(productList[indexPath.row].thumbnails)") ?? UIImage(named: "default")
        cell.thumbnailImageView.image = UIImage(named: "default")
        cell.nameLabel.text = productList[indexPath.row].title
        cell.priceLabel.text = "\(productList[indexPath.row].currency) \(productList[indexPath.row].price)"
        cell.stockLabel.text = "재고: \(productList[indexPath.row].stock)"
        
        return cell
    }
}
extension ViewController {
    @objc private func handleSegmentedControlValueChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            productListTableView.isHidden = false
        case 1:
            productListTableView.isHidden = true
            view.backgroundColor = .red
        default:
            setUpProductListView()
        }
    }
    
    @objc private func addButtonTapped(_ sender: Any) {
        print("button pressed")
    }
}
