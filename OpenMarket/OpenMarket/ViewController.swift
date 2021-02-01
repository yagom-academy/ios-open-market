//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {
    enum SegmentValueTypes: String, CaseIterable {
        case list = "List"
        case grid = "Grid"
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var segment: UISegmentedControl!
    
    private lazy var collectionViewLayouts: [UICollectionViewFlowLayout] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSegment()
        setUpCollectionViewLayouts()
        setUpCollection()
    }
    
    // MARK: - setUp UI
    private func setUpSegment() {
        for (index, element) in SegmentValueTypes.allCases.enumerated() {
            segment.setTitle(element.rawValue, forSegmentAt: index)
        }
        segment.addTarget(self, action: #selector(changedSegmentValue(_:)), for: .valueChanged)
    }
    
    private func setUpCollectionViewLayouts() {
        for valueType in SegmentValueTypes.allCases {
            switch valueType {
            case .list:
                collectionViewLayouts.append(makeListCollectionViewLayout())
            case .grid:
                collectionViewLayouts.append(makeGridCollectionViewLayout())
            }
        }
    }
    
    private func makeListCollectionViewLayout() -> UICollectionViewFlowLayout {
        return UICollectionViewFlowLayout()
    }
    
    private func makeGridCollectionViewLayout() -> UICollectionViewFlowLayout {
        return UICollectionViewFlowLayout()
    }
    
    private func setUpCollection() {
        // TODO: Lasagna - CollectionView List Type cell regist
        // TODO: Joons - CollectionVIew Grid Type cell Regist
    }
    
    @IBAction func touchUpAddButton(_ sender: UIButton) {
        // TODO: add logic in step3
        print("➕")
    }
    
    @objc func changedSegmentValue(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            print("click list")
        case 1:
            print("click grid")
        default:
            self.showErrorAlert(with: OpenMarketError.unknown, okHandler: nil)
        }
    }
}
