//
//  ProductDetailViewController.swift
//  OpenMarket
//
//  Created by dudu, safari on 2022/05/30.
//

import UIKit

final class ProductDetailViewController: UIViewController {
    private typealias DataSource = UICollectionViewDiffableDataSource<Section, UIImage>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, UIImage>
    
    private let networkManager = NetworkManager()
    
    private var mainView: ProductDetailView?
    private let product: Product
    
    private var dataSource: DataSource?
    private var snapshot: Snapshot?
    
    init(product: Product) {
        self.product = product
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        mainView = ProductDetailView(frame: view.bounds)
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestData()
        configureView()
        
    }
    
    // MARK: - Configure
    
    private func configureView() {
        mainView?.configure(data: product)
        configureCollectionView()
        configureNavigationBar()
    }
    
    private func configureNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(editButtonDidTapped))
        navigationItem.title = product.name
    }
    
    @objc private func editButtonDidTapped() {
        AlertDirector(viewController: self).createProductEditActionSheet { [weak self] _ in
            guard let self = self else { return }
            
            self.navigationController?.pushViewController(EditViewController(product: self.product), animated: true)
        } deleteAction: { [weak self] _ in
            let alert = UIAlertController(title: "암호를 입력해주세요", message: nil, preferredStyle:.alert)
            alert.addTextField()
            
            let okAction = UIAlertAction(title: "확인", style: .default) { [weak self] _ in
                guard let password = alert.textFields?.first?.text else { return }
                guard let id = self?.product.id else { return }
                
            }
            
            let cancelAction = UIAlertAction(title: "취소", style: .default)
            alert.addAction(okAction)
            alert.addAction(cancelAction)
            self?.present(alert, animated: true)
        }
    }
    
    private func configureCollectionView() {
        mainView?.productImageCollectionView.register(ProductImageCell.self, forCellWithReuseIdentifier: ProductImageCell.identifier)
        mainView?.productImageCollectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: UICollectionView.elementKindSectionFooter)
        dataSource = makeDataSource()
        snapshot = makeSnapshot()
    }
    
    // MARK: - CollectionView DataSource
    
    private func makeDataSource() -> DataSource? {
        guard let mainView = mainView else { return nil }
        
        let datasource = DataSource(collectionView: mainView.productImageCollectionView) { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductImageCell.identifier, for: indexPath) as? ProductImageCell ?? ProductImageCell()
            
            cell.configure(image: itemIdentifier)
            cell.hideRemoveButton()
            
            return cell
        }
        
        datasource.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard kind == UICollectionView.elementKindSectionFooter else { return nil }
            
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: UICollectionView.elementKindSectionFooter, for: indexPath)
            
            view.backgroundColor = .systemRed
            return view
        }
        
        return datasource
    }
    
    private func makeSnapshot() -> Snapshot? {
        var snapshot = dataSource?.snapshot()
        snapshot?.deleteAllItems()
        snapshot?.appendSections([.main])
        return snapshot
    }
    
    private func applySnapshot(images: [UIImage]) {
        DispatchQueue.main.async { [self] in
            snapshot?.appendItems(images)
            guard let snapshot = snapshot else { return }
            dataSource?.apply(snapshot, animatingDifferences: false)
        }
    }
    
    // MARK: - NetWork Method

    private func requestData() {
        guard let id = product.id else { return }
        
        let endPoint = EndPoint.requestProduct(id: id)
        
        networkManager.request(endPoint: endPoint) { [weak self] (result: Result<Product, NetworkError>) in
            guard let self = self else { return }
            
            switch result {
            case .success(let data):
                self.mainView?.configure(data: data)
                let imagesUrl = data.images?.compactMap { $0.url }
                imagesUrl?.forEach({ url in
                    self.requestImage(urlString: url)
                })
            case .failure(_):
                AlertDirector(viewController: self).createErrorAlert(message: "데이터를 불러오지 못했습니다.")
            }
        }
    }
    
    private func requestImage(urlString: String) {
        ImageManager.shared.downloadImage(urlString: urlString) { [weak self] result in
            switch result {
            case .success(let image):
                self?.applySnapshot(images: [image])
            case .failure(_):
                break
            }
        }
    }
    
    private func deleteData(id: Int, password: String) {
        let endPoint = EndPoint.deleteProuct(id: id, secret: password)
        
        networkManager.request(endPoint: endPoint) { [weak self] (result: Result<Product, NetworkError>) in
            guard let self = self else { return }
            
            switch result {
            case .success(_):
                self.navigationController?.popViewController(animated: true)
            case .failure(_):
                AlertDirector(viewController: self).createErrorAlert(message: "제품을 삭제하지 못하였습니다.")
            }
        }
    }
}
