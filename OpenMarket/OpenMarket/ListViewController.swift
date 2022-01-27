//
//  ListViewController.swift
//  OpenMarket
//
//  Created by Jun Bang on 2022/01/12.
//

import UIKit

final class ListViewController: UIViewController {
    //MARK: - IBOutlets
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK: - Properties
    
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let loadingIndicator = UIActivityIndicatorView(style: .large)
        loadingIndicator.isHidden = false

        self.view.addSubview(loadingIndicator)
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        loadingIndicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true

        return loadingIndicator
    }()
    
    private var products: [Product]
    
    //MARK: - Initializer
    
    init?(products: [Product], coder: NSCoder) {
        self.products = products
        super.init(coder: coder)
    }

    required init?(coder: NSCoder) {
        assertionFailure("init(coder:) has not been implemented")
        return nil
    }
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionViewCells()
        setupListLayout()
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    // MARK: - Internal Methods
    
    func updateProducts(with products: [Product]) {
        self.products = products
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}

//MARK: - Private Methods

extension ListViewController {
    private func setupListLayout() {
        let configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        collectionView.collectionViewLayout = layout
    }
    
    private func setupCollectionViewCells() {
        let listNib = UINib(nibName: NibIdentifier.list, bundle: .main)
        collectionView.register(listNib, forCellWithReuseIdentifier: MarketCell.identifier)
    }
    
    private func startLoadingIndicator() {
        loadingIndicator.startAnimating()
    }
    
    private func stopLoadingIndicator() {
        DispatchQueue.main.async {
            self.loadingIndicator.stopAnimating()
        }
    }
}

//MARK: - UICollectionViewDataSource

extension ListViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return products.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MarketCell.identifier,
            for: indexPath
        ) as? MarketCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: products[indexPath.row], cellType: .list)
        
        return cell
    }
    
}

extension ListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let apiService = MarketAPIService()
        let productID = products[indexPath.row].id
        
        startLoadingIndicator()
        apiService.fetchProduct(productID: productID) { [weak self] result in
            guard let self = self else {
                return
            }
            self.stopLoadingIndicator()
            switch result {
            case .success(let product):
                DispatchQueue.main.async {
                    guard let controller = self.storyboard?.instantiateViewController(
                            identifier: ProductDetailsViewController.identifier,
                            creator: { coder in
                        ProductDetailsViewController(product: product, coder: coder
                        )
                    }) else {
                        assertionFailure("init(coder:) has not been implemented")
                        return
                    }
                    self.navigationController?.pushViewController(controller, animated: true)
                }
            case .failure(_ ):
                DispatchQueue.main.async {
                    self.presentAlert(alertTitle: "데이터를 가져오지 못했습니다", alertMessage: "죄송해요", handler: nil)
                }
                
            }
        }
    }
}

//MARK: - IdentifiableView

extension ListViewController: IdentifiableView {}
