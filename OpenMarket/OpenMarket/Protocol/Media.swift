//
//  Media.swift
//  OpenMarket
//
//  Created by 김준건 on 2021/08/17.
//

import Foundation

protocol Media {
    var key: String { get set }
    var fileName: String { get set }
    var contentType: MimeType { get set }
    var data: Data { get set }
}

