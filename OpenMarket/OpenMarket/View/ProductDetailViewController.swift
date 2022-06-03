//
//  ProductDetailViewController.swift
//  OpenMarket
//
//  Created by Eddy, marisol on 2022/05/28.
//

import UIKit

final class ProductDetailViewController: UIViewController {
    private let products: Products
    private var productDetail: ProductDetail?
    private var networkManager = NetworkManager<ProductDetail>(session: URLSession.shared)
    private let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: nil, action: #selector(cancelButtonDidTapped(_:)))
    private var presenter = Presenter()
    private let productDetailView = ProductDetailView()
    
    private let imageScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.alwaysBounceVertical = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.isScrollEnabled = true
        scrollView.isPagingEnabled = true
        scrollView.bounces = false
        
        return scrollView
    }()
    
    private func setScrollView() {
        guard let images = presenter.images else {
            return
        }
        for index in 0..<images.count {
            let imageView = UIImageView()
            imageView.contentMode = .scaleToFill
            imageView.frame = CGRect(
                x: self.view.frame.width * CGFloat(index),
                y: 0,
                width: imageScrollView.frame.width,
                height: imageScrollView.frame.height
            )
            imageScrollView.contentSize.width = imageView.frame.width * CGFloat(index + 1)
            
            guard let imageURL = images[index].url else { return }
            imageView.loadImage(imageURL)
            
            imageScrollView.addSubview(imageView)
            
        }
    }
    
    init(products: Products) {
        self.products = products
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
      
    override func viewDidLoad() {
        super.viewDidLoad()
        imageScrollView.delegate = self
        setView()
        executeGET()
        setLayout()
        configureBarButton()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setData()
        setScrollView()
    }
    
    private func setView() {
        self.view.addSubview(productDetailView)
        productDetailView.addSubview(imageScrollView)
        
        self.view.backgroundColor = .white
        productDetailView.backgroundColor = .white
    }
    
    private func setLayout() {
        imageScrollView.translatesAutoresizingMaskIntoConstraints = false
        productDetailView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            productDetailView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            productDetailView.topAnchor.constraint(equalTo: self.view.topAnchor),
            productDetailView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            productDetailView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            imageScrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            imageScrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            imageScrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            imageScrollView.bottomAnchor.constraint(equalTo: productDetailView.pageControl.topAnchor),
            imageScrollView.heightAnchor.constraint(equalToConstant: 300)
        ])
    }
    
    private func configureBarButton() {
        let editButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(editButtonDidTapped))
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationItem.backBarButtonItem = cancelButton
        self.navigationItem.rightBarButtonItem = editButton
    }
    
    private func configurePriceUI() {
        let price = Int(presenter.price ?? "0")
        let discountedPrice = Int(presenter.discountedPrice ?? "0")

        productDetailView.priceLabel.numberOfLines = 0
        productDetailView.discountedLabel.numberOfLines = 0
        
        guard let formattedPrice = price?.formatNumber() ,let formattedDiscountedPrice = discountedPrice?.formatNumber(), let currency = presenter.currency else { return }
        
        if presenter.price == presenter.bargainPrice {
            productDetailView.priceLabel.text = "\(currency) \(formattedPrice)"
            
            productDetailView.priceLabel.textColor = .black
            
            productDetailView.discountedLabel.isHidden = true
        } else {
            productDetailView.priceLabel.text = "\(currency) \(formattedPrice)"
            productDetailView.discountedLabel.text = "\(currency) \(formattedDiscountedPrice)"
            
            productDetailView.priceLabel.attributedText = productDetailView.priceLabel.text?.strikeThrough()
            
            productDetailView.priceLabel.textColor = .systemRed
            productDetailView.discountedLabel.textColor = .black
        }
    }
    
    private func configureProductNameUI() {
        productDetailView.productNameLabel.font = UIFont.boldSystemFont(ofSize: 15)
    }
    
    private func configureStockUI() {
        productDetailView.stockLabel.textColor = .systemGray2
    }
    
    private func executeGET() {
        guard let id = self.products.id else {
            return
        }
        
        self.networkManager.execute(with: .productEdit(productId: id), httpMethod: .get) { result in
            switch result {
            case .success(let result):
                guard let result = result as? ProductDetail else { return }
                self.productDetail = result 
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    @objc func editButtonDidTapped() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let edit = UIAlertAction(title: Alert.edit, style: .default) {_ in
            guard let productDetail = self.productDetail else {
                return
            }
            
            let productEditViewController = ProductEditViewController(productDetail: productDetail)

            self.navigationController?.pushViewController(productEditViewController, animated: true)
        }
        
        let delete = UIAlertAction(title: Alert.delete, style: .destructive) {_ in
            let alert = UIAlertController(title: "상품 삭제", message: "비밀번호 입력", preferredStyle: .alert)
            let delete = UIAlertAction(title: "삭제", style: .destructive) {_ in
                guard let secret = alert.textFields?.first?.text else {
                    return
                }
                self.checkPassword(secret: secret) { result in
                    switch result {
                    case .success(let secret):
                        self.executeDELETE(secret: secret)
                    case .failure(_):
                        DispatchQueue.main.async {
                            self.showWrongPasswordAlert()
                        }
                    }
                }
            }
            
            let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
            alert.addTextField { passwordTextField in
                passwordTextField.placeholder = "비밀번호를 입력하세요"
            }
            
            alert.addAction(delete)
            alert.addAction(cancel)
            self.present(alert, animated: true, completion: nil)
        }
        
        let cancel = UIAlertAction(title: Alert.cancel, style: .cancel) {_ in
            self.dismiss(animated: true, completion: nil)
        }
        
        alertController.addAction(edit)
        alertController.addAction(delete)
        alertController.addAction(cancel)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc private func cancelButtonDidTapped(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension ProductDetailViewController {
    private func setData() {
        guard let productDetail = productDetail else {
            return
        }
        
        presenter = presenter.setData(of: productDetail)
        productDetailView.setDetailView(presenter)
        configurePriceUI()
        configureProductNameUI()
        configureStockUI()
    }
}

extension ProductDetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let size = imageScrollView.contentOffset.x / imageScrollView.frame.width
        productDetailView.pageControl.currentPage = Int(round(size))

    private func checkPassword(secret: String, completionHandler: @escaping (Result<String, Error>) -> Void) {
        guard let productId = products.id else {
            return
        }
        
        self.networkManager.execute(with: .productSecretCheck(productId: productId), httpMethod: .secretPost, secret: secret) { result in
            switch result {
            case .success(let secret):
                guard let data = secret as? Data else {
                    return
                }
                
                guard let secret = String(data: data, encoding: .utf8) else {
                    return
                }
                
                completionHandler(.success(secret))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    @objc private func executeDELETE(secret: String) {
        guard let productId = products.id else {
            return
        }
        
        self.networkManager.execute(with: .productDelete(productId: productId, secret: secret), httpMethod: .delete) {
            result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self.showSuccessAlert()
                }
            case .failure:
                DispatchQueue.main.async {
                    self.showFailureAlert()
                }
            }
            
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    private func showSuccessAlert() {
        let alert = UIAlertController(title: "삭제 성공", message: "상품을 삭제했습니다", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Alert.ok, style: .default, handler: { _ in
            self.navigationController?.popViewController(animated: true)
        }))
        self.present(alert, animated: true)
    }
    
    private func showFailureAlert() {
        let alert = UIAlertController(title: "삭제 실패", message: "상품을 삭제하지 못했습니다", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Alert.ok, style: .default))
        self.present(alert, animated: true)
    }
    
    private func showWrongPasswordAlert() {
        let alert = UIAlertController(title: "비밀번호 불일치", message: "비밀번호가 틀렸습니다", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }
}
