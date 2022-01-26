//
//  PostManager.swift
//  OpenMarket
//
//  Created by Jae-hoon Sim on 2022/01/23.
//

import UIKit

class PostManager {
    
    private var delegate: PostResultRepresentable?

    func setDelegate(_ delegate: PostResultRepresentable) {
        self.delegate = delegate
    }

    func post(data: UnboundDataForPost, completion: @escaping () -> Void) {
        let provider = URLSessionProvider(session: URLSession(configuration: .default))

        do {
            provider.request(try createPostService(with: data)) { result in
                switch result {
                case .success:
                    completion()
                case .failure:
                    DispatchQueue.main.async {
                        self.delegate?.postManager(didFailPostingWithError: .createFailure)
                    }
                }
            }
        } catch let error as CreateProductError {
            self.delegate?.postManager(didFailPostingWithError: error)
        } catch {
            self.delegate?.postManager(didFailPostingWithError: .createFailure)
        }
    }
    
    private func createPostService(with data: UnboundDataForPost) throws -> OpenMarketService {

        let params: Data = try JSONEncoder().encode(requestParamsForPost(with: data))

        let images: [Image] = try processedImages(data.images)

        return OpenMarketService.createProduct(sellerID: "1c51912b-7215-11ec-abfa-13ae6fd5cdba", params: params, images: images)
    }
    
    private func requestParamsForPost(with data: UnboundDataForPost) throws -> CreateProductRequestParams {
        guard let name = data.name,
              (3...100).contains(name.count) else {
            throw CreateProductError.invalidProductName
        }
        guard let descriptions = data.descriptions,
              (10...1000).contains(descriptions.count) else {
            throw CreateProductError.invalidDescription
        }
        guard let priceInString = data.price,
              let priceInDecimal = Decimal(string: priceInString, locale: .none) else {
            throw CreateProductError.invalidPrice
        }
        guard let discountedPriceInString = data.discountedPrice,
              let discountedPriceInDecimal = discountedPriceInString == "" ? 0
                : Decimal(string: discountedPriceInString, locale: .none) else {
            throw CreateProductError.invalidDiscountedPrice
        }
        let discountedPrice = (0...priceInDecimal).contains(discountedPriceInDecimal) ? discountedPriceInDecimal : 0
        let stockInString = data.stock ?? "0"
        let stockInInt = Int(stockInString) ?? 0
        let secret = "!QA4M%Lat9yF-?RW"

        return CreateProductRequestParams(name: name,
                                          descriptions: descriptions,
                                          price: priceInDecimal,
                                          currency: data.currency,
                                          discountedPrice: discountedPrice,
                                          stock: stockInInt,
                                          secret: secret)
    }
    
    private func processedImages(_ images: [UIImage]) throws -> [Image] {
        var imageIdentifiers = try images.compactMap { image -> Image? in
            guard let jpegData = try compressedImage(image) else { return nil }
            return Image(type: .png, data: jpegData)
        }
        imageIdentifiers.removeLast()
        
        guard (1...5).contains(images.count) else {
            throw CreateProductError.invalidImages
        }

        return imageIdentifiers
    }
    
    private func compressedImage(_ image: UIImage) throws -> Data? {
        var quality: CGFloat = 1.0
        while let size = image.jpegData(compressionQuality: quality)?.count,
              size >= 307200 {
            print(size)
            quality -= 0.1
        }
        return image.jpegData(compressionQuality: quality)
    }
    
}
