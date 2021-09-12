//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class OpenMarketViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    private let openMarketCollecionViewDataSource = OpenMarketCollectionViewDataSource()
    private let openMarketCollectionViewDelegate = OpenMarketCollectionViewDelegate()
    private let alertSelect = (enroll: "등록", modify: "수정", cancel: "취소")
    static let segueIdentifier = "presentToEnrollModify"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        processCollectionView()
        registeredIdetifier()
        openMarketCollecionViewDataSource.decidedListLayout(collectionView)
        openMarketCollecionViewDataSource.requestProductList(collectionView)
        openMarketCollecionViewDataSource.loadingIndicator = self
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    private func processCollectionView() {
        collectionView.dataSource = openMarketCollecionViewDataSource
        collectionView.delegate = openMarketCollectionViewDelegate
        collectionView.prefetchDataSource = openMarketCollecionViewDataSource
        
    }
    
    private func registeredIdetifier() {
        collectionView.register(UINib(nibName: ProductCell.listNibName, bundle: nil), forCellWithReuseIdentifier: ProductCell.listIdentifier)
        collectionView.register(UINib(nibName: ProductCell.gridNibName, bundle: nil), forCellWithReuseIdentifier: ProductCell.gridItentifier)
    }
    
    @IBAction func onCollectionViewTypeChanged(_ sender: UISegmentedControl) {
        openMarketCollecionViewDataSource.selectedView(sender, collectionView)
    }
}

extension OpenMarketViewController: LoadingIndicatable {
    func isHidden(_ isHidden: Bool) {
        loadingIndicator.isHidden = isHidden
    }
    
    func startAnimating() {
        loadingIndicator.startAnimating()
    }
    
    func stopAnimating() {
        loadingIndicator.stopAnimating()
    }
}

extension OpenMarketViewController {
    @IBAction func enrollModifyButton(_ sender: Any) {
        let alert = UIAlertController()
        let enroll = UIAlertAction(title: alertSelect.enroll, style: .default) { _ in
            self.performSegue(withIdentifier: Self.segueIdentifier, sender: self.alertSelect.enroll)
        }
        let modify = UIAlertAction(title: alertSelect.modify, style: .default) { _ in
            self.performSegue(withIdentifier: Self.segueIdentifier, sender: self.alertSelect.modify)
        }
        let cancel = UIAlertAction(title: alertSelect.cancel, style: .cancel, handler: nil)
        alert.addAction(enroll)
        alert.addAction(modify)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let enrollModifyViewController =
                segue.destination as? EnrollModifyViewController,
              let labelString = sender as? String else { return }
        enrollModifyViewController.topItemTitle = labelString
    }
}
