//
//  Data + extension.swift
//  OpenMarket
//
//  Created by unchain, hyeon2 on 2022/07/30.
//

import Foundation

extension Data {
    mutating func append(form: String) {
        guard let data = form.data(using: .utf8) else { return }
        self.append(data)
    }
}
