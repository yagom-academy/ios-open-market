//
//  SessionManager.swift
//  OpenMarket
//
//  Created by 천수현 on 2021/05/13.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case patch = "PATCH"
    case delete = "DELETE"
}

enum BaseURL {
    static let page = "https://camp-open-market-2.herokuapp.com/items/"
    static let item = "https://camp-open-market-2.herokuapp.com/item/"
}

class SessionManager {
    static let shared = SessionManager(requestBodyEncoder: RequestBodyEncoder())
    let requestBodyEncoder: RequestBodyEncoderProtocol
    private init(requestBodyEncoder: RequestBodyEncoderProtocol) {
        self.requestBodyEncoder = requestBodyEncoder
    }

    func get<DecodedType: Decodable>(id: Int,
                                     completionHandler: @escaping (Result<DecodedType, OpenMarketError>) -> Void) {
        let urlString = (DecodedType.self is Page.Type) ? BaseURL.page + String(id) : BaseURL.item + String(id)

        guard let url = URL(string: urlString) else {
            completionHandler(.failure(.invalidURL(urlString)))

            return
        }

        URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            guard let data = data else {
                completionHandler(.failure(.didNotReceivedData))
                return
            }

            do {
                let jsonData = try JSONDecoder().decode(DecodedType.self, from: data)
                completionHandler(.success(jsonData))
            } catch {
                completionHandler(.failure(.invalidData(data)))
            }
        }.resume()
    }

    func postItem(_ postingItem: PostingItem, completionHandler: @escaping (Result<Item, OpenMarketError>) -> Void) {
        guard let url = URL(string: BaseURL.item) else {
            completionHandler(.failure(.invalidURL(BaseURL.item)))

            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("multipart/form-data; boundary=\(requestBodyEncoder.boundary)",
                         forHTTPHeaderField: "Content-Type")
        do {
            request.httpBody = try requestBodyEncoder.encode(postingItem)
        } catch let error as OpenMarketError {
            completionHandler(.failure(error))
        } catch {
            completionHandler(.failure(.bodyEncodingError))
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                completionHandler(.failure(.didNotReceivedData))
                return
            }

            do {
                let jsonData = try JSONDecoder().decode(Item.self, from: data)
                completionHandler(.success(jsonData))
            } catch {
                completionHandler(.failure(.invalidData(data)))
            }
        }.resume()
    }

    func patchItem(id: Int, patchingItem: PatchingItem,
                   completionHandler: @escaping (Result<Item, OpenMarketError>) -> Void) {
        let urlString = BaseURL.item + id.description

        guard let url = URL(string: urlString) else {
            completionHandler(.failure(.invalidURL(urlString)))

            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.patch.rawValue
        request.setValue("multipart/form-data; boundary=\(requestBodyEncoder.boundary)",
                         forHTTPHeaderField: "Content-Type")
        do {
            request.httpBody = try requestBodyEncoder.encode(patchingItem)
        } catch let error as OpenMarketError {
            completionHandler(.failure(error))
        } catch {
            completionHandler(.failure(.bodyEncodingError))
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                completionHandler(.failure(.didNotReceivedData))
                return
            }

            do {
                let jsonData = try JSONDecoder().decode(Item.self, from: data)
                completionHandler(.success(jsonData))
            } catch {
                guard let errorData = try? JSONSerialization.jsonObject(with: data,
                                                                       options: []) as? [String: String] else {
                    completionHandler(.failure(.invalidData(data)))
                    return
                }

                if errorData["message"] == "Cannot find data for ID and password" {
                    completionHandler(.failure(.unauthorizedAccess))
                }
            }
        }.resume()
    }

    func deleteItem(id: Int, password: String, completionHandler: @escaping (Result<Item, OpenMarketError>) -> Void) {
        guard let url = URL(string: BaseURL.item + String(id)) else {
            completionHandler(.failure(.invalidURL(BaseURL.item)))

            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.delete.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            request.httpBody = try JSONEncoder().encode(["password": password])
        } catch {
            completionHandler(.failure(.JSONEncodingError))

            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                completionHandler(.failure(.didNotReceivedData))
                return
            }

            do {
                let errorData = try JSONDecoder().decode(Item.self, from: data)
                completionHandler(.success(errorData))
            } catch {
                guard let errorData = try? JSONSerialization.jsonObject(with: data,
                                                                        options: []) as? [String: String] else {
                    completionHandler(.failure(.invalidData(data)))

                    return
                }

                if errorData["message"] == "Cannot find data for ID and password" {
                    completionHandler(.failure(.unauthorizedAccess))
                }
            }
        }.resume()
    }
}
