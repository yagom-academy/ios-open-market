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
            if shouldHideListLayout {
                self.view.subviews.forEach { $0.removeFromSuperview() }
                self.view.addSubview(collectionView)
                configureGridDataSource()
                fetchData()
                collectionView.setCollectionViewLayout(createGridLayout(), animated: false)
            } else {
                self.view.subviews.forEach { $0.removeFromSuperview() }
                self.view.addSubview(collectionView)
                configureListDataSource()
                fetchData()
                collectionView.setCollectionViewLayout(createListLayout(), animated: false)
            }
        }
    }
    
    private let segmentController: UISegmentedControl = {
        let segmentController = UISegmentedControl(items: ["List", "Grid"])
        segmentController.translatesAutoresizingMaskIntoConstraints = true
        segmentController.selectedSegmentIndex = 0
        segmentController.tintColor = .systemBlue
        segmentController.backgroundColor = .systemBlue
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
        configureListDataSource()
        fetchData()
    }
    
    func fetchData() {
        manager.dataTask { [weak self] productList in
            var snapshot = NSDiffableDataSourceSnapshot<Section, Product>()
            snapshot.appendSections([.main])
            snapshot.appendItems(productList)
            self?.dataSource?.apply(snapshot, animatingDifferences: false)
        }
    }
    
    private func addUIComponents() {
        self.navigationItem.titleView = segmentController
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonDidTapped))
    }
    
    @objc private func didChangeValue(segment: UISegmentedControl) {
        self.shouldHideListLayout = segment.selectedSegmentIndex != 0
    }
    
    @objc private func addButtonDidTapped() {
    }
    
    private func setupSegment() {
        didChangeValue(segment: self.segmentController)
        self.segmentController.addTarget(self, action: #selector(didChangeValue(segment:)), for: .valueChanged)
    }
}
// MARK: - Modern Collection View List Style
extension MainViewController {
    
//    private func createListLayout() -> UICollectionViewLayout {
//        let config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
//        return UICollectionViewCompositionalLayout.list(using: config)
//    }
    
    private func createListLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                             heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .absolute(70))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)

        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    private func createGridLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                             heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .absolute(250))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        let spacing = CGFloat(10)
        group.interItemSpacing = .fixed(spacing)

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = spacing
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)

        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}

extension MainViewController {
    private func configureHierarchy(){
        collectionView.frame = view.bounds
        collectionView.setCollectionViewLayout(createListLayout(), animated: false)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(collectionView)
        collectionView.delegate = self
    }
    
    private func configureListDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<ListCell, Product> { (cell, indexPath, product) in
            cell.setupCellData(with: product)
        }
        dataSource = UICollectionViewDiffableDataSource<Section, Product>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: Product) -> UICollectionViewCell? in
            
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
        }
    }
    
    private func configureGridDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<GridCell, Product> { (cell, indexPath, product) in
            cell.setupCellData(with: product)
        }
        dataSource = UICollectionViewDiffableDataSource<Section, Product>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: Product) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
        }
    }
}

extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}
