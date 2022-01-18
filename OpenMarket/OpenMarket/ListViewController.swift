//
//  ListViewController.swift
//  OpenMarket
//
//  Created by Jun Bang on 2022/01/12.
//

import UIKit

final class ListViewController: UIViewController {
    //MARK: - IBOutlets
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK: - Properties
    
    private var products: [Product]
    
    //MARK: - Initializer
    
    init?(products: [Product], coder: NSCoder) {
        self.products = products
        super.init(coder: coder)
    }

    required init?(coder: NSCoder) {
        fatalError("class does not support nscoder")
    }
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionViewCells()
        setupListLayout()
        collectionView.dataSource = self
    }
}

//MARK: - Private Methods

extension ListViewController {
    private func setupListLayout() {
        let configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        collectionView.collectionViewLayout = layout
    }
    
    private func setupCollectionViewCells() {
        let listNib = UINib(nibName: NibIdentifier.list, bundle: .main)
        collectionView.register(listNib, forCellWithReuseIdentifier: MarketCell.identifier)
    }
}

//MARK: - UICollectionViewDataSource

extension ListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MarketCell.identifier,
            for: indexPath
        ) as? MarketCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: products[indexPath.row], cellType: .list)
        
        return cell
    }
}

//MARK: - IdentifiableView

extension ListViewController: IdentifiableView { }
