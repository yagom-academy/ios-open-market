//
//  AddItemViewController.swift
//  OpenMarket
//
//  Created by 두기, minseong on 2022/05/24.
//

import UIKit

class AddItemViewController: UIViewController {

    @IBOutlet private weak var navigationBarTitle: UINavigationItem!
    private var titleText: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setInitialView()
    }
    
    func getComponents(title: String) {
        titleText = title
    }
    
    private func setInitialView() {
        navigationController?.isNavigationBarHidden = true
        navigationBarTitle.title = titleText
    }
}
