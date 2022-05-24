//
//  RegistrationViewController.swift
//  OpenMarket
//
//  Created by cathy, mmim.
//

import UIKit

final class RegistrationViewController: UIViewController {
  private lazy var registrationView = RegistrationView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureRegistration()
    self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelModal))
      self.navigationItem.title = "상품등록"
      navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(cancelModal))
    navigationController?.navigationBar.backgroundColor = .white
    navigationController?.navigationBar.scrollEdgeAppearance = UINavigationBarAppearance()
  }
  
  private func configureRegistration() {
    let safeArea = self.view.safeAreaLayoutGuide
    self.view.addSubview(registrationView)
    
    NSLayoutConstraint.activate([registrationView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
                                     registrationView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
                                     registrationView.topAnchor.constraint(equalTo: safeArea.topAnchor),
                                     registrationView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)])
  }
  
  @objc private func cancelModal() {
    self.dismiss(animated: true, completion: nil)
  }
}
