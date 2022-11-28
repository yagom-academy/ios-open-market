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
    
    @IBAction private func switchLayout(_ sender: UISegmentedControl) {
        guard let selectedIndex = SegmentedItemState(rawValue: sender.selectedSegmentIndex) else { return }
        switch selectedIndex {
        case .list:
            listView.isHidden = false
            gridView.isHidden = true
        case .grid:
            listView.isHidden = true
            gridView.isHidden = false
        }
    }
}

extension MainViewController {
    enum SegmentedItemState: Int {
        case list = 0
        case grid = 1
    }
}
