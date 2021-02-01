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
        setUpCollectionViewLayouts()
        setUpCollection()
        setUpSegment()
    }
    
    // MARK: - setUp Segment
    private func setUpSegment() {
        for (index, element) in SegmentValueTypes.allCases.enumerated() {
            segment.setTitle(element.valueString, forSegmentAt: index)
        }
        segment.addTarget(self, action: #selector(changedSegmentValue(_:)), for: .valueChanged)
    }
    
    @objc func changedSegmentValue(_ sender: UISegmentedControl) {
        reloadCollectionView()
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
        // TODO: Lasagna - add CollectionView List Type Layout
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = CGSize(width: UIScreen.main.bounds.width, height: 90)
        return layout
    }
    
    private func makeGridCollectionViewLayout() -> UICollectionViewFlowLayout {
        // TODO: Joons - add CollectionView Grid Type Layout
        // This is test layout code
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = CGSize(width: UIScreen.main.bounds.width / 2 - 30, height: 90)
        return layout
    }
    
    private func setUpCollection() {
        collectionView.dataSource = self
        // test cell, will delete
        collectionView.register(UINib(nibName: "TestCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        // TODO: Lasagna - CollectionView List Type cell regist
        // TODO: Joons - CollectionView Grid Type cell Regist
    }
    
    private func reloadCollectionView() {
        collectionView.collectionViewLayout = collectionViewLayouts[segment.selectedSegmentIndex]
        self.collectionView.reloadData()
    }
    
    @IBAction func touchUpAddButton(_ sender: UIButton) {
        // TODO: add logic in step3
        print("➕")
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! TestCollectionViewCell
        return cell
    }
    
}
