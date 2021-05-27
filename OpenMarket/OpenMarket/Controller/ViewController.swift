//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

@available(iOS 14.0, *)
class ViewController: UIViewController {
    @IBOutlet weak var viewModeSegmentedControl: UISegmentedControl!
    
    enum Section {
        case main
    }

    var dataSource: UICollectionViewDiffableDataSource<Section, Item>! = nil
    var collectionView: UICollectionView! = nil
    var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
    let networkManager = NetworkManager(.shared)
    var currentPage: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        let listCellNibName = UINib(nibName: "ListCollectionViewCell", bundle: nil)
        let gridCellNibName = UINib(nibName: "GridCollectionViewCell", bundle: nil)
        configureHierarchy()
        configureDataSource()
        collectionView.register(listCellNibName, forCellWithReuseIdentifier: "ListCollectionViewCell")
        collectionView.register(gridCellNibName, forCellWithReuseIdentifier: "GridCollectionViewCell")
        
        self.collectionView.delegate = self
    }
}

@available(iOS 14.0, *)
extension ViewController {
    private func createListViewLayout() -> UICollectionViewLayout {
        let config = UICollectionLayoutListConfiguration(appearance: .plain)
        return UICollectionViewCompositionalLayout.list(using: config)
    }
    
    private func createGridViewLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(0.35))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        let spacing = CGFloat(10)
        group.interItemSpacing = .fixed(spacing)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = spacing
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}

@available(iOS 14.0, *)
extension ViewController {
    private func configureHierarchy() {
        if viewModeSegmentedControl.selectedSegmentIndex == 0 {
            collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createListViewLayout())
        } else {
            collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createGridViewLayout())
        }
        
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .white
        view.addSubview(collectionView)
    }
    
    func loadItems(from page: Int, _ networkManager: NetworkManager) {
        
        networkManager.request(ItemList.self, url: OpenMarketURL.viewItemList(page).url) { result in
            switch result {
            case .success(let itemList):
                if itemList.items.isEmpty { return }
                
                self.snapshot.appendItems(itemList.items)
                self.dataSource.apply(self.snapshot, animatingDifferences: false)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, item: Item) -> UICollectionViewCell? in
            var cell: OpenMarketCell?
            
            if self.viewModeSegmentedControl.selectedSegmentIndex == 0 {
                cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ListCollectionViewCell", for: indexPath) as! ListCollectionViewCell
            } else {
                cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GridCollectionViewCell", for: indexPath) as! GridCollectionViewCell
                cell?.layer.borderWidth = 1.5
                cell?.layer.borderColor = UIColor.lightGray.cgColor
                cell?.layer.cornerRadius = 10
            }
        
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: URL(string: item.thumbnails![0])!)
                
                DispatchQueue.main.async {
                    cell?.thumbnailImageView.image = UIImage(data: data!)
                    cell?.titleLabel.text = item.title
                    
                    if item.discountedPrice == nil {
                        cell?.priceLabel.attributedText = NSAttributedString(
                            string: "\(item.currency!) \(item.price!)"
                        )
                        cell?.discountedPriceLabel.isHidden = true
                    } else {
                        cell?.priceLabel.attributedText = "\(item.currency!) \(item.price!)".strikeThrough()
                        cell?.priceLabel.textColor = .red
                        cell?.discountedPriceLabel.text = item.currency! + " \(item.discountedPrice!)"
                    }
                    
                    guard let stock = item.stock else {
                        cell?.stockLabel.text = "정보 없음"
                        return
                    }
                    
                    if stock > 999 {
                        cell?.stockLabel.text = "잔여수량 : 999+"
                    } else if stock == 0 {
                        cell?.stockLabel.text = "품절"
                        cell?.stockLabel.textColor = .orange
                    } else {
                        cell?.stockLabel.text = "잔여수량 : " + "\(item.stock!)"
                    }
                }
            }
            
            return cell as? UICollectionViewCell
        }

        self.snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.main])
        
//        networkManager.request(ItemList.self, url: OpenMarketURL.viewItemList(1).url) { result in
//            switch result {
//            case .success(let itemList):
//                self.snapshot.appendItems(itemList.items)
//                self.dataSource.apply(self.snapshot, animatingDifferences: false)
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//        }
        
        currentPage += 1
        loadItems(from: currentPage, networkManager)
    }
    
    @IBAction func onClickSegmentedControl(_ sender: UISegmentedControl) {
        viewDidLoad()
    }
}

@available(iOS 14.0, *)
extension ViewController: UICollectionViewDelegate {
//    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//
//    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        print(self.snapshot.numberOfItems, indexPath.row)
        print(currentPage)
        if indexPath.row == self.snapshot.numberOfItems - 14 {
            currentPage += 1
            loadItems(from: currentPage, networkManager)
        }
    }
    
}

extension String {
    func strikeThrough() -> NSAttributedString {
        let attributeString = NSMutableAttributedString(string: self)
        attributeString.addAttribute(
            NSAttributedString.Key.strikethroughStyle,
            value: NSUnderlineStyle.single.rawValue,
            range: NSMakeRange(0,attributeString.length))
        return attributeString
    }
}

