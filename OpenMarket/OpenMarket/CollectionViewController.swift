//
//  CollectionViewController.swift
//  OpenMarket
//
//  Created by 박병호 on 2022/01/11.
//

import UIKit

private enum Section: Hashable {
  case main
}

class CollectionViewController: UIViewController {
  
  @IBOutlet weak var segmentControl: UISegmentedControl!
  @IBOutlet weak var collectionView: UICollectionView!
  
  private var dataSource: UICollectionViewDiffableDataSource<Section, Product>? = nil
  
  let api = APIManager(urlSession: URLSession(configuration: .default))
  var products: [Product] = []

  override func viewDidLoad() {
    super.viewDidLoad()
    let productCollectionViewGridCellNib =  UINib(nibName: "ProductCollectionViewGridCell", bundle: nil)
    self.collectionView.register(productCollectionViewGridCellNib, forCellWithReuseIdentifier: "ProductCollectionViewGridCell")
    fetchProducts()
    collectionView.delegate = self
    
  }
  
  func fetchProducts() {
    api.productList(pageNumber: 1, itemsPerPage: 10) { response in
      switch response {
      case .success(let data):
        self.products = data.pages
        DispatchQueue.main.async {
          self.configureGridViewDataSource()
          self.collectionView.collectionViewLayout = self.createGridViewLayout()
        }
      case .failure(let error):
        print(error)
      }
    }
  }
}

extension CollectionViewController {
  private func createGridViewLayout() -> UICollectionViewLayout {
    let layout = UICollectionViewCompositionalLayout {
      (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
      let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
      let item = NSCollectionLayoutItem(layoutSize: itemSize)
      item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10)
      
      let groupHeight = NSCollectionLayoutDimension.fractionalWidth(0.677)
      let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: groupHeight)
      
      let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
      let section = NSCollectionLayoutSection(group: group)
      section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0)
      
      return section
    }
    
    
    return layout
  }
  
  private func configureGridViewDataSource() {
    dataSource = UICollectionViewDiffableDataSource<Section, Product>(collectionView: collectionView) {
      (collectionView: UICollectionView, indexPath: IndexPath, item: Product) -> UICollectionViewCell? in
      guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCollectionViewGridCell", for: indexPath) as? ProductCollectionViewGridCell else {
        return UICollectionViewCell()
      }
      
      guard let imageUrl = URL(string: item.thumbnail),
        let imageData = try? Data(contentsOf: imageUrl),
        let image = UIImage(data: imageData) else {
          return UICollectionViewCell()
      }
      
      cell.insertCellData(image: image, name: item.name, fixedPrice: item.fixedPrice, bargainPrice: item.getBargainPrice, stock: item.getStock)
      
      return cell
    }
    var snapshot = NSDiffableDataSourceSnapshot<Section, Product>()
    snapshot.appendSections([.main])
    snapshot.appendItems(products)
    dataSource?.apply(snapshot, animatingDifferences: false)
  }
}

extension CollectionViewController: UICollectionViewDelegate {
  
}

extension CollectionViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let width = collectionView.frame.width
    let size = CGSize(width: width / 2.1, height: width / 1.65)
    
    return size
  }
}
