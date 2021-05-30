//
//  MarketItemsViewController.swift
//  OpenMarket
//
//  Created by 윤재웅 on 2021/05/26.
//

import UIKit

@available(iOS 14.0, *)
class MarketItemsViewController: UIViewController {
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, MarketItems.Infomation>!
    var snapshot = NSDiffableDataSourceSnapshot<Section, MarketItems.Infomation>()
    var segmentControl: UISegmentedControl!
    var currentCell = 0
    var MarketItemPage = 1 {
        willSet {
            fetchItem(newValue) {
                if self.dataItems == nil {
                    return
                }
                DispatchQueue.main.async {
                    if self.segmentControl.numberOfSegments == 0 {
                        self.snapshot.appendItems(self.dataItems!)
                        self.dataSource.apply(self.snapshot, animatingDifferences: true)
                    } else {
                        self.snapshot.appendItems(self.dataItems!)
                        self.dataSource.apply(self.snapshot, animatingDifferences: true)
                    }
                }
            }
        }
    }
    var dataItems: [MarketItems.Infomation]?
    
    enum Section {
        case marketItemsList
        case marketItmesGrid
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        segmentedControllerinNevigationItme()
        setCollectionViewList()
        self.collectionView.delegate = self
        self.collectionView.backgroundColor = .clear
    }
    
    private func setCollectionViewList() {
        let layoutConfig = UICollectionLayoutListConfiguration(appearance: .plain)
        let listLayout = UICollectionViewCompositionalLayout.list(using: layoutConfig)
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: listLayout)
        view.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 0.0),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0.0),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0.0),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0.0),
        ])
        
        collectionView.showsVerticalScrollIndicator = false
    }
    
    private func setCollectionViewGrid() {
        let layout = UICollectionViewCompositionalLayout { (secionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection in
            let columns = 2
            let spacing = CGFloat(5)
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(self.view.bounds.width-10), heightDimension: .absolute(self.view.bounds.height/4))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: columns)
            group.interItemSpacing = .fixed(spacing)
            
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = spacing
            section.contentInsets = NSDirectionalEdgeInsets(top: spacing, leading: spacing, bottom: spacing, trailing: 0)
            
            return section
        }
        collectionView.collectionViewLayout = layout
    }
    
    private func registrateListCell() {
        let cellRegistration = UICollectionView.CellRegistration<ItemListCell, MarketItems.Infomation> { (cell, indexPath, item) in
            cell.item = item
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, MarketItems.Infomation>(collectionView: collectionView) { (collectionView: UICollectionView, indexPath: IndexPath, identifier: MarketItems.Infomation) -> UICollectionViewCell in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
            cell.accessories = [.disclosureIndicator()]
            
            return cell
        }
    }
    
    private func registrateGridCell() {
        let cellRegistration = UICollectionView.CellRegistration<ItemsGridCell, MarketItems.Infomation> { (cell, indexPath, item) in
            cell.item = item
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, MarketItems.Infomation>(collectionView: collectionView) { (collectionView: UICollectionView, indexPath: IndexPath, identifier: MarketItems.Infomation) -> UICollectionViewCell in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
            print(indexPath.row)
            if indexPath.row == 17 {
                self.MarketItemPage += 1
            }
            return cell
        }
    }
    
    private func setSnapshotList() {
        guard let data = dataItems else { return }
        snapshot = NSDiffableDataSourceSnapshot<Section, MarketItems.Infomation>()
        snapshot.appendSections([.marketItemsList])
        snapshot.appendItems(data, toSection: .marketItemsList)
        
        self.dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func setSnapshotGrid() {
        guard let data = dataItems else { return }
        snapshot = NSDiffableDataSourceSnapshot<Section, MarketItems.Infomation>()
        snapshot.appendSections([.marketItmesGrid])
        snapshot.appendItems(data, toSection: .marketItmesGrid)
        
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    func segmentedControllerinNevigationItme() {
        let title = ["List", "Grid"]
        segmentControl = UISegmentedControl(items: title)
        segmentControl.tintColor = UIColor.white
        segmentControl.backgroundColor = UIColor.orange
        segmentControl.selectedSegmentIndex = 0
        for index in 0...title.count - 1 {
            segmentControl.setWidth(100, forSegmentAt: index)
        }
        
        segmentControl.sizeToFit()
        segmentControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
        segmentControl.selectedSegmentIndex = 0
        segmentControl.sendActions(for: .valueChanged)
        
        navigationItem.titleView = segmentControl
    }
    
    @objc func segmentChanged() {
        switch segmentControl.selectedSegmentIndex {
        case 0:
            // list
            indicator.startAnimating()
            fetchItem(1) {
                self.MarketItemPage = 1
                let layoutConfig = UICollectionLayoutListConfiguration(appearance: .plain)
                let listLayout = UICollectionViewCompositionalLayout.list(using: layoutConfig)
                DispatchQueue.main.async {
                    self.collectionView.collectionViewLayout = listLayout
                    self.registrateListCell()
                    self.setSnapshotList()
                    self.indicator.stopAnimating()
                    self.indicator.isHidden = true
                }
            }
        case 1:
            // grid
            indicator.startAnimating()
            fetchItem(1) {
                self.MarketItemPage = 1
                DispatchQueue.main.async {
                    self.setCollectionViewGrid()
                    self.registrateGridCell()
                    self.setSnapshotGrid()
                    self.indicator.stopAnimating()
                    self.indicator.isHidden = true
                }
            }
        default:
            return
        }
    }
    
    private func fetchItem(_ page: Int, completion: @escaping () -> ()) {
        guard let url = MarketAPI.items(page: page).url else { return }
        let request = URLRequest(url: url)
        let itemData = MarketNetworkManager(loader: Networkloader(), decoder: JSONDecoder())

        itemData.excute(request: request, decodeType: MarketItems.self) { (result: Result<MarketItems, Error>) in
            switch result {
            case .success(let data):
                self.dataItems = data.items
                completion()
            case .failure(_):
                // TODO: 디코드 실패시 오류 처리
                fatalError()
            }
        }
    }
}

@available(iOS 14.0, *)
extension MarketItemsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        print(indexPath.row)
        if indexPath.row == self.snapshot.numberOfItems - 8 {
            self.MarketItemPage += 1
        }
    }
}
