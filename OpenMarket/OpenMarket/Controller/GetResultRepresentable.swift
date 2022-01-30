//
//  GetResultRepresentable.swift
//  OpenMarket
//
//  Created by Jae-hoon Sim on 2022/01/26.
//

import Foundation
import UIKit.NSDiffableDataSourceSectionSnapshot

protocol GetResultRepresentable: AnyObject {
    func getManagerDidResetItems()
    func getManager(didAppendItems items: [Product])
}
