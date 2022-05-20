//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class MainViewController: UIViewController {
    
    enum SegmentView: Int {
        case list = 0
        case grid = 1
    }
    
    enum Section {
        case main
    }
    
    lazy var network = Network(delegate: self)
    let session: URLSessionProtocol = URLSession.shared
    private var pageNo = 2
    private var itemsPerPage = 40
    
    private lazy var listLayout: UICollectionViewCompositionalLayout = {
        let configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        return UICollectionViewCompositionalLayout.list(using: configuration)
    }()
    
    private lazy var gridLayout: UICollectionViewLayout = {
        let flowLayout = UICollectionViewFlowLayout()
        let inset: CGFloat = 20
        let rowItems = 2
        flowLayout.minimumLineSpacing = inset
        flowLayout.minimumInteritemSpacing = inset
        flowLayout.scrollDirection = .vertical
        flowLayout.itemSize = CGSize(
            width: (view.safeAreaLayoutGuide.layoutFrame.width / CGFloat(rowItems)) - (inset * 1.5),
            height: view.safeAreaLayoutGuide.layoutFrame.height / 2.5 - inset
        )
        flowLayout.sectionInset.left = inset
        flowLayout.sectionInset.right = inset
        return flowLayout
    }()
    
    private lazy var collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: listLayout)
    
    private lazy var dataSource = UICollectionViewDiffableDataSource<Section, ProductInformation>(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
        
        switch self.segmentedControl.selectedSegmentIndex {
        case SegmentView.list.rawValue:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListCollectionViewCell.identifier, for: indexPath) as? ListCollectionViewCell else { return UICollectionViewListCell() }
            cell.accessories = [.disclosureIndicator()]
            cell.configureContent(productInformation: itemIdentifier)
            return cell
            
        case SegmentView.grid.rawValue:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GridCollectionViewCell.identifier, for: indexPath) as? GridCollectionViewCell else { return UICollectionViewCell() }
            cell.configureContent(productInformation: itemIdentifier)
            return cell
        default:
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
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        activityIndicator.center = self.view.center
        activityIndicator.color = UIColor.red
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.medium
        activityIndicator.stopAnimating()
        return activityIndicator
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        configureSegmentedControl()
        configureCollectionView()
        configureIndicator()
        network.requestDecodedData(pageNo: pageNo, itemsPerPage: itemsPerPage)
    }
    
    private func configureSegmentedControl() {
        navigationItem.titleView = segmentedControl
    }
    
    @objc private func segmentedControlChanged(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case SegmentView.list.rawValue:
            collectionView.setCollectionViewLayout(listLayout, animated: true)
            collectionView.reloadData()
        case SegmentView.grid.rawValue:
            collectionView.setCollectionViewLayout(gridLayout, animated: true)
            collectionView.reloadData()
        default:
            return
        }
    }

    private func configureCollectionView() {
        view.addSubview(collectionView)
        collectionView.register(GridCollectionViewCell.self, forCellWithReuseIdentifier: GridCollectionViewCell.identifier)
        collectionView.register(ListCollectionViewCell.self, forCellWithReuseIdentifier: ListCollectionViewCell.identifier)
    }
    
    private func configureIndicator() {
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
}

extension MainViewController: MainViewDelegate {
    func setSnapshot(productInformations: [ProductInformation]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, ProductInformation>()
        snapshot.appendSections([.main])
        DispatchQueue.main.async {
            snapshot.appendItems(productInformations)
            self.dataSource.apply(snapshot, animatingDifferences: true)
            self.activityIndicator.stopAnimating()
        }
    }
    
    func showErrorAlert(error: Error) {
        let networkError = error as? NetworkError
        let alert = UIAlertController(title: networkError?.errorDescription,
                                      message: "Error Occurred",
                                      preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK",
                                        style: .default)
        alert.addAction(alertAction)
        present(alert, animated: true)
    }
}
