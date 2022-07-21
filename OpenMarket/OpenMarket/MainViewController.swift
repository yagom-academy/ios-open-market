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
    private var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    private var listDataSource: UICollectionViewDiffableDataSource<Section, Product>?
    private var gridDataSource: UICollectionViewDiffableDataSource<Section, Product>?
    private var listLayout: UICollectionViewLayout? = nil
    private var gridLayout: UICollectionViewLayout? = nil
    
    enum Section {
        case main
    }
    
    private var shouldHideListLayout: Bool? {
        didSet {
            guard let shouldHideListLayout = shouldHideListLayout else { return }
            print("DID TAPPED SEGMENT CONTROLLER")
            if shouldHideListLayout {
                guard let gridLayout = gridLayout else {
                    return
                }
                collectionView.dataSource = gridDataSource
                collectionView.setCollectionViewLayout(gridLayout, animated: true)
            } else {
                
                guard let listLayout = listLayout else {
                    return
                }
                collectionView.dataSource = listDataSource
                collectionView.setCollectionViewLayout(listLayout, animated: true)
            }
        }
    }
    // MARK: - UI Properties
    private let segmentController: UISegmentedControl = {
        let segmentController = UISegmentedControl(items: ["List", "Grid"])
        segmentController.translatesAutoresizingMaskIntoConstraints = false
        segmentController.selectedSegmentIndex = 0
        segmentController.tintColor = .systemBlue
        segmentController.backgroundColor = .systemBlue
        return segmentController
    }()
    
    private lazy var activitiIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        activityIndicator.center = self.view.center
        activityIndicator.color = UIColor.red
        
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.medium
        
        activityIndicator.stopAnimating()
        return activityIndicator
    }()
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeViewController()
        self.listLayout = createListLayout()
        self.gridLayout = createGridLayout()
        addUIComponents()
        setupSegment()
        configureListDataSource()
        configureGridDataSource()
        configureHierarchy()
        fetchData()
    }
    // MARK: - Main View Controller Method
    private func initializeViewController() {
        DispatchQueue.main.async {
            self.collectionView.alpha = 0
            self.activitiIndicator.startAnimating()
        }
        self.view.backgroundColor = .systemBackground
        activitiIndicator.startAnimating()
    }
    
    private func addUIComponents() {
        self.navigationItem.titleView = segmentController
        self.view.addSubview(activitiIndicator)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonDidTapped))
    }
    
    @objc private func addButtonDidTapped() {
        print("add button tapped")
    }
    
    private func setupSegment() {
        didChangeValue(segment: self.segmentController)
        self.segmentController.addTarget(self, action: #selector(didChangeValue(segment:)), for: .valueChanged)
    }
    
    @objc private func didChangeValue(segment: UISegmentedControl) {
        self.shouldHideListLayout = segment.selectedSegmentIndex != 0
    }
    
    private func fetchData() {
        manager.dataTask { [weak self] productList in
            var snapshot = NSDiffableDataSourceSnapshot<Section, Product>()
            snapshot.appendSections([.main])
            snapshot.appendItems(productList)
            self?.gridDataSource?.apply(snapshot, animatingDifferences: false)
            self?.listDataSource?.apply(snapshot, animatingDifferences: false)
            DispatchQueue.main.async {
                self?.activitiIndicator.stopAnimating()
                self?.collectionView.alpha = 1
            }
        }
    }
}
// MARK: - Modern Collection Create Layout
extension MainViewController {
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
// MARK: - Modern Collection VIew Configure Datasource
extension MainViewController {
    private func configureListDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<ListCell, Product> { (cell, indexPath, product) in
            cell.setup(with: product)
        }
        listDataSource = UICollectionViewDiffableDataSource<Section, Product>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: Product) -> UICollectionViewCell? in
            
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
        }
    }
    
    private func configureGridDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<GridCell, Product> { (cell, indexPath, product) in
            cell.setup(with: product)
        }
        gridDataSource = UICollectionViewDiffableDataSource<Section, Product>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: Product) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
        }
    }
    
    private func configureHierarchy(){
        collectionView.frame = view.bounds
        guard let listLayout = listLayout else {
            return
        }
        collectionView.setCollectionViewLayout(listLayout, animated: true)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(collectionView)
        collectionView.dataSource = listDataSource
        collectionView.delegate = self
    }
}
// MARK: - Modern Collection View Delegate
extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}
