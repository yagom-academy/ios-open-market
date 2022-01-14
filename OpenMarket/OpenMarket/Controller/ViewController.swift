import UIKit

class ViewController: UIViewController {

    enum Section {
        case main
    }

    var collectionView: UICollectionView! = nil
    var dataSource: UICollectionViewDiffableDataSource<Section, Product>!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureDataSource()
    }
}

extension ViewController {
    private func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.5),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(270)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)

        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }

    private func configureHierarchy() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .white
        view.addSubview(collectionView)
    }
}

extension ViewController {
    private func configureDataSource() {
        let cellRegistration =
        UICollectionView.CellRegistration<GridCell, Product> { cell, indexPath, identifier in
            guard let url = URL(string: identifier.thumbnail) else {
                return
            }
            guard let imageData = try? Data(contentsOf: url) else {
                return
            }
            cell.thumbnailImageView.image = UIImage(data: imageData)
            cell.nameLabel.text = identifier.name
            if identifier.discountedPrice != .zero {
                let formattedPrice = identifier.price.format()
                let priceAttributedString =
                    "\(identifier.currency) \(formattedPrice)".eraseOriginalPrice()
                cell.priceLabel.attributedText = priceAttributedString
            } else {
                cell.priceLabel.isHidden = true
            }
            let formattedBargainPrice = identifier.bargainPrice.format()
            cell.bargainPriceLabel.text = "\(identifier.currency) \(formattedBargainPrice)"
            if identifier.stock == .zero {
                cell.stockLabel.text = "품절"
                cell.stockLabel.textColor = .systemOrange
            } else {
                let formattedStock = identifier.bargainPrice.format()
                cell.stockLabel.text = "잔여수량 : \(formattedStock)"
                cell.stockLabel.textColor = .systemGray
            }
        }

        dataSource = UICollectionViewDiffableDataSource<Section, Product>(
            collectionView: collectionView
        ) { (collectionView: UICollectionView, indexPath: IndexPath, identifier: Product
        ) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(
                using: cellRegistration,
                for: indexPath,
                item: identifier
            )
        }

        generateProductItems()
    }

    private func generateProductItems() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Product>()

        snapshot.appendSections([.main])
        ProductService().retrieveProductList(
            pageNumber: 1,
            itemsPerPage: 20,
            session: HTTPUtility.defaultSession
        ) { result in
            switch result {
            case .success(let productList):
                let products = productList.pages
                snapshot.appendItems(products)
                DispatchQueue.main.async {
                    self.dataSource.apply(snapshot)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
