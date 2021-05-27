//
//  MarketItemsViewController.swift
//  OpenMarket
//
//  Created by 윤재웅 on 2021/05/26.
//

import UIKit

@available(iOS 14.0, *)
class MarketItemsViewController: UIViewController {
//    @IBOutlet weak var collectionView: UICollectionView!
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, MarketItems.Infomation>!
    var snapshot: NSDiffableDataSourceSnapshot<Section, MarketItems.Infomation>!
    var segmentControl: UISegmentedControl!
    var dataItems: [MarketItems.Infomation]? {
        didSet {
            DispatchQueue.main.async {
                self.setCollectionView()
                self.registrateCell()
                self.setSnapshot()
            }
        }
    }
    
    enum Section {
        case marketItems
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        segmentedControllerinNevigationItme()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchItem() {}
    }
    
    private func setCollectionView() {
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
    }
    
    private func registrateCell() {
        let cellRegistration = UICollectionView.CellRegistration<ItemListCell, MarketItems.Infomation> { (cell, indexPath, item) in

            cell.item = item
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, MarketItems.Infomation>(collectionView: collectionView) { (collectionView: UICollectionView, indexPath: IndexPath, identifier: MarketItems.Infomation) -> UICollectionViewCell in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
            cell.accessories = [.disclosureIndicator()]
            return cell
        }
    }
    
    private func setSnapshot() {
        guard let data = dataItems else { return }
        snapshot = NSDiffableDataSourceSnapshot<Section, MarketItems.Infomation>()
        snapshot.appendSections([.marketItems])
        snapshot.appendItems(data, toSection: .marketItems)
        
        dataSource.apply(snapshot, animatingDifferences: false)
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
        print("\(segmentControl.selectedSegmentIndex)")
        
        switch segmentControl.selectedSegmentIndex {
        case 0:
            // list
            self.view.backgroundColor = .cyan
        case 1:
            // grid
            self.view.backgroundColor = .green
        default:
            return
        }
    }
    
    private func fetchItem(completion: @escaping () -> ()) {
        guard let url = MarketAPI.items(page: 1).url else { return }
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
