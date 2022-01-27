//
//  ImageDetailViewController.swift
//  OpenMarket
//
//  Created by 이호영 on 2022/01/25.
//

import UIKit

class ImageDetailViewController: UIViewController {
    @IBOutlet private weak var pageControl: ImagePageControl!
    @IBOutlet private weak var closeButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var images: [UIImage] = []
    private var currentPage = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black

        setUpButton()
        registerXib()
        setUpCollectionView()
        setUpPageControl()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            let indexPath = IndexPath(item: self.currentPage, section: 0)
            self.collectionView.scrollToItem(
                at: indexPath,
                at: [.centeredHorizontally, .centeredVertically],
                animated: false
            )
        }
    }
    
    func setUpImage(_ images: [UIImage], currentPage: Int) {
        self.images = images
        self.currentPage = currentPage
    }
    
    private func setUpPageControl() {
        pageControl.numberOfPages = images.count
        pageControl.isHidden = false
        pageControl.hidesForSinglePage = true
        pageControl.currentPage = currentPage
    }
    
    private func setUpCollectionView() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = flowLayout
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isPagingEnabled = true
    }
    
    private func registerXib() {
        let nibName = UINib(nibName: ImageDetailCell.nibName, bundle: .main)
        collectionView.register(nibName, forCellWithReuseIdentifier: ImageDetailCell.identifier)
    }
    
    private func setUpButton() {
        closeButton.setTitle("", for: .normal)
    }
    
    @IBAction func tappedCloseButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension ImageDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ImageDetailCell.identifier,
            for: indexPath
        ) as? ImageDetailCell else {
            return UICollectionViewCell()
        }
        
        cell.imageView.image = images[indexPath.item]
        return cell
    }
}

extension ImageDetailViewController: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        willDisplay cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath
    ) {
        pageControl.currentPage = indexPath.item
    }
}

extension ImageDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 0
    }
}
