//
//  OpenMarket - MainViewController.swift
//  Created by Red, Mino.
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class MainViewController: UIViewController {
    private lazy var mainView = MainView(frame: view.bounds)
    
    override func loadView() {
        super.loadView()
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

