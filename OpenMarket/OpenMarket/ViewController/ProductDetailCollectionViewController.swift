//
//  ProductDetailCollectionViewController.swift
//  OpenMarket
//
//  Created by 주디, 재재 on 2022/08/02.
//

import UIKit

class ProductDetailCollectionViewController: UICollectionViewController {
    // MARK: Inner types
    enum Section: Int ,Hashable {
        case image
        case info
    }
    
    // MARK: Typealias
    typealias DataSource = UICollectionViewDiffableDataSource<Section, DetailProductItem>
    typealias SnapShot = NSDiffableDataSourceSnapshot<Section, DetailProductItem>
    
    // MARK: Properties
    private lazy var dataSource = makeDataSource()
    private var detailProduct: DetailProduct?
    private var detailProductItem: DetailProductItem?
    private var images: [String] = []
    private var productNumber: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.collectionViewLayout = createLayout()
        receiveDetailData()
        configureUI()
    }
    
    @objc private func backBarButtonDidTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func editProductButtonDidTapped() {
        let editAlert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let editAction = UIAlertAction(title: "수정", style: .default) { _ in
            self.convertToEditView()
        }
        let deleteAction = UIAlertAction(title: "삭제", style: .destructive) {_ in 
            self.deleteAfterCheckSecret()
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        
        [editAction, deleteAction, cancelAction].forEach {
            editAlert.addAction($0)
        }
        present(editAlert, animated: true)
    }
    
    private func deleteAfterCheckSecret() {
        let checkAlert = UIAlertController(title: "비밀번호 확인", message: "비밀번호를 입력해주세요.", preferredStyle: .alert)
        checkAlert.addTextField()
        
        let confirmAction = UIAlertAction(title: "확인", style: .default) { [self] _ in
            let sessionManager = URLSessionManager(session: URLSession.shared)
            guard let inputSecret = checkAlert.textFields?.first?.text else { return }
            guard let productNumber = productNumber else { return }
            
            sessionManager.inquireSecretKey(vendorSecret: inputSecret, productNumber: productNumber) { result in
                switch result {
                case .success(let data):
                    sessionManager.deleteData(secretKey: data, productNumber: productNumber) { result in
                        switch result {
                        case .success(_):
                            DispatchQueue.main.async {
                                self.navigationController?.popViewController(animated: true)
                            }
                        case .failure(_):
                            self.showAlert(title: "서버 통신 실패", message: "데이터를 삭제하지 못했습니다.")
                        }
                    }
                case .failure(_):
                    self.showAlert(title: "실패", message: "비밀번호가 일치하지 않습니다.")
                }
            }
        }
        checkAlert.addAction(confirmAction)
        present(checkAlert, animated: true)
    }
    
    
    private func configureUI() {
        let editProductBarButton = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(editProductButtonDidTapped))
        let backBarButton = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(backBarButtonDidTapped))
        navigationItem.rightBarButtonItem = editProductBarButton
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = backBarButton
    }
    
    private func convertToEditView() {
        guard let productVC = storyboard?.instantiateViewController(withIdentifier: "ProductViewController") as? AddProductViewController else { return }
        guard let detailProduct = detailProduct else { return }
        productVC.changeToEditMode(data: detailProduct, images: images)
        navigationController?.pushViewController(productVC, animated: true)
    }
    
    func receiveProductInfo(number: Int, name: String) {
        navigationItem.title = name
        productNumber = number
    }
    
    // MARK: DataSource
    private func makeDataSource() -> DataSource {
        let infoRegistration = UICollectionView.CellRegistration<DetailInfoCollectionViewCell, DetailProductItem>.init { cell, indexPath, item in
            cell.configureCell(with: item)
        }
        
        let imageRegistration = UICollectionView.CellRegistration<DetailImageCollectionViewCell, DetailProductItem>.init { cell, indexPath, item in
            cell.imageView.configureImage(url: item.thumbnailURL, cell, indexPath, self.collectionView)
            cell.imageNumberLabel.text = "\(indexPath.row+1)/\(self.images.count)"
        }
        
        return DataSource(collectionView: collectionView) { collectionView, indexPath, item -> UICollectionViewCell? in
            guard let section = Section(rawValue: indexPath.section) else { fatalError("Unknown section") }
            switch section {
            case .image:
                return collectionView.dequeueConfiguredReusableCell(using: imageRegistration, for: indexPath, item: item)
            case .info:
                return collectionView.dequeueConfiguredReusableCell(using: infoRegistration, for: indexPath, item: item)
            }
        }
    }
    
    // MARK: Data & Snapshot
    private func receiveDetailData() {
        let sessionManager = URLSessionManager(session: URLSession.shared)
        guard let productNumber = productNumber else { return }
        let subURL = SubURL().productURL(productNumber: productNumber)
        
        LoadingIndicator.showLoading(on: view)
        sessionManager.receiveData(baseURL: subURL) { result in
            switch result {
            case .success(let data):
                self.decodeResult(data)
                
                DispatchQueue.main.async {
                    self.applySnapshots()
                    LoadingIndicator.hideLoading(on: self.view)
                }
            case .failure(_):
                DispatchQueue.main.async {
                    self.showAlert(title: "서버 통신 실패", message: "데이터를 받아오지 못했습니다.")
                }
            }
        }
    }
    
    private func applySnapshots() {
        var itemSnapshot = SnapShot()
        guard let detailProduct = detailProductItem else { return }
        var detailImages: [DetailProductItem] = []
        
        images.forEach {
            detailImages.append(DetailProductItem(detailItem: detailProduct, image: $0))
        }
        itemSnapshot.appendSections([.image, .info])
        itemSnapshot.appendItems(detailImages , toSection: .image)
        itemSnapshot.appendItems([detailProduct], toSection: .info)
        
        dataSource.apply(itemSnapshot, animatingDifferences: false)
    }
    
    private func decodeResult(_ data: Data) {
        do {
            self.detailProduct = try DataDecoder().decode(type: DetailProduct.self, data: data)
            guard let detailProduct = detailProduct else {  return }
            self.detailProductItem = DetailProductItem(detailProduct: detailProduct)
            self.images = detailProduct.images.map { $0.url }
        } catch {
            DispatchQueue.main.async {
                self.showAlert(title: "데이터 변환 실패", message: "가져온 데이터를 읽을 수 없습니다.")
            }
        }
    }
    
    private func showAlert(title: String, message: String) {
        let failureAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        failureAlert.addAction(UIAlertAction(title: "확인", style: .default))
        DispatchQueue.main.async {
            self.present(failureAlert, animated: true)
        }
    }
    
    // MARK: Layout
    private func createLayout() -> UICollectionViewLayout {
        let sectionProvider = { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            guard let sectionKind = Section(rawValue: sectionIndex) else { return nil }
            let section: NSCollectionLayoutSection
            
            switch sectionKind {
            case .image:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.45))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                
                section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .groupPagingCentered
                
            case .info:
                let layoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: layoutSize)
                let groupsize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.55))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupsize, subitem: item, count: 1)
                
                item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
                section = NSCollectionLayoutSection(group: group)
            }
            return section
        }
        return UICollectionViewCompositionalLayout(sectionProvider: sectionProvider)
    }
}

