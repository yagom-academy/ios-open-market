//
//  MainViewController.swift
//  OpenMarket
//
//  Created by 웡빙, 보리사랑 on 2022/07/14.
//
import UIKit

class MainViewController: UIViewController {
    // MARK: - Instance Properties
    private let manager = NetworkManager()
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, Product>?
    
    enum Section {
        case main
    }
    
    // MARK: - UI Properties
    private var shouldHideListLayout: Bool? {
        didSet {
            guard let shouldHideListLayout = shouldHideListLayout else { return }
            print("DID TAPPED SEGMENT CONTROLLER")
        }
    }
    
    private let segmentController: UISegmentedControl = {
        let segmentController = UISegmentedControl(items: ["Table", "Grid"])
        segmentController.translatesAutoresizingMaskIntoConstraints = true
        segmentController.selectedSegmentIndex = 0
        return segmentController
    }()
    
    private var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        addUIComponents()
        setupSegment()
        configureHierarchy()
        configureDataSource()
    }
    
    private func addUIComponents() {
        self.navigationItem.titleView = segmentController
    }
    
    @objc private func didChangeValue(segment: UISegmentedControl) {
        self.shouldHideListLayout = segment.selectedSegmentIndex != 0
    }
    
    private func setupSegment() {
        didChangeValue(segment: self.segmentController)
        self.segmentController.addTarget(self, action: #selector(didChangeValue(segment:)), for: .valueChanged)
    }
}
// MARK: - Modern Collection View List Style
extension MainViewController {
    private func createLayout() -> UICollectionViewLayout {
        let config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        return UICollectionViewCompositionalLayout.list(using: config)
    }
}

extension MainViewController {
    private func configureHierarchy(){
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(collectionView)
        collectionView.delegate = self
    }
    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Product> { (cell, indexPath, product) in
            var content = cell.defaultContentConfiguration()
            guard let url = URL(string: product.thumbnail) else {
                return
            }
            do {
                content.image = UIImage(data: try Data(contentsOf: url))
                content.text = product.name
                content.secondaryText = String(product.price)
                cell.contentConfiguration = content
            } catch {
                print("ASDASD")
            }
        }
        dataSource = UICollectionViewDiffableDataSource<Section, Product>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: Product) -> UICollectionViewCell? in
            
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
        }
        
        // initial data
        manager.dataTask { [weak self] productList in
            var snapshot = NSDiffableDataSourceSnapshot<Section, Product>()
            snapshot.appendSections([.main])
            snapshot.appendItems(productList)
            self?.dataSource?.apply(snapshot, animatingDifferences: false)
        }
    }
}

extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}
