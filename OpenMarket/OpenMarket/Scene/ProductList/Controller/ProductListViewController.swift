//
//  OpenMarket - ProductListViewController.swift
//  Created by groot, bard. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class ProductListViewController: UIViewController {
    // MARK: - properties
    
    private var loadingView: UIView?
    private lazy var listCollectionView: ListCollectionView = {
        let layout  = createListLayout()
        let listCollectionView = ListCollectionView(frame: .zero,
                                                    collectionViewLayout: layout)
        
        return listCollectionView
    }()
    
    private lazy var gridCollectionView = GridCollecntionView(frame: .null,
                                                              collectionViewLayout: createGridLayout())
    
    private let segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["List", "Grid"])
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        
        return segmentedControl
    }()
    
    // MARK: - life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        self.setupUI()
        self.setupRefreshControl()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        fetchData()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        self.showSpinner(on: self.view)
    }
    
    //MARK: - View layout functions
    
    private func setupUI(){
        self.setupSubviews()
        self.setupNavigationController()
        self.setupSegmentedControl()
        self.setupListViewConstraints()
        self.setupGridViewConstraints()
    }
    
    private func setupSubviews() {
        self.view.addSubview(self.segmentedControl)
        self.view.addSubview(self.gridCollectionView)
        self.view.addSubview(self.listCollectionView)
    }
    
    private func setupNavigationController() {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.topItem?.titleView = segmentedControl
        self.navigationController?.navigationBar.topItem?.rightBarButtonItem
        = UIBarButtonItem(image: UIImage(systemName: Design.plusButton),
                          style: .plain,
                          target: self,
                          action: #selector(productRegistrationButtonDidTap))
    }
    
    private func setupSegmentedControl() {
        self.segmentedControl.addTarget(self,
                                        action: #selector(segmentButtonDidTap(sender:)),
                                        for: .valueChanged)
        self.segmentedControl.selectedSegmentIndex = 0
        
    }
    
    private func setupListViewConstraints() {
        NSLayoutConstraint.activate([
            self.listCollectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.listCollectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.listCollectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.listCollectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
        ])
    }
    
    private func setupGridViewConstraints() {
        NSLayoutConstraint.activate([
            self.gridCollectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.gridCollectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.gridCollectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.gridCollectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
        ])
    }
    
    // MARK: - functions

    func fetchData() {
        let request = OpenMarketGetRequest()
        
        let myURLSession = MyURLSession()
        myURLSession.dataTask(with: request) { (result: Result<Data, Error>) in
            switch result {
            case .success(let success):
                guard let decodedData = success.decodeImageData() else { return }
                decodedData.pages
                    .filter { ImageCacheManager.shared.object(forKey: NSString(string: $0.thumbnail)) == nil }
                    .forEach { $0.pushThumbnailImageCache() }
                
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
                                                     action: #selector(self.refresh),
                                                     for: .valueChanged)
        gridCollectionView.refreshControl?.addTarget(self,
                                                     action: #selector(self.refresh),
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
        self.navigationController?.pushViewController(ProductRegistrationViewController(),
                                                      animated: true)
    }
    
    @objc private func refresh() {
        self.listCollectionView.deleteSnapshot()
        self.gridCollectionView.deleteSnapshot()
        fetchData()
        self.listCollectionView.refreshControl?.endRefreshing()
        self.gridCollectionView.refreshControl?.endRefreshing()
    }
}

extension Data {
    func decodeImageData() -> ProductsDetailList? {
        let jsonDecoder = JSONDecoder()
        var data: ProductsDetailList?
        
        data = try? jsonDecoder.decode(ProductsDetailList.self, from: self)
        return data
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
