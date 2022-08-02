//
//  ProductDetailViewController.swift
//  OpenMarket
//
//  Created by 데릭, 수꿍.
//

import UIKit

final class ProductDetailViewController: UIViewController {
    // MARK: - Properties
    
    var productID: Int = 0
    
    private var productDetailsAPIManager: ProductDetailsAPIManager?
    
    private var productDetailViewModel: ProductDetailsViewModel?
    private var productDetailImagesdataSource: UICollectionViewDiffableDataSource<Section, UIImage>?
    private var productDetailImagesCollectionView: UICollectionView?
    
    private let rootScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        return scrollView
    }()
    
    private let rootStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 10
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.axis = .vertical
        
        return stackView
    }()
    
    private let productInfoLabelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 0
        stackView.alignment = .firstBaseline
        
        return stackView
    }()
    
    private let productNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .headline)
    
        label.text = "MacBook Pro"
        label.adjustsFontForContentSizeCategory = true

        return label
    }()
    
    private let productPriceAndStockStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 0
        stackView.alignment = .fill
        
        return stackView
    }()
    
    private let stockLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        label.textColor = .systemGray
        label.adjustsFontForContentSizeCategory = true

        return label
    }()
    
    private let originalPriceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        label.font = UIFont.preferredFont(forTextStyle: .caption2)
        label.adjustsFontForContentSizeCategory = true

        return label
    }()
    
    private let discountedPriceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        label.font = UIFont.preferredFont(forTextStyle: .caption2)
        label.adjustsFontForContentSizeCategory = true

        return label
    }()
    
    private let productDescriptionTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.textColor = .lightGray
        textView.font = UIFont.preferredFont(forTextStyle: .caption1)
        
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        configureRootScrollView()
        configureRootStackView()
        configureCollectionViewHierarchy()
        configureViewModel()
        configureDataSource()
        
        fetchProductDetails(by: productID)
    }
    
    private func configureRootScrollView() {
        view.addSubview(rootScrollView)
        rootScrollView.addSubview(rootStackView)
        
        let heightAnchor = rootScrollView.heightAnchor.constraint(equalTo: rootScrollView.heightAnchor)
        heightAnchor.priority = .defaultHigh
        heightAnchor.isActive = true
        
        NSLayoutConstraint.activate([
            rootScrollView.topAnchor.constraint(equalTo: view.topAnchor),
            rootScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            rootScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            rootScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func configureRootStackView() {
        NSLayoutConstraint.activate([
            rootStackView.topAnchor.constraint(equalTo: rootScrollView.topAnchor),
            rootStackView.leadingAnchor.constraint(equalTo: rootScrollView.leadingAnchor),
            rootStackView.trailingAnchor.constraint(equalTo: rootScrollView.trailingAnchor),
            rootStackView.bottomAnchor.constraint(equalTo: rootScrollView.bottomAnchor),
            
            rootStackView.widthAnchor.constraint(equalTo: rootScrollView.widthAnchor),
        ])
    }
    
    private func configureCollectionViewHierarchy() {
        productDetailImagesCollectionView = UICollectionView(frame: .zero,
                                                             collectionViewLayout: configureCollectionViewLayout())
        
        guard let productDetailImagesCollectionView = productDetailImagesCollectionView else {
            return
        }
        
        productDetailImagesCollectionView.translatesAutoresizingMaskIntoConstraints = false

        rootStackView.addArrangedSubview(productDetailImagesCollectionView)
        rootStackView.addArrangedSubview(productInfoLabelStackView)
        rootStackView.addArrangedSubview(productDescriptionTextView)

        productDetailImagesCollectionView.heightAnchor.constraint(equalToConstant: view.layer.bounds.height * 0.35).isActive = true
        
        productInfoLabelStackView.addArrangedSubview(productNameLabel)
        productInfoLabelStackView.addArrangedSubview(productPriceAndStockStackView)

        productPriceAndStockStackView.addArrangedSubview(stockLabel)
        productPriceAndStockStackView.addArrangedSubview(originalPriceLabel)
        productPriceAndStockStackView.addArrangedSubview(discountedPriceLabel)
    }
    
    private func fetchProductDetails(by productID: Int) {
        productDetailsAPIManager = ProductDetailsAPIManager(productID: productID.description)
        
        productDetailsAPIManager?.requestAndDecodeProduct(dataType: ProductDetail.self) { [weak self] result in
            switch result {
            case .success(let data):
                self?.productDetailViewModel?.format(productDetail: data)
            case .failure(_):
                break
            }
        }
    }
    
    private func configureViewModel() {
        productDetailViewModel = ProductDetailsViewModel()
        productDetailViewModel?.delegate = self
        productDetailImagesCollectionView?.delegate = self
    }
    
    private func configureCollectionViewLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalWidth(0.8))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitem: item,
                                                       count: 1)
        
        group.contentInsets = NSDirectionalEdgeInsets(top: 10,
                                                      leading: 10,
                                                      bottom: 10,
                                                      trailing: 10)
        
        group.interItemSpacing = NSCollectionLayoutSpacing.fixed(0)
        
        let section = NSCollectionLayoutSection(group: group)
        
        section.orthogonalScrollingBehavior = .groupPaging
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<ProductDetailsCollectionViewCell, UIImage> { [weak self] (cell, indexPath, item) in
            
            guard let totalImageNumber = self?.productDetailViewModel?.numberOfImages else {
                return
            }
            
            cell.configureUI(data: item,
                             currentImageNumber: indexPath.row + 1,
                             totalImageNumber: totalImageNumber)
        }
        
        guard let productDetailImagesCollectionView = productDetailImagesCollectionView else {
            return
        }

        
        productDetailImagesdataSource = UICollectionViewDiffableDataSource<Section, UIImage>(collectionView: productDetailImagesCollectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, item: UIImage) -> UICollectionViewCell? in
            
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration,
                                                                for: indexPath,
                                                                item: item)
        }
    }
    
    private func updateUI(_ data: [UIImage]) {
        DispatchQueue.main.async { [weak self] in
            if let unwrappedDataSource = self?.productDetailImagesdataSource {
                
                self?.applySnapShot(to: unwrappedDataSource, by: data)
            }
        }
    }
    
    private func applySnapShot(to dataSource: UICollectionViewDiffableDataSource<Section, UIImage>,
                               by data: [UIImage]) {
        var snapShot = NSDiffableDataSourceSnapshot<Section, UIImage>()
        snapShot.appendSections([.main])
        snapShot.appendItems(data)
        
        dataSource.apply(snapShot,
                         animatingDifferences: true,
                         completion: nil)
    }
}

extension ProductDetailViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

extension ProductDetailViewController: ProductDetailsViewDelegate {
    func productDetailsViewController(_ viewController: ProductDetailViewController.Type, didRecieve productInfo: ProductDetailsEntity) {
        updateUI(productInfo)
    }
    
    func productDetailsViewController(_ viewController: ProductDetailViewController.Type, didRecieve images: [UIImage]) {
        updateUI(images)
    }
}
