import Foundation

protocol APIManageable {
    func request(_ url: URL, _ httpMethod: String) -> URLRequest
    func requestHealthChecker(completionHandler: @escaping (Result<Data, URLSessionError>) -> Void)
    func requestProductInformation(productID: Int, completionHandler: @escaping (Result<ProductInformation, Error>) -> Void)
    func requestProductList(pageNumber: Int, itemsPerPage: Int, completionHandler: @escaping (Result<ProductList, Error>) -> Void)
}
