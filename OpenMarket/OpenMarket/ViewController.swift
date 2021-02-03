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
    let productListCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
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
        view.addSubview(productListTableView)
        view.addSubview(productListCollectionView)
        setUpProductListTableView()
        setUpProductListCollectionView()
        setUpNavigationItem()
        
        self.openMarketAPIManager.fetchProductList(of: 1) { (result) in
            switch result {
            case .success(let productList):
                for i in 0..<productList.items.count {
                    self.productList.append(productList.items[i])
                }
                
                DispatchQueue.main.async {
                    self.productListTableView.reloadData()
                    self.productListCollectionView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
        
        let testProduct = Product(id: nil, title: "태애태애", descriptions: "비밀번호 486", price: 20000, currency: "KRW", stock: 100, discountedPrice: 10000, thumbnails: nil, images: [], registrationDate: nil, password: "486")

        self.openMarketAPIManager.requestRegistration(of: testProduct) { (result) in
            switch result {
            case .success(let testProduct):
                print(testProduct)
            case .failure(let error):
                print(error)
            }
        }
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
        
        let productInformation = productList[indexPath.row]
        cell.priceLabel.text = productInformation.discountedPrice != nil ? "\(productInformation.currency) \(productInformation.price) \(String(describing: productInformation.discountedPrice))" : "\(productInformation.currency) \(productInformation.price)"
        cell.stockLabel.text = productInformation.stock > 0 ? "재고: \(productInformation.stock)" : "품절"
        cell.nameLabel.text = productInformation.title
        cell.thumbnailImageView.image = nil
        
        DispatchQueue.global().async {
            guard let imageStringPath = productInformation.thumbnails?.first,
                  let imageURL: URL = URL(string: imageStringPath),
                  let imageData: Data = try? Data(contentsOf: imageURL) else {
                return
            }
            
            DispatchQueue.main.async {
                if let index: IndexPath = tableView.indexPath(for: cell) {
                    if index.row == indexPath.row {
                        cell.thumbnailImageView.image = UIImage(data: imageData)
                    }
                }
            }
        }
        return cell
    }
}
extension ViewController: UICollectionViewDelegate {
    
}
extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 2.3, height: collectionView.frame.width / 1.5)
    }
}
extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductInformationGridCell.identifier, for: indexPath) as? ProductInformationGridCell else {
            return UICollectionViewCell()
        }
        
        let productInformation = productList[indexPath.item]
        cell.priceLabel.text = productInformation.discountedPrice != nil ? "\(productInformation.currency) \(productInformation.price) \(String(describing: productInformation.discountedPrice))" : "\(productInformation.currency) \(productInformation.price)"
        cell.stockLabel.text = productInformation.stock > 0 ? "재고: \(productInformation.stock)" : "품절"
        cell.nameLabel.text = productInformation.title
        cell.backgroundColor = .white
        cell.thumbnailImageView.image = nil
        
        DispatchQueue.global().async {
            guard let imageStringPath = productInformation.thumbnails?.first,
                  let imageURL: URL = URL(string: imageStringPath),
                  let imageData: Data = try? Data(contentsOf: imageURL) else {
                return
            }
            
            DispatchQueue.main.async {
                if let index: IndexPath = collectionView.indexPath(for: cell) {
                    if index.item == indexPath.item {
                        cell.thumbnailImageView.image = UIImage(data: imageData)
                    }
                }
            }
        }
        return cell
    }
}
extension ViewController {
    private func setUpProductListTableView() {
        productListTableView.delegate = self
        productListTableView.dataSource = self
        
        productListTableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            productListTableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            productListTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            productListTableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            productListTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        
        productListTableView.register(ProductInformationCell.self, forCellReuseIdentifier: ProductInformationCell.identifier)
        productListTableView.rowHeight = (self.view.frame.height) / 10
    }
    
    private func setUpProductListCollectionView() {
        productListCollectionView.delegate = self
        productListCollectionView.dataSource = self
        
        productListCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            productListCollectionView.topAnchor.constraint(equalTo: self.view.topAnchor),
            productListCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            productListCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            productListCollectionView.heightAnchor.constraint(equalToConstant: self.view.frame.height)
        ])
        
        productListCollectionView.register(ProductInformationGridCell.self, forCellWithReuseIdentifier: ProductInformationGridCell.identifier)
        productListCollectionView.isHidden = true
    }
    
    private func setUpNavigationItem() {
        self.navigationItem.titleView = listPresentingStyleSegmentControl
        self.navigationItem.rightBarButtonItem = addProductButton
    }
    
    @objc private func handleSegmentedControlValueChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            productListTableView.isHidden = false
            productListCollectionView.isHidden = true
        case 1:
            productListTableView.isHidden = true
            productListCollectionView.isHidden = false
        default:
            setUpProductListTableView()
        }
    }
    
    @objc private func addButtonTapped(_ sender: Any) {
        print("button pressed")
    }
}
