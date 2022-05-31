//
//  DetailViewController.swift
//  OpenMarket
//
//  Created by 조민호 on 2022/05/31.
//

import UIKit

final class DetailViewController: UIViewController {
    private enum Constants {
        static let requestErrorAlertTitle = "오류 발생"
        static let requestErrorAlertConfirmTitle = "확인"
        static let vendorName = "마이노"
    }
    
    lazy var mainView = DetailView(frame: view.bounds)
    private let productDetail: ProductDetail
    private let viewModel = DetailViewModel()
    
    init(product: ProductDetail) {
        self.productDetail = product
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViewModel()
        setUpNavigationItem()
        viewModel.setUpImages(with: productDetail.images)
        mainView.setUpView(data: productDetail)
    }
    
    private func setUpNavigationItem() {
        navigationItem.title = productDetail.name
        if productDetail.vendor?.name == Constants.vendorName {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didTapComposeButton))
        }
    }
    
    private func setUpViewModel() {
        viewModel.datasource = makeDataSource()
        viewModel.snapshot = viewModel.makeSnapshot()
        viewModel.delegate = self
    }
    
    @objc private func didTapComposeButton() {
        showModifyActionSheet()
    }
    
    private func showModifyActionSheet() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let modifyAction = UIAlertAction(title: "수정", style: .default) { _ in
            let modifyViewController = ModifyViewController(productDetail: self.productDetail)
            modifyViewController.modalPresentationStyle = .fullScreen
            self.present(modifyViewController, animated: true)
        }
        
        let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { _ in
            self.showPasswordAlert()
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alert.addAction(modifyAction)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    private func showPasswordAlert() {
        let alert = UIAlertController(title: "암호를 입력해주세요", message: nil, preferredStyle:.alert)
        alert.addTextField()
        
        let confirmAction = UIAlertAction(title: "확인", style: .default) { _ in
            guard let secret = alert.textFields?.first?.text else { return }
            self.deleteProduct(secret)
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .destructive)
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true)
    }
    
    private func deleteProduct(_ secret: String) {
        // rwfkpko1fp
        self.viewModel.requestSecret(by: self.productDetail.id, secret: ProductSecret(secret: secret)) { secret in
            self.viewModel.deleteProduct(by: self.productDetail.id, secret: secret) {
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
}

extension DetailViewController {
    private func makeDataSource() -> UICollectionViewDiffableDataSource<DetailViewModel.Section, ImageInfo> {
        let dataSource = UICollectionViewDiffableDataSource<DetailViewModel.Section, ImageInfo>(
            collectionView: mainView.collectionView,
            cellProvider: { (collectionView, indexPath, image) -> UICollectionViewCell in
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: ProductsHorizontalCell.identifier,
                    for: indexPath) as? ProductsHorizontalCell else {
                    return UICollectionViewCell()
                }
                
                cell.updateImage(imageInfo: image)
                
                return cell
            })
        return dataSource
    }
}

extension DetailViewController: ManagingAlertDelegate {
    func showAlertRequestError(with error: Error) {
        DispatchQueue.main.async {
            self.alertBuilder
                .setTitle(Constants.requestErrorAlertTitle)
                .setMessage(error.localizedDescription)
                .setConfirmTitle(Constants.requestErrorAlertConfirmTitle)
                .setConfirmHandler {
                    self.dismiss(animated: true)
                }
                .showAlert()
        }
    }
}
