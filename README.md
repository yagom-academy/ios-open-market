# 📣 Open Market 

- Gundy와 Wonbi가 만든 Open Market App입니다.

## 📖 목차
1. [팀 소개](#-팀-소개)
2. [GroundRule](#-ground-rule)
3. [Code Convention](#-code-convention)
4. [Diagram](#-diagram)
5. [폴더 구조](#-폴더-구조)
6. [타임라인](#-타임라인)
7. [기술적 도전](#-기술적-도전)
8. [트러블 슈팅 및 고민](#-트러블-슈팅-및-고민)
9. [일일 스크럼](#-일일-스크럼)
10. [참고 링크](#-참고-링크)


## 🌱 팀 소개
 |[Wonbi](https://github.com/wonbi92)|[Gundy](https://github.com/Gundy93)|
 |:---:|:---:|
| <img width="180px" img style="border: 2px solid lightgray; border-radius: 90px;-moz-border-radius: 90px;-khtml-border-radius: 90px;-webkit-border-radius: 90px;" src="https://avatars.githubusercontent.com/u/88074999?v=4">| <img width="180px" img style="border: 2px solid lightgray; border-radius: 90px;-moz-border-radius: 90px;-khtml-border-radius: 90px;-webkit-border-radius: 90px;" src= "https://avatars.githubusercontent.com/u/106914201?v=4">|

## 🤙 Ground Rule

[Ground Rule 바로가기](https://github.com/wonbi92/ios-open-market/wiki/1.-Ground-Rule)

## 🖋 Code Convention

[Code Convention 바로가기](https://github.com/wonbi92/ios-open-market/wiki/2.-Code-Convention)

## 👀 Diagram

### 🧬 Class Diagram
![](https://i.imgur.com/Pt1EV4o.png)

 
## 🗂 폴더 구조
> Network: 서버로부터 데이터를 받아오는 로직을 담당 <br>
> OpenMarket: 데이터를 처리하고 컨트롤 하는 메인 구조 <br>
> Extension: 기존 타입에 커스텀 로직 추가<br>
> OpenMarketTests: 유닛 테스트
```
OpenMarket
├── Extension
│   ├── JSONDecoder+
│   └── String+
├── Network
│   ├── HttpMethod
│   ├── Network Protocol
│   │   ├── URLSessionDataTaskProtocol
│   │   └── URLSessionProtocol
│   ├── NetworkManager
│   └── NetworkRequest
├── OpenMarket
│   ├── Network
│   │   ├── DTO
│   │   │   ├── Product
│   │   │   └── ProductList
│   │   └── OpenMarketNetworkRequest
│   └── ViewController
└── OpenMarketTests
    ├── JSONParsingTests
    ├── MockData
    │   ├── DataLoader
    │   └── products
    ├── NetworkManagerTests
    ├── NetworkRequestTests
    └── Test Double
        ├── DummyData
        ├── MockURLSession
        └── MockURLSessionDataTask
```

## ⏰ 타임라인

### 👟 Step 1
- JSONParsing
    - ✅ DTO 생성
- Networking 구현
    - ✅ URLSession을 활용한 서버와의 데이터 통신
    - ✅ 각 네트워킹 요소를 프로토콜을 이용하여 추상화
- Test Double 작성
    - ✅ 테스트를 위한 객체 생성
    - ✅ Unit Test 진행

<details>
<summary> 
펼쳐보기
</summary>
    
#### 1️⃣ data
- Node의 내부 값을 의미하는 프로퍼티입니다. 
     
#### 2️⃣ Network
- HttpMethod 
    - HttpMethod를 나타내는 열거형 타입입니다.
- NetworkRequest
    - 네트워킹을 위한 URL과 Request를 가지고 이를 구현하기 위한 필수 프로퍼티를 선언하는 프로토콜입니다.
- NetworkManager
    - 네트워크에서 데이터를 가져와 오류를 처리하고 데이터를 파싱해주는 객체입니다.
- URLSessionProtocol
    - DIP적용을 위해 `dataTask`메서드를 정의하는 프로토콜입니다.
    - 이 프로토콜을 채택하면 `dataTask`메서드의 로직을 구현해주어야 합니다.
- URLSessionDataTaskProtocol
    - `URLSessionProtocol`의 `dataTask`메서드에서 반환하는 타입을 지정하는 프로토콜입니다.
    - 이 프로토콜을 채택하면 `resume`메서드의 로직을 구현해주어야 합니다.

#### 3️⃣ Extension
- JSONDecoder
    - 제네릭 타입과 데이터를 받아 디코딩하는 타입 메서드를 추가하였습니다.
- String
    - `"yyyy-MM-dd'T'HH:mm:ss"`의 형식의 문자열을 `Date`타입의 값으로 변경시켜주는 메서드를 추가하였습니다.
    
#### 4️⃣ OpenMarket
- Product
    - `Codable`을 채택하는 DTO입니다.
- ProductList
    - `Codable`을 채택하는 DTO입니다.
- HealthCheckerRequest
    - NetworkRequest를 채택하고, Application HealthChekcer를 리퀘스트하기위한 프로퍼티를 갖고 있는 구조체입니다.
- ProductListRequest
    - NetworkRequest를 채택하고, 상품 리스트 조회를 리퀘스트하기위한 프로퍼티를 갖고 있는 구조체입니다.
- ProductDetailRequest
    - NetworkRequest를 채택하고, 상품 상세 조회를 리퀘스트하기위한 프로퍼티를 갖고 있는 구조체입니다.
    
#### 5️⃣ Test Double
- products
    - 테스트를 위한 Mock JSON데이터입니다.
- DataLoader
    - Mock JSON데이터를 코드로 연결시켜 data를 생성해주는 클래스입니다.
- DummyData
    - 실제 네트워킹이 아닌 테스트를 진행할 때 반환할 데이터 구조체입니다.
- MockURLSession
    - 테스트를 위해 실제 네트워킹이 아니라 `DummyData`를 사용하는 클래스입니다.
- MockURLSessionDataTask
    - 테스트를 위해 실제 네트워킹 테스트가 아닌 `DummyData`를 반환하는 클래스 입니다.
    
#### 6️⃣ Unit Test
- JSONDecoder, DTO
    - JSONParsingTests
- NetworkManager
    - NetworkManagerTests
- OpenMarketNetworkRequest
    - NetworkRequestTests
</details>


    
## 🏃🏻 기술적 도전
### ⚙️ URLSession 
<details>
<summary> 
펼쳐보기
</summary>
    
- iOS 앱에서 서버와 통신하기 위해 애플은 `URLSession`이라는 API를 제공하고 있습니다. 유명한 라이브러리인 Alamofire, Moya 등의 기반이 되는 API로 서버와의 데이터 교류를 위해서는 필수적으로 알아야 하는 API입니다.
- `URLSession`은 HTTP를 포함한 몇 가지 프로토콜을 지원하고, 인증, 쿠키 관리, 캐시 관리 등을 지원합니다.<br><br>
- 💡 이번 프로젝트에서는 제공받은 서버에 있는 JSON 데이터를 받아오도록 구현해 보았습니다.

</details> 

### ⚙️ Test Double
<details>
<summary> 
펼쳐보기
</summary>
    
- Test Double 테스트를 진행하기 어려운 경우 이를 대신해 테스트를 진행할 수 있도록 만들어주는 객체를 말합니다.
- 실제로 네트워킹을 하지 않고, 정상적으로 fetch가 진행되는지 로직을 테스트 하기위해 `MockURLSession`이라는 test double객체를 만들고 `MockData` 객체를 반환하도록 로직을 구현해야 했습니다.<br><br>
- 💡 이번 프로젝트에서는 실제 `URLSession`과 이런 `MockURLSession`은 다르게 작동해야 하므로, 프로토콜을 통해 의존성을 역전시켜 네트워크 매니저가 프로토콜을 바라보게 하여 테스트를 할 때는 `MockURLSession`을 주입시키고, 실제 네트워킹을 할 때는 `URLSession`을 주입시키는 방법으로 구현해 보았습니다.

</details>  
    
## 🏔 트러블 슈팅 및 고민
### 🚀 테스트용 JSON 파일과 서버 API 문서
    
<details>
<summary> 
펼쳐보기
</summary>

**문제 👻**
- 이번 프로젝트 안내페이지에서 제공하는 테스트용 JSON 파일과 앞으로 작업을 진행할 API의 JSON이 서로 CodingKey나 value의 형식이 달랐습니다. 
```json
// 테스트용 JSON 파일
{
  "page_no": 1,
  "items_per_page": 20,
  "total_count": 10,
  "offset": 0,
  "limit": 20,
    ...
}
```
```json
// 서버 API 문서
{
  "pageNo": 1,
  "itemsPerPage": 20,
  "totalCount": 10,
  "offset": 0,
  "limit": 20,
    ...
}
```
- 우선 테스트용 파일에 맞게 DTO를 구현했었는데, 실제 API Network를 진행해보면서 서로 다르다는 것을 알게 되었습니다. 

**해결 🔫**
- 테스트의 취지가 네트워크가 없는 상황에서도 정상적으로 동작하는지를 검증하는 것이기 때문에 서버 API 문서의 데이터 형식에 맞추는 것이 적절하다고 생각해 테스트용 JSON 파일을 서버 API 문서의 데이터 형식에 맞게 수정하였습니다. 

</details>

### 🚀 Deprecated Initializer

<details>
<summary> 
펼쳐보기
</summary>

**문제 👻**
- 테스트 더블을 위해 URLSessionProtocol을 정의하였습니다.
```swift
protocol URLSessionProtocol {
    func dataTask(with url: URL,
                  completionHandler: @escaping DataTaskCompletionHandler
    ) -> URLSessionDataTask
}
```
- 이 때 `URLSessionDataTask`타입도 Mock데이터로 만들어 주었는데, 이 타입의 초기화 구문이 iOS13버전 부터 더 이상 사용되지 않는(deprecated) 로직이어서 현재 동작은 수행하지만 적절하지 않은 방법이라고 생각했습니다.
![](https://i.imgur.com/0ipjyRN.png)
![](https://i.imgur.com/Dzncleq.png)

**해결 🔫**
- `URLSessionDataTask`를 직접 사용하지 않고 URLSessionProtocol과 마찬가지로 의존성을 역전시켜 URLSessionProtocol이 프로토콜을 바라보게 구현하였습니다.
```swift
protocol URLSessionProtocol {
    func dataTask(with url: URL,
                  completionHandler: @escaping DataTaskCompletionHandler
    ) -> URLSessionDataTaskProtocol
}

protocol URLSessionDataTaskProtocol {
    func resume()
}
```


</details>

### 💭 재사용이 가능한 Request객체 구현하기
    
<details>
<summary> 
펼쳐보기
</summary>
    
```swift
protocol NetworkRequest {
    var httpMethod: HttpMethod { get }
    var urlHost: String { get }
    var urlPath: String { get }
    var queryParameters: [String: String] { get }
}

extension NetworkRequest {
    var url: URL? {
        if queryParameters.isEmpty {
            return URL(string: urlHost + urlPath)
        }
        var urlComponents = URLComponents(string: urlHost + urlPath)
        let queryItems = queryParameters.map { URLQueryItem(name: $0, value: $1) }
        urlComponents?.queryItems = queryItems
        
        return urlComponents?.url
    }
}

```
**고민 🤔**
- 이번 프로젝트에서 네트워킹의 요소가 총 3가지 였습니다.
- 그리고 실제 오픈마켓 서버에서도 GET메서드 말고도 POST, PATCH, DEL 등의 httpMethod를 사용할 수 있었습니다.
- 이에 각각의 리퀘스트마다 URL주소가 달라졌었고, 이를 String으로 써주는건 코드의 재사용이 많고, 확장성에도 문제가 있어보인다 판단하였습니다.
- 그래서 `NetworkRequest` 프로토콜을 만들고, 각 네트워킹 요소를 객체화하여 이를 채택하도록 하였습니다.
- 이로써 URL을 String으로 직접 작성할 필요가 없이 프로토콜을 채택하고 그 프로토콜을 각자의 역할에 맞게 구현만 해주면 알아서 URL과 Request를 만들게 되었습니다.
</details>
    
### 💭 BoringSSL
    
<details>
<summary> 
펼쳐보기
</summary>

**고민 🤔**
- Step 1-2를 진행하면서 서버와 실제로 데이터를 주고 받을 때, `boringssl_metrics_log_metric_block_invoke(153)` 라는 메시지가 콘솔에 뜨게 되었습니다. 
- [boringssl_metrics_log_metric_block_invoke(151) Failed to log metrics](https://github.com/firebase/firebase-ios-sdk/issues/9262)의 내용 및 여러 게시글들을 찾아본 결과 기능에는 문제가 없고, 콘솔에 나타나기만 하는 메시지로 파악했습니다. 
- 스키마에서 OS_ACTIVITY_MODE를 disable로 바꿔주면 이 에러 메세지가 콘솔에서 나타나지 않지만, `NSLog`도 사라지는 문제가 있어서 이 방법은 적절한 방법이 아니라 판단하였습니다.
- 또 다른 방법으로는 `xcrun simctl spawn booted log config --subsystem com.apple.network --category boringssl --mode level:off` 처럼 Xcode 설정을 건드리는 방법도 있었는데, 이는 Xcode의 설정을 건드리는 것이고, 어떤 사이드 이펙트가 발생할지 몰라, 적용하기에 적절하지 않다 판단하여 적용하지 않았습니다.

</details>
    
## 📝 일일 스크럼

[일일 스크럼 바로가기](https://github.com/wonbi92/ios-open-market/wiki/3.-Open-Market-Scrum)

## 🔗 참고 링크

[공식문서]

- [Apple Developer Documentation - URLSession](https://developer.apple.com/documentation/foundation/urlsession)
- [Apple Developer Documentation - Fetching Website Data into Memory](https://developer.apple.com/documentation/foundation/url_loading_system/fetching_website_data_into_memory)
- [Apple Developer Documentation - UICollectionView](https://developer.apple.com/documentation/uikit/uicollectionview)
- [WWDC2020 - Modern cell configuration](https://developer.apple.com/videos/play/wwdc2020/10027/)
- [WWDC2020 - Lists in UICollectionView](https://developer.apple.com/videos/play/wwdc2020/10026)
- [Implementing Modern Collection Views](https://developer.apple.com/documentation/uikit/views_and_controls/collection_views/implementing_modern_collection_views)

---

[⬆️ 맨 위로 이동하기](#-open-market)
