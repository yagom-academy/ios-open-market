//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class CollectionViewController: UIViewController {
    static var items: [Item]!
    let segmentedControl = SegmentedControl()
    let collectionView = CollectionView(frame: .zero, flowlayout: UICollectionViewFlowLayout())
    let loadingImageView = LoadingImageView()
    let failView = FailView()
    var isListView: Bool = true

    override func loadView() {
        super.loadView()
        let apiTarget = APITarget.목록조회(page: 1)
        let clientRequest = apiTarget.request
        let networkManager = NetworkManager<Items>(clientRequest: clientRequest, session: URLSession.shared)
        
        loadingImageView.configure(viewController: self)
        segmentedControl.configure()
        navigationController?.navigationBar.isHidden = true
        
        networkManager.getServerData(url: apiTarget.url){ result in
            switch result {
            case .failure:
                self.failView.configure(viewController: self)
            case .success(let data):
                DispatchQueue.main.async {
                    CollectionViewController.items = data.items
                    self.navigationController?.navigationBar.isHidden = false
                    self.collectionView.configure(viewController: self)
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.titleView = segmentedControl
        segmentedControl.addTarget(self, action: #selector(changed), for: .valueChanged)
        
        if #available(iOS 14.0, *) {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(tapNavigationRightButton))
        }
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    @objc func changed() {
        switch segmentedControl.selectedSegmentIndex {
        case 0: isListView = true
        case 1: isListView = false
        default: return
        }
        
        collectionView.reloadData()
    }

    @objc func tapNavigationRightButton() {
        let registerViewController = RegisterViewController()

        self.present(registerViewController, animated: true, completion: nil)
    }
}

extension CollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CollectionViewController.items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if isListView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCellForList.identifier, for: indexPath) as! CollectionViewCellForList
           
            cell.configure(item: CollectionViewController.items[indexPath.row])
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCellForGrid.identifier, for: indexPath) as! CollectionViewCellForGrid
            
            cell.configure(item: CollectionViewController.items[indexPath.row])
            
            return cell
        }
    }
}

extension CollectionViewController: UICollectionViewDelegate {}

extension CollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var widthSize: CGFloat
        var heightSize: CGFloat

        if isListView {
            widthSize = view.frame.width - 10
            heightSize = widthSize * 0.25
        } else {
            widthSize = ((view.frame.width - 20) / 2)
            heightSize = widthSize  * 1.3

            if widthSize > 200 {
                widthSize = 160
            }
        }

        return CGSize(width: widthSize, height: heightSize)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
}
