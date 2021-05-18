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
    static let shared = SessionManager()
    private let boundary: String = "Boundary-\(UUID().uuidString)"

    private init() {}

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
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.httpBody = body(from: postingItem)

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
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.httpBody = body(from: patchingItem)

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
            completionHandler(.failure(.JSONEncdoingError))

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

    func body(from formData: FormData) -> Data {
        var formDataBody = Data()

        for textField in formData.textFields {
            formDataBody.append(convertTextField(key: textField.key,
                                                 value: textField.value))
        }

        for fileField in formData.fileFields {
            formDataBody.append(convertFileField(key: fileField.key,
                                                 source: "image0.jpg",
                                                 mimeType: "image/jpeg",
                                                 value: fileField.value))
        }

        formDataBody.append("--\(boundary)--")
        print(String(decoding: formDataBody, as: UTF8.self))
        return formDataBody
    }

    private func convertFileField(key: String, source: String, mimeType: String, value: Data) -> Data {
        var dataField = Data()

        dataField.append("--\(boundary)\r\n")
        dataField.append("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(source)\"\r\n")
        dataField.append("Content-Type: \"\(mimeType)\"\r\n\r\n")
        dataField.append(value)
        dataField.append("\r\n")

        return dataField
    }

    private func convertTextField(key: String, value: String) -> String {
        var textField: String = "--\(boundary)\r\n"

        textField.append("Content-Disposition: form-data; name=\"\(key)\"\r\n")
        textField.append("\r\n")
        textField.append("\(value)\r\n")

        return textField
    }
}
