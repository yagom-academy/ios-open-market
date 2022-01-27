//
//  MarketItemRegistrationViewController.swift
//  OpenMarket
//
//  Created by yeha on 2022/01/27.
//

import UIKit

class MarketItemRegistrationViewController: UIViewController {

    private let registrationView = MarketItemFormView()
    private let itemRegisterManager = ItemRegisterAndModifyManager()
    private let imagePicker = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()
        registrationView.formViewDidLoad()
        view = registrationView
    }
}
