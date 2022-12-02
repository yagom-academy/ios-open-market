//
//  RegistrationViewController.swift
//  OpenMarket
//
//  Created by 써니쿠키, 메네 on 2022/12/01.
//

import UIKit

class RegistrationViewController: UIViewController {
    let registrationView: RegistrationView = RegistrationView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        
        registrationView.ImageCollectionView.delegate = self
        registrationView.ImageCollectionView.dataSource = self
        
        self.view = registrationView
    }
    
    func setupNavigationBar() {
        let button = UIBarButtonItem(title: "Done",
                                     style: .plain,
                                     target: self,
                                     action: #selector(registerProduct))
        
        navigationItem.title = "상품등록"
        navigationItem.rightBarButtonItem  = button
    }
    
    @objc func registerProduct() {
    }
    
}

extension RegistrationViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = UICollectionViewCell()
        return cell
    }
}

