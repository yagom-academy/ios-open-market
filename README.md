# 🏪 오픈 마켓1
> 프로젝트 기간: 2022-05-09 ~ 2022-05-20
> 
> 팀원: [Safari](https://github.com/saafaaari), [dudu](https://github.com/firstDo)
> 
> 리뷰어: [개굴🐸](https://github.com/yoo-kie)

## 🔎 프로젝트 소개

> 네트워크 요청을 통해 데이터를 받아와 `CollectionView`에 LIST, GIRD `Cell` 레이아웃으로 보여주는 오픈마켓 프로젝트

## 📺 프로젝트 실행화면

<img src = "https://i.imgur.com/Uj85GyM.gif" width = "300">

## 👀 PR
- [STEP 1](https://github.com/yagom-academy/ios-open-market/pull/136)
- [STEP 2](https://github.com/yagom-academy/ios-open-market/pull/145)


## 🛠 개발환경 및 라이브러리
- [![swift](https://img.shields.io/badge/swift-5.0-orange)]()
- [![xcode](https://img.shields.io/badge/Xcode-13.0-blue)]()
- [![iOS](https://img.shields.io/badge/iOS-13.2-red)]()


## 🔑 키워드
- `Network`
- `URLSession Mock Test`
- `Json Decoding Strategy`
- `XCTestExpection`
- `completionHandler`
- `Escaping Closure`
- `URLSession`
- `Test Double`
- `URLProtocol`
- `EndPoint`
- `CompostionalLayout`
- `UICollectionViewDiffableDataSource`
- `NSDiffableDataSourceSnapshot`
- `NSCache`
- `CollectionView Cell Prefecting`
- `CollectionView Paging`

## ✨ 구현내용
- Network 통신을 위한 타입 구현
- Network 통신없이 타입을 테스트하기 위한 MockURLSession 객체 구현
- 상품 상세 조회를 위한 Model 타입 구현
- 상품 리스트 조회를 위한 Model 타입 구현
- `URLProtocol`를 이용해 MockNetwork 객체 수정
- `FlowLayout` + `DataSource`/`Delegate`프로토콜을 활용한 CollectionView 구현
- `CompostionalLayout` + `UICollectionViewDiffableDataSource`/ `NSDiffableDataSourceSnapshot` 구현
- `NavigationBar` + `SegmentControl` 구현 
- `List` 형식의 `CollectionView` 구현
- 네트워크 통신을 통해 받은 데이터 `CollectionView`에 표현
- `NSCache`를 활용한 Network Image Caching 기능 구현
- `DataSourcePrefetching` 활요한 paging 기능 구현
- `RefreshControl` 기능 구현
- `UIActivityindicatorView` 기능 구현


## 📖 학습내용
- `JsonDecoder`의 Decoding Strategy
- `URLSession`을 이용한 네트워크에 데이터 요청
- `completionHandler`의 사용 방법 및 개념
- 네트워크 없이 타입을 `UniTest`하기 위한 방법
- UICompostionalLayout, UICollectionViewDiffableDataSource,NSDiffableDataSourceSnapshot 를 이용한 collectionView 구현
- Network에서 data 다운받을때 paging 방법

## 🤔 STEP별 고민한 점 및 해결한 방법

## [STEP 1]

### 1. 네트워크 통신 없이 네트워크 로직을 테스트하는 방법

핵심은 session을 바꿔치기 해서 URLSession의 DataTask 매서드를 재정의 하는것..!
네트워크에서 data, response, error를 내려주는데, 네트워크 통신 없이도 해당 3요소를 반환해주도록 매서드를 작성하는것!

```swift
// URLSessionProtocol을 생성하고, URLSession에 채택
typealias DataTaskCompletionHandler = (Data?, URLResponse?, Error?) -> Void

protocol URLSessionProtocol {
    func dataTask(with url: URL, completionHandler: @escaping DataTaskCompletionHandler) -> URLSessionDataTask
}

extension URLSession: URLSessionProtocol {}

```


```swift
// DummyData를 data형태로 저장하고 있을 모델
struct DummyData {
    var data: Data?
    
    init() {
        guard let path = Bundle.main.path(forResource: "products", ofType: "json") else { return }
        guard let jsonString = try? String(contentsOfFile: path) else { return }
        data = jsonString.data(using: .utf8)
    }
}

// URLSessionDataTask를 상속받아, resume()을 재정의

final class MockURLSessionDataTask: URLSessionDataTask {
    var completion: () -> Void = {}

    override func resume() {
        completion()
    }
}

// URLSessionProtocol을 상속받아 dataTask 매서드를 구현하고, 내부적으로 flag에 따라 성공, 실패 경우의 데이터를 만들어서 최종적으로 URLSessionDataTask를 return하도록 구현

final class MockURLSession: URLSessionProtocol {
    var isRequestSuccess: Bool
    
    init(isRequestSuccess: Bool = true) {
        self.isRequestSuccess = isRequestSuccess
    }
    
    func dataTask(with url: URL, completionHandler: @escaping DataTaskCompletionHandler) -> URLSessionDataTask {
        let successResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: "2", headerFields: nil)
        let failureResponse = HTTPURLResponse(url: url, statusCode: 404, httpVersion: "2", headerFields: nil)
        
        let sessionDataTask = MockURLSessionDataTask()
        let dummyData = DummyData()
        
        if isRequestSuccess {
            sessionDataTask.completion = {
                completionHandler(dummyData.data, successResponse, nil)
            }
        } else {
            sessionDataTask.completion = {
                completionHandler(nil, failureResponse, nil)
            }
        }
        return sessionDataTask
    }
}

```

### 2. URLSession에 shared vs configuration

`URLSession` 객체를 사용하는 방법은 크게 두가지가 있다고 생각했습니다.

첫 번째는 `URLSession`의 싱글톤 패턴으로 구현된 공용 객체를 사용하는 방법이고, 
두 번째는 `URLSession` 인스턴스를 생성해 `configuration`을 주입해주는 방법입니다.

결론적으로, 두 번째 방법을 선택했는데 이유는 `shared`을 이용하는 경우 `URLSession`을 커스텀 할 수 없고, 고정된 `default` 세션 밖에 사용할 수 없었습니다. 또한 

```swift
let config = URLSessionConfiguration.default
config.waitsForConnectivity = true
config.timeoutIntervalForResource = 300
```

위와 같이 `URLSessionConfiguration`에 속성들을 이용하여 좀더 유연한 `URLSession`을 만들 수 있다는 생각이 들어 `configuration`를 이용하여 `URLSession` 객체를 사용하였습니다.

### 3. 비동기 매서드의 테스트

비동기 매서드의 경우, test 매서드가 시작하자마자 끝나기 때문에, 무조건 test를 통과합니다.
이때 XCTestExpection을 사용하면 비동기 매서드의 종료 시점에 테스트를 수행할 수 있습니다

```swift
//XCTestExpectation 생성
let promise = expectation(description: "will return product")

// 비동기 매서드가 끝나는 시점에 호출
promise.fulfill()

// test 매서드 마지막에 작성하여, 비동기 작업을 기다리도록 함
wait(for: [promise], timeout: 10)
```

### 4. JSONDecoder Decoding Strategy

#### keyDecodingStrategy

```swift
jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
```

위 속성을 이용하여 Josn을 파싱할 때 별도의 네이밍 수정이 필요 없을 경우, snake_case -> lowerCamelCase로 `CodingKey` 없이 한번에 변환할 수 있었습니다.

#### DateDecodingStrategy
Json을 파싱하였을 때 기본 `JsonDecoder`로는 `Date`타입을 받을 수 없었습니다. 때문에 `DateFormatter`를 이용하여 `JsonDecoder`의 `dateDecodingStrategy` 전략을 추가하여 결과적으로 Json을 파싱하여 Date타입을 얻을 수 있었습니다.

```swift
let dateFormatter = DateFormatter()
dateFormatter.dateFormat = "yyyy-MM-dd'T'hh:mm:ss.SS"

jsonDecoder.dateDecodingStrategy = .formatted(DateFormatter)
```


## [STEP 2]

### 1. URLProtocol을 이용한 test 객체 만들기

기존에는 URLSessionDataTask 클래스를 상속받아서 Mock 객체를 만들고 있었는데, 해당 클래스의 init() deprecated되서 고민했습니다.

2018 WWDC를 봤는데, URLProtocol을 사용해서 테스트하는 방법이 있어서 그대로 적용했습니다

final class MockURLProtocol: URLProtocol {
    static var requsetHandler: ((URLRequest) throws -> (HTTPURLResponse, Data))?
    
```swift
override class func canInit(with request: URLRequest) -> Bool {
    return true
}

override class func canonicalRequest(for request: URLRequest) -> URLRequest {
    return request
}

override func startLoading() {
    guard let handler = Self.requsetHandler else {
        XCTFail()
        return
    }
    do {
        let (response, data) = try handler(request)
        client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        client?.urlProtocol(self, didLoad: data)
        client?.urlProtocolDidFinishLoading(self)
    } catch {
        client?.urlProtocol(self, didFailWithError: error)
    }
}

override func stopLoading() {}
```

### 2. Protocol을 이용한 Cell 추상화

이번 프로젝트에서 두개의 Cell을 이용하였습니다.(list, grid)
때문에 dequeueReusableCell에서 Cell 타입이 달라 스위치로 분리 처리할 수 밖에 없었습니다. 두 Cell을 추상화 해주기 위해서 ProductCell이라는 프로토콜을 만들고, CollectionLayout 열거형에서 cellType이라는 프로퍼티로 Cell의 메타타입을 반환 해줘, 반환값으로 상황에 맞는 Cell을 만들 수 있도록 구현하였습니다.

```swift
// 추상화를 위한 프로토콜
protocol ProductCell: UICollectionViewCell {
    func configure(data: Product)
    func setImage(with image: UIImage)
}

extension ProductCell {
    static var identifier: String {
        return String(describing: self)
    }
}
```

```swift
// 분기처리를 해주는 열거형
enum CollectionLayout: Int {
    case list = 0
    case grid = 1
    
    var cellType: ProductCell.Type {
        switch self {
        case .list:
            return ProductListCell.self
        case .grid:
            return ProductGridCell.self
        }
    }
}
```

### 3. CompositionalLayout & DiffableDataSource를 이용한 CollectionView 구현

먼저 flowLayout/ CompostionalLayout + DelegateMethod 방식으로 구현해본 후, 최종적으로 CompostionalLayout + DiffableDataSouce + Snapshot 방식으로 결정했습니다

프로젝트 요구사항을 충족시키기 위해 list, grid의 layout을 만들 필요성이 있었습니다.
고민끝에 layouy과 cell을 각각 2개씩 만들어서 segmentControl 선택에 따라서 collectionView의 layout을 변경해 주도록 했습니다.

### 4. EndPoint, NetworkManager를 이용한 네트워크 통신

get, post, put, delete 작업까지 처리할 수 있게 하기 위해
EndPoint를 다음과 같이 만들어 봤습니다.

```swift
import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

enum EndPoint {
    case serverState(httpMethod: HTTPMethod, sendData: Encodable? = nil)
    case requestList(page: Int, itemsPerPage: Int, httpMethod: HTTPMethod, sendData: Encodable? = nil)
    case requestProduct(id: Int, httpMethod: HTTPMethod, sendData: Encodable? = nil)
}

extension EndPoint {
    private static var host: String {
        "https://market-training.yagom-academy.kr/"
    }
    
    private var url: URL? {
        switch self {
        case .serverState:
            return URL(string: Self.host + "healthChecker")
        case .requestList(let page, let itemsPerPage, _, _):
            return URL(string: Self.host + "api/products?items_per_page=\(itemsPerPage)&page_no=\(page)")
        case .requestProduct(let id, _, _):
            return URL(string: Self.host + "api/products/\(id)")
        }
    }
    
    var urlRequst: URLRequest? {
        switch self {
        case .serverState(let httpMethod, let sendData):
            return makeUrlRequest(httpMethod: httpMethod, sendData: sendData)
        case .requestList(_, _, let httpMethod, let sendData):
            return makeUrlRequest(httpMethod: httpMethod, sendData: sendData)
        case .requestProduct(_, let httpMethod, let sendData):
            return makeUrlRequest(httpMethod: httpMethod, sendData: sendData)
        }
    }
    
    private func makeUrlRequest(httpMethod: HTTPMethod, sendData: Encodable? = nil) -> URLRequest? {
        guard let url = url else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        request.httpBody = sendData?.encodeData()
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
}
```

### 5. Paging

조금더 사용자들에게 데이터가 부드럽게 보여지기 위해 UICollectionViewDataSourcePrefetching 프로토콜을 채택하고,

func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath])
메소드를 이용하여 보여질 Cell의 IndexPath를 가져와 일정 스크롤을 내리면, 미리 다음 페이지에 대한 데이터를 다운받는 기능을 구현하였습니다.

private func prefetchData(_ indexPaths: [IndexPath]) {
    guard let indexPath = indexPaths.last else { return }
    
    let section = indexPath.row / Constant.requestItemCount
    
    if section + 1 == pageNumber {
        pageNumber += 1
        requestData(pageNumber: pageNumber)
    }
}

위 처럼 사용자가 보고있는 페이지의 다음 페이지를 미리 네트워크에서 받아와 부드럽게 데이터를 보여주고 싶었습니다. 하지만, 데이터를 받아올 뿐 image를 미리 받아 뿌려주지 못해 아쉬움이 남습니다.
