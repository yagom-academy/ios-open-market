//
//  AddItemViewController.swift
//  OpenMarket
//
//  Created by 두기, minseong on 2022/05/24.
//

import UIKit

final class AddItemViewController: UIViewController {
    @IBOutlet private weak var itemImageCollectionView: UICollectionView!
    @IBOutlet private weak var curruncySegment: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setInitialView()
    }
    
    private func setInitialView() {
        navigationItem.setLeftBarButton(makeCancelButton(), animated: true)
        navigationItem.setRightBarButton(makeDoneButton(), animated: true)
        itemImageCollectionView.dataSource = self
        itemImageCollectionView.register(UINib(nibName: "\(ItemImageCell.self)", bundle: nil), forCellWithReuseIdentifier: "\(ItemImageCell.self)")
        setSegmentTextFont()
        setLayout()
    }
    @objc private func touchCancelButton() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func touchDoneButton() {
        print("Done")
    }
}
// MARK: - aboutCell
extension AddItemViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(ItemImageCell.self)", for: indexPath) as? ItemImageCell else {
            return ItemImageCell()
        }
        cell.backgroundColor = .brown
        
        return cell
    }
}

//MARK: - aboutView
extension AddItemViewController {
    private func makeCancelButton() -> UIBarButtonItem {
        let barButton = UIBarButtonItem(image: nil, style: .plain, target: self, action: #selector(touchCancelButton))
        barButton.title = "Cancel"
        return barButton
    }
    
    private func makeDoneButton() -> UIBarButtonItem {
        let barButton = UIBarButtonItem(image: nil, style: .plain, target: self, action: #selector(touchDoneButton))
        barButton.title = "Done"
        return barButton
    }
    
    private func setSegmentTextFont() {
        let font = UIFont.preferredFont(forTextStyle: .caption1)
        curruncySegment.setTitleTextAttributes([NSAttributedString.Key.font: font], for: .normal)
    }
    
    private func setLayout() {
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(itemImageCollectionView.frame.height), heightDimension: .absolute(itemImageCollectionView.frame.height))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: itemSize.widthDimension, heightDimension: itemSize.heightDimension)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 3, bottom: 0, trailing: 3)

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .paging
        
        itemImageCollectionView.collectionViewLayout = UICollectionViewCompositionalLayout(section: section)
    }
}



