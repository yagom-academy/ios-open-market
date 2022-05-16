//
//  ProductsListDTO.swift
//  OpenMarket
//
//  Created by Red, Mino on 2022/05/10.
//

struct ProductsListDTO: Encodable{
    let pageNumber: Int
    let perPages: Int
    
    private enum CodingKeys: String, CodingKey {
        case pageNumber = "page_no"
        case perPages = "items_per_page"
    }
}
