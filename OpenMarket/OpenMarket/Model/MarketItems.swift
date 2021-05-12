//
//  MarketItems.swift
//  OpenMarket
//
//  Created by Fezz, Tak on 2021/05/12.
//

import Foundation

struct MarketItems: ProductList {
    let page: UInt
    let items: [Infomation]
    
    struct Infomation: ProductInfo {
        let id: UInt
        let title: String
        let price: UInt
        let currency: String
        let stock: UInt
        let discountedPrice: UInt?
        let thumbnails: [String]
        let registrationData: Double
        
        enum CodingKeys: String, CodingKey {
            case id, title, price, currency, stock, thumbnails
            case discountedPrice = "discounted_price"
            case registrationData = "registration_date"
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.id = (try? container.decode(UInt.self, forKey: .id)) ?? 0
            self.title = (try? container.decode(String.self, forKey: .title)) ?? ""
            self.price = (try? container.decode(UInt.self, forKey: .price)) ?? 0
            self.currency = (try? container.decode(String.self, forKey: .currency)) ?? ""
            self.stock = (try? container.decode(UInt.self, forKey: .stock)) ?? 0
            self.discountedPrice = (try? container.decode(UInt?.self, forKey: .discountedPrice)) ?? 0
            self.thumbnails = (try? container.decode([String].self, forKey: .thumbnails)) ?? []
            self.registrationData = (try? container.decode(Double.self, forKey: .registrationData)) ?? 0.0
        }
    }
    
    enum CodingKeys: CodingKey {
        case page, items
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.page = (try? container.decode(UInt.self, forKey: .page)) ?? 0
        self.items = (try? container.decode([Infomation].self, forKey: .items)) ?? []
    }
}
