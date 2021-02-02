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
    }
    
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
        productListTableView.rowHeight = 50
    }
    
    private func setUpProductListCollectionView() {
        productListCollectionView.delegate = self
        productListCollectionView.dataSource = self
        
        productListCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            productListCollectionView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 40),
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
        
        if productInformation.discountedPrice != nil {
            cell.priceLabel.text = "\(productInformation.currency) \(productInformation.price) \(String(describing: productInformation.discountedPrice))"
        } else {
            cell.priceLabel.text = "\(productInformation.currency) \(productInformation.price)"
        }
        
        if productInformation.stock == 0 {
            cell.stockLabel.text = "품절"
        } else {
            cell.stockLabel.text = "재고: \(productInformation.stock)"
        }
        
        cell.nameLabel.text = productInformation.title
        cell.imageView?.image = nil
        
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
        cell.backgroundColor = .white
        
        let productInformation = productList[indexPath.item]
        
        if productInformation.discountedPrice != nil {
            cell.priceLabel.text = "\(productInformation.currency) \(productInformation.price) \(String(describing: productInformation.discountedPrice))"
        } else {
            cell.priceLabel.text = "\(productInformation.currency) \(productInformation.price)"
        }
        
        if productInformation.stock == 0 {
            cell.stockLabel.text = "품절"
        } else {
            cell.stockLabel.text = "재고: \(productInformation.stock)"
        }
        
        cell.nameLabel.text = productInformation.title
        
        DispatchQueue.global().async {
            guard let imageStringPath = productInformation.thumbnails?.first,
                  let imageURL: URL = URL(string: imageStringPath),
                  let imageData: Data = try? Data(contentsOf: imageURL) else {
                return
            }
            
            DispatchQueue.main.async {
                if let index: IndexPath = collectionView.indexPath(for: cell) {
                    if index.row == indexPath.row {
                        cell.thumbnailImageView.image = UIImage(data: imageData)
                    }
                }
            }
        }
        
        return cell
    }
    
    
}
extension ViewController {
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
