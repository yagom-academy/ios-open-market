//
//  OpenMarket - MainViewController.swift
//  Created by Red, Mino.
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class MainViewController: UIViewController {
    private enum Constants {
        static let requestErrorAlertTitle = "오류 발생"
        static let requestErrorAlertConfirmTitle = "다시요청하기"
        static let loadImageErrorAlertConfirmTitle = "확인"
    }
    
    private lazy var mainView = MainView(frame: view.bounds)
    private let viewModel = MainViewModel()
    
    override func loadView() {
        super.loadView()
        view.addSubview(mainView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationItem()
        setUpCollectionView()
        setUpSegmentControl()
        setUpViewModel()
        viewModel.requestProducts(by: viewModel.currentPage)
    }
}

// MARK: SetUp Method

extension MainViewController {
    private func setUpNavigationItem() {
        navigationItem.titleView = mainView.segmentControl
        navigationItem.rightBarButtonItem = mainView.addButton
    }
    
    private func setUpCollectionView() {
        mainView.collectionView.delegate = self
    }
    
    private func setUpSegmentControl() {
        mainView.segmentControl.addTarget(self, action: #selector(segmentControlValueChanged), for: .valueChanged)
    }
    
    private func setUpViewModel() {
        viewModel.datasource = makeDataSource()
        viewModel.delegate = self
    }
    
    @objc private func segmentControlValueChanged() {
        mainView.setUpLayout(segmentIndex: mainView.segmentControl.selectedSegmentIndex)
    }
    
}

// MARK: Datasource && Snapshot

extension MainViewController {
    private func makeDataSource() -> UICollectionViewDiffableDataSource<MainViewModel.Section, Item> {
        let dataSource = UICollectionViewDiffableDataSource<MainViewModel.Section, Item>(
            collectionView: mainView.collectionView,
            cellProvider: { (collectionView, indexPath, item) -> UICollectionViewCell in
                switch self.mainView.layoutStatus {
                case .list:
                    guard let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: ListCollectionViewCell.identifier,
                        for: indexPath) as? ListCollectionViewCell else {
                        return UICollectionViewCell()
                    }
                    
                    self.viewModel.loadImage(url: item.thumbnail) { image in
                        DispatchQueue.main.async {
                            cell.updateImage(image: image)
                        }
                    }
                    
                    cell.updateLabel(data: item)
                    return cell
                    
                case .grid:
                    guard let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: GridCollectionViewCell.identifier,
                        for: indexPath) as? GridCollectionViewCell else {
                        return UICollectionViewCell()
                    }
                    
                    self.viewModel.loadImage(url: item.thumbnail) { image in
                        DispatchQueue.main.async {
                            cell.updateImage(image: image)
                        }
                    }
                    
                    cell.updateLabel(data: item)
                    return cell
                }
            })
        return dataSource
    }
}

extension MainViewController: AlertDelegate {
    func showAlertRequestError(with error: Error) {
        self.alertBuilder
            .setTitle(Constants.requestErrorAlertTitle)
            .setMessage(error.localizedDescription)
            .setConfirmTitle(Constants.requestErrorAlertConfirmTitle)
            .setConfirmHandler {
                self.viewModel.requestProducts(by: self.viewModel.currentPage)
            }
            .showAlert()
    }
    
    func showAlertRequestImageError(with error: Error) {
        self.alertBuilder
            .setTitle(Constants.requestErrorAlertTitle)
            .setMessage(error.localizedDescription)
            .setConfirmTitle(Constants.loadImageErrorAlertConfirmTitle)
            .showAlert()
    }
}

extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard viewModel.products?.hasNext == true else {
            return
        }
        
        if indexPath.row >= viewModel.items.count - 3 {
            viewModel.currentPage += 1
            viewModel.requestProducts(by: viewModel.currentPage)
        }
    }
}
