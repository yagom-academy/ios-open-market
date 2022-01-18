//
//  RegisterViewController.swift
//  OpenMarket
//
//  Created by Ari on 2022/01/10.
//

import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCollectionView()
    }
    
    func setUpCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        
        let cellNib = UINib(nibName: ImageCell.nibName, bundle: .main)
        collectionView.register(cellNib, forCellWithReuseIdentifier: ImageCell.identifier)
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = flowLayout
        collectionView.showsHorizontalScrollIndicator = false
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension RegisterViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ImageCell.identifier,
            for: indexPath
        ) as? ImageCell else {
            return UICollectionViewCell()
        }
        return cell
    }
}

extension RegisterViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let width = collectionView.safeAreaLayoutGuide.layoutFrame.width / 3
        return CGSize(width: width, height: width)
    }
}
