//
//  ProductDetailViewController.swift
//  OpenMarket
//
//  Created by groot, bard on 2022/08/09.
//

import UIKit

final class ProductDetailViewController: UIViewController {
    // MARK: - properties
    
    private var productID: String?
    
    private var productImageCollectionView: UICollectionView!
    
    // MARK: - life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupNavigationController()
        fetchData()
        setupProductImageCollectionView()
        setupSubviews()
        setupConstraints()
    }
    
    // MARK: - functions
    
    private func fetchData() {
        guard let productID = productID else { return }
        
        let request = ProductGetRequest(headers: nil,
                                        query: nil,
                                        body: nil,
                                        productID: "/" + productID)
        
        let session = MyURLSession()
        session.dataTask(with: request) { (result: Result<Data, Error>) in
            switch result {
            case .success(let success):
                guard let decodedData = success.decodeData(type: ProductDetail.self) else { return }
                
                decodedData.images
                    .filter
                {
                    ImageCacheManager.shared.object(forKey: NSString(string: $0.thumbnail)) == nil
                    
                }
                
                .forEach
                {
                    $0.pushThumbnailImageCache()
                }
                
                DispatchQueue.main.async {
                    self.navigationItem.title = decodedData.name
                }
                
            case .failure(let error):
                print(error.localizedDescription)
                break
            }
        }
    }
    
    private func setupNavigationController() {
        let rightBarButton = UIBarButtonItem(barButtonSystemItem: .action, target: self,
                                             action: #selector(rightBarButtonDidTap))
        navigationItem.setRightBarButton(rightBarButton, animated: true)
    }
    
    private func setupSubviews() {
        view.addSubview(productImageCollectionView)
    }
    
    private func setupConstraints() {
        productImageCollectionView.backgroundColor = .red
        NSLayoutConstraint.activate([
            productImageCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            productImageCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            productImageCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            productImageCollectionView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.5)
        ])
    }
    
    private func setupProductImageCollectionView() {
        let layout = UICollectionViewFlowLayout()
        
        layout.itemSize = CGSize(width: view.safeAreaLayoutGuide.layoutFrame.width,
                                 height: view.safeAreaLayoutGuide.layoutFrame.height/2)
        layout.scrollDirection = .horizontal
        
        productImageCollectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: layout)
        productImageCollectionView?.translatesAutoresizingMaskIntoConstraints = false
        
        let insetX = (productImageCollectionView.bounds.width - productImageCollectionView.frame.width) / 2.0
        let insetY = (productImageCollectionView.bounds.height - productImageCollectionView.frame.height/3) / 2.0
        
        productImageCollectionView.contentInset = UIEdgeInsets(top: insetY,
                                                               left: insetX,
                                                               bottom: insetY,
                                                               right: insetX)
        
        productImageCollectionView?.register(ProductImageCell.self,
                                forCellWithReuseIdentifier: ProductImageCell.identifier)
        productImageCollectionView.isPagingEnabled = true
        productImageCollectionView?.dataSource = self
    }
    
    @objc private func rightBarButtonDidTap() {
        let alertController = UIAlertController(title: nil,
                                                message: nil,
                                                preferredStyle: .actionSheet)
        
        let updateAlertAction = UIAlertAction(title: "수정",
                                              style: .default) { _ in
            print("수정")
        }
        let deleteAlertAction = UIAlertAction(title: "삭제",
                                              style: .destructive) { _ in
            print("삭제")
        }
        let cancelAlertAction = UIAlertAction(title: "취소",
                                              style: .cancel)
        
        alertController.addAction(updateAlertAction)
        alertController.addAction(deleteAlertAction)
        alertController.addAction(cancelAlertAction)
        
        present(alertController, animated: true)
    }
}

// MARK: - extensions

extension ProductDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductImageCell.identifier,
                                                            for: indexPath) as? ProductImageCell
        else { return UICollectionViewCell()}
        
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = .blue
        } else {
            cell.backgroundColor = .brown
        }
        
        return cell
    }
}

extension ProductDetailViewController: Datable {
    func setupProduct(id: String) {
        productID = id
    }
}
