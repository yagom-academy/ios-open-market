//
//  EditView.swift
//  OpenMarket
//
//  Created by 박세리 on 2022/05/24.
//

import UIKit

final class EditView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    lazy var navigationBar: UINavigationBar = {
        let navigationBar = UINavigationBar(frame: CGRect(x: .zero, y: .zero, width: self.bounds.width, height: 50))
        navigationBar.items = [navigationBarItem]
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        navigationBar.barTintColor = .white
        navigationBar.shadowImage = UIImage()
        return navigationBar
    }()
    
    let navigationBarItem: UINavigationItem = {
        let navigationBarItem = UINavigationItem(title: "")
        let cancelItem = UIBarButtonItem(title: "Cancel", style: .plain, target: nil, action: nil)
        let doneItem = UIBarButtonItem(title: "Done", style: .plain, target: nil, action: nil)
        
        navigationBarItem.leftBarButtonItem = cancelItem
        navigationBarItem.rightBarButtonItem = doneItem
        return navigationBarItem
    }()
    
    private func addSubviews() {
        self.addSubview(navigationBar)
    }
    
    private func makeConstraints() {
        NSLayoutConstraint.activate([
            navigationBar.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            navigationBar.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            navigationBar.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    func setUpBarItem(title: String) {
        navigationBarItem.title = title
    }
}
                                            
