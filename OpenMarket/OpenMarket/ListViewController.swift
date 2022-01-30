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
        let loadingNib = UINib(nibName: "LoadingCell", bundle: .main)
        collectionView.register(loadingNib, forCellWithReuseIdentifier: "LoadingCell")
    }
    
    private func paging() {
        var cellProduct: [Product] = []
        
        // 데이터 20개 추가
        let apiService = MarketAPIService()
        
        apiService.fetchPage(pageNumber: pageNumber, itemsPerPage: 20) { result in
            switch result {
                
            case .success(let data):
                cellProduct = data.products
                print(self.pageNumber)
                self.products.append(contentsOf: cellProduct)
                
                
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    
                    self.collectionView.reloadData()
                    self.isPaging = false
                }
                self.pageNumber += 1
            case .failure(let error):
                print(error)
            }
        }
    }

    private func beginPaging() {
        isPaging = true
        
        DispatchQueue.main.async {
            self.collectionView.reloadSections(IndexSet(integer: 0))
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.paging()
        }
    }
     
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.height

        
//        print(offsetY > (contentHeight - height))
//        print("offsetY: \(offsetY)") // 954.3333333333334
//        print("contentHeight - height: \(contentHeight - height)") // 954.3333333333337
//
//        print(offsetY + 1 > (contentHeight - height))
        // 스크롤이 테이블 뷰 Offset의 끝에 가게 되면 다음 페이지를 호출
//        print("스크롤뷰")
        
        if offsetY  + 1 > (contentHeight - height), isPaging == false {
            beginPaging()
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
        if indexPath.section == 0 {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: MarketCell.identifier,
                for: indexPath
            ) as? MarketCell else {
                return UICollectionViewCell()
            }
            print("product 개수: \(products.count)")
            print("indexpath: \(indexPath.row)")
            cell.configure(with: products[indexPath.row], cellType: .list)
            
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LoadingCell", for: indexPath) as? LoadingCell else {
                return UICollectionViewCell()
            }
            cell.start()
            return cell
        }
       
    }
}

extension ListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let controller = storyboard?.instantiateViewController(withIdentifier: ProductDetailsViewController.identifier) as? ProductDetailsViewController else {
            return
        }
        let productId = products[indexPath.row].id
        controller.fetchDetails(of: productId)
        navigationController?.pushViewController(controller, animated: true)
    }
}

//MARK: - IdentifiableView

extension ListViewController: IdentifiableView {}
