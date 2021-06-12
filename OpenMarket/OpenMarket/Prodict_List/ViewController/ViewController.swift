//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class CollectionViewController: UIViewController {
    let segmentedControl = SegmentedControl()
    let collectionView = CollectionView(frame: .zero, flowlayout: UICollectionViewFlowLayout())
    var isListView: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.titleView = segmentedControl
        self.view.backgroundColor = .white

        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.configureCollectionView(viewController: self)
        
        self.segmentedControl.addTarget(self,
                                        action: #selector(changed),
                                        for: .valueChanged)
    }
    
    @objc func changed() {
        switch self.segmentedControl.selectedSegmentIndex {
        case 0:
            self.isListView = true
        case 1: self.isListView = false
        default: return
        }
        
        self.collectionView.reloadData()
    }
}

extension CollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell: UICollectionViewCell
        var items: Items = handleResult(result: parseData())
        
        if isListView {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCellForList.identifier, for: indexPath)
        } else {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCellForGrid.identifier, for: indexPath)
        }

        return cell
    }
    
    func parseData() -> Result<Items, NetworkError> {
        guard let data = NSDataAsset(name: "items")?.data else { return .failure(.receiveError) }
        guard let parsedData = try? JSONDecoder().decode(Items.self, from: data) else { return .failure(.receiveError) }
        
        return .success(parsedData)
    }
    
    func handleResult(result: Result<Items, NetworkError>) -> Items {
        switch result {
        case .failure: print("에러남")
        case .success(let data):
            return data
        }
    }
}

extension CollectionViewController: UICollectionViewDelegate {}

extension CollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var widthSize: CGFloat
        var heightSize: CGFloat
        
        if isListView {
            widthSize = view.frame.width - 10
            heightSize = widthSize * 0.25
        } else {
            widthSize = ((view.frame.width - 20) / 2)
            heightSize = widthSize  * 1.3
            
            if widthSize > 200 {
                widthSize = 160
            }
        }

        return CGSize(width: widthSize, height: heightSize)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
}
