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
    self.view = registrationView
  }
}
