
# 오픈마켓

# 🎁 ios-open-market 
> 프로젝트 기간 2022.05.09 ~ 2022.05.20  
팀원 : [malrang](https://github.com/malrang-malrang) [Taeangel](https://github.com/Taeangel) / 리뷰어 : [stevenkim](https://github.com/stevenkim18)

- [Ground Rules](#ground-rules)
- [프로젝트 목표](#프로젝트-목표)
- [실행화면](#실행화면)
- [UML](#uml)
- [STEP 1 기능 구현](#step-1-기능-구현)
    + [고민했던 것들(트러블 슈팅)](#고민했던-것들트러블-슈팅)
    + [배운 개념](#배운-개념)
    + [PR 후 개선사항](#pr-후-개선사항)
- [STEP 2 기능 구현](#step-2-기능-구현)
    + [고민했던 것들(트러블 슈팅)](#고민했던-것들트러블-슈팅)
    + [배운 개념](#배운-개념)
    + [PR 후 개선사항](#pr-후-개선사항)

## Ground Rules
### 🌈 스크럼
- 10시 ~ 11시

### 주간 활동 시간
- 월, 화, 목, 금 : 10시 ~ 22시
- 수요일 : 개인공부
- 점심시간 : 13시 ~ 14시
- 저녁시간 : 18시 ~ 20시
- 상황에 따라 조정 가능

###  🪧 코딩 컨벤션
#### Swift 코드 스타일
코드 스타일은 [스타일쉐어 가이드 컨벤션](https://github.com/StyleShare/swift-style-guide#%EC%A4%84%EB%B0%94%EA%BF%88) 에 따라 진행한다.

#### Commit 규칙
커밋 제목은 최대 50자 입력
본문은 한 줄 최대 72자 입력

#### Commit 메세지
🪛[chore]: 코드 수정, 내부 파일 수정.  
✨[feat]: 새로운 기능 구현.  
🎨[style]: 스타일 관련 기능.(코드의 구조/형태 개선)  
➕[add]: Feat 이외의 부수적인 코드 추가, 라이브러리 추가  
🔧[file]: 새로운 파일 생성, 삭제 시  
🐛[fix]: 버그, 오류 해결.  
🔥[del]: 쓸모없는 코드/파일 삭제.  
📝[docs]: README나 WIKI 등의 문서 개정.  
💄[mod]: storyboard 파일,UI 수정한 경우.  
✏️[correct]: 주로 문법의 오류나 타입의 변경, 이름 변경 등에 사용합니다.  
🚚[move]: 프로젝트 내 파일이나 코드(리소스)의 이동.  
⏪️[rename]: 파일 이름 변경이 있을 때 사용합니다.  
⚡️[improve]: 향상이 있을 때 사용합니다.  
♻️[refactor]: 전면 수정이 있을 때 사용합니다  
🔀[merge]: 다른브렌치를 merge 할 때 사용합니다.  
✅ [test]: 테스트 코드를 작성할 때 사용합니다.  

#### Commit Body 규칙
제목 끝에 마침표(.) 금지
한글로 작성

#### 브랜치 이름 규칙
`STEP1`, `STEP2`, `STEP3`

---
## 프로젝트 목표
>**1. 서버와 통신하는 방법**  
>**2. `CollectionView` 코드로 구현하는 방법**  
---

## 실행화면
>![](https://i.imgur.com/emrPvQh.gif)

---
## UML
>![](https://i.imgur.com/nFoLkJS.png)
>[miro](https://miro.com/welcomeonboard/UlJBT0lpTjdqYWkyaGtINmQwbFVQOU1WS1J5MnNtTlJDTEZkMjduNFVSZzdzT2Y5TVJzTjZ5UGRyMTlLQ25KdnwzNDU4NzY0NTIzMDc5MjMxMTI5?share_link_id=654547367472)

---
## STEP 1 기능 구현
>1️⃣ `struct Product: Codable`
>- 네트워크 서버에서 `JSON` 데이터를 가져오기위한 타입
>
>2️⃣ `struct ProductCatalog: Codable`
>- 네트워크 서버에서 `JSON` 데이터를 가져오기위한 타입
>
>3️⃣ `struct URLSessionProvider<T: Codable>`
>- 네트워크 통신을 담당할 타입
>- `private let session`: `URLSession` 을 주입받을 프로퍼티
>- `func fetchData(path: Stirng)`: `path`를 인자로받아 `URLRequest`로 변경한후 `getData()`를 호출하는 메서드
>- `func getData(from urlRequest: URLRequest)`: `URLSession`의 `dataTask()` 메서드를 호출하고 전달받은 값이 정상적으로 전달되었는지 검증후 `CompletionHandler`를 통해 반환하는 메서드
>
>4️⃣ `enum NetworkError: Error`
>- 네트워크 통신중 발생할수있는 `case` 를 담아둔 열거형
>
>5️⃣ `protocol URLSessionProtocol`
>- 네트워크와 무관한 `Test` 를 위한 프로토콜
>- `func dataTask(with request: URLRequest)`: `URLSessionProtocol` 의 필수구현 메서드 
>
>6️⃣ `struct MockData`
>- 네트워크와 무관한 `Test` 를 위해 `MockData` 를 위한 구조체
>- `func load() -> Data?`: `Asset` 에 저장된 `JSON` 파일 데이터를 반환하는 메서드
>
>7️⃣ `class MockURLSessionDataTask: URLSessionDataTask`
>- 네트워크와 무관한 `Test` 를 위해 구현된 타입
>- `private let closure: () -> Void`: resume() 메서드가 호출되면 실행될 클로저
>- `override func resume()`: 정지되어있는(suspend) `URLSessionDataTask` 를 실행시키기 위한 메서드
>
>8️⃣ `class MockURLSession: URLSessionProtocol`
>- 네트워크와 무관한 `Test` 를 위해 구현된 `Mock` 객체
>- `func dataTask(with urlRequest: URLRequest) -> URLSessionDataTask`: `URLSessionProvider` 의 `getData()` 메서드 검증조건을 모두 통과하는 데이터를 전해줄 메서드

---
## 고민했던 것들(트러블 슈팅)
>1️⃣ **네트워크 통신과 무관하도록 Mock 객체를 만들어 Test 하는 방법? 🤔**
>
>**1. 네트워크 통신과 무관한 테스트를 왜 해야할까??**
>
>- 유닛 테스트는 빠르고 안정적으로 진행되어야 한다.
>실제 서버와 통신하게되면 단위 테스트의 속도가 느려질 뿐만 아니라 인터넷 연결에 의존하기 때문에 테스트를 신뢰할 수 없다.
>
>- 실제 서버와 통신하면 의도치 않은 결과를 불러올 수 있다.
예를들어 서버에 요청해서 데이터를 가져올때, 서버에 저장된값이 변경될수 있기 때문에 항상 원하는 값을 받을수있을것이라는 보장이 없다.
>
>- 서버에서 주는 데이터와 상관없이 구현한 기능들이 잘 작동하는지 테스트 해야하기 때문이다.
>
>**2. 네트워크 통신과 무관한 테스트는 어떻게 해야할까?**
>
>네트워크 통신을 통해 데이터를 전달 받을때는 `URLSession` 에 구현된 메서드인 `dataTask()`메서드를 활용한다.
>내부에서 어떻게 작동되는지 알수 없지만 우리는 `URL` 혹은 `URLRquest`의 값을 `dataTask()` 메서드에 인자로 전달하여 데이터를 받아오게된다!(URL은 주소값만 URLRquest은 주소값과 로딩할때 사용한 정책)
>
>그렇다면 우리가 해주어야할것은 `dataTask()`메서드를 조작하는것이 핵심이될것이다!
>
>즉 `URLSession` 의 `dataTask()` 메서드를 호출하는것이 아닌 새로운 타입을 만든후 새로운 타입의 `dataTask()` 메서드를 호출할수 있도록 해주면 될것이라고 생각했다🥳
>
>**3. 네트워크 통신과 무관한 테스트를 하기위해 필요한것들**
>
>- 네트워크와 통신할수있는 객체가 필요할것이다.
>- `URLSession` 의 `dataTask()`메서드 말고 다른 기능을 가진 `dataTask()`메서드 를 가진 객체가 필요할것이다.
>- 네트워크와 통신할수있는 객체가 Mock(가짜) `URLSession` 을 소유할수있도록 `protocol` 이 필요할것이다.
>- Mock(가짜) 객체가 `dataTask()` 메서드를 흉내낼수 있도록 가짜`Response`값을 가지고있는 객체와 `@escaping closure` 를 활용할 가짜`URLSessonTask` 객체가 필요할것이다.
>
>2️⃣ **네트워크 통신중 발생할수 있는 에러에는 어떤것들이 있을까? 🤔**
>- `urlError`: 잘못된 `URL` 에 접근했을수 있을거라 생각했다.
>- `statusCodeError`: 클라이언트, 혹은 서버에 문제가 생겨 `statusCode` 가 200~299 번 사이의 값이 아닐수 있을거라 생각했다.
>- `dataError`: 서버에서 가져온 데이터가 nil 일수도 있을거라 생각했다.
>- `decodeError`: 서버에서 가져온 데이터를 사용하려는 형태에 맞게 디코딩 과정중 실패할수 있을거라 생각했다.
>- `clientError`: `Client`가 서버에게 잘못된 요청을 할수 있을거라 생각했다.
>
>3️⃣ **URL 의 Path와 query를 관리하는 방법? 🤔**
>
>**URL 의 구성요소인 path와 query 를 어떻게 관리하고 접근할지 고민하였다.**
>
>**변경전 코드**
>`path: String` 값을 인자로받아 추가하고 `query` 부분을 딕셔너리 형태로 인자로받아서 구현하였다.
>```swift 
>func fetchData(
>        path: String,
>        parameters: [String: String] = [:],
>        completionHandler: @escaping (Result<T, NetworkError>) -> >Void
>    ) {
>            guard var url = URLComponents(string: API.host + path) >else {
>                return completionHandler(.failure(.urlError))
>            }
>
>            let query = parameters.map { (key: String, value: String) in
>                URLQueryItem(name: key, value: value)
>            }
>
>            url.queryItems = query
>            guard let url = url.url else {
>                return completionHandler(.failure(.urlError))
>            }
>
>            var request = URLRequest(url: url)
>            request.httpMethod = "GET"
>
>    getData(from: request, completionHandler: completionHandler)
>        }
>```
>**변경후 코드**
>`enum`과 `URL`을 `extension` 하여 좀더 편하게 `URL` 의 `Path`와 `query` 를 관리할수 있도록 수정하였다.
>```swift
>enum Endpoint {
>    case healthChecker
>    case productList(page: Int, itemsPerPage: Int)
>    case detailProduct(id: Int)
>}
>
>extension Endpoint {
>    var url: URL? {
>        switch self {
>        case .healthChecker:
>            return .makeForEndpoint("healthChecker")
>        case .productList(let page, let itemsPerPage):
>            return .makeForEndpoint("api/products?page_no=\(page)&items_per_page=\(itemsPerPage)")
>        case .detailProduct(let id):
>            return .makeForEndpoint("api/products/\(id)")
>        }
>    }
>}
>
>private extension URL {
>    static let baseURL = "https://market-training.yagom->academy.kr/"
>
>    static func makeForEndpoint(_ endpoint: String) -> URL? {
>        return URL(string: baseURL + endpoint)
>    }
>}
>
>struct URLSessionProvider<T: Codable> {
>func getData(
>        from url: Endpoint,
>        completionHandler: @escaping (Result<T, NetworkError>) -> Void
>    ) {
>
>        guard let url = url.url else {
>            return 
>        }
>
>        var request = URLRequest(url: url)
>        request.httpMethod = "GET"
>        
>        let task = session.dataTask(with: request) { data, urlResponse, error in
>            
>            guard error == nil else {
>                completionHandler(.failure(.unknownError))
>                return
>            }
>            
>            guard let httpResponse = urlResponse as? >HTTPURLResponse,
>                  (200...299).contains(httpResponse.statusCode) >else {
>                completionHandler(.failure(.statusCodeError))
>                return
>            }
>            
>            guard let data = data else {
>                completionHandler(.failure(.unknownError))
>                return
>            }
>            
>            guard let products = try? JSONDecoder().decode(T.self, >from: data) else {
>                completionHandler(.failure(.decodeError))
>                return
>            }
>            
>            completionHandler(.success(products))
>        }
>        task.resume()
>    }
>}
>```
>
>### 질문한것들
>#### 1️⃣ MockURLSessionDataTask init 관련 Error
>```swift
>class MockURLSessionDataTask: URLSessionDataTask {
>    private let closure: () -> Void
>
>    init(closure: @escaping () -> Void) {
>        self.closure = closure
>    }
>    
>    override func resume() {
>        closure()
>    }
>}
>```
>
>![](https://i.imgur.com/TqXVi4m.png)
>
> 위의 사진과 같은 에러가 나오는데 어떤방법 키워드를 공부해야 해결할수있을지 궁금합니다!
>
>#### 2️⃣ 테스트를 하기위한 Mock 객체에서의 강제언래핑
>```swift
>func dataTask(
>        with urlRequest: URLRequest,
>        completionHandler: @escaping >DataTaskCompletionHandler
>    ) -> URLSessionDataTask {
>        let successResponse = HTTPURLResponse(
>            url: urlRequest.url!,
>            statusCode: 200, httpVersion: "",
>            headerFields: nil
>        )
>
>```
>테스트를 위한 목객체를 만들었는데 목객체에도 강제언래핑을 지양해야하는지 궁금합니다!

---
## 배운 개념
1️⃣ `URLSession`  
2️⃣ `URLSessionTask`  
3️⃣ `URL`, `URI`  
4️⃣ `Response`  
5️⃣ `Request`  
6️⃣ `@escaping closure`  
7️⃣ `Result`  
8️⃣ `EndPoint`  
9️⃣ 비동기 메서드를 테스트 하는 방법  

---
## PR 후 개선사항
>1️⃣ **MockURLSessionDataTask init 관련 Error 에러**
>
>![](https://i.imgur.com/TqXVi4m.png)
>
> 위와 같은 에러를 어떻게 처리해야할지 고민끝에 스티븐에게 어떤 키워드를 공부해야 해결할수있을지 질문을 남겼었다.
> URLProtocol을 활용해서 Mock 테스트 하는것을 찾아보라는 피드백을 받아 공부해보았고 해결했다.
>
>문제는 URLSessionDataTask 를 상속받았을경우 생기는 문제였다.
>
>![](https://i.imgur.com/48SsfND.png)
>
>위의 코드처럼 상속을 받지 않았을때는 문제가 없었다.
>
>그래서 어떻게 저문제를 해결할수 있을까 고민해보았고 URLSession 을 테스트 하기위해 URLSessionProtocol 을 만들어 주었던것처럼 URLSessionDataTaskProtocol 을 만들어주었다.
>
>URLSessionDataTask에서 사용하던 메서드 resume() 를URLSessionDataTaskProtocol에서 필수구현하도록 명시해두었으며
>
>URLSessionProtocol 의 메서드 dataTask() 의 반환타입을 URLSessionDataTaskProtocol 로 수정해준뒤 Protocol 의 conform 에 맞도록 코드를 수정해주어 문제를 해결했다.
>
>![](https://i.imgur.com/O1XLdvS.png)
>
>
>2️⃣ **MockURLSessionTest 의 statusCode Error 테스트 추가**
>
>구현된 코드에서 data, response, error 를 요청하는 fetch() 메서드는 enum 타입으로 url 을 인자로 받고 있기때문에 url 을 잘못 입력하는 경우가 있을수 없으며, MockURLSession 에서 구현한 dataTask() 메서드 에는 항상 성공하는 Response(200번) 를 반환해 주기 때문에 StatusCode Error 를 테스트하기 위해 어떻게 해야할지 고민했다.
>
>스티븐의 조언을 듣고 MockURLSession 의 dataTask() 메서드에서 어떠한 경우에는 성공하는 Response 를 반환하도록 어떠한 경우에는 실패하는 Response(400번)을 반환하도록 분기 처리를 해주었다.
>
>분기 처리를 하기위해 MockURLSession 에 flag 를 추가해 MockURLSession 을 초기화할때 주입 받을수 있도록 initializer 를 활용했다.
>
>이제는 테스트하기전에 flag 에 대한 값을 실패의 경우로 변경해서 Test 하기만 하면된다!
>
>**StatusCode Error Test 코드**
>```swift
>class MockURLSession: URLSessionProtocol {
>    var isRequestSuccess: Bool
>    
>    init(isRequestSuccess: Bool = true) {
>        self.isRequestSuccess = isRequestSuccess
>    }
>    
>    func dataTask(
>        with urlRequest: URLRequest,
>        completionHandler: @escaping DataTaskCompletionHandler
>    ) -> URLSessionDataTaskProtocol {
>        
>        let sucessResponse = HTTPURLResponse(
>            url: urlRequest.url!,
>            statusCode: 200, httpVersion: "",
>            headerFields: nil
>        )
>        
>        let failureResponse = HTTPURLResponse(
>            url: urlRequest.url!,
>            statusCode: 400, httpVersion: "",
>            headerFields: nil
>        )
>        
>        if isRequestSuccess {
>            return MockURLSessionDataTask {
>                completionHandler(MockData().load(), sucessResponse, nil)
>            }
>        } else {
>            return MockURLSessionDataTask {
>                completionHandler(MockData().load(), failureResponse, nil)
>            }
>        }
>    }
>}
>
>class MockURLSessionTest: XCTestCase {
>   func test_isRequestSuccess가_false라면_fetchData_함수를호출하면_statusCode_Error인지() {
>        //given
>        let promise = expectation(description: "statusCodeError if isRequestSuccess value is false")
>        let session = MockURLSession(isRequestSuccess: false)
>        sut = URLSessionProvider(session: session)
>
>        //when
>        sut.fetchData(from: .healthChecker) { result in
>            //then
>            switch result {
>            case .success(_):
>                XCTFail()
>            case .failure(let error):
>                XCTAssertEqual(error, .statusCodeError)
>            }
>            promise.fulfill()
>        }
>        wait(for: [promise], timeout: 10)
>    }
>}
>```

---
## STEP 2 기능 구현

---
## 고민했던 것들(트러블 슈팅)
>1️⃣ **이미지를 텍스트로 변경하여 label text 에 할당 하는 방법🤔**
>
>![](https://i.imgur.com/ddvA786.png)
>
>위의 사진에 보이는 `discloser indicator` 이미지를 기존에는 이미지뷰를 추가하여 구현하였다.
>
>하지만 레이아웃 관련 에러가 생겨 디스클로저 인디케이터가 늘어나는 상황이 발생했고 이를 해결하기위해 인디케이터 이미지의 고정 크기를 설정해주는것이 아니라 텍스트로 변환 하여 인디 케이터 이미지를 `label text`에 할당 주는 방법을 사용했다.
>
>**변경 전 코드**
>```swift
>private lazy var accessoryImage: UIImageView = {
>        let imageView = UIImageView()
>        imageView.image = UIImage(systemName: "chevron.right")
>        imageView.translatesAutoresizingMaskIntoConstraints = false
>        imageView.tintColor = .lightGray
>        return imageView
>    }()
>```
>**변경 후 코드**
>```swift
>private lazy var accessoryLabel: UILabel = {
>        let label = UILabel()
>        let attachment = NSTextAttachment()
>        attachment.image = UIImage(systemName: "chevron.right")?.withTintColor(.lightGray)
>        let attachmentString = NSAttributedString(attachment: attachment)
>        let attributedStr = NSMutableAttributedString(string: attachmentString.description)
>        label.attributedText = attachmentString
>        return label
>    }()
>```
>
>**변경 후 코드**
>
>2️⃣ **서버에서 가져온 데이터를 어떻게 화면에 보여줄수 있을까?? 🤔**
>
>기존 만들어두었던 서버와 통신하는 `URLSessionProvider` 를 활용해 `UIApp` 을 만들기 위해 `ViewController`에서 아래의 코드처럼 서버에서 데이터를 가지고오도록 했다.
>```swift
>class OpenMarketViewController: UIViewController {
>    private let segmentControl = UISegmentedControl(items: ["list", "grid"])
>    private var collectionView: UICollectionView?
>    private var network: URLSessionProvider<ProductList>?
>    private var productList: [Product]? {
>        didSet {
>            DispatchQueue.main.async {
>                self.collectionView?.reloadData()
>            }
>        }
>    }
>    
>    override func viewDidLoad() {
>        super.viewDidLoad()
>        network = URLSessionProvider()
>        getData(from: .productList(page: 1, itemsPerPage: 110))
>        setup()
>        addsegment()
>    }
>    
>    func getData(from: Endpoint) {
>        network?.fetchData(from: from, completionHandler: { result in
>            switch result {
>            case .success(let data):
>                self.productList = data.pages
>            case .failure(_):
>                return
>            }
>        })
>    }
>}
>```
> `viewDidLoad`에서 `getData()`메서드를 호출하여 서버에서 받아온 데이터를 파싱에 성공하면 저장 프로퍼티 `productList` 에 값이 할당되고 `productList` 의 값이 변경될때마다 `CollectionView` 의 `reloadData()`메서드를 사용해 `CollectionView` 를 갱신하도록 해주었다.
> 
>그후 서버에서 가져온 데이터를 `CollectionViewDataSource` 에서 활용하도록 해주었다.
>```swift
>extension OpenMarketViewController: UICollectionViewDataSource {
>    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
>        guard let cell = >collectionView.dequeueReusableCell(withReuseIdentifier: >ListCell.identifier, for: indexPath) as? ListCell else {
>            return UICollectionViewCell()
>        }
>        
>        guard let product = productList?[indexPath.item] else { 
>            return return UICollectionViewCell()
>        }
>        
>        guard let url = product.thumbnail else {
>            return UICollectionViewCell()
>        }
>    
>        network?.fetchImage(from: url, completionHandler: { result in
>            switch result {
>            case .success(let data):
>                cell.update(image: data)
>            case .failure(_):
>                break
>            }
>        })
>        
>        cell.update(data: product)
>        
>        return cell
>    }
>    
>    func collectionView(_ collectionView: UICollectionView, >numberOfItemsInSection section: Int) -> Int {
>        return productList?.count ?? .zero
>    }
>}
>```
>이미지를 제외한 데이터들은 `viewDidLoad` 단계에서 서버에서 받아오고 `cellForItemAt` 단계에서 서버에서 이미지를 가져오도록 구현하였으나 `cellForItemAt`에서 이미지와 화면을 연결 시켜주는 것보다는 cell에서 이미지를 연결시켜 다른데이터들과 마찬가지로 데이터를 가공해 cell을 만드는 방식으로 변경하였습니다.
>   
>**서버에서 이미지를 가져오는 코드**
>UIImageView 를 extention 하여 서버에서 이미지를 가지고 오는 메서드를 구현해주었다.
>```swift
>extension UIImageView {
>    func fetchImage(url: URL, completion: @escaping (UIImage) -> Void) {
>        URLSession.shared.dataTask(with: url) { data, response, _ in
>            
>            guard let response = response as? HTTPURLResponse,
>                  (200...299).contains(response.statusCode) else {
>                return
>            }
>            
>            guard let data = data else {
>                return
>            }
>            
>            guard let image = UIImage(data: data) else {
>                return
>            }
>            
>            completion(image)
>            
>        }
>        .resume()
>    }
>}
>```
>각각의 Cell 에서 호출되는 fetchImage() 메서드
>```swift
>private func loadImage(data: Product) {
>        
>        guard let stringUrl = data.thumbnail else {
>            return
>        }
>        
>        guard let url = URL(string: stringUrl) else {
>            return
>        }
>        
>        thumbnailImageView.fetchImage(url: url) { image in
>            DispatchQueue.main.async {
>                self.thumbnailImageView.image = image
>            }
>        }
>    }
>```
>    
>3️⃣ **SegmentControl의 items를 유동적으로 변경할수는 없을까?🤔**
>    
>기존의 코드는 아래의 코드처럼 items 에 어떠한 것들이 포함되는지 하드코딩하여 일일히 작성해주었다.
>열거형을 활용하면 좀더 유동적으로 사용할수있지 않을까?? 하고 고민하였다.
>
>**변경전 코드**    
>```swift
>private let segmentControl = SegmentControl(items: ["list", "grid"])
>```
>    
>**변경후 코드**
>```swift
>// LayoutType 열거
>enum LayoutType 열거형: Int, CaseIterable {
>    case list = 0
>    case grid = 1
>    
>    static var inventory: [String] {
>        return Self.allCases.map { $0.description }
>    }
>    
>    private var description: String {
>        switch self {
>        case .list:
>            return "List"
>        case .grid:
>            return "Grid"
>        }
>    } 
>}
>    
>// ViewController 의 segmentControl    
>private let segmentControl = SegmentControl(items: LayoutType.inventory)   
>```
>enum 타입이 CaseIterable 를 채택하여 타입 외부에서 allCases 를 사용한적은 있었지만 이와같이 enum 타입 내부에서 allCases 를 활용해서 사용 할수있다는것을 알게되었고
> 앞으로 enum 타입을 잘 활용한다면 기존보다 더 퀄리티 높은 코드를 작성할수 있을것 같다.
>    
>4️⃣ **UICollectionViewDataSource 의 각 셀에 따른 분기처리 해결방법 🤔**
>    
>현재 프로젝트에서 List Cell 과 Grid Cell 두가지로 구분되어있으며 셀을 변경할때마다 화면에 보여지는 뷰가 변경되게끔 구현되어있다.
>
>그렇기 때문에 UICollectionViewDataSource 의 메서드 cellForItemAt 에서 현재 어떤 Cell 인지 분기 처리를 해주어야 했다.
>    
>하지만 분기 처리된 코드를 비교해보면 다른점은 각 Cell의 identifier 와 타입 캐스팅 부분만 제외하고 모두 동일했기에 Protocol 과 enum 을 잘 활용하면 분기처리를 하지 않아도 되지 않을까? 고민했다.
>
>**변경전 코드**
>```swift
>func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
>        
>     guard let product = productList?[indexPath.item] else {
>         return UICollectionViewCell()
>     }
>        
>     if segmentControl.selectedSegmentIndex == 0 {
>            
>         guard let cell = >collectionView.dequeueReusableCell(withReuseIdentifier: ListCell.identifier, for: indexPath) as? ListCell else {
>                return UICollectionViewCell()
>         }
>            
>         cell.configure(data: product)
>            return cell
>         } else {
>            
>         guard let cell = >collectionView.dequeueReusableCell(withReuseIdentifier: GridCell.identifier, for: indexPath) as? GridCell else {
>             return UICollectionViewCell()
>         }
>            
>         cell.configure(data: product)
>            return cell
>     }
>```
>**변경후 코드**
>```swift
>func collectionView(_ collectionView: UICollectionView, cellForItemAt >indexPath: IndexPath) -> UICollectionViewCell {
>        
>    guard let product = productList?[indexPath.item] else {
>        return UICollectionViewCell()
>    }
>        
>    guard let layoutType = LayoutType(rawValue: segmentControl.selectedSegmentIndex) else {
>            return UICollectionViewCell()
>    }
>        
>    guard let cell = >collectionView.dequeueReusableCell(withReuseIdentifier: layoutType.cell.identifier, for: indexPath) as? CustomCell else {
>        return UICollectionViewCell()
>    }
>        
>    cell.configure(data: product)
>        return cell
>    }
>    
>extension UICollectionViewCell {
>    static var identifier: String {
>        return String(describing: self)
>    }
>}    
>
>enum LayoutType: Int, CaseIterable {
>    case list = 0
>    case grid = 1
>    
>    static var inventory: [String] {
>        return Self.allCases.map { $0.description }
>    }
>    
>    private var description: String {
>        switch self {
>        case .list:
>            return "List"
>        case .grid:
>            return "Grid"
>        }
>    }
>    
>    var cell: CustomCell.Type {
>        switch self {
>        case .list:
>            return ListCell.self
>        case .grid:
>            return GridCell.self
>        }
>    }
>}
>    
>protocol CustomCell: UICollectionViewCell {
>    func configure(data: Product)
>}    
>```
>이번 프로젝트를 하면서 가장 많이 고민했던 부분인것 같다.
>    
>위의 변경후 코드를 보면 LayoutType enum, 과 CustomCell protocol 을 활용해 분기처리된 코드를 하나로 합칠수 있었다.
>    
>identifier 를 해결하기 위해 현재 선택된 Cell 이 ListCell과 GridCell 둘중 어떤 Cell 인지 알고 있어야 하기 때문에 SegmentControl과 LayoutType 을 활용해 현재 어떤Cell 이 선택되었는지 알수있도록 하였다.
>    
>그후 UICollectionViewCell 을 extension 하여 identifier 라는 연산 프로퍼티를 구현해주었다.
> 그렇다면 UICollectionViewCell 를 상속받는 Cell 들은 모두 identifier 라는 프로퍼티가 존재할테니 현재 선택된 Cell 의 identifier 를 기입하는것이 가능해졌다.
>    
>그렇다면 남은 문제는 캐스팅 부분이었다.
>
>enum 에서 타입을 반환하게 할수는 없을까? 고민했다.
>현재 선택된 Cell 의 타입을 그대로 반환할수있다면 좋을텐데 🤔
>Layout Type enum 에서 Meta Type 을 활용해서 Cell 타입을 반환하도록 하여 Casting 부분을 해결할수있었다.
>    
>Casting 문제를 해결하고나니 Cell 의 configure() 메서드 문제가 생겼다🫠
>UICollectionViewCell 에는 configure() 메서드가 존재한다고 보장되지 않기 때문에 cell 의 configure() 메서드 를 호출할수 없게되었다.
>
>이를 해결하기 위해 CustomCell 이라는 프로토콜을 구현하고 configure() 메서드를 필수 메서드로 명세 해주었다.
>
>그후 ListCell, GridCell 각각의 셀이 CustomCell 을 채택하도록 해주었고 CustomCell 은 UICollectionViewCell를 상속받는 타입만 채택이 가능하도록 해주었다.
>
>이렇게 수정하여 cell의 identifier, casting 문제를 모두 해결했다.
>분기 처리를 해결하기위해 extension, protocol, enum 을 활용했는데 코드의 양 자체는 증가했으나 공부도 많이 되었고 enum, protocol 을 활용하는 방법을 많이 알게되었다.
>    
>### 질문한것들
>
>1️⃣ **오토레이아웃 관련 에러**
>현재`stockStackView`에서만 Width and horizontal position are ambiguous for UILabel 에러가 발생하는데 좋은 해결 방법이 있을까요~?
>    
>![](https://i.imgur.com/vskIXOF.png)
>
>2️⃣ **이미지 관련에러**
>현재 `prepareForReuse`에 이미지설정을 해주지 않는데 이미지가 변경되는 에러가 발생하지 않습니다.
>스크롤을 빠르게 내린후 다시 위쪽으로 스크롤을 하게될경우 셀이 재사용되면서 이미지가 잘못 들어갈것이라 예상 했는데 이미지가 각각의 셀의 위치에 맞게 잘 적용되는것을 확인했습니다!
>
>왜 `prepareForReuse`을 해주지 않았는데도 이미지 `bug`가 발생하지 않았는지 궁급합니다.

---
## 배운 개념  
1️⃣ `CollectionView`  
2️⃣ `CollectionvewFlowLayout`  
3️⃣ `CALayer`  
4️⃣ `segmentControl`  
5️⃣ `NSTextAttachment`: 이미지를 텍스트로 변경하여 레이블에 추가하는 방법  
6️⃣ `NSLayoutConstraint`  
7️⃣ `prepareForReuse`  

---
## PR 후 개선사항
1️⃣ **오토레이아웃 스택뷰 최소화**
>기존 오토레이아웃 에서는 StackView 를 활용하여 오토레이아웃 Constraint 를 최소화 하는 방식으로 UI 를 구현하였다.
>
>그렇다 보니 Cell 의 UI 를 구현하기위해 사용되는 StackView가 너무많아 복잡해졌고 Constraint 도 적지 않았다.
>    
>스티븐의 조언을 듣고 StackView 를 활용하는것은 좋지만 남용할경우 구조가 복잡해진다는걸 깨닫게 되었다. 
>
>조언을 듣고 필요한 곳에만 StackView 를 사용하는 방법으로 수정하였다.
>
>**변경전 오토레이아웃 구조**
>    
>![](https://i.imgur.com/BiL1uKa.png)
>
>**변경후 오토레이아웃 구조**
>    
>![](https://i.imgur.com/Uf4ry6i.png)
> 
>위의 사진 처럼 구조를 StackView 를 최소화하고 label, image 등등은 Constraint 을 사용하여 위치를 잡아주었다.
