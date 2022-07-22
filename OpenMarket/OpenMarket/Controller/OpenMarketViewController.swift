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
    
    lazy var gridCollectionView = GridCollecntionView(frame: .null,
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
        self.configureRefreshControl()
        self.fetchData()
        self.setUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.showSpinner(on: self.view)
    }
    
    //MARK: - View layout functions
    
    private func setUI(){
        self.setSubviews()
        self.setNavigationController()
        self.setSegmentedControl()
        self.setListViewConstraints()
        self.setGridViewConstraints()
    }
    
    private func setSubviews() {
        self.view.addSubview(self.segmentedControl)
        self.view.addSubview(self.gridCollectionView)
        self.view.addSubview(self.listCollectionView)
    }
    
    private func setNavigationController() {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.topItem?.titleView = segmentedControl
        self.navigationController?.navigationBar.topItem?.rightBarButtonItem
        = UIBarButtonItem(image: UIImage(systemName: Design.plusButton),
                          style: .plain,
                          target: self,
                          action: #selector(productRegistrationButtonDidTap))
    }
    
    private func setSegmentedControl() {
        self.segmentedControl.addTarget(self,
                                        action: #selector(segmentButtonDidTap(sender:)),
                                        for: .valueChanged)
        self.segmentedControl.selectedSegmentIndex = 0
        
    }
    
    private func setListViewConstraints() {
        NSLayoutConstraint.activate([
            self.listCollectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.listCollectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.listCollectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.listCollectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
        ])
    }
    
    private func setGridViewConstraints() {
        NSLayoutConstraint.activate([
            self.gridCollectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.gridCollectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.gridCollectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.gridCollectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
        ])
    }
    
    // MARK: - functions
    
    private func configureRefreshControl() {
        listCollectionView.refreshControl = UIRefreshControl()
        gridCollectionView.refreshControl = UIRefreshControl()
        listCollectionView.refreshControl?.addTarget(self, action: #selector(self.refresh), for: .valueChanged)
        gridCollectionView.refreshControl?.addTarget(self, action: #selector(self.refresh), for: .valueChanged)
    }
    
    private func fetchData() {
        let productsRequest = ProductsRequest()
        let myURLSession = MyURLSession()
        myURLSession.dataTask(with: productsRequest) {
            (result: Result<ProductsDetailList, Error>) in
            switch result {
            case .success(let success):
                self.gridCollectionView.configureSnapshot(productsList: success.pages)
                self.listCollectionView.configureSnapshot(productsList: success.pages)
                
                DispatchQueue.main.async {
                    guard let loadingView = self.loadingView,
                          loadingView.isHidden == false
                    else { return }
                    self.removeSpinner()
                }
                
            case .failure(let error):
                print(error)
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
        self.loadingView?.removeFromSuperview()
        self.loadingView = nil
    }
    
    // MARK: - @objc functions
    
    @objc private func segmentButtonDidTap(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            listCollectionView.isHidden = false
            gridCollectionView.isHidden = true
        case 1:
            listCollectionView.isHidden = true
            gridCollectionView.isHidden = false
        default:
            break
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

