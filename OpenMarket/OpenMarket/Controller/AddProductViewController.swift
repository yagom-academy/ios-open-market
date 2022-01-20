//
//  AddProductViewController.swift
//  OpenMarket
//
//  Created by Jae-hoon Sim on 2022/01/20.
//

import UIKit

class AddProductViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }

    private func configure() {
        view.backgroundColor = .white

        // navi bar
        title = "상품등록"

        let closeButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(closeButtonDidTap))
        navigationItem.leftBarButtonItem = closeButton

        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonDidTap))
        navigationItem.rightBarButtonItem = doneButton
    }

    @objc
    func closeButtonDidTap() {
        self.dismiss(animated: true, completion: nil)
    }

    @objc
    func doneButtonDidTap() {
        (print("POST")) //POST actions..+ reload collectionView(?)
        self.dismiss(animated: true, completion: nil)
    }

}
