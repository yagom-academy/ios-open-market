//  StockStatus.swift
//  OpenMarket
//  Created by SummerCat on 2022/11/29.

enum StockStatus: String {
    case soldOut = "품절"
    case enoughStock = "재고 여유 있음"
    case remainingStock = "잔여수량"
    case stockError = "오류"
}
