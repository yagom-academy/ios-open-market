//
//  OpenMarket - OpenMarketViewController.swift
//  Created by groot, bard. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class OpenMarketViewController: UIViewController {
    // MARK: - properties
    
    private var loadingView : UIView?
    private let listCollectionView: ListCollectionView = {
        let listConfiguration = UICollectionLayoutListConfiguration(appearance: .plain)
        let listLayout = UICollectionViewCompositionalLayout.list(using: listConfiguration)
        let listCollectionView = ListCollectionView(frame: .zero,
                                                    collectionViewLayout: listLayout)
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
        self.setUpUI()
        self.setUpRefreshControl()
        self.fetchData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.showSpinner(on: self.view)
    }
    
    //MARK: - View layout functions
    
    private func setUpUI(){
        self.setUpSubviews()
        self.setUpNavigationController()
        self.setUpSegmentedControl()
        self.setUpListViewConstraints()
        self.setUpGridViewConstraints()
    }
    
    private func setUpSubviews() {
        self.view.addSubview(self.segmentedControl)
        self.view.addSubview(self.gridCollectionView)
        self.view.addSubview(self.listCollectionView)
    }
    
    private func setUpNavigationController() {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.topItem?.titleView = segmentedControl
        self.navigationController?.navigationBar.topItem?.rightBarButtonItem
        = UIBarButtonItem(image: UIImage(systemName: Design.plusButton),
                          style: .plain,
                          target: self,
                          action: #selector(productRegistrationButtonDidTap))
    }
    
    private func setUpSegmentedControl() {
        self.segmentedControl.addTarget(self,
                                        action: #selector(segmentButtonDidTap(sender:)),
                                        for: .valueChanged)
        self.segmentedControl.selectedSegmentIndex = 0
        
    }
    
    private func setUpListViewConstraints() {
        NSLayoutConstraint.activate([
            self.listCollectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.listCollectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.listCollectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.listCollectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
        ])
    }
    
    private func setUpGridViewConstraints() {
        NSLayoutConstraint.activate([
            self.gridCollectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.gridCollectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.gridCollectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.gridCollectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
        ])
    }
    
    // MARK: - functions
    
    private func setUpRefreshControl() {
        listCollectionView.refreshControl = UIRefreshControl()
        gridCollectionView.refreshControl = UIRefreshControl()
        listCollectionView.refreshControl?.addTarget(self, action: #selector(self.refresh), for: .valueChanged)
        gridCollectionView.refreshControl?.addTarget(self, action: #selector(self.refresh), for: .valueChanged)
    }
    
    private func fetchData() {
        let productsRequest = OpenMarketRequest(path: URLAdditionalPath.product.value,
                                              method: .get,
                                              baseURL: URLHost.openMarket.url + URLAdditionalPath.product.value,
                                              query: [
                                                Product.page.text:  "\(Product.page.number)",
                                                Product.itemPerPage.text: "\(Product.itemPerPage.number)"
                                              ])
        let myURLSession = MyURLSession()
        myURLSession.dataTask(with: productsRequest) { [weak self]
            (result: Result<Data, Error>) in
            switch result {
            case .success(let success):
                guard let decoededData = success.decodeImageData() else { return }
                DispatchQueue.main.async {
                    decoededData.pages.forEach { $0.pushThumbnailImageCache() }
                    self?.gridCollectionView.setSnapshot(productsList: decoededData.pages)
                    self?.listCollectionView.setSnapshot(productsList: decoededData.pages)
                    guard let loadingView = self?.loadingView,
                          loadingView.isHidden == false
                    else { return }
                    self?.removeSpinner()
                }
            case .failure(let error):
                print(error.localizedDescription)
                break
            }
        }
    }
    
    private func createGridLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = Design.itemSize
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(Design.groupFractionalWidth),
                                               heightDimension: .absolute(self.view.frame.height * Design.groupFrameHeightRatio))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitem: item, count: Design.groupCount)
        group.interItemSpacing = .fixed(Design.interItemSpacing)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = CGFloat(Design.interGroupSpacing)
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
    
    private func removeSpinner() {
        self.loadingView?.isHidden = true
        self.loadingView = nil
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
        print("productRegistrationButtonDidTapped")
    }
    
    @objc private func refresh() {
        self.listCollectionView.deleteSnapshot()
        self.gridCollectionView.deleteSnapshot()
        self.fetchData()
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
    static let groupFractionalWidth = 1.0
    static let groupFrameHeightRatio = 0.3
    static let groupCount = 2
    static let interItemSpacing = 20.0
    static let interGroupSpacing = 10
    static let contentEdgeInsets = NSDirectionalEdgeInsets(top: 5.0,
                                                           leading: 5.0,
                                                           bottom: 5.0,
                                                           trailing: 5.0)
}

