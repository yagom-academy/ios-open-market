//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

@available(iOS 14.0, *)
class ViewController: UIViewController {
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var viewModeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var itemDetailButton: UIBarButtonItem!
    
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
        self.view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
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
    
    private func changeNumberStyleToComma(_ number: Int) -> String? {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        return numberFormatter.string(for: number)
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
        
            let group = DispatchGroup()
            group.enter()
            
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: URL(string: item.thumbnails![0])!)
                
                DispatchQueue.main.async {
                    cell?.thumbnailImageView.image = UIImage(data: data!)
                }
                
                group.leave()
                
                DispatchQueue.main.async {
                    self.activityIndicator.isHidden = true
                    self.activityIndicator.stopAnimating()
                }
            }
            
            guard let price = item.price else { return nil }
            guard let formattedPrice = self.changeNumberStyleToComma(price) else { return nil }
            guard let currency = item.currency else { return nil }
            
            cell?.titleLabel.text = item.title
            
            if item.discountedPrice == nil {
                cell?.priceLabel.attributedText = NSAttributedString(
                    string: "\(currency) \(formattedPrice)"
                )
                cell?.priceLabel.textColor = .gray
                cell?.discountedPriceLabel.isHidden = true
            } else {
                guard let discountedPrice = item.discountedPrice else { return nil }
                guard let formattedDiscountedPrice = self.changeNumberStyleToComma(discountedPrice) else { return nil }
                cell?.priceLabel.attributedText = "\(currency) \(formattedPrice)".strikeThrough()
                cell?.priceLabel.textColor = .red
                cell?.discountedPriceLabel.text = currency + " \(formattedDiscountedPrice)"
                cell?.discountedPriceLabel.textColor = .gray
            }
            
            guard let stock = item.stock else {
                cell?.stockLabel.text = "정보 없음"
                return nil
            }
            
            cell?.stockLabel.textColor = .gray
            if stock > 999 {
                cell?.stockLabel.text = "잔여수량 : 999+"
            } else if stock == 0 {
                cell?.stockLabel.text = "품절"
                cell?.stockLabel.textColor = .orange
            } else {
                cell?.stockLabel.text = "잔여수량 : " + "\(item.stock!)"
            }
            
            return cell as? UICollectionViewCell
        }
        
        guard snapshot.numberOfItems == 0 else {
            let listCellNibName = UINib(nibName: "ListCollectionViewCell", bundle: nil)
            let gridCellNibName = UINib(nibName: "GridCollectionViewCell", bundle: nil)
            collectionView.register(listCellNibName, forCellWithReuseIdentifier: "ListCollectionViewCell")
            collectionView.register(gridCellNibName, forCellWithReuseIdentifier: "GridCollectionViewCell")
            self.dataSource.apply(self.snapshot, animatingDifferences: false)
            return
        }

        self.snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.main])
        
        currentPage += 1
        loadItems(from: currentPage, networkManager)
    }
    
    @IBAction func onClickSegmentedControl(_ sender: UISegmentedControl) {
        viewDidLoad()
    }
}

@available(iOS 14.0, *)
extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        print(self.snapshot.numberOfItems, indexPath.row)
        print(currentPage)
        if indexPath.row == self.snapshot.numberOfItems - 18 {
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

