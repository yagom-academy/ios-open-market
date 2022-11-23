//
// ViewController.swift
// OpenMarket
//
//  Created by 써니쿠키, 메네 on 2022/11/22.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var listView: UIView!
    @IBOutlet weak var gridView: UIView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gridView.isHidden = true
        segmentControl.backgroundColor = .systemBackground
        segmentControl.setTitleTextAttributes([.foregroundColor: UIColor.white, .backgroundColor: UIColor.systemBlue], for: .selected)
        segmentControl.setTitleTextAttributes([.foregroundColor: UIColor.systemBlue], for: .normal)
    }
    
    @IBAction func changeView(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            listView.isHidden = false
            gridView.isHidden = true
            
        } else {
            listView.isHidden = true
            gridView.isHidden = false
        }
    }
}
