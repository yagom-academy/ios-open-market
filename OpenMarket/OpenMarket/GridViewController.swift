//
//  GridViewController.swift
//  OpenMarket
//
//  Created by Jun Bang on 2022/01/12.
//

import UIKit

final class GridViewController: UIViewController {
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
        assertionFailure("init(coder:) has not been implemented")
        return nil
    }
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionViewCells()
        setupGridLayout()
        collectionView.dataSource = self
        collectionView.delegate = self
    }
 
    func updateProducts(with products: [Product]) {
        self.products = products
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}

//MARK: - Private Methods

extension GridViewController {
    private func setupGridLayout() {
        let layout = UICollectionViewFlowLayout()
        collectionView.collectionViewLayout = layout
    }
    
    private func setupCollectionViewCells() {
        let gridNib = UINib(nibName: NibIdentifier.grid, bundle: .main)
        collectionView.register(gridNib, forCellWithReuseIdentifier: MarketCell.identifier)
    }
}

//MARK: - UICollectionViewDataSource

extension GridViewController: UICollectionViewDataSource {
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
        cell.configure(with: products[indexPath.row], cellType: .grid)
        
        return cell
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension GridViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 2 - 15
        let height = collectionView.frame.height / 2.5
        let size = CGSize(width: width, height: height)
        
        return size
    }
}

//MARK: - IdentifiableView

extension GridViewController: IdentifiableView { }
