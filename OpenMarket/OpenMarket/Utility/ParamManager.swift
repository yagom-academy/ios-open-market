//
//  ParamManager.swift
//  OpenMarket
//
//  Created by 주디, 재재 on 2022/08/01.
//

import Foundation

struct ParamManager {
    func combineParamForPost(param: Param, imageParams: [ImageParam]) -> [[String : Any]]{
        let description = param.description.replacingOccurrences(of: "\n", with: "\\n")
         
        let dataElement: [[String : Any]] = [
            [
                "key": "params",
                "value": """
                        {
                            "name": "\(param.productName)",
                            "price": \(param.price),
                            "discounted_price": \(param.discountedPrice),
                            "stock": \(param.stock),
                            "currency": "\(param.currency)",
                            "secret": "\(param.secret)",
                            "descriptions": "\(description)"
                        }
                        """,
                "type": "text"
            ],
            [
                "key": "images",
                "images": imageParams
            ]
        ]
        
        return dataElement
    }
    
    func combineParamForPatch(param: Param) -> String {
        let dataElement = "{\n\"secret\": \"\(VendorInfo.secret)\",\n\"name\": \"\(param.productName)\"\n,\n\"price\": \(param.price)\n,\n\"discounted_price\": \(param.discountedPrice)\n,\n\"stock\": \(param.stock)\n,\n\"currency\": \"\(param.currency)\"\n,\n\"descriptions\": \"\(param.description)\"\n}"
        
        return dataElement
    }
}
