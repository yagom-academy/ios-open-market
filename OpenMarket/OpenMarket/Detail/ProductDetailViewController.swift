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
    
    private let mainView = ProductDetailView(frame: .zero)
    private var product: Product
    
    private var dataSource: DataSource?
    private var snapshot = Snapshot()
    
    init(product: Product) {
        self.product = product
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestData()
        configureView()
        registerNotification()
    }
    
    // MARK: - Configure Method
    
    private func configureView() {
        configureMainView()
        configureCollectionView()
        configureNavigationBar()
    }
    
    private func configureMainView() {
        view.addSubview(mainView)
        
        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: view.topAnchor),
            mainView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            mainView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        mainView.configure(data: product)
    }
    
    private func configureNavigationBar() {
        if product.vendorId == UserInformation.id {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(editButtonDidTapped))
        }
        navigationItem.title = product.name
    }
    
    @objc private func editButtonDidTapped() {
        AlertDirector(viewController: self).createProductEditActionSheet { [weak self] _ in
            guard let self = self else { return }
            
            self.navigationController?.pushViewController(EditViewController(product: self.product), animated: true)
        } deleteAction: { [weak self] _ in
            self?.showInputPasswordAlert()
        }
    }
    
    private func showInputPasswordAlert() {
        let alert = UIAlertController(title: "암호를 입력해주세요", message: nil, preferredStyle:.alert)
        alert.addTextField()
        
        let okAction = UIAlertAction(title: "확인", style: .default) { [weak self] _ in
            guard let password = alert.textFields?.first?.text else { return }
            guard let id = self?.product.id else { return }
            
            self?.requestPassword(id: id, userPassword: password)
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .default)
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
    private func configureCollectionView() {
        mainView.productImageCollectionView.register(ProductImageCell.self, forCellWithReuseIdentifier: ProductImageCell.identifier)
        dataSource = makeDataSource()
        snapshot = makeSnapshot()
    }
    
    private func registerNotification() {
        NotificationCenter.default.addObserver(forName: .update, object: "patch", queue: .main) { [weak self] _ in
            self?.requestData()
        }
    }
    
    // MARK: - CollectionView DataSource
    
    private func makeDataSource() -> DataSource? {
        let datasource = DataSource(collectionView: mainView.productImageCollectionView) { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductImageCell.identifier, for: indexPath) as? ProductImageCell ?? ProductImageCell()
            
            cell.configure(image: itemIdentifier)
            cell.hideRemoveButton()
            
            return cell
        }
        
        return datasource
    }
    
    private func makeSnapshot() -> Snapshot {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        
        return snapshot
    }
    
    private func applySnapshot(images: [UIImage]) {
        DispatchQueue.main.async { [self] in
            snapshot.appendItems(images)
            dataSource?.apply(snapshot, animatingDifferences: false)
        }
    }
    
    // MARK: - NetWork Method
    
    private func requestData() {
        guard let id = product.id else { return }
        
        let requestProductAPI = RequestProduct(path: "\(id)")
        
        networkManager.request(api: requestProductAPI) { [weak self] (result: Result<Product, NetworkError>) in
            guard let self = self else { return }
            
            switch result {
            case .success(let data):
                self.product = data
                self.mainView.configure(data: data)
                data.images?
                    .compactMap { $0.url }
                    .forEach { url in
                        self.requestImage(urlString: url)
                    }
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
    
    private func requestPassword(id: Int, userPassword: String) {
        let params = ["secret": "\(userPassword)"]
        guard let sendData = try? JSONSerialization.data(withJSONObject: params, options: .prettyPrinted) else { return }
        let endPoint = EndPoint.requestProductPassword(id: id, sendData: sendData)
        
        networkManager.request(endPoint: endPoint) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let productPassword):
                self.deleteData(id: id, password: productPassword)
            case .failure(_):
                AlertDirector(viewController: self).createErrorAlert(message: "비밀번호가 틀렸습니다")
            }
        }
    }
    
    private func deleteData(id: Int, password: String) {
        let endPoint = EndPoint.deleteProuct(id: id, secret: password)
        
        networkManager.request(endPoint: endPoint) { [weak self] (result: Result<Product, NetworkError>) in
            guard let self = self else { return }
            
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: .update, object: nil)
                    self.navigationController?.popViewController(animated: true)
                }
            case .failure(_):
                AlertDirector(viewController: self).createErrorAlert(message: "제품을 삭제하지 못했습니다.")
            }
        }
    }
}
