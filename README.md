# 📣 Open Market 

- Gundy와 Wonbi가 만든 Open Market App입니다.

## 📖 목차
1. [팀 소개](#-팀-소개)
2. [팀 위키](#-팀-위키)
3. [Diagram](#-diagram)
4. [폴더 구조](#-폴더-구조)
5. [타임라인](#-타임라인)
6. [기술적 도전](#-기술적-도전)
7. [트러블 슈팅 및 고민](#-트러블-슈팅-및-고민)
8. [참고 링크](#-참고-링크)


## 🌱 팀 소개
|[Wonbi](https://github.com/wonbi92)|[Gundy](https://github.com/Gundy93)|
|:---:|:---:|
| <img width="180px" img style="border: 2px solid lightgray; border-radius: 90px;-moz-border-radius: 90px;-khtml-border-radius: 90px;-webkit-border-radius: 90px;" src="https://avatars.githubusercontent.com/u/88074999?v=4">| <img width="180px" img style="border: 2px solid lightgray; border-radius: 90px;-moz-border-radius: 90px;-khtml-border-radius: 90px;-webkit-border-radius: 90px;" src= "https://avatars.githubusercontent.com/u/106914201?v=4">|

## 🧭 팀 위키

#### [🤙 Ground Rule](https://github.com/wonbi92/ios-open-market/wiki/1.-Ground-Rule)

#### [🖋 Code Convention](https://github.com/wonbi92/ios-open-market/wiki/2.-Code-Convention)

#### [📝 일일 스크럼](https://github.com/wonbi92/ios-open-market/wiki/3.-Open-Market-Scrum)

## 👀 Diagram

### 🧬 Class Diagram
![](https://i.imgur.com/kLdn0Ix.png)

 
## 🗂 폴더 구조
> Network: 서버로부터 데이터를 받아오는 로직을 담당 <br>
> OpenMarket: 데이터를 처리하고 컨트롤 하는 메인 구조 <br>
> Extension: 기존 타입에 커스텀 로직 추가<br>
> OpenMarketTests: 유닛 테스트
```
OpenMarket
├── Extension
│   ├── Collection+
│   ├── DecodingError+
│   ├── Data+
│   ├── Int+
│   └── JSONDecoder+
├── Network
│   ├── HttpMethod
│   ├── Network Protocol
│   │   ├── URLSessionDataTaskProtocol
│   │   └── URLSessionProtocol
│   ├── NetworkError
│   ├── NetworkManager
│   └── NetworkRequest
├── OpenMarket
│   ├── AddProductViewController
│   ├── AppDelegate
│   ├── FormatConverter
│   ├── GridCollectionViewCell
│   ├── ImageCell
│   ├── ListCollectionViewCell
│   ├── Model
│   │   ├── EditProduct
│   │   ├── NewProduct
│   │   ├── Product
│   │   └── ProductList
│   ├── Network
│   │   ├── ImageCacheManager
│   │   └── OpenMarketNetworkRequest
│   ├── ProductsViewController
│   └── SceneDelegate
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

### 🅰️ 오픈마켓 I
<details>
<summary>펼쳐보기</summary>

#### 👟 Step 1
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
    
1️⃣ **Network**
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
     
2️⃣ **Extension**
- JSONDecoder
    - 제네릭 타입과 데이터를 받아 디코딩하는 타입 메서드를 추가하였습니다.
- String
    - `"yyyy-MM-dd'T'HH:mm:ss"`의 형식의 문자열을 `Date`타입의 값으로 변경시켜주는 메서드를 추가하였습니다.

3️⃣ **OpenMarket**
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
    
    
4️⃣ **Test Double**
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
    
5️⃣ **Unit Test**
- JSONDecoder, DTO
    - JSONParsingTests
- NetworkManager
    - NetworkManagerTests
- OpenMarketNetworkRequest
    - NetworkRequestTests
</details>

#### 👟 Step 2
- 컬렉션 뷰 사용하기
    - ✅ 커스터마이징 셀 구현하기
    - ✅ 리스트와 그리드 모양의 컬렉션 뷰 구현하기
- 이미지 비동기로 처리하기
    - ✅ 이미지를 서버에서 파싱하는 과정을 비동기로 처리하기
    - ✅ race condition 해결하기
- UISegmentedControl 사용하기
- 이미지 캐싱하기
    - ✅ 서버를 통해서 전달받은 데이터를 로컬에 캐시하기

<details>
<summary> 
펼쳐보기
</summary>

1️⃣ **Extension**
- DecodingError
    - `errorDescription`을 사용해 상황에 맞는 에러 메세지를 출력하도록 하였습니다.
- Collection
    - `subscript`를 이용해 첨자 문법으로 값에 접근 시 런타임에러가 나지 않도록 하였습니다.
- Int
    - 값이 0인지 확인하는 `isZero`, 숫자의 자리수를 체크하는 `decimal` 프로퍼티를 가지도록 하였습니다.
- OpenMarket
    - Product
        - 이제 `Product`는 `Hashable`을 채택합니다.
    - ImageCacheManager
        - 이미지를 캐싱하기 위한 싱글톤 객체입니다.

2️⃣ **Controller**
- ProductsViewController
    - 앱 실행시 나오는 첫 화면을 컨트롤 합니다.
    - 데이터를 파싱하고 이를 각 컬렉션 뷰에 전달합니다.
    - segmentedControl의 값이 바뀔 때 마다 각각의 컬렉션 뷰를 보여주도록 화면을 전환합니다.
- AddProductViewController
    - 다음 스텝에서 추가될 새로운 상품을 등록하는 화면을 컨트롤합니다.

3️⃣ **View**
- ListCollectionViewCell
    - 리스트 형태의 컬렉션 뷰에서 사용하는 셀입니다.
    - 리스트 형태로 커스터마이징 된 셀을 그립니다.
- GridCollectionViewCell
    - 그리드 형태의 컬렉션 뷰에서 사용하는 셀입니다.
    - 그리드 형태로 커스터마이징 된 셀을 그립니다.
</details>
    
</details>

### 🅱️ 오픈마켓 II
<details open>
<summary>펼쳐보기</summary>

#### 👟 Step 1
- 컬렉션 뷰 사용하기
    - ✅ 하나의 컬렉션 뷰에 여러개의 FlowLayout적용하기
- 모던 컬렉션 뷰 사용하기
    - ✅ 커스터마이징 셀 구현하기
    - ✅ 가로 스크롤되는 컬렉션뷰 구현하기
    - ✅ DiffableDataSource, Snapshot 활용하기
- 네트워킹
    - ✅ multipart/form-data httpBody 만들기
    - ✅ POST, DELETE httpMethod를 요청하는 Request 생성하기
    - ✅ UUID를 활용한 고유값 할당하기

<details>
<summary> 
펼쳐보기
</summary>

1️⃣ **Extension**
- Data
    - `append(_:using:)`을 사용해 문자열을 Data 타입으로 변환시켜 추가하도록 하였습니다.

2️⃣ **Controller**
- AddProductViewController
    - 상품의 등록과 수정을 담당하는 뷰 컨트롤러입니다.
    - 이미지가 추가될 때마다 이미지 컬렉션뷰의 아이템도 추가됩니다.

3️⃣ **AddProductViewController**
- ImageCell
    - AddProductViewController에서 상품의 이미지를 담당하는 셀입니다.

4️⃣ **OpenMarket**
- EditProduct
    - Codable을 채택하는 DTO입니다.
    - 상품 수정시 변경될 값을 갖습니다.
- NewProduct
    - Encodable을 채택하는 DTO입니다.
    - 상품 등록시 전달할 값을 갖습니다.
- ProductAddRequest
    - NetworkRequest를 채택하고, 상품 등록을 리퀘스트하기위한 프로퍼티를 갖고 있는 구조체입니다.
- ProductEditRequest
    - NetworkRequest를 채택하고, 상품 수정을 리퀘스트하기위한 프로퍼티를 갖고 있는 구조체입니다.
- URISearchRequest
    - NetworkRequest를 채택하고, 상품 삭제 URI를 리퀘스트하기위한 프로퍼티를 갖고 있는 구조체입니다.
- ProductDeleteRequest
    - NetworkRequest를 채택하고, 상품 삭제를 리퀘스트하기위한 프로퍼티를 갖고 있는 구조체입니다.
</details>
    
</details>

## 🏃🏻 기술적 도전

### 🅰️ 오픈마켓 I
<details>
<summary>펼쳐보기</summary>
    
#### ⚙️ URLSession 
<details>
<summary>펼쳐보기</summary>
    
- iOS 앱에서 서버와 통신하기 위해 애플은 `URLSession`이라는 API를 제공하고 있습니다. 유명한 라이브러리인 Alamofire, Moya 등의 기반이 되는 API로 서버와의 데이터 교류를 위해서는 필수적으로 알아야 하는 API입니다.
- `URLSession`은 HTTP를 포함한 몇 가지 프로토콜을 지원하고, 인증, 쿠키 관리, 캐시 관리 등을 지원합니다.<br><br>
- 💡 이번 프로젝트에서는 제공받은 서버에 있는 JSON 데이터를 받아오도록 구현해 보았습니다.

</details> 

#### ⚙️ Test Double
<details>
<summary>펼쳐보기</summary>
    
- Test Double 테스트를 진행하기 어려운 경우 이를 대신해 테스트를 진행할 수 있도록 만들어주는 객체를 말합니다.
- 실제로 네트워킹을 하지 않고, 정상적으로 fetch가 진행되는지 로직을 테스트 하기위해 `MockURLSession`이라는 test double객체를 만들고 `MockData` 객체를 반환하도록 로직을 구현해야 했습니다.<br><br>
- 💡 이번 프로젝트에서는 실제 `URLSession`과 이런 `MockURLSession`은 다르게 작동해야 하므로, 프로토콜을 통해 의존성을 역전시켜 네트워크 매니저가 프로토콜을 바라보게 하여 테스트를 할 때는 `MockURLSession`을 주입시키고, 실제 네트워킹을 할 때는 `URLSession`을 주입시키는 방법으로 구현해 보았습니다.

</details>

#### ⚙️ Segmented Control
<details>
<summary>펼쳐보기</summary>
    
- Segmented Control은 각각 버튼으로 기능하는 두 개 이상의 세그먼트로 구성된 리니어 집합입니다. `UISegmentedControl`는 여러 세그먼트로 구성된 수평 컨트롤이며 각 세그먼트는 개별 버튼으로 작동합니다.
<br><br>
- 💡 이번 프로젝트에서는 요구사항으로 오픈마켓 상품 리스트를 LIST모양과 GRID모양 두가지로 표현해 주어야 했습니다. 이를 각각 구현하고 세그먼트에 할당하여 서로 isHidden 상태를 전환하는 방식으로 화면을 변경하도록 구현하였습니다.

</details>

#### ⚙️ UIActivityIndicatorView
<details>
<summary>펼쳐보기</summary>
    
- `UIActivityIndicatorView`는 작업이 진행 중임을 보여주는 뷰입니다. 일반적으로 사용자에게 데이터를 불러오고 있다는 것을 알려주기 위해 사용합니다.
- 이미지를 서버에서 가져오는 로직은 텍스트를 가져오는 것과는 다르게 시간이 걸리는 작업입니다. 따라서, 이미지의 파싱이 끝날 때 까지 사용자는 이미지가 없는 셀을 보다가 이미지가 나중에 나타나는 UI를 보게 될 것입니다. 이는 좋은 사용자 경험이 아니라 판단하여 이미지의 파싱이 끝날 때 까지 로딩중임을 알리는 시각적 정보가 필요하였습니다.<br><br>
- 💡 이번 프로젝트에서는 이미지와 정확히 같은 위치에 `UIActivityIndicatorView`를 추가하여 이미지가 파싱되어 이미지뷰에 할당될 때까지 로딩중임을 알렸습니다. 이미지가 할당된 후에는 `UIActivityIndicatorView`의 애니메이션을 멈추고 보이지 않게 바꾸도록 구현하였습니다.

</details>

#### ⚙️ NSCache
<details>
<summary>펼쳐보기</summary>
    
- 캐싱은 재사용될 수 있을 만한 자원을 특정영역에 저장해놓는 것을 의미합니다. 캐싱된 데이터가 있다면 추가적인 자원을 소모하지않고 캐싱 데이터를 가져다 쓸 수 있기 때문에 자원을 절약할 수 있고 애플리케이션의 처리 속도가 향상됩니다.
- NSCache는 iOS 애플리케이션에서 Memory Caching 에 주로 사용되는 클래스입니다. key-value 형태의 데이터를 임시로 저장하는 데 사용할 수 있는 가변 컬렉션입니다. 자원이 부족할 때 삭제 대상이 됩니다.
- 매번 셀을 dequeue할 때마다 이미지를 서버에서 불러오는 것은 자원 낭비가 너무 심하다 판단되었습니다. 한번 불러온 이미지를 캐싱하여 이 문제를 해결하고자 했습니다.<br><br>
- 💡 이번 프로젝트에서는 `NSCache<NSString, UIImage>`타입의 싱글턴 객체를 갖는 `ImageCacheManager` 클래스를 구현하였습니다. 이를 통해 한 번 사용된 이미지는 캐싱하여 성능을 향상시킬 수 있도록 구현하였습니다.

</details>

</details> 

### 🅱️ 오픈마켓 II
<details open>
<summary>펼쳐보기</summary>
    
#### ⚙️ UIRefreshControl
<details>
<summary>펼쳐보기</summary>
    
![](https://i.imgur.com/pmSW13Q.png)

- UIRefreshControl 객체는 table view와 collection view를 포함한 모든 `UIScrollView`에 붙일 수 있는 표준 컨트롤입니다. 이 컨트롤을 스크롤 가능한 뷰에 추가하면 사용자는 표준적인 방법으로 컨텐츠를 새로고침할 수 있습니다.
- 사용자는 아래로 스크롤을 아래로 당기면 리프레시 인디케이터를 직관적으로 확인할 수 있으며, 리프레싱 로직이 끝나면 인디케이터가 사라져 작업이 끝났음을 알 수 있습니다.<br><br>
- 💡 이번 프로젝트에서는 스크롤을 아래로 당기면 상품목록을 업데이트 하여 새로 등록된 상품을 원하는 때에 바로바로 확인할 수 있도록 구현하였습니다.
- 또한, 업데이트가 완료되는 시점보다 1초의 여유 시간을 더 줘서 사용자에게 네트워킹이 진행중이라는 정보를 확실하게 전달하도록 구현하였습니다.
    
</details>

#### ⚙️ UICollectionViewDiffableDataSource
<details>
<summary>펼쳐보기</summary>
    
- iOS13부터 사용 가능한 Generic Class로, tableView나 collectionView를 이전 방식보다 비교적 단순하게 업데이트가 가능해집니다. 이전 테이블과 달라진 부분을 자동으로 알아차리고, 새로운 부분만 다시 그리기 때문입니다.
- 이 Diffable을 사용하여 얻게 되는 효과와 장점은:
    1. 추가적인 코드작업 없이도, 애니메이션 적용이 가능합니다.
    2. 개선된 Data Source 매커니즘은 완벽하게 동기적인 버그나, 예외, 충돌 상황들을 피할 수 있게 해줍니다.
    3. UI 데이터의 동기화 부분 대신 앱의 동적인 데이터와 내용에 집중할 수 있게 해줍니다.
    4. identifier와 snapshot을 사용하는 간소화 된 Data 모델을 정의 하고, 이를 이용하여 UI를 업데이트 합니다.<br><br>
- 💡 이번 프로젝트에서는 상품등록 및 수정 화면에서 상품의 사진을 추가할 때 마다 자연스럽게 셀이 추가되고, 가로로 스크롤되도록 구현하였습니다.
    
</details>
    
</details> 

## 🏔 트러블 슈팅 및 고민
    
### 🅰️ 오픈마켓 I
<details>
<summary>펼쳐보기</summary>
    
#### 🚀 테스트용 JSON 파일과 서버 API 문서
    
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

#### 🚀 Deprecated Initializer

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

#### 💭 재사용이 가능한 Request객체 구현하기
    
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
    
#### 💭 BoringSSL
    
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

#### 🚀 투명한 네비게이션 바 문제 해결하기

<details>
<summary> 
펼쳐보기
</summary>

**문제 👻**
- 앱 구동시 네비게이션 바가 투명해져서 네비게이션 바 아이템들이 둥둥 떠다니는 모습이 되어버렸습니다.
![](https://i.imgur.com/ajEo04E.png)
- 이는 iOS가 15버전으로 업데이트 된 후 네비게이션 바가 확장되면서 생긴 문제였습니다. 시뮬레이터의 iOS버전은 15 였고, 시뮬레이터에서 네비게이션 바가 투명해 진 것입니다.

**해결 🔫**
- 저희가 원했던 방향성은 네비게이션 바가 항상 불투명하게 자리를 잡는 것이기 때문에 UINavigationBarAppearance의 configureWithDefaultBackground() 인스턴스 메서드를 사용해서 항상 불투명하게 나오도록 처리하였습니다.
```swift
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithDefaultBackground()
        
        UINavigationBar.appearance().standardAppearance = navigationBarAppearance
        UINavigationBar.appearance().compactAppearance = navigationBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
        return true
    }
```
![](https://i.imgur.com/20jVluj.png)
    
</details>

#### 🚀 비동기로 인한 race-condition발생 문제 해결

<details>
<summary> 
펼쳐보기
</summary>

**문제 👻**
- 이미지를 서버에서 가져오는 로직의 경우, 이미지의 크기가 커 불러오는 작업을 메인 스레드에서 진행하면 스크롤을 내릴 때 마다 화면이 버벅이게 되어 쾌적한 사용자 경험을 제공하지 못하게 됩니다.
- 따라서 이 로직을 메인 스레드가 아닌 다른 스레드에서 진행하도록 하여 메인 스레드는 받아온 이미지를 띄우기만 하도록 로직을 짜보았습니다.
문제는 이 작업을 비동기적으로 진행하다보니, 이미지를 불러오기 위한 thumbnail에 접근하는 과정에서 race-condition이 발생하는 것입니다. 때문에 스크롤을 빠르게 내릴 수록 이미지가 계속 바뀌는 상태가 되었습니다.

![](https://i.imgur.com/RzInO7A.gif)

**해결 🔫**
- 이를 해결하기 위해 이미지를 불러오기 전에 셀이 가지고 있는 product와 디스패치 큐로 작업을 넘길 때 캡쳐한 product가 일치하는지 확인하는 로직을 추가하였고, product가 비교 가능한 상태가 될 수 있도록 Hashable을 채택하도록 처리하였습니다.
```swift
DispatchQueue.main.async { [weak self] in
    if product == self?.product {
        self?.productImage.image = image
        self?.loadingView.stopAnimating()
        self?.loadingView.isHidden = true
        self?.productImage.isHidden = false
    }
}
```
![](https://i.imgur.com/DeWDRlh.gif)
    
</details>

#### 💭 코드로만 화면 구현하기

<details>
<summary> 
펼쳐보기
</summary>

**고민 🤔**
- 이번 프로젝트는 유독 스토리보드로 구현하기가 더 쉬웠을 것 같습니다.
- 하지만 양쪽 모두 할 줄 알아야하기 때문에 이번 프로젝트에서는 코드로만 화면을 구현하는 것을 목표로 했습니다.
- 이 과정에서 스토리보드 삭제 및 초기 설정으로 필요한 부분들을 AppDelegate 및 SceneDelegate에 작성하여 진행했습니다.
```swift
func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    guard let scene = scene as? UIWindowScene else { return }
    let rootViewController = ProductsViewController()
    let navigationController = UINavigationController(rootViewController: rootViewController)

    window = UIWindow(frame: scene.coordinateSpace.bounds)
    window?.windowScene = scene
    window?.rootViewController = navigationController
    window?.makeKeyAndVisible()
}
```

</details>

#### 💭 안전한 Collection 사용을 위한 extension

<details>
<summary> 
펼쳐보기
</summary>

**고민 🤔**
- 저희는 API를 통해 데이터를 요청할 때 한 번에 20개씩 요청을 하고 있습니다.
- 더이상 불러올 데이터가 없는 마지막에 가서는 20개보다 적게 응답이 올 수 있기 때문에 잘못된 인덱스에 접근할 가능성이 있었습니다.
- 이에 대한 반환값은 옵셔널이 아닌 타입이기 때문에 이를 nil인지 확인하는 과정을 만드는 것 보다는 subscript 문법으로 접근할 때 옵셔널 값을 반환하게 처리하는 것이 더 적절하다고 생각했습니다.
- subscript 문법에 대한 메서드 추가로 안전하게 값에 접근하도록 하였습니다.
```swift
extension Collection {
    subscript(valid index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
```

```swift
func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section:
Int) -> Int {
    return productLists[valid: section]?.pages.count ?? 0
}
```

</details>
    
</details> 

### 🅱️ 오픈마켓 II
<details open>
<summary>펼쳐보기</summary>

#### 🚀 multipart/form-data httpBody
    
<details>
<summary> 
펼쳐보기
</summary>

**문제 👻**
```http
// Header
identifier: "test"
Content-Type: "multipart/form-data; boundary=----D29749DE-06BB-43ED-B94A-D9F2550C9496"

// Body
----A5A44C23-8AE2-44FE-9CEA-019BAD96EA2D
Content-Disposition: form-data; name="params"
Content-Type: application/json

{"secret":"test","discounted_price":100,"price":10000,"stock":10,"description":"새로운 상품입니다.","currency":"KRW","name":"새로운 상품"}
----A5A44C23-8AE2-44FE-9CEA-019BAD96EA2D
Content-Disposition: form-data; name="images"; filename="image.jpeg"
Content-Type: image/jpeg

image Data
----A5A44C23-8AE2-44FE-9CEA-019BAD96EA2D--    
```
- multipart/form-data의 Body를 만들어 POST 요청을 보내는 과정에서, 계속해서 `statusCode - 400` 에러가 나타나는 문제가 있었습니다.
- 위와 같은 방법으로 Header와 Body를 구성하여 시도해 보았지만 `MissingServletRequestPartException`라는 메세지와 함께,  `statusCode - 400` 에러가 나타났습니다.
    
**해결 🔫**
```http
// Header
identifier: "test"
Content-Type: "multipart/form-data; boundary=----D29749DE-06BB-43ED-B94A-D9F2550C9496"

// Body
------A5A44C23-8AE2-44FE-9CEA-019BAD96EA2D
Content-Disposition: form-data; name="params"
Content-Type: application/json

{"secret":"test","discounted_price":100,"price":10000,"stock":10,"description":"새로운 상품입니다.","currency":"KRW","name":"새로운 상품"}
------A5A44C23-8AE2-44FE-9CEA-019BAD96EA2D
Content-Disposition: form-data; name="images"; filename="image.jpeg"
Content-Type: image/jpeg

image Data
------A5A44C23-8AE2-44FE-9CEA-019BAD96EA2D--    
```
- 보통 이런 400 에러의 경우 multipart/form-data가 요구하는 폼으로 데이터를 작성하지 않을 때 생기는 에러입니다.
- 언뜻 보면 잘 지켜서 작성한 것 같지만, 자세하게 보니 바운더리 앞에 `--`를 추가적으로 입력하지 않아서 발생한 문제였습니다.
- 바운더리를 선언하는 부분과 다르게 바운더리를 사용하는 부분(실제 멀티파트를 구분하는 부분)에서는 추가 접두사로 `--`을 반드시 붙여주어야 합니다.
- 이를 적용하여 문제를 해결하였습니다.

</details>

#### 🚀 모던 컬렉션뷰 가로 스크롤
    
<details>
<summary> 
펼쳐보기
</summary>

**문제 👻**
- 모던 컬렉션뷰를 통해 상품 등록/수정 페이지의 이미지 목록 가로 스크롤을 구현하였습니다.
- 하지만 컬렉션뷰 자체의 스크롤때문에 좌우만이 아닌 위아래로도 스크롤 기능이 살아있었습니다.
![](https://i.imgur.com/r5phSYP.gif)

**해결 🔫**
- 이를 해결하기 위해 `configureCollectionView()` 메서드를 호출할 때 컬렉션뷰의 `isScrollEnabled` 프로퍼티를 false로 변경해주었습니다.
![](https://i.imgur.com/5oUHwyj.gif)
```swift
private func configureCollectionView() {
    imageCollectionView.isScrollEnabled = false
```

</details>
    
#### 💭 하나의 CollectionView 사용하기

<details>
<summary> 
펼쳐보기
</summary>

**고민 🤔**
- 두 개의 collectionView를 hide/unhide하면서 화면을 전환하는 방향으로 프로젝트를 진행했습니다.
- 하지만 컬렉션뷰의 레이아웃만을 교체하는 것이 더욱 자원의 활용적인 측면에서 좋을 것이라고 생각했습니다.
- 하나의 컬렉션뷰로 활용할 수 있도록 제약사항 등을 정리하고, 레이아웃도 매번 초기화하는 것이 아닌 저장 프로퍼티로 변경하게끔 수정하였습니다.
    
```swift
private let listLayout: UICollectionViewFlowLayout = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    layout.itemSize = CGSize(width: UIScreen.main.bounds.width - 20, height:
UIScreen.main.bounds.height / 12)
    layout.minimumLineSpacing = 0
    return layout
}()
private let gridLayout: UICollectionViewFlowLayout = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 2 - 15,
                             height: UIScreen.main.bounds.height / 3)
    layout.sectionInset = .init(top: 10, left: 0, bottom: 0, right: 0)
    return layout
}()
private let collectionView: UICollectionView = {
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout:
UICollectionViewLayout())
    collectionView.register(ListCell.self, forCellWithReuseIdentifier: "ListCell")
    collectionView.register(GridCell.self, forCellWithReuseIdentifier: "GridCell")
    collectionView.contentInset = UIEdgeInsets(top: .zero, left: 10, bottom: .zero, right:
10)
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    return collectionView
}()
```

</details>
        
#### 💭 레이아웃 변경시 스크롤 동기화하기

<details>
<summary> 
펼쳐보기
</summary>

**고민 🤔**
- List와 Grid의 두 화면을 오갈때 서로 다른 아이템을 보게되는 것보다 같은 아이템을 레이아웃만 달리 보게하는 것이 더욱 좋은 사용자 경험을 유발하리라 생각했습니다.
- 적절한 위치로 스크롤을 맞추기 위해 처음에는 `visibleCells` 프로퍼티를 활용하고자 하였으나 이는 정렬되지 않은 UICollectionViewCell의 배열을 반환하였습니다.
- 매번 동일한 결과를 내기 위하여 `indexPathsForVisibleItems.sprted()`를 사용해 실제로 보이는 첫 번째 아이템의 상단으로 스크롤을 동기화시켰습니다.
    
```swift
@objc private func changeLayout(_ segmentedControl: UISegmentedControl) {
    let visiblePath: [IndexPath] = collectionView.indexPathsForVisibleItems.sorted()
    var index: IndexPath = IndexPath()
    
    switch segmentedControl.selectedSegmentIndex {
    case LayoutType.list.rawValue:
        index = visiblePath.count == 8 ? visiblePath[2] : visiblePath[0]
        collectionView.collectionViewLayout = listLayout
    case LayoutType.grid.rawValue:
        index = collectionView.contentOffset.y > 0 ? visiblePath[2] : visiblePath[0]
        collectionView.collectionViewLayout = gridLayout
    default:
        break
    }
    collectionView.reloadData()
    collectionView.scrollToItem(at: index, at: .top, animated: false)
}
```
    
</details>
    
</details>
    
## 🔗 참고 링크

[공식문서]

- [Apple Developer Documentation - URLSession](https://developer.apple.com/documentation/foundation/urlsession)
- [Apple Developer Documentation - Fetching Website Data into Memory](https://developer.apple.com/documentation/foundation/url_loading_system/fetching_website_data_into_memory)
- [Apple Developer Documentation - UICollectionView](https://developer.apple.com/documentation/uikit/uicollectionview)
- [Apple Developer Documentation - UIAlertController](https://developer.apple.com/documentation/uikit/uialertcontroller)
- [Apple Developer HIG - Entering data](https://developer.apple.com/design/human-interface-guidelines/patterns/entering-data/)
- [WWDC2020 - Modern cell configuration](https://developer.apple.com/videos/play/wwdc2020/10027/)
- [WWDC2020 - Lists in UICollectionView](https://developer.apple.com/videos/play/wwdc2020/10026)
- [Implementing Modern Collection Views](https://developer.apple.com/documentation/uikit/views_and_controls/collection_views/implementing_modern_collection_views)

---

[⬆️ 맨 위로 이동하기](#-open-market)
