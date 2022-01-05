//
//  Parsable.swift
//  OpenMarket
//
//  Created by Jun Bang on 2022/01/05.
//

import Foundation

protocol Parsable {
    func parse(with data: Data) -> Page?
    func parse(with data: Data) -> Product?
}

extension Parsable {
    func parse(with data: Data) -> Page? {
        do {
            let data = try JSONDecoder().decode(Page.self, from: data)
            return data
        } catch {
            return nil
        }
    }
    
    func parse(with data: Data) -> Product? {
        do {
            let data = try JSONDecoder().decode(Product.self, from: data)
            return data
        } catch {
            return nil
        }
    }
}
