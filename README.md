# 🛒 오픈 마켓
> 프로젝트 기간: 2022-05-09 ~ 2022-06-03
> 
> 팀원: [Safari](https://github.com/saafaaari), [dudu](https://github.com/firstDo)
> 
> 리뷰어: [개굴](https://github.com/yoo-kie)

## 🔎 프로젝트 소개

> 물건을 사고 파는 나만의 오픈마켓

## 📺 프로젝트 실행화면

|Main 화면|상품 등록 화면|
|:---:|:---:|
|<img src="https://user-images.githubusercontent.com/91936941/172367434-8f568029-3b98-49e7-8677-d0201bdb87f3.gif" width="250">|<img src="https://user-images.githubusercontent.com/91936941/172367614-79e28669-5d74-4f45-b57e-e967e997c398.gif" width="250">|

|Detail 화면| 상품 수정| 상품 삭제 | 
|:---:|:---:|:---:|
|![](https://i.imgur.com/2GBt9CU.gif)|![](https://i.imgur.com/CYRrTpd.gif)| ![](https://i.imgur.com/VDRPIzB.gif)

## 👀 PR
- [STEP 1](https://github.com/yagom-academy/ios-open-market/pull/136)
- [STEP 2](https://github.com/yagom-academy/ios-open-market/pull/145)
- [STEP 3](https://github.com/yagom-academy/ios-open-market/pull/156)
- [STEP 4](https://github.com/yagom-academy/ios-open-market/pull/166)


## 🛠 개발환경 및 라이브러리
- [![swift](https://img.shields.io/badge/swift-5.0-orange)]()
- [![xcode](https://img.shields.io/badge/Xcode-13.0-blue)]()
- [![iOS](https://img.shields.io/badge/iOS-13.2-red)]()


## 🔑 키워드
- `Network Get/Post/Petch`
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
- `TextFieldDelegate, TextViewDelegate`
- `MultipartForm data`
- `UIImagePickerController`

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
- 다운로드 취소 기능 구현
- 제품 수정 및 등록 UI 구현
- Text Field 입력 정보에 맞는 키보드 및 입력 제한 기능 구현
- 제품 수정을 위한 네트워크 PETCH 기능 구현
- 제품 등록을 위한 네트워크 POST 기능 구현
- Image 데이터 압축 기능 구현

## 📖 학습내용
- `JsonDecoder`의 Decoding Strategy
- `URLSession`을 이용한 네트워크에 데이터 요청
- `completionHandler`의 사용 방법 및 개념
- 네트워크 없이 타입을 `UniTest`하기 위한 방법
- `UICompostionalLayout`, `UICollectionViewDiffableDataSource`, NSDiffableDataSourceSnapshot 를 이용한 `collectionView` 구현
- `Network`에서 `data` 다운받을때 `paging` 방법
- `URLSessionTask` `cancel` 메소드 사용 방법
- 'UITextField' 텍스트에 제약을 주는 방법
- `UITextField`의 inputAccessroyView 사용법
- `MultipartForm data`, `JSON data` 를 이용한 post 통신, petch 통신
- `UIImagePickerController`를 이용한 Image 가져오는 방법

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
```swift
func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath])
```
메소드를 이용하여 보여질 Cell의 IndexPath를 가져와 일정 스크롤을 내리면, 미리 다음 페이지에 대한 데이터를 다운받는 기능을 구현하였습니다.
```swift
private func prefetchData(_ indexPaths: [IndexPath]) {
    guard let indexPath = indexPaths.last else { return }
    
    let section = indexPath.row / Constant.requestItemCount
    
    if section + 1 == pageNumber {
        pageNumber += 1
        requestData(pageNumber: pageNumber)
    }
}
```
위 처럼 사용자가 보고있는 페이지의 다음 페이지를 미리 네트워크에서 받아와 부드럽게 데이터를 보여주고 싶었습니다. 하지만, 데이터를 받아올 뿐 image를 미리 받아 뿌려주지 못해 아쉬움이 남습니다.

### 6. Cell에 이미지 깜빡거림을 해결하기 위한 다운로드 취소 기능구현

Cell의 재사용 특성 때문에 빠르게 스크롤 시 Cell에 이미지 다운로드가 겹쳐 

<img src="https://i.imgur.com/vNUSEfz.gif" width="200">

아래 처럼 이미지가 깜빡거리는 이슈가 있었습니다. 처음엔,

```swift
guard collectionView.indexPath(for: cell) == indexPath else { return }
```
위처럼 조건문을 이용하여 `indexPath` 검사해 올바른 Cell에 올바른 이미지가 로드되도록 구현하였습니다. 하지만, iOS15 아래의 버전에서는 올바르게 검사되지 않는 버그가 발생했습니다. 버그를 해결하기 위해 이미지의 로드가 아예 겹치지 않도록, 

```swift
func downloadImage(urlString: String?, 
                   completion: @escaping (Result<UIImage, NetworkErorr>) -> Void) -> URLSessionDataTask?
```
```swift
imageDownloadTask = ImageManager.shared.downloadImage(urlString: imageURL) { 
    ...중략
}

```

`prepareForReuse`메서드 내부에서 `downloadImage` 메서드에서 `URLSessionDataTask`를 반환받아,

```swift
imageDownloadTask?.suspend()
imageDownloadTask?.cancel()
```

위와 같이 `URLSessionDataTask`를 `suspend`메서드로 중지 시키고, `cancel` 메서드를 이용해 취소하였습니다.

### 7. AlertController를 사용하기 위한 Builder Pattern

재사용성을 높이기 위해 Product - Builder - Director 를 가지는 Builder Pattern으로 AlertController를 구현했습니다.

```swift

// Director
final class AlertDirector {
    private let viewController: UIViewController
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func createErrorAlert() {
        AlertBuilder(viewController: viewController)
            .setTitle("에러 발생")
            .setMessage("데이터를 불러오지 못했습니다.")
            .setOkActionTitle("확인")
            .show()
    }
}
```

```swift
// 실제 사용
AlertDirector(viewController: self).createErrorAlert()
```

## [STEP 3]

### 1. textField에 입력제한을 두는 법

가격, 할인가격, 재고 textField에는 양의 정수만 들어가야하는 제약사항이 있었습니다.
TextFieldDelegate, TextViewDelegate를 채택하여 

```swift
textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
```

### 2. cell에 x버튼 추가

제품 등록 화면에서 등록한 이미지를 다시 사용자가 취소할 수 있도록 Cell 상단에 x버튼을 추가하여, 클릭시 등록한 이미지를 삭제할 수 있도록 구현하였습니다. 또한 x버튼을 클릭하면 cell 자신이 지워질 수 있도록 Cell에 클로저 프로퍼티를 추가하고, addTarget을 Cell내부에서 해주었습니다.

![](https://i.imgur.com/ddrFKET.gif)

### 3. multipart form - data

상품을 서버에 등록하기 위해 `multipart form - data` 포멧을 사용하여 데이터를 등록하였습니다. 그 덕분에 서로다른 형식의 데이터를 동시에 보낼 수 있게 되었습니다. Model 데이터 부분은 Model 타입을 인코팅하였고, 이미지는 이미지를 데이터로 compactMap을 활용하여 변환 후 반복문을 통해 

```swift
let newLine = "\r\n"
let boundaryPrefix = "--\(boundary)\r\n"
let boundarySuffix = "\r\n--\(boundary)--\r\n"
// ..중략
for imageData in imageDatas {
    data.appendString(boundaryPrefix)
    data.appendString("Content-Disposition: form-data; name=\"images\"; filename=\"\(fileName).jpg\"\r\n")
    data.appendString("Content-Type: image/jpg\r\n\r\n")
    data.append(imageData)
    data.appendString(newLine)
}
```

### 4. Keyboard 이슈

- autolayout 제약문제
    - sizeToFit 매서드 호출 순서를 바꿔 해결했습니다
- keyboard appear시 view가 가려지는 문제
    - frame.origin.y 좌표를 수정하여 view 자체를 올려주었습니다

### 5. 이미지 압축

```swift
private func compress(image: UIImage) -> Data? {
    guard var jpegData = image.jpegData(compressionQuality: 1.0) else { return nil }
    while jpegData.count >= 300 * 1024 {
        guard let image = UIImage(data: jpegData) else { return nil }
        guard let data = image.jpegData(compressionQuality: 0.8) else { return nil }
        
        jpegData = data
    }
    return jpegData
}
```

위처럼 등록될 이미지를 받아 데이터로 변환 후 데이터의 크기를 체크해 300KB가 넘으면, 더 낮은 0.8의 퀄리티로 재압축하도록 구현하였습니다.

## [STEP 4]

### 1. product를 post, patch, delete 후, 화면을 업데이트 하는 방법

원래는 delegate 패턴을 썼었는데, 뷰컨들이 많아지다보니 너무 복잡해지는 문제가 있었습니다.
그래서 Notification을 사용해서  단순히 업데이트를 발생시키는 곳에서 post를 하고
해당 이벤트를 받아서 뷰컨을 업데이트 시켜야 할 곳에서 addObserver를 방법으로 바꿨습니다


### 2. 자신이 올린 게시글만 수정및 삭제가 가능하도록 기능 구현

자신이 올린 글만을 수정 및 삭제가 가능하도록 만들고 싶어, 오른쪽 상단에 수정/삭제 버튼을 유저의 정보와 네트워크를 통해 받아온 작성자 데이터의 id를 비교하여 동일하면, 버튼을 navigationitem에 추가하는 방법으로 기능을 구현하였습니다.

### 3. DetailProductView의 PageIndex 표시

처음에는 CollectionViewFooter를 사용해서 해보려 했는데, scroll에 따라 동적으로 변경되어야 하는 text가 footer에 들어가는게 맞지 않더라구요.

그래서 그냥 UILabel을 만들고, Cell이 Scroll될때마다 ScrollView의 delegate를 활용해서 업데이트를 시키려고 했는데, Delegate 매서드가 동작하지 않는 문제가 있었습니다.

찾아보니까 CompostionalLayout을 사용하면 인식을 못한다는 말이 있더라구요.
그래서 대신 NSCollectionLayoutSection의 visibleItemsInvalidationHandler 프로퍼티를 활용해서 구현하였습니다

<img src = "https://i.imgur.com/VjvpQJG.gif" width = "200">

### 4. Network API의 추상화

기존에는 Endpoint라는 enum을 만들고, 요청 api들에 대한 case를 만들어서 관리하였습니다.
그런데 이렇게 하니깐 매우 큰 문제가 있었는데, 새로운 api가 추가될때마다 case로 추가될때마다 기존 코드가 모두 변경되어야 했습니다 (열거형이다보니.. ㅠㅠ)

그래서 새로운 추상화 모델 도입의 필요성을 느껴서 APIable 라는 추상 프로토콜을 만들었습니다

프로토콜에서는 네트워크 통신에 필요한 hostURL, path, HTTPMethod, headers, body등을 정의하였습니다. 

```swift
protocol APIable {
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var queryParameters: [String: String]? { get }
    var bodyParameters: Encodable? { get }
    var headers: [String: String] { get }
}
```

또한 프로토콜를 extension하여 URLRequset를 반환하는 메서드를 구현하였습니다.

```swift
extension APIable {
    private func makeURL() -> URL? {
        // ...중략
    }
    
    func makeURLRequest() -> URLRequest? {
        guard let url = makeURL() else { return nil }
        var urlRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = method.rawValue
        headers.forEach { key, value in
            urlRequest.addValue(value, forHTTPHeaderField: key)
        }
        
        if let bodyParameters = bodyParameters {
            guard let body = try? bodyParameters.toDictionary() else { return nil }
            urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: body)
        }
        
        return urlRequest
    }
    
    func makeMutiPartFormDataURLRequest() -> URLRequest? {
        guard let url = makeURL() else { return nil }
        var urlRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = method.rawValue
        headers.forEach { key, value in
            urlRequest.addValue(value, forHTTPHeaderField: key)
        }
        
        urlRequest.httpBody = makeMutiPartFormData()
        
        return urlRequest
    }
    
    private func makeMutiPartFormData() -> Data? { 
        // ...중략
    }
}
```

이방식은 새로운 api가 추가됬을때 기존 코드를 아예 건들 필요가 없어서 유지보수 + 확장이 매우 편리했습니다!
