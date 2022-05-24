//
//  AddItemViewController.swift
//  OpenMarket
//
//  Created by 두기, minseong on 2022/05/24.
//

import UIKit

class AddItemViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setInitialView()
    }
    
    private func setInitialView() {
        navigationItem.setLeftBarButton(makeCancelButton(), animated: true)
        navigationItem.setRightBarButton(makeDoneButton(), animated: true)
    }
    @objc private func touchCancelButton() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func touchDoneButton() {
        print("Done")
    }
    
//MARK: - aboutView
    private func makeCancelButton() -> UIBarButtonItem {
        let barButton = UIBarButtonItem(image: nil, style: .plain, target: self, action: #selector(touchCancelButton))
        barButton.title = "Cancel"
        return barButton
    }
    private func makeDoneButton() -> UIBarButtonItem {
        let barButton = UIBarButtonItem(image: nil, style: .plain, target: self, action: #selector(touchDoneButton))
        barButton.title = "Done"
        return barButton
    }
}
