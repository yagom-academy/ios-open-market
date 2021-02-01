//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {
    enum SegmentValueTypes: Int, CaseIterable {
        case list = 0
        case grid
        
        var valueString: String {
            switch self {
            case .list:
                return "List"
            case .grid:
                return "Grid"
            }
        }
    }
    
    // MARK: - IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var segment: UISegmentedControl!
    
    private lazy var collectionViewLayouts: [UICollectionViewFlowLayout] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSegment()
        setUpCollectionViewLayouts()
        setUpCollection()
    }
    
    // MARK: - setUp Segment
    private func setUpSegment() {
        for (index, element) in SegmentValueTypes.allCases.enumerated() {
            segment.setTitle(element.valueString, forSegmentAt: index)
        }
        segment.addTarget(self, action: #selector(changedSegmentValue(_:)), for: .valueChanged)
    }
    
    @objc func changedSegmentValue(_ sender: UISegmentedControl) {
        collectionView.collectionViewLayout = collectionViewLayouts[sender.selectedSegmentIndex]
        self.collectionView.reloadData()
    }
    
    // MARK: - setUp CollectionView
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
}
