//
//  RegistrationViewController.swift
//  OpenMarket
//
//  Created by unchain, hyeon2 on 2022/08/01.
//

import UIKit

class RegistrationViewController: UIViewController {
    
    private lazy var doneButton: UIButton = {
        let button = UIButton()
        button.setTitle("Done", for: .normal)
        button.setTitleColor(UIColor.systemBlue, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(UIColor.systemBlue, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: doneButton)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: cancelButton)
        self.title = "상품등록"
    }
}
