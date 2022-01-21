//
//  ProductDetailsController.swift
//  OpenMarket
//
//  Created by Jun Bang on 2022/01/21.
//

import UIKit

final class ProductDetailsViewController: UIViewController {
    // MARK: - IBOutlets
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Properties
    
    private lazy var flowLayout: UICollectionViewFlowLayout = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        
        return flowLayout
    }()
    
    private var images: [UIImage] = []
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupCollectionViewCells()
    }
}

// MARK: - Private Methods

extension ProductDetailsViewController {
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.collectionViewLayout = flowLayout
        collectionView.isPagingEnabled = true
        collectionView.decelerationRate = .fast
    }
    
    private func setupCollectionViewCells() {
        let imageCellNib = UINib(nibName: ImageCell.identifier, bundle: .main)
        let addImageButtonCellNib = UINib(nibName: AddImageButtonCell.identifier, bundle: .main)
        
        collectionView.register(imageCellNib, forCellWithReuseIdentifier: ImageCell.identifier)
        collectionView.register(addImageButtonCellNib, forCellWithReuseIdentifier: AddImageButtonCell.identifier)
    }
}

// MARK: - UICollectionViewDataSource

extension ProductDetailsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row < images.count {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.identifier, for: indexPath) as! ImageCell
            
            cell.configure(with: images[indexPath.row])
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddImageButtonCell.identifier, for: indexPath) as! AddImageButtonCell
            
            cell.delegate = self
            return cell
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ProductDetailsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 2
        let height = collectionView.frame.height
        let size = CGSize(width: width, height: height)
        
        return size
    }
}

// MARK: - AddImageCellDelegate

extension ProductDetailsViewController: AddImageCellDelegate {
    func addImagePressed(by cell: AddImageButtonCell) {
        images.insert(UIImage(named: "olaf")!, at: 0)
        collectionView.reloadData()
    }
}
