//
//  OpenMarket - NetworkError.swift
//  Created by Zhilly, Dragon. 22/11/16
//  Copyright © yagom. All rights reserved.
//

enum NetworkError: Error {
    case informational
    case redirection
    case clientError
    case serverError
    case unknownError
    case invalidData
    case dataTaskError
    case parsingError
}
