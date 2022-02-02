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
    
    private var products: [Product]
    private var isPaging = false
    private var pageNumber = 2
    
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
    
    func reloadCollectionView(with products: [Product]) {
        self.products = products
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            self.collectionView.scrollToItem(
                at: IndexPath(row: 0, section: 0),
                at: .top,
                animated: true
            )
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.height

        if offsetY + 1 > (contentHeight - height), isPaging == false {
            isPaging = true
            startPagination()
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
        let loadingNib = UINib(nibName: LoadingCell.identifier, bundle: .main)
        collectionView.register(loadingNib, forCellWithReuseIdentifier: LoadingCell.identifier)
    }
    
    private func startPagination() {
        DispatchQueue.main.async {
            self.collectionView.reloadSections(IndexSet(integer: 0))
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.fetchNextPage()
        }
    }
    
    private func fetchNextPage() {
        var cellProduct: [Product] = []
        
        MarketAPIService().fetchPage(pageNumber: pageNumber, itemsPerPage: 20) { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let data):
                cellProduct = data.products
                self.products.append(contentsOf: cellProduct)
                
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    self.isPaging = false
                }
                self.pageNumber += 1
            case .failure(_):
                self.presentAlert(
                    alertTitle: "로딩 실패",
                    alertMessage: "페이지를 가져올 수 없습니다",
                    handler: nil
                )
            }
        }
    }
}

//MARK: - UICollectionViewDataSource

extension ListViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        if section == 0 {
            return products.count
        } else if section == 1 && isPaging {
            return 1
        } else {
            return 0
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        if indexPath.section == 0, products.count > indexPath.row {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: MarketCell.identifier,
                for: indexPath
            ) as? MarketCell else {
                return UICollectionViewCell()
            }
            cell.configure(with: products[indexPath.row], cellType: .list)
            
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: LoadingCell.identifier,
                for: indexPath
            ) as? LoadingCell else {
                return UICollectionViewCell()
            }
            cell.startLoadingIndicator()
            
            return cell
        }
    }
}

//MARK: - UICollectionViewDelegate

extension ListViewController: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        guard let controller = storyboard?.instantiateViewController(
            withIdentifier: ProductDetailsViewController.identifier
        ) as? ProductDetailsViewController else {
            return
        }
        let productId = products[indexPath.row].id
        controller.fetchDetails(of: productId)
        navigationController?.pushViewController(controller, animated: true)
    }
}

//MARK: - IdentifiableView

extension ListViewController: IdentifiableView {}
