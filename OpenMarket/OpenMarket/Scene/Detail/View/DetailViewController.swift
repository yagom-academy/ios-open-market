//
//  DetailViewController.swift
//  OpenMarket
//
//  Created by 조민호 on 2022/05/31.
//

import UIKit

final class DetailViewController: UIViewController, NotificationObservable {
    private enum Constants {
        static let requestErrorAlertTitle = "오류 발생"
        static let requestErrorAlertConfirmTitle = "확인"
        static let modifyActionTitle = "수정"
        static let deleteActionTitle = "삭제"
        static let cancelActionTitle = "취소"
        static let passwordAlertTitle = "암호를 입력해주세요"
        static let confirmTitle = "확인"
        static let successDeleteAlertTitle = "삭제 완료"
        static let successDeleteAlertMessage = "메인 화면으로 이동합니다."
    }
    
    lazy var mainView = DetailView(frame: view.bounds)
    private let id: Int
    private let viewModel = DetailViewModel()
    
    init(id: Int) {
        self.id = id
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
        setUpData()
        setUpNotification()
    }
}

// MARK: SetUp Method

extension DetailViewController {
    private func setUpData() {
        viewModel.requestProductDetail(by: id) { productDetail in
            DispatchQueue.main.async {
                self.setUpNavigationItem()
                self.mainView.setUpView(data: productDetail)
            }
        }
    }
    
    private func setUpNavigationItem() {
        navigationItem.title = viewModel.productDetail?.name
        if viewModel.productDetail?.vendor?.id == UserInformation.vendorId {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didTapComposeButton))
        }
    }
    
    private func setUpViewModel() {
        viewModel.datasource = makeDataSource()
        viewModel.snapshot = viewModel.makeSnapshot()
        viewModel.delegate = self
    }
    
    private func setUpNotification() {
        registerNotification { [weak self] in
            self?.setUpData()
        }
    }
}

// MARK: Alert Method

extension DetailViewController {
    private func showModifyActionSheet() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let modifyAction = UIAlertAction(title: Constants.modifyActionTitle, style: .default) { _ in
            guard let productDetail = self.viewModel.productDetail else { return }
            let modifyViewController = ModifyViewController(productDetail: productDetail)
            modifyViewController.modalPresentationStyle = .fullScreen
            self.present(modifyViewController, animated: true)
        }
        
        let deleteAction = UIAlertAction(title: Constants.deleteActionTitle, style: .destructive) { _ in
            self.showPasswordAlert()
        }
        
        let cancelAction = UIAlertAction(title: Constants.cancelActionTitle, style: .cancel, handler: nil)
        
        alert.addAction(modifyAction)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    private func showPasswordAlert() {
        let alert = UIAlertController(title: Constants.passwordAlertTitle, message: nil, preferredStyle:.alert)
        alert.addTextField()
        
        let confirmAction = UIAlertAction(title: Constants.confirmTitle, style: .default) { _ in
            guard let secret = alert.textFields?.first?.text else { return }
            self.deleteProduct(secret)
        }
        
        let cancelAction = UIAlertAction(title: Constants.cancelActionTitle, style: .destructive)
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true)
    }
}

// MARK: Objc Method

extension DetailViewController {
    @objc private func didTapComposeButton() {
        showModifyActionSheet()
    }
}

// MARK: Datasource & Delete API

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
    
    private func deleteProduct(_ secret: String) {
        self.viewModel.requestSecret(secret: ProductRequest(secret: secret)) { secret in
            self.viewModel.deleteProduct(secret: secret) {
                DispatchQueue.main.async {
                    self.showAlertSuccessDelete()
                }
            }
        }
    }
}

// MARK: AlertDelegate

extension DetailViewController: AlertDelegate {
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
    
    func showAlertSuccessDelete() {
        self.alertBuilder
            .setTitle(Constants.successDeleteAlertTitle)
            .setMessage(Constants.successDeleteAlertMessage)
            .setConfirmTitle(Constants.confirmTitle)
            .setConfirmHandler {
                self.navigationController?.popViewController(animated: true)
            }
            .showAlert()
    }
}
