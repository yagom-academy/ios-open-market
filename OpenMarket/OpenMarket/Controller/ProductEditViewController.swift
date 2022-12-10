//
//  ProductEditViewController.swift
//  OpenMarket
//  Created by inho, Hamo, Jeremy on 2022/12/6.
//

import UIKit

final class ProductEditViewController: UIViewController {
    private let networkManager: NetworkManager = .init()
    private let errorManager: ErrorManager = .init()
    private let productEditView: ProductFormView
    private let identifier: Int
    private var images: [ImageData] = [] {
        didSet {
            DispatchQueue.main.async {
                self.productEditView.imagesCollectionView.reloadData()
            }
        }
    }
    
    init(product: ProductData) {
        identifier = product.identifier
        let product = PostProduct(name: product.name,
                                  description: product.description ?? "",
                                  price: product.price,
                                  currency: product.currency,
                                  discountedPrice: product.discountedPrice,
                                  stock: product.stock,
                                  secret: "9vqf2ysxk8tnhzm9")
        productEditView = ProductFormView(product: product)
        productEditView.imagesCollectionView.register(RegistrationImageCell.self,
                                                      forCellWithReuseIdentifier: RegistrationImageCell.identifier)
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        productEditView.imagesCollectionView.delegate = self
        productEditView.imagesCollectionView.dataSource = self
        configureView()
        configureNavigationBar()
        networkManager.loadData(of: .product(identifier: identifier),
                                dataType: ProductData.self) { result in
            switch result {
            case .success(let productData):
                guard let images = productData.images else { return }
                self.images = images
            case .failure(let error):
                guard let error = error as? NetworkError else { return }
                DispatchQueue.main.async {
                    self.present(self.errorManager.createAlert(error: error),                 animated: true)
                }
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView() {
        view = productEditView
        view.backgroundColor = .white
    }
    
    private func configureNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel",
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(cancelRegistration))
        navigationItem.title = "상품 수정"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done",
                                                            style: .plain,
                                                            target: self,
                                                            action: nil)
    }
}

//MARK: - CollectionViewDelegateFlowLayout
extension ProductEditViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = view.bounds.width * 0.3
        let height: CGFloat = width
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10,
                            left: 10,
                            bottom: 10,
                            right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}

//MARK: - CollectionViewDataSource
extension ProductEditViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell: RegistrationImageCell = collectionView.dequeueReusableCell(
            withReuseIdentifier: RegistrationImageCell.identifier,
            for: indexPath) as? RegistrationImageCell
        else {
            return UICollectionViewCell()
        }
        
        self.networkManager.loadThumbnailImage(of: images[indexPath.item].thumbnailUrl) { result in
            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    cell.addImage(image)
                }
            case .failure(_):
                DispatchQueue.main.async {
                    cell.addImage(self.errorManager.showFailedImage() ?? UIImage())
                }
            }
        }
        
        return cell
    }
}

//MARK: - Action Method
extension ProductEditViewController {
    @objc private func cancelRegistration() {
        dismiss(animated: true)
    }
}
