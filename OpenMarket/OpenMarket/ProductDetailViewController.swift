//
//  ProductDetailViewController.swift
//  OpenMarket
//
//  Created by Gundy, Wonbi on 2022/12/07.
//

import UIKit

final class ProductDetailViewController: UIViewController {
    private let detailProduct: DetailProduct
    private let networkManager: NetworkManager
    private let detailView: DetailView = DetailView()
    private var dataSource: UICollectionViewDiffableDataSource<Int, Int>! = nil
    private var snapshot = NSDiffableDataSourceSnapshot<Int, Int>()
    private var images: [UIImage] = []
    
    init(_ detailProduct: DetailProduct, networkManager: NetworkManager) {
        self.detailProduct = detailProduct
        self.networkManager = networkManager
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        super.loadView()
        view = detailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        setupImages()
        configureNavigationBar()
        configureDetailView()
        configureCollectionView()
        configureDataSource()
    }
    
    private func configureNavigationBar() {
        navigationItem.title = detailProduct.name
        navigationItem.rightBarButtonItem = detailView.fetchNavigationBarButton()
    }
    
    private func configureDetailView() {
        detailView.configureImageNumberLabel(present: 1, total: detailProduct.images.count)
        detailView.configureNameLabel(from: detailProduct.name)
        detailView.configureStockLabel(from: setupStock())
        detailView.configurePriceLabel(from: setupPrice())
        detailView.configureDescriptionText(from: detailProduct.description)
    }
    
    private func setupStock() -> String {
        if detailProduct.stock.isZero {
            return "품절"
        } else if detailProduct.stock >= 1000 {
            let stock = FormatConverter.convertToDecimal(from: Double(detailProduct.stock / 1000))
            return "남은 수량 : \(stock.components(separatedBy: ".")[0])k"
        } else {
            return "남은 수량 : \(detailProduct.stock)"
        }
    }
    
    private func setupPrice() -> NSMutableAttributedString {
        let text: String
        let currency = detailProduct.currency.rawValue
        let price = FormatConverter.convertToDecimal(from: detailProduct.price)
        let bargainPrice = FormatConverter.convertToDecimal(from: detailProduct.bargainPrice)
        
        if detailProduct.discountedPrice.isZero {
            text = "\(currency) \(price)"
            let attributedString = NSMutableAttributedString(string: text)
            return attributedString
        } else {
            text = "\(currency) \(price)\n\(currency) \(bargainPrice)"
            let attributedString = NSMutableAttributedString(string: text)
            attributedString.addAttributes([.foregroundColor: UIColor.systemRed, .strikethroughStyle: 1],
                                           range: (text as NSString).range(of: "\(currency) \(price)"))
            attributedString.addAttributes([.foregroundColor: UIColor.black],
                                           range: (text as NSString).range(of: "\(currency) \(bargainPrice)"))
            return attributedString
        }
    }
    
    private func setupImages() {
        DispatchQueue.global().async {
            self.detailProduct.images.forEach { image in
                guard let url = URL(string: image.url),
                      let data = try? Data(contentsOf: url),
                      let image = UIImage(data: data)
                else {
                    return
                }
                self.images.append(image)
            }
            self.configureSnapshot()
        }
    }
}

extension ProductDetailViewController {
    private func createCollectionViewLayout() -> UICollectionViewLayout {
        let config = UICollectionViewCompositionalLayoutConfiguration()
        
        let layout = UICollectionViewCompositionalLayout(sectionProvider: {
            (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            let imageItem = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(1.0)
                )
            )
            imageItem.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)

            let containerGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalHeight(1.0),
                    heightDimension: .fractionalHeight(1.0)),
                subitems: [imageItem]
            )
            
            let section = NSCollectionLayoutSection(group: containerGroup)
            section.orthogonalScrollingBehavior = .groupPagingCentered
            
            section.visibleItemsInvalidationHandler = { (_, _, _) -> Void in
                guard let itemIndex = self.detailView.imageCollectionView.indexPathsForVisibleItems.first?.item
                else { return }
                self.detailView.configureImageNumberLabel(present: itemIndex + 1, total: self.images.count)
            }
            return section

        }, configuration: config)
        return layout
    }
    
    private func configureCollectionView() {
        detailView.imageCollectionView.collectionViewLayout = createCollectionViewLayout()
    }
    
    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<DetailImageCell, Int> { (cell, indexPath, _) in
            cell.configureImageView(with: self.images[indexPath.item])
        }
        
        dataSource = UICollectionViewDiffableDataSource<Int, Int>(collectionView: detailView.imageCollectionView) {(
            collectionView: UICollectionView,
            indexPath: IndexPath,
            identifier: Int) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration,
                                                                for: indexPath,
                                                                item: identifier)
        }
    }
    
    private func configureSnapshot() {
        let items = images.compactMap { images.firstIndex(of: $0) }

        snapshot.appendSections([0])
        snapshot.appendItems(items)
        
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}
