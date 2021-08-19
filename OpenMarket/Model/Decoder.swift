//
//  ParsingMock.swift
//  ParsingTest
//
//  Created by 수박, ehd on 2021/08/10.
//

import UIKit

protocol Decoder {
    func parse<Model, ErrorModel>(
        from data: Data,
        to model: Model.Type,
        or errorModel: ErrorModel.Type
    ) -> Result<Model, ErrorModel> where Model: Decodable, ErrorModel: ErrorMessage
}

extension Decoder {
    func parse<Model, ErrorModel>(
        from data: Data,
        to model: Model.Type,
        or errorModel: ErrorModel.Type
    ) -> Result<Model, ErrorModel> where Model: Decodable, ErrorModel: ErrorMessage {
        
        let decoder = JSONDecoder()
        
        do {
            let result = try decoder.decode(Model.self, from: data)
            
            return .success(result)
        } catch {
            if let error = try? decoder.decode(ErrorModel.self, from: data) {
                return .failure(error)
            } else {
                let unrecognizedError = ErrorModel(message: .parsingError)
                
                return .failure(unrecognizedError)
            }
        }
    }
}
