//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class MainViewController: UIViewController, ActivityIndicatorProtocol {
    
    enum Section {
        case main
    }
    
    private let productListUseCase = ProductListUseCase(
        network: Network(),
        jsonDecoder: JSONDecoder(),
        pageInfoManager: PageInfoManager()
    )
    
    private lazy var collectionView: MainCollectionView = {
        let view = MainCollectionView(frame: view.bounds, collectionViewLayout: UICollectionViewFlowLayout())
        view.changeLayout(viewType: .list)
        return view
    }()
    
    private lazy var dataSource = UICollectionViewDiffableDataSource<Section, ProductInformation>(collectionView: collectionView) { [weak self] collectionView, indexPath, itemIdentifier in
        switch MainCollectionView.LayoutType(rawValue: self?.segmentedControl.selectedSegmentIndex ?? 0) {
        case .list:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListCollectionViewCell.identifier, for: indexPath) as? ListCollectionViewCell else { return UICollectionViewListCell() }
            cell.accessories = [.disclosureIndicator()]
            cell.configureContent(productInformation: itemIdentifier)
            return cell
        case .grid:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GridCollectionViewCell.identifier, for: indexPath) as? GridCollectionViewCell else { return UICollectionViewCell() }
            cell.configureContent(productInformation: itemIdentifier)
            return cell
        case .none:
            return UICollectionViewCell()
        }
    }
    
    private lazy var segmentedControl: UISegmentedControl = {
        let segment = UISegmentedControl(items: ["LIST", "GRID"])
        segment.selectedSegmentIndex = 0
        segment.backgroundColor = .white
        segment.selectedSegmentTintColor = .systemBlue
        segment.layer.borderWidth = 2
        segment.layer.borderColor = UIColor.systemBlue.cgColor
        segment.addTarget(self, action: #selector(segmentedControlChanged), for: .valueChanged)
        segment.translatesAutoresizingMaskIntoConstraints = false
        segment.widthAnchor.constraint(equalToConstant: view.frame.size.width / 2).isActive = true
        let selectedTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20)
        ]
        let releasedTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.systemBlue
        ]
        segment.setTitleTextAttributes(selectedTextAttributes, for: .selected)
        segment.setTitleTextAttributes(releasedTextAttributes, for: .normal)
        return segment
    }()
    
    private lazy var rightBarButtonItem: UIBarButtonItem = UIBarButtonItem(
        barButtonSystemItem: .add,
        target: self,
        action: #selector(mainViewRightBarButtonTapped)
    )
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        activityIndicator.center = self.view.center
        activityIndicator.color = UIColor.red
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.medium
        activityIndicator.stopAnimating()
        return activityIndicator
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
       let control = UIRefreshControl()
        control.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
       return control
    }()
    
    @objc private func pullToRefresh(){
        requestList()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        collectionView.delegate = self
        configureSegmentedControl()
        configureCollectionView()
        configureIndicator()
        requestList()
    }
}

// MARK: - Method
extension MainViewController {
    private func requestList() {
        productListUseCase.requestPageInformation { [weak self] data in
            DispatchQueue.main.async {
                self?.setSnapshot(productInformations: data.pages)
                self?.collectionView.reloadData()
                self?.refreshControl.endRefreshing()
            }
        } errorHandler: { [weak self] error in
            self?.showErrorAlert(error: error)
        }
    }
    
    private func configureSegmentedControl() {
        navigationItem.titleView = segmentedControl
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    private func configureCollectionView() {
        view.addSubview(collectionView)
        collectionView.changeLayout(viewType: .list)
        collectionView.register(GridCollectionViewCell.self, forCellWithReuseIdentifier: GridCollectionViewCell.identifier)
        collectionView.register(ListCollectionViewCell.self, forCellWithReuseIdentifier: ListCollectionViewCell.identifier)
        collectionView.refreshControl = refreshControl
    }
    
    private func setSnapshot(productInformations: [ProductInformation]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, ProductInformation>()
        snapshot.appendSections([.main])
        DispatchQueue.main.async { [weak self] in
            snapshot.appendItems(productInformations)
            self?.dataSource.apply(snapshot, animatingDifferences: false)
            self?.activityIndicator.stopAnimating()
        }
    }
    
    private func showErrorAlert(error: Error) {
        DispatchQueue.main.async {
            let networkError = error as? NetworkError
            let alert = UIAlertController(title: networkError?.errorDescription,
                                          message: "Error Occurred",
                                          preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK",
                                            style: .default) { _ in
                self.requestList()
            }
            alert.addAction(alertAction)
            self.present(alert, animated: true)
        }
    }
}

// MARK: - Action Method
extension MainViewController {
    
    @objc private func mainViewRightBarButtonTapped() {
        let viewController = RegisterViewController()
        viewController.delegate = self
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc private func segmentedControlChanged(sender: UISegmentedControl) {
        switch MainCollectionView.LayoutType(rawValue: sender.selectedSegmentIndex) {
        case .list:
            collectionView.changeLayout(viewType: .list)
            collectionView.reloadData()
        case .grid:
            collectionView.changeLayout(viewType: .grid)
            collectionView.reloadData()
        case .none:
            return
        }
    }
}

// MARK: - RefreshDelegate
extension MainViewController: ViewControllerDelegate {
    func viewControllerShouldRefresh(_ viewController: UIViewController) {
        requestList()
    }
}

// MARK: - CollectionView Delegate

extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? DetailCellSelectable else { return }
        guard let productNumber = cell.productNumber else { return }
        let detailViewController = DetailViewController(producntNubmer: productNumber)
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}
