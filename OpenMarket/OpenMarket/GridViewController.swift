//
//  GridViewController.swift
//  OpenMarket
//
//  Created by Jun Bang on 2022/01/12.
//

import UIKit

final class GridViewController: UIViewController {
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
        setupGridLayout()
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    // MARK: - Internal Methods
 
    func reloadCollectionView(with products: [Product]) {
        self.products = products
        
        DispatchQueue.main.async {
            self.loadViewIfNeeded()
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

extension GridViewController {
    private func setupGridLayout() {
        let layout = UICollectionViewFlowLayout()
        collectionView.collectionViewLayout = layout
    }
    
    private func setupCollectionViewCells() {
        let gridNib = UINib(nibName: NibIdentifier.grid, bundle: .main)
        collectionView.register(gridNib, forCellWithReuseIdentifier: MarketCell.identifier)
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

extension GridViewController: UICollectionViewDataSource {
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
            return 2
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

extension GridViewController: UICollectionViewDelegate {
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

//MARK: - UICollectionViewDelegateFlowLayout

extension GridViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 10
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 10
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let width = collectionView.frame.width / 2 - 15
        let height = collectionView.frame.height / 2.5
        let size = CGSize(width: width, height: height)
        
        return size
    }
}

//MARK: - IdentifiableView

extension GridViewController: IdentifiableView {}
