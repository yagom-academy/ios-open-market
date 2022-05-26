//
//  EditingViewController.swift
//  OpenMarket
//
//  Created by cathy, mmim.
//

import UIKit

class EditingViewController: UIViewController {
  private lazy var editingView = EditingView()
  override func viewDidLoad() {
    super.viewDidLoad()
    configureRegistration()
    configureNavigationBar()
  }
  
  private func configureRegistration() {
    let safeArea = self.view.safeAreaLayoutGuide
    self.view.addSubview(editingView)
    
    NSLayoutConstraint.activate(
      [editingView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
       editingView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
       editingView.topAnchor.constraint(equalTo: safeArea.topAnchor),
       editingView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
      ])
  }
  
  private func configureNavigationBar() {
//    self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel,
//                                                            target: self,
//                                                            action: #selector(cancelModal))
//    self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done,
//                                                             target: self,
//                                                             action: #selector(postData))
    self.navigationItem.title = "상품수정"
    
    self.navigationController?.navigationBar.backgroundColor = .white
    self.navigationController?.navigationBar.scrollEdgeAppearance = UINavigationBarAppearance()
  }
}
