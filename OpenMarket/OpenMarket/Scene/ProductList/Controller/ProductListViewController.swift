//
//  OpenMarket - ProductListViewController.swift
//  Created by groot, bard.
//  Copyright © yagom. All rights reserved.
//

import UIKit

final class ProductListViewController: UIViewController {
    // MARK: - properties
    
    private var datableDelgate: DataSendable?
    private var loadingView: UIView?
    private var productsIDList = [String]()
    private lazy var gridCollectionView = GridCollecntionView(frame: .null,
                                                              collectionViewLayout: createGridLayout())
    
    private lazy var listCollectionView: ListCollectionView = {
        let layout  = createListLayout()
        let listCollectionView = ListCollectionView(frame: .zero,
                                                    collectionViewLayout: layout)
        
        return listCollectionView
    }()
    
    private let segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["List", "Grid"])
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        
        return segmentedControl
    }()
    
    // MARK: - life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupUI()
        setupRefreshControl()
        
        listCollectionView.delegate = self
        gridCollectionView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchData()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showSpinner(on: view)
    }
    
    //MARK: - View layout functions
    
    private func setupUI(){
        setupSubviews()
        setupNavigationController()
        setupSegmentedControl()
        setupViewConstraints()
    }
    
    private func setupSubviews() {
        view.addSubview(segmentedControl)
        view.addSubview(gridCollectionView)
        view.addSubview(listCollectionView)
    }
    
    private func setupNavigationController() {
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.topItem?.titleView = segmentedControl
        navigationController?.navigationBar.topItem?.rightBarButtonItem
        = UIBarButtonItem(image: UIImage(systemName: Design.plusButton),
                          style: .plain,
                          target: self,
                          action: #selector(productRegistrationButtonDidTap))
    }
    
    private func setupSegmentedControl() {
        segmentedControl.addTarget(self,
                                   action: #selector(segmentButtonDidTap(sender:)),
                                   for: .valueChanged)
        segmentedControl.selectedSegmentIndex = 0
        
    }
    
    private func setupViewConstraints() {
        NSLayoutConstraint.activate(
            [
                listCollectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
                listCollectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
                listCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                listCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
            ])
        
        NSLayoutConstraint.activate(
            [
                gridCollectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
                gridCollectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
                gridCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                gridCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            ])
    }
    
    // MARK: - functions
    
    private func fetchData() {
        let request = ProductGetRequest()
        
        let myURLSession = MyURLSession()
        myURLSession.dataTask(with: request) { (result: Result<Data, Error>) in
            switch result {
            case .success(let success):
                guard let decodedData = success.decodeData(type: ProductsList.self) else { return }
                
                self.productsIDList.removeAll()
                
                decodedData.pages
                    .forEach
                {
                    self.productsIDList.append($0.id.description)
                }
                
                decodedData.pages
                    .filter
                {
                    ImageCacheManager.shared.object(forKey: NSString(string: $0.thumbnail)) == nil
                }
                
                .forEach
                {
                    $0.pushThumbnailImageCache()
                }
                
                DispatchQueue.main.async { [weak self] in
                    self?.gridCollectionView.setSnapshot(productsList: decodedData.pages)
                    self?.listCollectionView.setSnapshot(productsList: decodedData.pages)
                    
                    guard let loadingView = self?.loadingView else { return }
                    
                    loadingView.isHidden = true
                }
            case .failure(let error):
                print(error.localizedDescription)
                break
            }
        }
    }
    
    private func setupRefreshControl() {
        listCollectionView.refreshControl = UIRefreshControl()
        gridCollectionView.refreshControl = UIRefreshControl()
        listCollectionView.refreshControl?.addTarget(self,
                                                     action: #selector(refresh),
                                                     for: .valueChanged)
        gridCollectionView.refreshControl?.addTarget(self,
                                                     action: #selector(refresh),
                                                     for: .valueChanged)
    }
    
    private func createListLayout() -> UICollectionViewCompositionalLayout {
        let layoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(Design.listLayoutFractionalWidth),
                                                heightDimension: .fractionalHeight(Design.listLayoutFractionalHeight))
        
        let item = NSCollectionLayoutItem(layoutSize: layoutSize)
        
        let groupsize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(Design.listGroupFractionlWidth),
                                               heightDimension: .fractionalHeight(Design.listGroupFractionlHeight))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupsize,
                                                       subitem: item,
                                                       count: Design.listGroupCount)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = Design.contentEdgeInsets
        section.interGroupSpacing = Design.listInterGroupSpacing
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
    private func createGridLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = Design.itemSize
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(Design.gridGroupFractionalWidth),
                                               heightDimension: .absolute(self.view.frame.height * Design.gridGroupFrameHeightRatio))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitem: item, count: Design.gridGroupCount)
        group.interItemSpacing = .fixed(Design.girdInterItemSpacing)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = CGFloat(Design.gridInterGroupSpacing)
        section.contentInsets = Design.contentEdgeInsets
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
    private func showSpinner(on view : UIView) {
        let spinnerView = UIView.init(frame: view.bounds)
        spinnerView.backgroundColor = .systemGray
        spinnerView.alpha = Design.spinnerViewAlpha
        
        let activityIndicatorView = UIActivityIndicatorView.init(style: .large)
        activityIndicatorView.startAnimating()
        activityIndicatorView.center = spinnerView.center
        
        spinnerView.addSubview(activityIndicatorView)
        view.addSubview(spinnerView)
        
        loadingView = spinnerView
    }
    
    // MARK: - @objc functions
    
    @objc private func segmentButtonDidTap(sender: UISegmentedControl) {
        guard let section = Section.init(rawValue: sender.selectedSegmentIndex) else { return }
        
        switch section {
        case .list:
            listCollectionView.isHidden = false
            gridCollectionView.isHidden = true
        case .grid:
            listCollectionView.isHidden = true
            gridCollectionView.isHidden = false
        }
    }
    
    @objc private func productRegistrationButtonDidTap() {
        navigationController?.pushViewController(ProductRegistrationViewController(),
                                                 animated: true)
    }
    
    @objc private func refresh() {
        listCollectionView.deleteSnapshot()
        gridCollectionView.deleteSnapshot()
        
        fetchData()
        
        listCollectionView.refreshControl?.endRefreshing()
        gridCollectionView.refreshControl?.endRefreshing()
    }
}

extension ProductListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let productDetailViewController = ProductDetailViewController()
        
        datableDelgate = productDetailViewController
        datableDelgate?.setupData(productsIDList[indexPath.row])
        
        navigationController?.pushViewController(productDetailViewController,
                                                 animated: true)
    }
}

// MARK: - Design

private enum Design {
    static let plusButton = "plus"
    static let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                 heightDimension: .fractionalHeight(1.0))
    static let spinnerViewAlpha = 0.5
    static let listLayoutFractionalWidth = 1.0
    static let listLayoutFractionalHeight = 1.0
    static let listGroupFractionlWidth = 1.0
    static let listGroupFractionlHeight = 0.08
    static let gridGroupFractionalWidth = 1.0
    static let gridGroupFrameHeightRatio = 0.3
    static let gridGroupCount = 2
    static let listGroupCount = 1
    static let girdInterItemSpacing = 20.0
    static let gridInterGroupSpacing = 10
    static let listInterGroupSpacing = 4.0
    static let contentEdgeInsets = NSDirectionalEdgeInsets(top: 5.0,
                                                           leading: 5.0,
                                                           bottom: 5.0,
                                                           trailing: 5.0)
}
