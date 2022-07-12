//
//  URLSession.swift
//  OpenMarket
//
//  Created by 유한석 on 2022/07/12.
//

import Foundation

func checkUrl() {
    //가장 기본 폼
    let urlString = URL(string: UrlData.urlHost.rawValue)
    guard let url = URL(string: "api/products?page_no=1&items_per_page=10", relativeTo: urlString) else {
        print("URL() 메서드 에서 에러남")
        return
    }
    
    print("전체 주소 : \(url.absoluteURL )")
    print("네트워킹 방식: \(url.scheme)")
    print("Host 주소: \(url.host)")
    print("메서드 경로: \(url.path)")
    print("쿼리 파라미터: \(url.query)")
    print("베이스 주소: \(url.baseURL)")
}

func checkUrlComponents() {
    //url로 하는것 보다 query를 좀 더 쉽게 지정할 수 있다.
    var urlComponents = URLComponents(string: UrlData.urlHost.rawValue + "api/products?")
    // 쿼리 아이템 선언
    let pageNo = URLQueryItem(name: "page_no", value: "1")
    let itemsPerPage = URLQueryItem(name: "items_per_page", value: "10")
    // URL Components에 등록
    urlComponents?.queryItems?.append(pageNo)
    urlComponents?.queryItems?.append(itemsPerPage)
    
    print("컴포넌트를 활용한 전체 URL(스트링아님): \(urlComponents?.url)")
    print("컴포넌트를 활용한 전체 URL(스트링형태): \(urlComponents?.string)")
    print("아이템들 : \(urlComponents?.queryItems)")
}

func dataTask() {
    /* 메서드 주소를 지정
     1. URLSessionConfiguration을 생성하여 통신 형태 지정
     1-1. (세 가지 존재): .default / .ephemeral / .background
     2. URLSession 과 URLComponents를 활용하여 DataTask를 생성
     3. resume() 하여 통신 시작
     */
    let config = URLSessionConfiguration.default
    let session = URLSession(configuration: config)
    
    var urlComponents = URLComponents(string: UrlData.urlHost.rawValue + "api/products?")
    let pageNo = URLQueryItem(name: "page_no", value: "1")
    let itemsPerPage = URLQueryItem(name: "items_per_page", value: "10")
    urlComponents?.queryItems?.append(pageNo)
    urlComponents?.queryItems?.append(itemsPerPage)
    
    guard let requestURL = urlComponents?.url else {
        return
    }
    
    let dataTask = session.dataTask(with: requestURL) { (data, response, error) in
        // error가 존재하면 종료
        guard error == nil else {
            return
        }
        // status 코드가 200번대여야 성공적인 네트워크라 판단
        let successsRange = 200..<300
        guard let statusCode = (response as? HTTPURLResponse)?.statusCode,
              successsRange.contains(statusCode) else {
            return
        }
        // response 데이터 획득, utf8인코딩을 통해 string형태로 변환
        guard let resultData = data else {
            return
        }
        let decoder = JSONDecoder()
        do {
            let fetchedData = try decoder.decode(ProductPage.self, from: resultData)
            print(fetchedData.showSelf())
        } catch {
            print(error.localizedDescription)
        }
        //let resultString = String(data: resultData, encoding: .utf8)
    }
    dataTask.resume()
}
