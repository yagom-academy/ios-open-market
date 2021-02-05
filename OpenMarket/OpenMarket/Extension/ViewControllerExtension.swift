//
//  ViewControllerExtension.swift
//  OpenMarket
//
//  Created by Yeon on 2021/02/04.
//

import Foundation
import UIKit

extension ViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.height
        
        if offsetY > (contentHeight - height) {
            if isPaging == false && hasNextPage {
                beginPaging()
            }
        }
    }

    func beginPaging() {
        isPaging = true

        if !self.itemTableView.isHidden {
            DispatchQueue.main.async {
                self.itemTableView.reloadSections(IndexSet(integer: 1), with: .none)
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.currentPage += 1
            self.loadItemList(page: self.currentPage)
            self.isPaging = false
        }
    }
}
