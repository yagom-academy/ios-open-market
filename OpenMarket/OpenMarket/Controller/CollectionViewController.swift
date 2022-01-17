//
//  CollectionViewController.swift
//  OpenMarket
//
//  Created by 박병호 on 2022/01/11.
//

import UIKit

protocol CollectionViewCell: UICollectionViewCell {
  var productImageView: UIImageView! { get set }
  var productNameLabel: UILabel! { get set }
  var productBargainPriceLabel: UILabel! { get set }
  var productStockLabel: UILabel! { get set }
  var productFixedPriceLabel: UILabel! { get set }
  func setCellImage(image: UIImage?)
  func setCellData(product: Product)
}

private enum Section: Hashable {
  case productList
  case productGrid
}

enum CellType {
  case list
  case grid
  
  var segmentedControlIndex: Int {
    switch self {
    case .list:
      return 0
    case .grid:
      return 1
    }
  }
}

class CollectionViewController: UIViewController {
  @IBOutlet private weak var segmentControl: UISegmentedControl!
  @IBOutlet private weak var collectionView: UICollectionView!
  
  private var dataSource: UICollectionViewDiffableDataSource<Section, Product>? = nil
  private let api = APIManager(urlSession: URLSession(configuration: .default), jsonParser: JSONParser())
  private var products: [Product] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    collectionView.delegate = self
    LoadingIndicator.showLoading()
    registerNib()
    fetchProducts()
  }
  
  @IBAction private func touchUpPresentingSegment(_ sender: UISegmentedControl) {
    switch sender.selectedSegmentIndex {
    case CellType.list.segmentedControlIndex:
      configureListViewDataSource(cellType: .list)
    case CellType.grid.segmentedControlIndex:
      configureListViewDataSource(cellType: .grid)
    default:
      return
    }
  }
  
  private func registerNib() {
    let productCollectionViewListCellNib =  UINib(nibName: ProductCollectionViewListCell.nibName, bundle: nil)
    self.collectionView.register(productCollectionViewListCellNib, forCellWithReuseIdentifier: ProductCollectionViewListCell.reuseIdentifier)
    let productCollectionViewGridCellNib =  UINib(nibName: ProductCollectionViewGridCell.nibName, bundle: nil)
    self.collectionView.register(productCollectionViewGridCellNib, forCellWithReuseIdentifier: ProductCollectionViewGridCell.reuseIdentifier)
  }
  
  private func fetchProducts() {
    api.productList(pageNumber: 1, itemsPerPage: 20) { [self] response in
      switch response {
      case .success(let data):
        products = data.pages
        DispatchQueue.main.async {
          configureListViewDataSource(cellType: .list)
          LoadingIndicator.hideLoading()
        }
      case .failure(let error):
        print(error)
        DispatchQueue.main.async {
          showAlert(message: error.errorDescription)
        }
      }
    }
  }
}

extension CollectionViewController {
  private func configureListViewDataSource(cellType: CellType) {
    var currentIdentifier: String {
      switch cellType {
      case .list:
        return ProductCollectionViewListCell.reuseIdentifier
      case .grid:
        return ProductCollectionViewGridCell.reuseIdentifier
      }
    }
    
    dataSource = UICollectionViewDiffableDataSource<Section, Product>(collectionView: collectionView) { [self]
      (
        collectionView: UICollectionView,
        indexPath: IndexPath, item: Product
      ) -> UICollectionViewCell? in
      guard let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: currentIdentifier,
        for: indexPath
      ) as? CollectionViewCell else {
        return UICollectionViewCell()
      }
      
      api.requestProductImage(url: item.thumbnail) { response in
        switch response {
        case .success(let data):
          let image = UIImage(data: data)
          DispatchQueue.main.async {
            cell.setCellImage(image: image)
          }
        case .failure(_):
          let image = UIImage(named: "nosign")
          DispatchQueue.main.async {
            cell.setCellImage(image: image)
          }
        }
      }
      cell.setCellData(product: item)
      
      return cell
    }
    var snapshot = NSDiffableDataSourceSnapshot<Section, Product>()
    snapshot.appendSections([.productList])
    snapshot.appendItems(products)
    dataSource?.apply(snapshot, animatingDifferences: false)
  }
}

extension CollectionViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    let width = collectionView.frame.width
    
    switch segmentControl.selectedSegmentIndex {
    case CellType.list.segmentedControlIndex:
      return LayoutConstant.cellSize(cellType: .list, width: width)
    case CellType.grid.segmentedControlIndex:
      return LayoutConstant.cellSize(cellType: .grid, width: width)
    default:
      return CGSize()
    }
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    insetForSectionAt section: Int
  ) -> UIEdgeInsets {
    switch segmentControl.selectedSegmentIndex {
    case CellType.list.segmentedControlIndex:
      return LayoutConstant.insetForSectionAtList
    case CellType.grid.segmentedControlIndex:
      return LayoutConstant.insetForSectionAtGrid
    default:
      return UIEdgeInsets()
    }
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    minimumLineSpacingForSectionAt section: Int
  ) -> CGFloat {
    switch segmentControl.selectedSegmentIndex {
    case CellType.list.segmentedControlIndex:
      return LayoutConstant.minimumLineSpacingForSectionAtList
    case CellType.grid.segmentedControlIndex:
      return LayoutConstant.minimumLineSpacingForSectionAtGrid
    default:
      return CGFloat()
    }
  }
}
