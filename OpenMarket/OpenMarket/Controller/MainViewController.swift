//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class MainViewController: UIViewController {
    private let networkManager = NetworkManager()
    private var currentPage = 1
    private let itemsPerPage = 20
    private var items = [Item]()
    private var isPageRfreshing: Bool = true
    
    private var collectionView: UICollectionView! = nil
    private let gridLayout = GridFlowLayout()
    private var activityIndicatorView = UIActivityIndicatorView()
    private let segment = UISegmentedControl(items: ["List", "Grid"])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        configureSegment()
        configureLoadingView()
        self.activityIndicatorView.startAnimating()
        fetchData()
    }
    
    private func fetchData() {
        isPageRfreshing = false
        networkManager.fetchItmeList(pageNumber: currentPage, itemsPerPage: itemsPerPage) { result in
            switch result {
            case .success(let responseData):
                guard let data = responseData,
                      let itemData: ItemList = JSONDecoder.decodeJson(jsonData: data) else { return }
                itemData.pages.forEach { item in
                    self.items.append(item)
                }
                
                DispatchQueue.main.async {
                    if self.currentPage == 1 {
                        self.configureListCollectionView()
                    }
                    self.collectionView.reloadData()
                    let indexPath = Array(0..<(self.currentPage * self.itemsPerPage)).map { IndexPath(item: $0, section: 0) }
                    self.collectionView.reloadItems(at: indexPath)
                    self.activityIndicatorView.stopAnimating()
                    self.isPageRfreshing = true
                }
            default:
                return
            }
        }
    }
}
//MARK: SegmentControl
extension MainViewController {
    private func configureSegment() {
        self.navigationItem.titleView = segment
        segment.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        segment.setTitleTextAttributes([.foregroundColor: UIColor.systemBlue], for: .normal)
        segment.frame.size.width = view.bounds.width * 0.3
        segment.setWidth(view.bounds.width * 0.15, forSegmentAt: 0)
        segment.setWidth(view.bounds.width * 0.15, forSegmentAt: 1)
        segment.layer.borderWidth = 1.0
        segment.layer.borderColor = UIColor.systemBlue.cgColor
        segment.selectedSegmentTintColor = .systemBlue
        segment.selectedSegmentIndex = 0
        segment.addTarget(self, action: #selector(tapSegment(sender:)), for: .valueChanged)
    }
    
    @objc private func tapSegment(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            collectionView.setCollectionViewLayout(createListLayout(), animated: true)
            DispatchQueue.main.async { [self] in
                let indexPath = Array(0..<(currentPage * itemsPerPage)).map { IndexPath(item: $0, section: 0) }
                collectionView.reloadItems(at: indexPath)
            }
        case 1:
            collectionView.setCollectionViewLayout(gridLayout, animated: true)
            DispatchQueue.main.async { [self] in
                let indexPath = Array(0..<(currentPage * itemsPerPage)).map { IndexPath(item: $0, section: 0) }
                collectionView.reloadItems(at: indexPath)
            }
        default:
            return
        }
    }
}
//MARK: LoadingView
extension MainViewController {
    private func configureLoadingView() {
        activityIndicatorView = UIActivityIndicatorView(style: .large)
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(activityIndicatorView)

        NSLayoutConstraint.activate([
            activityIndicatorView.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerYAnchor)
        ])
    }
}
//MARK: ListFlowLayout
extension MainViewController {
    private func createListLayout() -> UICollectionViewLayout {
        let listLayout = UICollectionViewFlowLayout()
        listLayout.minimumLineSpacing = 5
        
        return listLayout
    }
    
    private func configureListCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createListLayout())
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.decelerationRate = .fast
        collectionView.register(ListCollectionViewCell.self, forCellWithReuseIdentifier: "ListCell")
        collectionView.register(GridCollectionViewCell.self, forCellWithReuseIdentifier: "GridCell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 5),
            collectionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -5),
            collectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
//MARK: DataSource
extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentPage * itemsPerPage
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if segment.selectedSegmentIndex == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ListCell", for: indexPath)
                    as? ListCollectionViewCell else { return UICollectionViewCell() }
            cell.resetContent()
            cell.configureContent(item: items[indexPath.row])
            return cell
        }
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GridCell", for: indexPath)
                as? GridCollectionViewCell else { return UICollectionViewCell() }
        cell.resetContent()
        cell.configureContent(item: items[indexPath.row])
        return cell
    }
}
//MARK: FlowLayoutDelegate
extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let gridLayout = collectionViewLayout as? GridFlowLayout {
            let widthOfCells = collectionView.bounds.width - (collectionView.contentInset.left + collectionView.contentInset.right)
            let widthOfSpacing = CGFloat(gridLayout.numberOfColumns - 1) * gridLayout.minimumInteritemSpacing
            let width = (widthOfCells - widthOfSpacing) / CGFloat(gridLayout.numberOfColumns)
            let height = collectionView.bounds.height * 0.35

            return CGSize(width: width, height: height)
        }
        
        let itemSize = CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height * 0.1)
        return itemSize
    }
}
//MARK: Paging
extension MainViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard collectionView.contentSize.height > 0 else { return }
        if collectionView.contentOffset.y > (collectionView.contentSize.height - collectionView.frame.height) {
            if isPageRfreshing {
                self.currentPage += 1
                activityIndicatorView.startAnimating()
                fetchData()
            }
        }
    }
}
