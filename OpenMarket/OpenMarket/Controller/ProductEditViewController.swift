//
//  ProductEditViewController.swift
//  OpenMarket
//
//  Created by Eddy, marisol on 2022/05/28.
//

import UIKit

class ProductEditViewController: UIViewController {
    var productDetail: ProductDetail?
    var imageArray = [UIImage]()
    let doneButton = UIBarButtonItem()
    private var networkManager = NetworkManager<ProductsList>(session: URLSession.shared)
    private var networkImageArray = [ImageInfo]()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: view.frame, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        
        return collectionView
    }()
    
    let entireScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        
        return scrollView
    }()
    
    let productDetailView = ProductDetailView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(entireScrollView)
        entireScrollView.addSubview(collectionView)
        entireScrollView.addSubview(productDetailView)
        
        self.view.backgroundColor = .white
        productDetailView.backgroundColor = .white
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(EditViewCell.self, forCellWithReuseIdentifier: EditViewCell.identifier)
        setLayout()
        configureBarButton()
    }
    
    func configureBarButton() {
        self.navigationController?.navigationBar.topItem?.title = "Cancel"
        self.title = "상품수정"
        self.navigationItem.rightBarButtonItem = doneButton
//        doneButton.isEnabled = false
        doneButton.title = "Done"
        doneButton.style = .done
        doneButton.target = self
        doneButton.action = #selector(executePATCH)
    }
    
    func setLayout() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        productDetailView.translatesAutoresizingMaskIntoConstraints = false
        entireScrollView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            entireScrollView.widthAnchor.constraint(equalTo: view.widthAnchor),
            entireScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            entireScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            entireScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            entireScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            collectionView.widthAnchor.constraint(equalTo: entireScrollView.widthAnchor),
            collectionView.leadingAnchor.constraint(equalTo: entireScrollView.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: entireScrollView.safeAreaLayoutGuide.topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: entireScrollView.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: productDetailView.topAnchor, constant: -10),
            collectionView.heightAnchor.constraint(equalToConstant: 160),
            
            productDetailView.widthAnchor.constraint(equalTo: entireScrollView.widthAnchor),
            productDetailView.leadingAnchor.constraint(equalTo: entireScrollView.leadingAnchor),
            productDetailView.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 10),
            productDetailView.trailingAnchor.constraint(equalTo: entireScrollView.trailingAnchor),
            productDetailView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension ProductEditViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let imageCount = imageArray.count + 1
        return imageCount < 5 ? imageCount : 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EditViewCell.identifier, for: indexPath) as? EditViewCell else {
            return UICollectionViewCell()
        }
        
        return cell
    }
}

extension ProductEditViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 150)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5.0
    }
}

extension ProductEditViewController {
    @objc func executePATCH() {
        let dispatchGroup = DispatchGroup()
        let params = productDetailView.generateParameters()
        DispatchQueue.global().async(group: dispatchGroup) {
            guard let productID = self.productDetail?.id else {
                return
            }
            self.networkManager.execute(with: .productEdit(productId: productID), httpMethod: .patch, params: params) { result in
                switch result {
                case .success:
                    print("success")
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            self.navigationController?.popViewController(animated: true)
        }
    }
}
