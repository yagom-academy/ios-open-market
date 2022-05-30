//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class MainViewController: UIViewController {
  enum Section {
    case main
  }
  
  private enum Constants {
    static let itemsPerView: Double = 10.0
    static let itemsPerPage: Int = 20
  }
  
  typealias DataSource = UICollectionViewDiffableDataSource<Section, Page>
  typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Page>
  
  private let apiProvider = HttpProvider()
  private lazy var collectionView = CollectionView()
  private lazy var editingView = EditingView()
  private lazy var dataSource = makeDataSource()
  private var currentPageNumber = 1
  private var productsList:PageInformation?
  private var pages: [Page] = [] {
    didSet {
      DispatchQueue.main.async {
        self.applySnapshot()
      }
    }
  }
  
  private lazy var segmentedControl: UISegmentedControl = {
    let segment = UISegmentedControl(items: [Layout.list.string, Layout.grid.string])
    segment.selectedSegmentIndex = Layout.list.rawValue
    segment.addTarget(self,
                      action: #selector(changeCollectionViewLayout(_:)),
                      for: .valueChanged)
    return segment
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureView()
    configureNavigationBar()
    applySnapshot(animatingDifferences: false)
    collectionView.delegate = self
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    self.currentPageNumber = 1
    self.pages.removeAll()
    self.fetchPages()
  }
  
  private func fetchPages() {
    apiProvider.get(.productList(pageNumber: currentPageNumber, itemsPerPage: 20)) { data in
      guard let data = try? data.get() else {
        return
      }
      guard let products = try? JSONDecoder().decode(PageInformation.self, from: data) else {
        return
      }
      self.productsList = products
      self.pages += products.pages
    }
  }
  
  private func configureView() {
    self.view.addSubview(collectionView)
    self.view.backgroundColor = .white
    collectionView.configureCollectionView()
  }
  
  private func configureNavigationBar() {
    navigationController?.navigationBar.backgroundColor = .lightGray
    navigationController?.navigationBar.scrollEdgeAppearance = UINavigationBarAppearance()
    navigationItem.titleView = segmentedControl
    navigationItem.rightBarButtonItem = .init(barButtonSystemItem: .add,
                                              target: self,
                                              action: #selector(presentRegistrationViewController))
  }
  
  @objc private func presentRegistrationViewController() {
    let registrationVC = RegistrationViewController()
    let navigationController = UINavigationController(rootViewController: registrationVC)
    navigationController.modalPresentationStyle = .fullScreen
    present(navigationController, animated: true, completion: nil)
  }
  
  @objc private func changeCollectionViewLayout(_ sender: UISegmentedControl) {
    switch sender.selectedSegmentIndex {
    case Layout.list.rawValue:
      collectionView.currentLayout = .list
    case Layout.grid.rawValue:
      collectionView.currentLayout = .grid
    default:
      return
    }
  }
}
// MARK: - DataSource
extension MainViewController {
  private func makeDataSource() -> DataSource {
    let dataSource = DataSource(
      collectionView: collectionView,
      cellProvider: {(collectionView, indexPath, page) -> UICollectionViewCell? in
        
        switch self.segmentedControl.selectedSegmentIndex {
        case Layout.list.rawValue:
          guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ListCell.identifier,
            for: indexPath
          ) as? ListCell
          else {
            return nil
          }
          DispatchQueue.main.async {
            if collectionView.indexPath(for: cell) == indexPath {
              cell.setUpListCell(page: page)
            }
          }
          return cell
          
        case Layout.grid.rawValue:
          guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: GridCell.identifier,
            for: indexPath
          ) as? GridCell
          else {
            return nil
          }
          DispatchQueue.main.async {
            if collectionView.indexPath(for: cell) == indexPath {
              cell.setUpGridCell(page: page)
            }
          }
          return cell
          
        default:
          return nil
        }
      })
    return dataSource
  }
  
  private func applySnapshot(animatingDifferences: Bool = true) {
    var snapshot = Snapshot()
    snapshot.appendSections([.main])
    snapshot.appendItems(pages)
    dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
  }
}
// MARK: - ViewController Delegate
extension MainViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let detailViewController = DetailViewController()
    detailViewController.receiveInformation(for: pages[indexPath.row].id)
    navigationController?.pushViewController(detailViewController, animated: false)
  }
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let contentOffsetY = scrollView.contentOffset.y
    let collectionViewContentSize = self.collectionView.contentSize.height
    let paginationY = collectionViewContentSize * (Constants.itemsPerView / CGFloat(pages.count))
    
    if contentOffsetY > collectionViewContentSize - paginationY {
      currentPageNumber += 1
      fetchPages()
    }
  }
}
