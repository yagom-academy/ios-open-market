import Foundation

protocol APIService { }

extension APIService {
    func doDataTask<Type: Decodable>(
        with request: URLRequest,
        session: URLSessionProtocol,
        completionHandler: @escaping (Result<Type, NetworkingError>) -> Void
    ) {
        let task = session.dataTask(with: request) { data, response, error in
            guard error == nil else {
                return completionHandler(.failure(.request))
            }
            guard let response = response as? HTTPURLResponse,
                  (200...299).contains(response.statusCode) else {
                return completionHandler(.failure(.response))
            }
            guard let data = data else {
                return completionHandler(.failure(.data))
            }
            do {
                let decodedData: Type = try DecodeUtility.decode(data: data)
                completionHandler(.success(decodedData))
            } catch {
                completionHandler(.failure(.decoding))
            }
        }
        task.resume()
    }

    func checkNetworkConnection(
        session: URLSessionProtocol,
        completionHandler: @escaping ((Result<String, NetworkingError>) -> Void)
    ) {
        let urlString = "\(HTTPUtility.baseURL)/healthChecker"
        guard let request = HTTPUtility.urlRequest(urlString: urlString) else {
            return
        }
        doDataTask(with: request, session: session) { result in
            completionHandler(result)
        }
    }

    func makeMultipartFormData<T: Encodable>(
        parameters: T,
        images: [Data],
        boundary: String
    ) -> Data? {
        var formData = Data()
        guard let param = try? JSONEncoder().encode(parameters) else {
            return nil
        }
        formData.append(addJsonPart(name: "params", value: param, boundary: boundary))
        for image in images {
            formData.append(addImagePart(name: "images", image: image, boundary: boundary))
        }
        formData.append("--\(boundary)--\r\n")
        return formData
    }

    private func addJsonPart(name: String, value: Data, boundary: String) -> Data {
        var data = Data()
        data.append("--\(boundary)\r\n")
        data.append("Content-Disposition: form-data; name=\"\(name)\"\r\n")
        data.append("Content-Type: application/json\r\n\r\n")
        data.append(value)
        data.append("\r\n")
        return data
    }

    private func addImagePart(name: String, image: Data, boundary: String) -> Data {
        var data = Data()
        let filename = UUID().uuidString
        data.append("--\(boundary)\r\n")
        data.append(
            "Content-Disposition: form-data; name=\"images\"; filename=\"\(filename).png\"\r\n"
        )
        data.append("Content-Type: image/png\r\n\r\n")
        data.append(image)
        data.append("\r\n")
        return data
    }
}
