//
//  CollectionViewController.swift
//  OpenMarket
//
//  Created by 박병호 on 2022/01/11.
//

import UIKit

private enum Section: Hashable {
  case products
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

class ProductCollectionViewController: UIViewController {
  @IBOutlet private weak var segmentControl: UISegmentedControl!
  @IBOutlet private weak var collectionView: UICollectionView!
  
  private var dataSource: UICollectionViewDiffableDataSource<Section, Product>? = nil
  private let api = APIManager(urlSession: URLSession(configuration: .default), jsonParser: JSONParser())
  private var productsPage: ProductList?
  private var products: [Product] = []
  private var productImage: UIImage?
  private var currentPage = 1
  
  private let refreshContol = UIRefreshControl()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    LoadingIndicator.showLoading()
    registerNib()
    refreshAnimate()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    refreshData(cellType: currentCellType())
  }
  
  @IBAction private func plusButtonDidTap(_ sender: Any) {
    let presentStoryBoard = UIStoryboard(
      name: ProductRegistrationModificationViewController.stroyBoardName,
      bundle: nil
    )
    guard let presentViewController = presentStoryBoard.instantiateViewController(
      withIdentifier: ProductRegistrationModificationViewController.reuseIdentifier
    ) as? ProductRegistrationModificationViewController else {
      return
    }
    presentViewController.viewMode = .registation
    self.navigationController?.pushViewController(presentViewController, animated: true)
  }
  
  @IBAction private func touchUpPresentingSegment(_ sender: UISegmentedControl) {
    configureListViewDataSource(cellType: currentCellType())
  }
  
  @objc private func handleRefresh(sender: AnyObject) {
    refreshData(cellType: currentCellType())
    self.collectionView.refreshControl?.endRefreshing()
  }
  
  private func registerNib() {
    let productCollectionViewListCellNib = UINib(
      nibName: ProductCollectionViewListCell.nibName,
      bundle: nil
    )
    let productCollectionViewGridCellNib = UINib(
      nibName: ProductCollectionViewGridCell.nibName,
      bundle: nil
    )
    self.collectionView.register(
      productCollectionViewListCellNib,
      forCellWithReuseIdentifier: ProductCollectionViewListCell.reuseIdentifier
    )
    self.collectionView.register(
      productCollectionViewGridCellNib,
      forCellWithReuseIdentifier: ProductCollectionViewGridCell.reuseIdentifier
    )
  }
  
  private func refreshAnimate() {
    let refreshControl = UIRefreshControl()
    refreshControl.tintColor = UIColor.darkGray
    refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
    self.collectionView.refreshControl = refreshControl
  }
  
  private func refreshData(cellType: CellType) {
    products.removeAll()
    fetchProducts(pageNumber: 1, cellType: cellType)
  }
  
  private func currentCellType() -> CellType {
    if segmentControl.selectedSegmentIndex == 0 {
      return CellType.list
    } else {
      return CellType.grid
    }
  }
  
  private func fetchProducts(pageNumber: Int, cellType: CellType) {
    api.productList(pageNumber: pageNumber, itemsPerPage: 20) { [self] response in
      switch response {
      case .success(let data):
        productsPage = data
        products.append(contentsOf: data.pages)
        DispatchQueue.main.async {
          configureListViewDataSource(cellType: cellType)
          LoadingIndicator.hideLoading()
        }
      case .failure(let error):
        print(error)
        DispatchQueue.main.async {
          showAlert(message: error.localizedDescription)
        }
      }
    }
  }
}

extension ProductCollectionViewController: UICollectionViewDelegate {
  func collectionView(
    _ collectionView: UICollectionView,
    willDisplay cell: UICollectionViewCell,
    forItemAt indexPath: IndexPath
  ) {
    if products.count - 1 == indexPath.item, productsPage?.hasNext == true {
      currentPage += 1
      fetchProducts(pageNumber: currentPage, cellType: currentCellType())
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let presentStoryBoard = UIStoryboard(
      name: ProductDetailViewController.stroyBoardName,
      bundle: nil
    )
    guard let presentViewController = presentStoryBoard.instantiateViewController(
      withIdentifier: ProductDetailViewController.reuseIdentifier
    ) as? ProductDetailViewController else {
      return
    }
    presentViewController.product = products[indexPath.row]
    self.navigationController?.pushViewController(presentViewController, animated: true)
  }
}

extension ProductCollectionViewController {
  private func configureListViewDataSource(cellType: CellType) {
    var currentCellIdentifier: String {
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
        withReuseIdentifier: currentCellIdentifier,
        for: indexPath
      ) as? ProductCollectionViewCell else {
        return UICollectionViewCell()
      }
      
      api.requestProductImage(url: item.thumbnail) { response in
        switch response {
        case .success(let data):
          let image = UIImage(data: data)
          DispatchQueue.main.async {
            if indexPath == collectionView.indexPath(for: cell) {
              cell.setCellImage(image: image)
            }
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
    snapshot.appendSections([.products])
    snapshot.appendItems(products)
    dataSource?.apply(snapshot, animatingDifferences: false)
  }
}

extension ProductCollectionViewController: UICollectionViewDelegateFlowLayout {
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
