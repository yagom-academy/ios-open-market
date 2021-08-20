//
//  DataForm.swift
//  OpenMarket
//
//  Created by Luyan, Ellen on 2021/08/20.
//

import Foundation

protocol DataForm {
    var contentType: String { get }
    func createBody() throws -> Data?
}


