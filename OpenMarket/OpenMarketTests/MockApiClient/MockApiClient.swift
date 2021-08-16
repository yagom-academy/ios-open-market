//
//  MockApiClient.swift
//  OpenMarket
//
//  Created by jost, 잼킹 on 2021/08/10.
//

import Foundation
@testable import OpenMarket

class MockApiClient: Api, JSONDecodable {
    private static let delay = 1
    
    func getMarketPageItems(for pageNumber: Int, completion: @escaping (Result<MarketItems, Error>) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(MockApiClient.delay)) {
            switch pageNumber {
            case 1:
                let fileName = "Items"
                do {
                    let jsonData = try self.readLocalFile(for: fileName)
                    let items = try self.decodeJSON(MarketItems.self ,from: jsonData)
                    completion(.success(items))
                } catch let parsingError as ParsingError {
                    completion(.failure(parsingError))
                } catch {
                    completion(.failure(ParsingError.unknown))
                }
            default:
                completion(.failure(ParsingError.unknown))
            }
        }
    }
    
    func getMarketItem(for id: Int, completion: @escaping (Result<MarketItem, Error>) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(MockApiClient.delay)) {
            switch id {
            case 1:
                let fileName = "Item"
                do {
                    let jsonData = try self.readLocalFile(for: fileName)
                    let item = try self.decodeJSON(MarketItem.self, from: jsonData)
                    completion(.success(item))
                } catch let parsingError as ParsingError {
                    completion(.failure(parsingError))
                } catch {
                    completion(.failure(ParsingError.unknown))
                }
            default:
                completion(.failure(ParsingError.unknown))
            }
        }
    }
}
