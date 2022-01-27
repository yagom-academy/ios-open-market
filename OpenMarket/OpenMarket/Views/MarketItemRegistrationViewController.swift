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
        setupDelegate()
        setupNavigationBar()
        registrationView.formViewDidLoad()
        view = registrationView
    }

    private func setupDelegate() {
        registrationView.photoCollectionView.delegate = self
        registrationView.photoCollectionView.dataSource = self
        imagePicker.delegate = self
    }

    private func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done,
                                         target: self,
                                         action: #selector(doneButtonDidTap))
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel,
                                           target: self,
                                           action: #selector(cancelButtonDidTap))
        self.navigationItem.rightBarButtonItem = doneButton
        self.navigationItem.leftBarButtonItem = cancelButton
    }

    @objc private func doneButtonDidTap() {
        let currency = registrationView.currencySegmentedControl.titleForSegment(at: registrationView.currencySegmentedControl.selectedSegmentIndex)!
        itemRegisterManager.fillWithInformation(registrationView.nameInputTextField.text,
                                                registrationView.descriptionInputTextView.text,
                                                registrationView.priceInputTextField.text,
                                                currency,
                                                registrationView.discountedPriceInputTextField.text,
                                                registrationView.stockInputTextField.text)
        itemRegisterManager.upload()
    }

    @objc private func cancelButtonDidTap() {
        self.dismiss(animated: true, completion: nil)
    }

}
