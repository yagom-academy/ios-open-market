# 오픈마켓

# 🎁 ios-open-market 
> 프로젝트 기간 2022.05.09 ~ 2022.0  
팀원 : [malrang](https://github.com/malrang-malrang) [Taeangel](https://github.com/Taeangel) / 리뷰어 : [stevenkim](https://github.com/stevenkim18)

- [Ground Rules](#ground-rules)
- [프로젝트 목표](#프로젝트-목표)
- [실행화면](#실행화면)
- [UML](#uml)
- [STEP 1 기능 구현](#step-1-기능-구현)
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

---
## UML
>![](https://i.imgur.com/AQfFjAm.png)

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

## PR 후 개선사항
