//
//  Image.swift
//  OpenMarket
//
//  Created by 김동용 on 2022/07/12.
//

struct Image: Decodable {
    private(set) var id: Int
    private(set) var url: String
    private(set) var thumbnailURL: String
    private(set) var succeed: Bool
    private(set) var issuedAt: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case url
        case thumbnailURL = "thrumbnail_url"
        case succeed
        case issuedAt = "issued_at"
    }
}
