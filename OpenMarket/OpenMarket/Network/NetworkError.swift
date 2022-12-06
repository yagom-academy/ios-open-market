//  NetworkError.swift
//  OpenMarket
//  Created by SummerCat & Bella on 2022/11/18.

import Foundation

enum NetworkError: String, Error {
    case statusCodeError = "http 응답 에러"
    case noData = "데이터 없음"
    case URLError = "URL 오류"
    case decodingError = "디코딩 오류"
}
