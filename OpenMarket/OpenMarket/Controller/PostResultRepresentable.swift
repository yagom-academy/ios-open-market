//
//  PostResultRepresentable.swift
//  OpenMarket
//
//  Created by Jae-hoon Sim on 2022/01/24.
//

import Foundation

protocol PostResultRepresentable: AnyObject {
    func postManagerDidSuccessPosting()
    func postManager(didFailPostingWithError error: CreateProductError)
}
