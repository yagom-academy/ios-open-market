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
    
    private lazy var rightNavigationButton = UIBarButtonItem(title: Constant.rightNavigationButtonText, style: .plain, target: self, action: #selector(registerEditViewRightBarButtonTapped))
    
    @objc private func registerEditViewRightBarButtonTapped() {
        
    }
    
    private lazy var leftNavigationButton: UIBarButtonItem = UIBarButtonItem(title: Constant.leftNavigationButtonText, style: .plain, target: self, action: #selector(registerEditViewLeftBarButtonTapped))
    
    @objc private func registerEditViewLeftBarButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setNavigationTitle()
    }
    
    private func setNavigationTitle() {
        navigationItem.title = mode.navigationItemTitle
        navigationItem.rightBarButtonItem = rightNavigationButton
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = leftNavigationButton
    }
}
