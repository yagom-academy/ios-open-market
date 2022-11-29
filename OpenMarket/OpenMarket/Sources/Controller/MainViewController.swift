//
//  OpenMarket - MainViewController.swift
//  Created by Zhilly, Dragon. 22/11/14
//  Copyright © yagom. All rights reserved.
//

import UIKit

final class MainViewController: UIViewController {
    private var product: ProductList?
    private var cellMode: CellMode = .listType
    
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var viewModeController: UISegmentedControl!
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        
        activityIndicator.center = view.center
        activityIndicator.style = UIActivityIndicatorView.Style.large
        
        return activityIndicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(self.activityIndicator)
        
        configureCollectionViewDelegate()
        configureCollectionView()
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        activityIndicator.startAnimating()
    }
    
    private func loadData() {
        let session: URLSessionProtocol = URLSession.shared
        let networkManager: NetworkRequestable = NetworkManager(session: session)
        
        networkManager.request(from: URLManager.productList(pageNumber: 1, itemsPerPage: 200).url,
                               httpMethod: HttpMethod.get,
                               dataType: ProductList.self) { result in
            switch result {
            case .success(let data):
                self.product = data
                self.reloadData()
                
                DispatchQueue.main.sync {
                    self.activityIndicator.stopAnimating()
                }
            case .failure(_):
                break
            }
        }
    }
    
    private func reloadData() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    private func configureCollectionViewDelegate() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func configureCollectionView() {
        switch cellMode {
        case .listType:
            registerCellNib(cellIdentifier: ListCollectionViewCell.stringIdentifier())
            listCollectionViewFlowLayout()
        case .gridType:
            registerCellNib(cellIdentifier: GridCollectionViewCell.stringIdentifier())
            gridCollectionViewFlowLayout()
        }
    }
    
    private func registerCellNib(cellIdentifier: String) {
        let collectionViewCellNib = UINib(nibName: cellIdentifier, bundle: nil)
        
        collectionView.register(collectionViewCellNib,
                                     forCellWithReuseIdentifier: cellIdentifier)
    }
    
    @IBAction private func tapViewModeController(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case CellMode.listType.index:
            cellMode = .listType
            collectionView.reloadData()
            configureCollectionView()
            collectionView.scrollToItem(at: IndexPath(row: 0, section: 0),
                                        at: .top,
                                        animated: false)
        case CellMode.gridType.index:
            cellMode = .gridType
            collectionView.reloadData()
            configureCollectionView()
            collectionView.scrollToItem(at: IndexPath(row: 0, section: 0),
                                        at: .top,
                                        animated: false)
        default:
            collectionView.reloadData()
        }
    }
    
    private func gridCollectionViewFlowLayout() {
        let flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let oneProductWidth: CGFloat = UIScreen.main.bounds.width / 2.2
        let oneProductHeight: CGFloat = UIScreen.main.bounds.height / 3
        
        flowLayout.itemSize = CGSize(width: oneProductWidth, height: oneProductHeight)
        flowLayout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        collectionView.collectionViewLayout = flowLayout
    }
    
    private func listCollectionViewFlowLayout() {
        let flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let oneProductWidth: CGFloat = UIScreen.main.bounds.width
        let oneProductHeight: CGFloat = UIScreen.main.bounds.height / 12
        
        flowLayout.minimumLineSpacing = 0
        flowLayout.itemSize = CGSize(width: oneProductWidth, height: oneProductHeight)
        
        collectionView.collectionViewLayout = flowLayout
    }
}

extension MainViewController: UICollectionViewDelegate {}

extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        
        return product?.pages.count ?? .zero
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch cellMode {
        case .listType:
            return makeListCell(cellForItemAt: indexPath)
        case .gridType:
            return makeGridCell(cellForItemAt: indexPath)
        }
    }
    
    private func makeListCell(cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell: ListCollectionViewCell =
        collectionView.dequeueReusableCell(withReuseIdentifier:
                                            ListCollectionViewCell.stringIdentifier(),
                                           for: indexPath) as? ListCollectionViewCell else {
            return UICollectionViewCell()
        }
        guard let productItem = product?.pages[indexPath.item] else {
            return cell
        }
        
        cell.configurationCell(item: productItem)
        cell.addBottomLine(color: .gray, width: 0.5)
        
        return cell
            
    }
    
    private func makeGridCell(cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell: GridCollectionViewCell =
        collectionView.dequeueReusableCell(withReuseIdentifier:
                                            GridCollectionViewCell.stringIdentifier(),
                                           for: indexPath) as? GridCollectionViewCell else {
            return UICollectionViewCell()
        }
        guard let productItem = product?.pages[indexPath.item] else {
            return cell
        }
        
        cell.configurationCell(item: productItem)
        cell.addBorderLine(color: .gray, width: 1)
        
        return cell
    }
}
