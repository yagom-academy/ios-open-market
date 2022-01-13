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

  override func viewDidLoad() {
    super.viewDidLoad()
    collectionView.dataSource = self
    collectionView.delegate = self
    
    let productCollectionViewGridCellNib =  UINib(nibName: "ProductCollectionViewGridCell", bundle: nil)
    self.collectionView.register(productCollectionViewGridCellNib, forCellWithReuseIdentifier: "ProductCollectionViewGridCell")
  }
}

extension CollectionViewController {
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
  }
}

extension CollectionViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 10
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCollectionViewGridCell", for: indexPath) as? ProductCollectionViewGridCell else {
      return UICollectionViewCell()
    }
    api.productList(pageNumber: 1, itemsPerPage: 10) { response in
      switch response {
      case .success(let data):
        let product = data.pages[indexPath.item]
        guard let imageURL = URL(string: product.thumbnail) else {
          return
        }
        guard let imageData = try? Data(contentsOf: imageURL), let image = UIImage(data: imageData) else {
          return
        }
        DispatchQueue.main.async {
          cell.insertCellData(image: image, name: product.name, fixedPrice: product.fixedPrice, bargainPrice: product.getBargainPrice, stock: product.getStock)
        }
      case .failure(let error):
        print(error)
      }
    }
    return cell
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
