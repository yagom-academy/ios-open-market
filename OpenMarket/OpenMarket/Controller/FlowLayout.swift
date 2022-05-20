//
//  FlowLayout.swift
//  OpenMarket
//
//  Created by 김동욱 on 2022/05/19.
//

import UIKit

final class FlowLayout: UICollectionViewFlowLayout {
    override init() {
        super.init()
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func changeLayout(_ type: LayoutType) {
        switch type {
        case .list:
            listLayout()
        case .grid:
            gridLayout()
        }
    }
    
    private func configure() {
        scrollDirection = .vertical
    }
    
    private func listLayout() {
        sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        minimumLineSpacing = 5
    }
    
    private func gridLayout() {
        sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
}
