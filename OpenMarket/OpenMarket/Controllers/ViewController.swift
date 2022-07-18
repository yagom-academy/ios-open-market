import UIKit

class ViewController: UIViewController {
    var segmentControl: UISegmentedControl?
    var collectionView: UICollectionView?
    var dataSource: UICollectionViewDiffableDataSource<Section, Int>?
    
    var productImages: [UIImage] = []
    var Products: Products? {
        didSet {
            Products?.pages.forEach {
                guard let imageUrl = URL(string: $0.thumbnail),
                      let imageData = try? Data(contentsOf: imageUrl),
                      let image = UIImage(data: imageData) else { return }
                
                productImages.append(image)
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let productsDataManager = ProductsDataManager()
        productsDataManager.getData(pageNumber: 1, itemsPerPage: 50) { (result: Products) in
            self.Products = result
            
            DispatchQueue.main.async {
                self.collectionView?.reloadData()                
            }
        }
        
        configureHierarchy()
        configureDataSoure()
        configureSegmentControl()
        
        setupCollectionViewLayout()
    }
        
    private func setupCollectionViewLayout() {
        let flowLayout = UICollectionViewFlowLayout()

        let width = self.view.frame.width
        let height = self.view.frame.height

        flowLayout.minimumLineSpacing = 2
        flowLayout.estimatedItemSize = CGSize(width: width, height: height * 0.08)

        collectionView?.collectionViewLayout = flowLayout
//        collectionView?.backgroundColor = .systemGray
    }
}

extension ViewController {
    private func configureSegmentControl() {
        segmentControl = UISegmentedControl(items: Titles.toString)
        segmentControl?.selectedSegmentIndex = Titles.LIST.rawValue
        segmentControl?.addTarget(self, action: #selector(changeLayout), for: .valueChanged)
        navigationItem.titleView = segmentControl
    }
}

extension ViewController {
    private func createGridLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.31))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        group.interItemSpacing = .fixed(10)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 10
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    private func createListLayout() -> UICollectionViewLayout {
        let config = UICollectionLayoutListConfiguration(appearance: .plain)
        return UICollectionViewCompositionalLayout.list(using: config)
    }
}

extension ViewController {
    private func configureHierarchy() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createListLayout())
        collectionView?.backgroundColor = .white
        collectionView?.delegate = self
        
        guard let collectionView = collectionView else { return }
        
        view.addSubview(collectionView)
    }
    
    private func configureDataSoure() {
        let cellRegistration = UICollectionView.CellRegistration<ItemCollectionViewCell, Int> { (cell, indexPath, identifier) in
            cell.backgroundColor = .systemBackground
        }
        
        guard let collectionView = collectionView else { return }
        
        dataSource = UICollectionViewDiffableDataSource<Section, Int>(collectionView: collectionView) { (collectionView, indexPath, identifier) -> UICollectionViewCell? in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
            cell.product = self.Products?.pages[indexPath.row]
            cell.currentSeguement = Titles(rawValue: self.segmentControl!.selectedSegmentIndex)
            switch cell.currentSeguement {
            case .LIST:
                cell.stackView.axis = .horizontal
                cell.accessories = [
                    .disclosureIndicator()
                ]
                cell.priceStackView.axis = .horizontal
                //                self.itemImageViewLayoutConstraint?.constant = -(self.multiplieToConstant ?? 0.0)
                cell.itemNameAndPriceStackView.alignment = .leading
                cell.layer.borderWidth = 0
                cell.layer.borderColor = nil
                cell.layer.cornerRadius = 0
                cell.clipsToBounds = false
                cell.stackView.isLayoutMarginsRelativeArrangement = false
                cell.layoutIfNeeded()
                
            case .GRID:
                
                cell.stackView.axis = .vertical
                cell.accessories = [
                    .delete()
                ]
                cell.priceStackView.axis = .vertical
                //                self.itemImageViewLayoutConstraint?.constant = 0
                cell.itemNameAndPriceStackView.alignment = .fill
                cell.layer.borderWidth = 1
                cell.layer.borderColor = UIColor.systemGray.cgColor
                cell.layer.cornerRadius = 20
                cell.clipsToBounds = true
                cell.layoutIfNeeded()
                cell.stackView.isLayoutMarginsRelativeArrangement = true
                
            case .none:
                break
            }
            if self.productImages.count > 0 {
                cell.itemImageView.image = self.productImages[indexPath.row]
            }

            return cell
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Int>()
        snapshot.appendSections([.main])
        snapshot.appendItems(Array(0...49))
        dataSource?.apply(snapshot, animatingDifferences: false)
    }
    
}

extension ViewController {
    @objc private func changeLayout() {
        if segmentControl?.selectedSegmentIndex == Titles.LIST.rawValue {
            self.collectionView?.setCollectionViewLayout(createListLayout(), animated: true)
            setupCollectionViewLayout()
            collectionView?.visibleCells.forEach{ cell in
                guard let cell = cell as? ItemCollectionViewCell else { return }
                cell.setAxis(segment: .LIST)
            }
        } else if segmentControl?.selectedSegmentIndex == Titles.GRID.rawValue {
            self.collectionView?.setCollectionViewLayout(createGridLayout(), animated: true)
            collectionView?.visibleCells.forEach{ cell in
                guard let cell = cell as? ItemCollectionViewCell else { return }
                cell.setAxis(segment: .GRID)
            }
        }
    }
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath)
    }
}
