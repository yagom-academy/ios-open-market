//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {
    let segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["List", "Grid"])

        control.selectedSegmentIndex = 0
        control.autoresizingMask = .flexibleWidth
        control.frame = CGRect(x: 0, y: 0, width: 200, height: 30)
        control.addTarget(self, action: #selector(didChangeValue(segment:)), for: .valueChanged)

        return control
    }()

    let plusButton = UIBarButtonItem(image: UIImage(systemName: "plus"),
                                     style: .plain,
                                     target: self,
                                     action: #selector(tapped(sender:)))

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.titleView = segmentedControl
        self.navigationItem.rightBarButtonItem = plusButton

    }

    @objc private func didChangeValue(segment: UISegmentedControl) {
        print("얍!")
    }

    @objc private func tapped(sender: UIBarButtonItem) {
        print("tapped!")
    }
}
