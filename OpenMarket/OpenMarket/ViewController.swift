//
//  OpenMarket - ViewController.swift
//  Created by Grumpy, OneTool
//  Copyright © yagom. All rights reserved.
// 

import UIKit

enum ArrangeMode: Int {
    case list = 0
    case grid = 1
}

class ViewController: UIViewController {
    private let segmentedControl = UISegmentedControl(items: ["LIST", "GRID"])
    private var arrangeMode: ArrangeMode = .list
    private var data: [Product] = []
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: listLayout())
    private lazy var activityIndicator: UIActivityIndicatorView = {
        createActivityIndicator()
    }()
}

// MARK: - Life Cycle
extension ViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationItems()
        self.view.addSubview(collectionView)
        self.view.addSubview(activityIndicator)
        self.activityIndicator.startAnimating()
        receiveProductListData()
        
        setUpSegmentedControlLayout()
        setUpCollectionViewConstraints()
        collectionViewDelegate()
        
        setUpInitialState()
    }
}

// MARK: - Delegate
extension ViewController {
    func collectionViewDelegate() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
}

// MARK: - Delegate Method
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch self.arrangeMode {
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
        self.navigationItem.titleView = segmentedControl
        self.navigationItem.rightBarButtonItem = plusButton
        self.navigationController?.navigationBar.backgroundColor = .systemGroupedBackground
    }
    
    private func receiveProductListData() {
        RequestAssistant.shared.requestListAPI(pageNumber: 1, itemsPerPage: 20) { result in
            Thread.sleep(forTimeInterval: 5)
            switch result {
            case .success(let data):
                self.data = data.pages
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
        
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.backgroundColor = .white
        segmentedControl.selectedSegmentTintColor = .systemBlue
        segmentedControl.setTitleTextAttributes(normalTextAttributes, for: .normal)
        segmentedControl.setTitleTextAttributes(selectedTextAttributes, for: .selected)
        segmentedControl.layer.borderColor = UIColor.systemBlue.cgColor
        segmentedControl.layer.borderWidth = 1.0
        segmentedControl.layer.cornerRadius = 1.0
        segmentedControl.layer.masksToBounds = false
        segmentedControl.setWidth(85, forSegmentAt: 0)
        segmentedControl.setWidth(85, forSegmentAt: 1)
        segmentedControl.apportionsSegmentWidthsByContent = true
        segmentedControl.sizeToFit()
    }
    
    @objc private func arrangementChange(_ sender: UISegmentedControl) {
        let mode = sender.selectedSegmentIndex
        
        if mode == ArrangeMode.list.rawValue {
            self.arrangeMode = .list
            collectionView.setCollectionViewLayout(listLayout(), animated: true) { [weak self] _ in self?.collectionView.reloadData() }
            collectionView
                .register(ListCollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "listCell")
            self.collectionView.reloadData()
        } else if mode == ArrangeMode.grid.rawValue {
            self.arrangeMode = .grid
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
        segmentedControl.addTarget(self, action: #selector(arrangementChange(_:)), for: .valueChanged)
        segmentedControl.selectedSegmentIndex = 0
        self.arrangementChange(segmentedControl)
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
            return UICollectionViewCell()
        }
        
        cell.accessories = [.disclosureIndicator()]
        configureCellContents(indexPath: indexPath, cell: cell)
        
        return cell
    }
    
    private func configureGridCell(indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "gridCell", for: indexPath) as? GridCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        configureCellContents(indexPath: indexPath, cell: cell)
        
        cell.layer.borderWidth = 1.5
        cell.layer.borderColor = UIColor.systemGray.cgColor
        cell.layer.cornerRadius = 10.0
        
        return cell
    }
    
    private func configureCellContents(indexPath: IndexPath, cell: OpenMarketCell) {
        guard let currency = data[indexPath.row].currency?.rawValue else {
            return
        }
        cell.productNameLabel.text = data[indexPath.row].name
        cell.productPriceLabel.text = "\(currency) \(NumberFormatterAssistant.shared.numberFormatString(for: data[indexPath.row].price))"
        cell.productImageView.requestImageDownload(url: data[indexPath.row].thumbnail)
        guard let price = cell.productPriceLabel.text else {
            return
        }
        
        if data[indexPath.row].discountedPrice != 0 {
            cell.productBargainPriceLabel.text = "\(currency) \(NumberFormatterAssistant.shared.numberFormatString(for: data[indexPath.row].bargainPrice))"
            cell.productPriceLabel.textColor = .red
            cell.productPriceLabel.attributedText = setTextAttribute(of: price, attributes: [.strikethroughStyle: NSUnderlineStyle.single.rawValue])
        }
        if data[indexPath.row].stock == 0 {
            cell.productStockLabel.text = "품절"
            cell.productStockLabel.textColor = .systemOrange
        } else {
            cell.productStockLabel.text = "잔여수량 :  \(String(data[indexPath.row].stock))"
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

