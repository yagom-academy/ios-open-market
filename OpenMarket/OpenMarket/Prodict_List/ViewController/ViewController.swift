//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class CollectionViewController: UIViewController {
    let segmentedControl = SegmentedControl()
    let collectionView = CollectionView(frame: .zero, flowlayout: UICollectionViewFlowLayout())
    var isListView: Bool = true
    static var items: [Item]!

    override func loadView() {
        super.loadView()
        
        let clientRequest = GETRequest(page: 1, id: 1, descriptionAboutMenu: .목록조회)
        let networkManager = NetworkManager<Items>(clientRequest: clientRequest, session: URLSession.shared)
        
        networkManager.getServerData(url: clientRequest.urlRequest.url!){ result in
            switch result {
            case .failure: return
            case .success(let data):
                DispatchQueue.main.async {
                    CollectionViewController.items = data.items
                    self.collectionView.configureCollectionView(viewController: self)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.titleView = segmentedControl
        
        let loadingImageView: UIImageView = {
            let loadingImageView = UIImageView()
            loadingImageView.image = UIImage(named: "yagom")
            
            return loadingImageView
        }()
        
        view.addSubview(loadingImageView)
        loadingImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            loadingImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
        
        segmentedControl.addTarget(self, action: #selector(changed), for: .valueChanged)
        
        collectionView.dataSource = self
        collectionView.delegate = self

        if #available(iOS 14.0, *) {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(tapNavigationRightButton))
        }
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
        return 20
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if isListView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCellForList.identifier, for: indexPath) as! CollectionViewCellForList
           
            cell.configure(item: CollectionViewController.items[indexPath.row])
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCellForGrid.identifier, for: indexPath) as! CollectionViewCellForGrid
            
            cell.configure(indexPath: indexPath)
            
            return cell
        }
    }
    
    func parseData() -> Items? {
        guard let data = NSDataAsset(name: "Items")?.data else { return nil }
        guard let parsedData = try? JSONDecoder().decode(Items.self, from: data) else { return nil }

        return parsedData
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
