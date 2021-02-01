//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {
    
    let listView = ListViewController()
    let gridView = GridViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpNavigationBar(segmentedControl: setUpSegmentedControl())
        setUpView()
    }
    
    private func setUpSegmentedControl() -> UISegmentedControl {
        let segmentedControl = UISegmentedControl()
        
        segmentedControl.insertSegment(withTitle: "LIST", at: 0, animated: true)
        segmentedControl.insertSegment(withTitle: "GRID", at: 1, animated: true)
        segmentedControl.addTarget(self, action: #selector(didTapSegment(segment:)), for: .valueChanged)
        
        return segmentedControl
    }
    
    @objc private func didTapSegment(segment: UISegmentedControl) {
        listView.view.isHidden = true
        gridView.view.isHidden = true
        
        if segment.selectedSegmentIndex == 0 {
            listView.view.isHidden = false
        }
        else {
            gridView.view.isHidden = false
        }
    }
    
    private func setUpView() {
        
        addChild(listView)
        addChild(gridView)
        self.view.addSubview(listView.view)
        self.view.addSubview(gridView.view)
        
        listView.didMove(toParent: self)
        gridView.didMove(toParent: self)
        
        listView.view.frame = self.view.bounds
        gridView.view.frame = self.view.bounds
        gridView.view.isHidden = true
    }
    
    private func setUpNavigationBar(segmentedControl: UISegmentedControl) {
        
        navigationItem.titleView = segmentedControl
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)
    }
}
