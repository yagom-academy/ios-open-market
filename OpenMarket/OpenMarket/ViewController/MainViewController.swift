//
// MainViewController.swift
// OpenMarket
//
//  Created by 써니쿠키, 메네 on 2022/11/22.
//

import UIKit

final class MainViewController: UIViewController {
    @IBOutlet private weak var listView: UIView!
    @IBOutlet private weak var gridView: UIView!
    @IBOutlet private weak var segmentControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSegmentControl()
        gridView.isHidden = true
    }
    
    private func setUpSegmentControl() {
        segmentControl.backgroundColor = .systemBackground
        segmentControl.setTitleTextAttributes([.foregroundColor: UIColor.white,
                                               .backgroundColor: UIColor.systemBlue],
                                              for: .selected)
        segmentControl.setTitleTextAttributes([.foregroundColor: UIColor.systemBlue],
                                              for: .normal)
    }
    
    @IBAction private func changeView(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            listView.isHidden = false
            gridView.isHidden = true
            
        } else {
            listView.isHidden = true
            gridView.isHidden = false
        }
    }
}
