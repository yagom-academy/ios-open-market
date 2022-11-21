//
//  MainView.swift
//  OpenMarket
//
//  Created by Kyo, LJ on 2022/11/21.
//

import UIKit

final class MainView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["LIST", "GRID"])
        control.layer.borderColor = UIColor.blue.cgColor
        control.layer.borderWidth = 1
        control.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.blue],
                                       for: UIControl.State.normal)
        control.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white],
                                       for: UIControl.State.selected)
        
        control.selectedSegmentTintColor = .blue
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()
    
//    let listView: UICollectionView = {
//        let listView = UICollectionView()
//        listView.translatesAutoresizingMaskIntoConstraints = false
//        return listView
//    }()
//
//    let gridView: UICollectionView = {
//        let gridView = UICollectionView()
//        gridView.translatesAutoresizingMaskIntoConstraints = false
//        return gridView
//    }()
}


// MARK: - UI Constraint
extension MainView {
    private func setupUI() {
        self.addSubview(segmentedControl)
        setupConstraint()
    }
    func setupConstraint() {
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(
                equalTo: self.safeAreaLayoutGuide.topAnchor),
            segmentedControl.leadingAnchor.constraint(
                equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            segmentedControl.trailingAnchor.constraint(
                equalTo: self.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
}
