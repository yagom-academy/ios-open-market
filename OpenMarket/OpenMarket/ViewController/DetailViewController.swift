//
//  DetailViewController.swift
//  OpenMarket
//
//  Created by Grumpy, OneTool on 2022/05/31.
//

import UIKit

class DetailViewController: UIViewController {
    var product: Product?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviewStructures()
        setupLayoutConstraints()
        configureContents()
        defineCollectionViewDelegate()
        
        collectionView.register(DetailCollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "detailCell")
    }
    
    let mainScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isScrollEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        return scrollView
    }()
    
    let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fill
        stackView.spacing = 5
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        return stackView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let stockLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        return label
    }()
    
    let bargainPriceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let informationStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalCentering
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    var collectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .horizontal
        collectionViewLayout.minimumLineSpacing = 20
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.allowsMultipleSelection = false
        collectionView.isPagingEnabled = true
        collectionView.contentInsetAdjustmentBehavior = .never
        
        return collectionView
    }()
    
    func setupSubviewStructures() {
        
        informationStackView.addArrangedSubview(nameLabel)
        informationStackView.addArrangedSubview(stockLabel)
        
        mainStackView.addArrangedSubview(collectionView)
        mainStackView.addArrangedSubview(informationStackView)
        
        mainStackView.addArrangedSubview(priceLabel)
        mainStackView.addArrangedSubview(bargainPriceLabel)
        mainStackView.addArrangedSubview(descriptionLabel)
        mainScrollView.addSubview(mainStackView)
        self.view.addSubview(mainScrollView)
        
    }
    
    func setupLayoutConstraints() {
        mainScrollView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        mainScrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        mainScrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        mainScrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        mainScrollView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        mainScrollView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        
        mainStackView.topAnchor.constraint(equalTo: mainScrollView.topAnchor).isActive = true
        mainStackView.bottomAnchor.constraint(equalTo: mainScrollView.bottomAnchor).isActive = true
        mainStackView.leadingAnchor.constraint(equalTo: mainScrollView.leadingAnchor).isActive = true
        mainStackView.trailingAnchor.constraint(equalTo: mainScrollView.trailingAnchor).isActive = true
        mainStackView.centerXAnchor.constraint(equalTo: mainScrollView.centerXAnchor).isActive = true
        
        collectionView.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor).isActive = true
        collectionView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.45).isActive = true
        collectionView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        informationStackView.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor).isActive = true
        informationStackView.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor).isActive = true
        
        nameLabel.leadingAnchor.constraint(equalTo: informationStackView.leadingAnchor).isActive = true
        stockLabel.trailingAnchor.constraint(equalTo: informationStackView.trailingAnchor).isActive = true
        
        priceLabel.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor).isActive = true
        bargainPriceLabel.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor).isActive = true
    }
    
    func configureContents() {
        guard let product = product else {
            return
        }
        nameLabel.text = product.name
        stockLabel.text = String(product.stock)
        priceLabel.text = String(product.price)
        bargainPriceLabel.text = String(product.bargainPrice)
        descriptionLabel.text = product.description
    }
}

extension DetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "detailCell", for: indexPath) as? DetailCollectionViewCell else {
            return DetailCollectionViewCell()
        }
        
        guard let images = product?.images else {
            return DetailCollectionViewCell()
        }
        
        cell.imageView.requestImageDownload(url: images[indexPath.row].url)
        cell.pageLabel.text = String(indexPath.row + 1)
        
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let images = product?.images else {
            return .zero
        }
        return images.count
    }
    
    private func defineCollectionViewDelegate() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}

