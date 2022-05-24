//
//  RegisterEditViewController.swift
//  OpenMarket
//
//  Created by 우롱차, Donnie on 2022/05/24.
//

import UIKit

final class RegisterEditViewController: UIViewController {
    
    private enum Constant {
        static let rightNavigationButtonText = "Done"
        static let leftNavigationButtonText = "Cancel"
    }
    
    enum Mode {
        case add
        case edit
        
        var navigationItemTitle: String {
            switch self{
            case .add:
                return "상품등록"
            case .edit:
                return "상품수정"
            }
        }
    }
    
    var mode: Mode = .add
    
    private lazy var rightNavigationButton = UIBarButtonItem(
        title: Constant.rightNavigationButtonText,
        style: .plain,
        target: self,
        action: #selector(registerEditViewRightBarButtonTapped)
    )
    
    private lazy var leftNavigationButton: UIBarButtonItem = UIBarButtonItem(
        title: Constant.leftNavigationButtonText,
        style: .plain,
        target: self,
        action: #selector(registerEditViewLeftBarButtonTapped)
    )
    
    private lazy var mainVerticalStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.spacing = 5
        return view
    }()
    
    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        return view
    }()
    
    private lazy var horizontalStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [tempImage, tempImage2])
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.spacing = 10
        view.alignment = .leading
        view.distribution = .equalSpacing
        return view
    }()
    
    private lazy var tempImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "swift")
        return imageView
    }()
    private lazy var tempImage2: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "star")
        return imageView
    }()
    private lazy var tempImage3: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "person")
        return imageView
    }()
    private lazy var tempImage4: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "star")
        return imageView
    }()
    private lazy var tempImage5: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "star")
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setNavigationTitle()
        setConstraint()
    }
}

// MARK: - Method
extension RegisterEditViewController {
    
    private func setNavigationTitle() {
        navigationItem.title = mode.navigationItemTitle
        navigationItem.rightBarButtonItem = rightNavigationButton
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = leftNavigationButton
    }
    
    private func setConstraint() {
        view.addSubview(mainVerticalStackView)
        NSLayoutConstraint.activate([
            mainVerticalStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainVerticalStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainVerticalStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainVerticalStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        mainVerticalStackView.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: mainVerticalStackView.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: mainVerticalStackView.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: mainVerticalStackView.topAnchor),
            scrollView.heightAnchor.constraint(equalTo: mainVerticalStackView.heightAnchor, multiplier: 0.2)
        ])
        
        scrollView.addSubview(horizontalStackView)
        NSLayoutConstraint.activate([
            horizontalStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            horizontalStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            horizontalStackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            horizontalStackView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        ])
        
        NSLayoutConstraint.activate([
            tempImage.widthAnchor.constraint(equalToConstant: 150),
            tempImage.heightAnchor.constraint(equalToConstant: 150)
        ])
    }
}

// MARK: - Action Method
extension RegisterEditViewController {
    
    @objc private func registerEditViewRightBarButtonTapped() {
        
    }
    
    @objc private func registerEditViewLeftBarButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}
