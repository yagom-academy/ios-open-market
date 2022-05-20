//
//  OpenMarket - ViewController.swift
//  Created by Grumpy, OneTool
//  Copyright © yagom. All rights reserved.
// 

import UIKit

enum ArrangeMode: String, CaseIterable {
    case list = "LIST"
    case grid = "GRID"
    
    var value: Int {
        switch self {
        case .list:
            return 0
        case .grid:
            return 1
        }
    }
}

final class ViewController: UIViewController {
    private let arrangeModeChanger = UISegmentedControl(items: ArrangeMode.allCases.map {
        $0.rawValue
    })
    private var currentArrangeMode: ArrangeMode = .list
    private var products: [Product] = []
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: listLayout())
    private lazy var activityIndicator: UIActivityIndicatorView = {
        createActivityIndicator()
    }()
    private let numberFormatter = NumberFormatter()
}

extension ViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationItems()
        self.view.addSubview(collectionView)
        self.view.addSubview(activityIndicator)
        self.activityIndicator.startAnimating()
        requestProductListData()
        
        setUpSegmentedControlLayout()
        setUpCollectionViewConstraints()
        defineCollectionViewDelegate()
        
        setUpInitialState()
    }
}

// MARK: - Delegate
extension ViewController {
   private func defineCollectionViewDelegate() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
}

// MARK: - Delegate Method
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch self.currentArrangeMode {
        case .list:
            return configureListCell(indexPath: indexPath)
        case .grid:
            return configureGridCell(indexPath: indexPath)
        }
    }
}

// MARK: - Private Method
extension ViewController {
    private func setUpNavigationItems() {
        let plusButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: nil)
        self.navigationItem.titleView = arrangeModeChanger
        self.navigationItem.rightBarButtonItem = plusButton
        self.navigationController?.navigationBar.backgroundColor = .systemGroupedBackground
    }
    
    private func requestProductListData() {
        RequestAssistant.shared.requestListAPI(pageNumber: 1, itemsPerPage: 20) { result in
            Thread.sleep(forTimeInterval: 5)
            switch result {
            case .success(let data):
                self.products = data.pages
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.collectionView.reloadData()
                }
            case .failure(_):
                return
            }
        }
    }
    
    private func setUpSegmentedControlLayout() {
        let normalTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.systemBlue, .font: UIFont.preferredFont(forTextStyle: .callout)]
        let selectedTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, .font: UIFont.preferredFont(forTextStyle: .callout)]
        
        arrangeModeChanger.translatesAutoresizingMaskIntoConstraints = false
        arrangeModeChanger.backgroundColor = .white
        arrangeModeChanger.selectedSegmentTintColor = .systemBlue
        arrangeModeChanger.setTitleTextAttributes(normalTextAttributes, for: .normal)
        arrangeModeChanger.setTitleTextAttributes(selectedTextAttributes, for: .selected)
        arrangeModeChanger.layer.borderColor = UIColor.systemBlue.cgColor
        arrangeModeChanger.layer.borderWidth = 1.0
        arrangeModeChanger.layer.cornerRadius = 1.0
        arrangeModeChanger.layer.masksToBounds = false
        arrangeModeChanger.setWidth(85, forSegmentAt: 0)
        arrangeModeChanger.setWidth(85, forSegmentAt: 1)
        arrangeModeChanger.apportionsSegmentWidthsByContent = true
        arrangeModeChanger.sizeToFit()
    }
    
    @objc private func changeArrangement(_ sender: UISegmentedControl) {
        let mode = sender.selectedSegmentIndex
        if mode == ArrangeMode.list.value {
            self.currentArrangeMode = .list
        } else if mode == ArrangeMode.grid.value {
            self.currentArrangeMode = .grid
        }
        switch currentArrangeMode {
        case .list:
            collectionView.setCollectionViewLayout(listLayout(), animated: true) { [weak self] _ in self?.collectionView.reloadData() }
            collectionView
                .register(ListCollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "listCell")
            self.collectionView.reloadData()
        case .grid:
            collectionView.setCollectionViewLayout(gridLayout(), animated: true) { [weak self] _ in self?.collectionView.reloadData() }
            collectionView
                .register(GridCollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "gridCell")
            self.collectionView.reloadData()
        }
    }
    
    private func setUpCollectionViewConstraints() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    private func setUpInitialState() {
        arrangeModeChanger.addTarget(self, action: #selector(changeArrangement(_:)), for: .valueChanged)
        arrangeModeChanger.selectedSegmentIndex = 0
        self.changeArrangement(arrangeModeChanger)
    }
    
    private func createActivityIndicator() -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        activityIndicator.center = self.view.center
        activityIndicator.color = UIColor.systemBlue
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.medium
        return activityIndicator
    }
    
    private func configureListCell(indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "listCell", for: indexPath) as? ListCollectionViewCell else {
            return ListCollectionViewCell()
        }
        
        cell.accessories = [.disclosureIndicator()]
        configureCellContents(indexPath: indexPath, cell: cell)
        
        return cell
    }
    
    private func configureGridCell(indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "gridCell", for: indexPath) as? GridCollectionViewCell else {
            return GridCollectionViewCell()
        }
        
        configureCellContents(indexPath: indexPath, cell: cell)
        
        cell.layer.borderWidth = 1.5
        cell.layer.borderColor = UIColor.systemGray.cgColor
        cell.layer.cornerRadius = 10.0
        
        return cell
    }
    
    private func configureCellContents(indexPath: IndexPath, cell: OpenMarketCell) {
        guard let currency = products[indexPath.row].currency?.rawValue else {
            return
        }
        cell.productNameLabel.text = products[indexPath.row].name
        cell.productPriceLabel.text = "\(currency) \(numberFormatter.numberFormatString(for: products[indexPath.row].price))"
        cell.productImageView.requestImageDownload(url: products[indexPath.row].thumbnail)
        guard let price = cell.productPriceLabel.text else {
            return
        }
        
        if products[indexPath.row].discountedPrice != 0 {
            cell.productBargainPriceLabel.text = "\(currency) \(numberFormatter.numberFormatString(for: products[indexPath.row].bargainPrice))"
            cell.productPriceLabel.textColor = .red
            cell.productPriceLabel.attributedText = setTextAttribute(of: price, attributes: [.strikethroughStyle: NSUnderlineStyle.single.rawValue])
        }
        if products[indexPath.row].stock == 0 {
            cell.productStockLabel.text = "품절"
            cell.productStockLabel.textColor = .systemOrange
        } else {
            cell.productStockLabel.text = "잔여수량 :  \(String(products[indexPath.row].stock))"
        }
    }
    
    private func setTextAttribute(of target: String, attributes: [NSAttributedString.Key: Any]) -> NSAttributedString {
        let attributedText = NSMutableAttributedString(string: target)
        attributedText.addAttributes(attributes, range: (target as NSString).range(of: target))
        
        return attributedText
    }
}

// MARK: - Collection View Layout
extension ViewController {
    private func listLayout() -> UICollectionViewCompositionalLayout {
        var listConfiguration = UICollectionLayoutListConfiguration(appearance: .plain)
        
        listConfiguration.showsSeparators = true
        listConfiguration.backgroundColor = UIColor.clear
        
        return UICollectionViewCompositionalLayout.list(using: listConfiguration)
    }
    
    private func gridLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(self.view.frame.height * 0.30))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        let section = NSCollectionLayoutSection(group: group)
        
        group.interItemSpacing = .fixed(10)
        section.interGroupSpacing = CGFloat(10)
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 10)
        
        return UICollectionViewCompositionalLayout(section: section)
    }
}

