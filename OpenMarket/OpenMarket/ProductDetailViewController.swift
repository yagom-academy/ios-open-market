//
//  ProductDetailViewController.swift
//  OpenMarket
//
//  Created by Gundy, Wonbi on 2022/12/07.
//

import UIKit

final class ProductDetailViewController: UIViewController {
    private let productID: Int
    private var detailProduct: DetailProduct?
    private let networkManager: NetworkManager
    private let detailView: DetailView = DetailView()
    private var dataSource: UICollectionViewDiffableDataSource<Int, Int>! = nil
    private var snapshot = NSDiffableDataSourceSnapshot<Int, Int>()
    private var images: [UIImage] = []
    
    init(_ productID: Int, networkManager: NetworkManager) {
        self.productID = productID
        self.networkManager = networkManager
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        view = detailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        configureNavigationBar()
        configureCollectionView()
        configureDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let request = ProductDetailRequest(productID: productID).request
        else { return }
        
        networkManager.fetchData(from: request, dataType: DetailProduct.self) { result in
            switch result {
            case .success(let data):
                self.detailProduct = data
                DispatchQueue.main.async {
                    self.configureDetailView(detailProduct: data)
                    self.setupImages(data.images)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func configureNavigationBar() {
        navigationItem.title = detailProduct?.name
        navigationItem.rightBarButtonItem = detailView.fetchNavigationBarButton()
        navigationItem.rightBarButtonItem?.target = self
        navigationItem.rightBarButtonItem?.action = #selector(showActionSheet)
    }
    
    private func configureDetailView(detailProduct: DetailProduct) {
        detailView.configureImageNumberLabel(present: 1, total: detailProduct.images.count)
        detailView.configureNameLabel(from: detailProduct.name)
        detailView.configureStockLabel(from: setupStock(detailProduct.stock))
        detailView.configurePriceLabel(from: setupPrice(detailProduct))
        detailView.configureDescriptionText(from: detailProduct.description)
    }
    
    private func setupStock(_ stock: Int) -> String {
        if stock.isZero {
            return "품절"
        } else if stock >= 1000 {
            let stock = FormatConverter.convertToDecimal(from: Double(stock / 1000))
            return "남은 수량 : \(stock.components(separatedBy: ".")[0])k"
        } else {
            return "남은 수량 : \(stock)"
        }
    }
    
    private func setupPrice(_ detailProduct: DetailProduct) -> NSMutableAttributedString {
        let text: String
        let currency = detailProduct.currency.rawValue
        let price = FormatConverter.convertToDecimal(from: detailProduct.price)
        let bargainPrice = FormatConverter.convertToDecimal(from: detailProduct.bargainPrice)
        
        if detailProduct.discountedPrice.isZero {
            text = "\(currency) \(price)"
            let attributedString = NSMutableAttributedString(string: text)
            return attributedString
        } else {
            text = "\(currency) \(price)\n\(currency) \(bargainPrice)"
            let attributedString = NSMutableAttributedString(string: text)
            attributedString.addAttributes([.foregroundColor: UIColor.systemRed, .strikethroughStyle: 1],
                                           range: (text as NSString).range(of: "\(currency) \(price)"))
            attributedString.addAttributes([.foregroundColor: UIColor.black],
                                           range: (text as NSString).range(of: "\(currency) \(bargainPrice)"))
            return attributedString
        }
    }
    
    private func setupImages(_ images: [Image]) {
        guard snapshot.numberOfItems.isZero else { return }
        DispatchQueue.global().async {
            images.forEach { image in
                guard let url = URL(string: image.url),
                      let data = try? Data(contentsOf: url),
                      let image = UIImage(data: data)
                else {
                    return
                }
                self.images.append(image)
            }
            self.configureSnapshot()
        }
    }
    
    @objc private func showActionSheet() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let editAction = UIAlertAction(title: "수정", style: .default) { _ in
            self.editProduct()
        }
        let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { _ in
            self.showDeleteAlert()
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        
        [editAction, deleteAction, cancelAction].forEach {
            alert.addAction($0)
        }
        present(alert, animated: true)
    }
    
    private func showDeleteAlert() {
        let alert = UIAlertController(title: nil, message: "비밀번호를 입력하세요", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        let confirmAction = UIAlertAction(title: "확인", style: .default) { _ in
            guard let input = alert.textFields?.first?.text else { return }
            self.searchURI(with: input)
        }
        alert.addTextField { textField in
            textField.placeholder = "비밀번호"
        }
        [cancelAction, confirmAction].forEach {
            alert.addAction($0)
        }
        alert.preferredAction = confirmAction
        present(alert, animated: true)
    }
    
    private func showAlert(title: String? = nil, message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .default) { _ in
            if let completion = completion {
                completion()
            }
        }
        
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    private func editProduct() {
        guard let detailProduct = detailProduct else { return }
        let navigationController = UINavigationController(
            rootViewController: EditProductViewController(networkManager, product: detailProduct, images: images)
        )
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true)
    }
    
    private func searchURI(with password: String) {
        let uriSearchRequest = URISearchRequest(productID: productID,
                                                identifier: "c598a7e9-6941-11ed-a917-8dbc932b3fe4",
                                                secret: password)
        guard let request = uriSearchRequest.request else { return }
        
        networkManager.postData(from: request) { result in
            switch result {
            case .success(let data):
                guard let uri = String(data: data, encoding: .utf8) else { return }
                self.deleteProduct(with: uri)
            case .failure(_):
                DispatchQueue.main.async { [weak self] in
                    self?.showAlert(message: "비밀번호가 틀렸습니다")
                }
            }
        }
    }
    
    private func deleteProduct(with uri: String) {
        let productDeleteRequest = ProductDeleteRequest(identifier: "c598a7e9-6941-11ed-a917-8dbc932b3fe4", uri: uri)
        guard let request = productDeleteRequest.request else { return }
        
        networkManager.fetchData(from: request, dataType: DetailProduct.self) { result in
            switch result {
            case .success(let product):
                DispatchQueue.main.async { [weak self] in
                    self?.showAlert(title: "삭제 완료!", message: product.name) {
                        self?.navigationController?.popToRootViewController(animated: true)
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension ProductDetailViewController {
    private func createCollectionViewLayout() -> UICollectionViewLayout {
        let config = UICollectionViewCompositionalLayoutConfiguration()
        
        let layout = UICollectionViewCompositionalLayout(sectionProvider: {
            (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            let imageItem = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(1.0)
                )
            )
            imageItem.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
            
            let containerGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalHeight(1.0),
                    heightDimension: .fractionalHeight(1.0)),
                subitems: [imageItem]
            )
            
            let section = NSCollectionLayoutSection(group: containerGroup)
            section.orthogonalScrollingBehavior = .groupPagingCentered
            
            section.visibleItemsInvalidationHandler = { (_, _, _) -> Void in
                guard let itemIndex = self.detailView.imageCollectionView.indexPathsForVisibleItems.first?.item
                else { return }
                self.detailView.configureImageNumberLabel(present: itemIndex + 1, total: self.images.count)
            }
            return section
            
        }, configuration: config)
        return layout
    }
    
    private func configureCollectionView() {
        detailView.imageCollectionView.collectionViewLayout = createCollectionViewLayout()
    }
    
    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<DetailImageCell, Int> { (cell, indexPath, _) in
            cell.configureImageView(with: self.images[indexPath.item])
        }
        
        dataSource = UICollectionViewDiffableDataSource<Int, Int>(collectionView: detailView.imageCollectionView) {(
            collectionView: UICollectionView,
            indexPath: IndexPath,
            identifier: Int) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration,
                                                                for: indexPath,
                                                                item: identifier)
        }
    }
    
    private func configureSnapshot() {
        let items = images.compactMap { images.firstIndex(of: $0) }
        
        snapshot.appendSections([0])
        snapshot.appendItems(items)
        
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}
