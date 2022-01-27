//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class MainViewController: UIViewController {
    @IBOutlet private weak var collectionView: ProductsCollectionView!
    @IBOutlet private weak var indicator: UIActivityIndicatorView!
    private var refreshControl: UIRefreshControl = UIRefreshControl()
    
    private var dataSource = MainDataSource()

    @IBOutlet private weak var segmentControl: UISegmentedControl! {
        didSet {
            let normal: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.white]
            let selected: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.black]
            segmentControl.setTitleTextAttributes(normal, for: .normal)
            segmentControl.setTitleTextAttributes(selected, for: .selected)
            segmentControl.selectedSegmentTintColor = .white
            segmentControl.backgroundColor = .black
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestProducts {
            self.dataSource.updateProductList()
            self.collectionViewLoad()
        }
        setUpNotification()
        setUpRefreshControl()
    }
    
    private func requestProducts(completion: @escaping () -> Void) {
        let networkManager: NetworkManager = NetworkManager()
        guard let request = networkManager.requestListSearch(page: dataSource.currentPage, itemsPerPage: 20) else {
            print(Message.badRequest)
            return
        }
        networkManager.fetch(request: request, decodingType: Products.self) { result in
            switch result {
            case .success(let products):
                self.dataSource.setUpProducts(products)
                completion()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func collectionViewLoad() {
        DispatchQueue.main.async {
            self.collectionView.dataSource = self.dataSource
            self.collectionView.delegate = self
            self.indicator.stopAnimating()
            self.indicator.isHidden = true
            self.collectionView.isHidden = false
        }
    }
    
    private func collectionViewReload() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            if self.refreshControl.isRefreshing {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.refreshControl.endRefreshing()
                }
            }
        }
    }
    
    private func setUpRefreshControl() {
        collectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(updateMainView), for: .valueChanged)
    }
    
    private func setUpNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateMainView),
            name: .updateMain,
            object: nil
        )
    }
    
    @objc private func updateMainView() {
        DispatchQueue.global().async {
            self.dataSource.resetCurrentPage()
            self.requestProducts {
                self.dataSource.updateProductList()
                self.collectionViewReload()
            }
        }
    }

    @IBAction private func switchSegmentedControl(_ sender: UISegmentedControl) {
        collectionView.reloadData()
        collectionView.scrollToTop()
        switch sender.selectedSegmentIndex {
        case 0:
            dataSource.currentCellIdentifier = ProductCell.listIdentifier
        case 1:
            dataSource.currentCellIdentifier = ProductCell.gridIdentifier
        default:
            showAlert(message: Message.unknownError)
            return
        }
    }
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        guard let productView = collectionView as? ProductsCollectionView else {
            return CGSize()
        }
        if dataSource.currentCellIdentifier == ProductCell.listIdentifier {
            return productView.cellSize(numberOFItemsRowAt: .portraitList)
        } else {
            return UIDevice.current.orientation.isLandscape ?
            productView.cellSize(numberOFItemsRowAt: .landscapeGrid) :
            productView.cellSize(numberOFItemsRowAt: .portraitGrid)
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        guard let productView = collectionView as? ProductsCollectionView else {
            return UIEdgeInsets()
        }
        return dataSource.currentCellIdentifier == ProductCell.listIdentifier ?
        productView.listSectionInset : productView.gridSectionInset
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        guard let productView = collectionView as? ProductsCollectionView else {
            return CGFloat()
        }
        return dataSource.currentCellIdentifier == ProductCell.listIdentifier ?
        productView.listMinimumLineSpacing : productView.gridMinimumLineSpacing
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        guard let productView = collectionView as? ProductsCollectionView else {
            return CGFloat()
        }
        return dataSource.currentCellIdentifier == ProductCell.listIdentifier ?
        productView.listminimumInteritemSpacing : productView.gridminimumInteritemSpacing
    }
}

extension MainViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentHeight = scrollView.contentSize.height
        let yOffset = scrollView.contentOffset.y
        let remainBottomHeight = contentHeight - yOffset
        let frameHeight = scrollView.frame.size.height
        if remainBottomHeight < frameHeight ,
           let products = dataSource.products, products.hasNext, products.pageNumber == dataSource.currentPage {
            dataSource.currentPage += 1
            self.requestProducts {
                self.dataSource.appendProducts(products.pages)
                self.collectionViewReload()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: SegueIdentifier.productDetailView, sender: dataSource.productList[indexPath.item])
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is UINavigationController {
            return
        } else if let product = sender as? Product,
                  let nextViewController = segue.destination as? DetailViewController {
            nextViewController.requestDetail(productId: UInt(product.id))
            nextViewController.setUpTitle(product.name)
        } else {
            showAlert(message: AlertMessage.dataDeliveredFail, completion: nil)
        }
    }
}
