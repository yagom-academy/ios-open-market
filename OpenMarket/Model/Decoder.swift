//
//  ParsingMock.swift
//  ParsingTest
//
//  Created by 수박, ehd on 2021/08/10.
//

import UIKit

protocol Decoder {
    func parse<Model>(
        from data: Data,
        to model: Model.Type
    ) -> Result<Model, HttpError> where Model: Decodable
}

extension Decoder {
    func parse<Model>(
        from data: Data,
        to: Model.Type
    ) -> Result<Model, HttpError> where Model: Decodable {
        
        let decoder = JSONDecoder()
        
        do {
            let result = try decoder.decode(Model.self, from: data)
            
            return .success(result)
        } catch {
            if let error = try? decoder.decode(HttpError.self, from: data) {
                return .failure(error)
            } else {
                let unrecognizedError = HttpError(message: "?")
                
                return .failure(unrecognizedError)
            }
        }
    }
}

extension Decoder {
    func takeAssetData(assetName: String) throws -> Data {
        guard let convertedAsset = NSDataAsset(name: assetName) else {
            let debugDescription = "failed to take data from asset"
            let context = DecodingError.Context(
                codingPath: [],
                debugDescription: debugDescription
            )
            let error = DecodingError.valueNotFound(NSDataAsset.self, context)
            
            throw error
        }
        
        return convertedAsset.data
    }
}
