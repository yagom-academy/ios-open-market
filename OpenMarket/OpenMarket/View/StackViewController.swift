//
//  StackViewController.swift
//  OpenMarket
//
//  Created by jin on 11/22/22.
//

import UIKit

class StackViewController : UIViewController {
    
    let stackedViewsProvider: StackedViewsProvider

    init(stackedViewsProvider: StackedViewsProvider) {
        self.stackedViewsProvider = stackedViewsProvider
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .darkGray
        self.view = view
        
        let stackView = UIStackView(arrangedSubviews: [])
        view.addSubview(stackView)
        
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.axis = .vertical
        stackView.spacing = 32
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 32),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])
    }
}

protocol StackedViewsProvider {
    var views: [UIView] { get }
}

class SegmentedControlStackedViewsProvider: StackedViewsProvider {
    let items = ["Apple", "Banana", "Carrot"]
    
    lazy var views: [UIView] = {
        return [
            createView(items: items)
        ]
    }()
    
    private func createView(items: [String]) -> UIView {
        let segmentedControl = UISegmentedControl(items: items)
        segmentedControl.tintColor = .white
        segmentedControl.selectedSegmentIndex = 0
        
        return segmentedControl
    }
}
