# README(6) 오픈 마켓

# 💵 오픈마켓

REST API와의 연동을 통해 간단한 마켓기능을 사용해볼 수 있는 앱입니다.
서버와 통신하여 받아온 JSON파일을 디코딩하여 보여줍니다.

</br>

## 📖 목차
1. [팀 소개](#-팀-소개)
2. [기능 소개](#-기능-소개)
3. [Diagram](#-diagram)
4. [폴더 구조](#-폴더-구조)
5. [프로젝트에서 경험하고 배운 것](#-프로젝트에서-경험하고-배운-것)
6. [타임라인](#-타임라인)
7. [고민한 부분](#-고민한-부분)
8. [트러블 슈팅](#-트러블-슈팅)
9. [참고 링크](#-참고-링크)

</br>

## 🌱 팀 소개
 |[mene](https://github.com/JaeKimdev)|[써니쿠키](https://github.com/sunny-maeng)|
 |:---:|:---:|
| <img width="180px" img style="border: 2px solid lightgray; border-radius: 90px;-moz-border-radius: 90px;-khtml-border-radius: 90px;-webkit-border-radius: 90px;" src="https://avatars.githubusercontent.com/u/84453688?v=4">| <img width="180px" img style="border: 2px solid lightgray; border-radius: 90px;-moz-border-radius: 90px;-khtml-border-radius: 90px;-webkit-border-radius: 90px;" src="https://avatars.githubusercontent.com/u/107384230?v=4">|

</br>

## 🛠 기능 소개
- step2 진행 후, 화면 gif생성 update 예정입니다

</br>

## 👀 Diagram
- 리팩토링 후, step2 진행 후 update 예정입니다

</br>

## 🗂 폴더 구조
```
OpenMarket
├── OpenMarket
│   ├── AppDelegate.swift
│   ├── MockURLSession
│   │   ├── MockHTTPURLResponse.swift
│   │   ├── MockURLSession.swift
│   │   ├── MockURLSessionDataTask.swift
│   │   ├── SampleData.swift
│   │   └── URLSessionProtocol.swift
│   ├── Model
│   │   ├── DataType
│   │   │   ├── Market.swift
│   │   │   └── Page.swift
│   │   ├── Extension
│   │   │   └── DateFormatter+Extension.swift
│   │   └── URLSession
│   │       ├── Decodable+Extension.swift
│   │       ├── MockURLSession
│   │       ├── NetworkError.swift
│   │       ├── Request.swift
│   │       ├── URLComponents+Extension.swift
│   │       └── URLSessionProvider.swift
│   ├── SceneDelegate.swift
│   ├── View
│   │   └── Base.lproj
│   │       ├── LaunchScreen.storyboard
│   │       └── Main.storyboard
│   └── ViewController
│       └── ViewController.swift
└── UnitTest
    ├── DecodeTests
    │   └── DecodeTests.swift
    └── MockURLSessionTests
        └── MockURLSessionTests.swift
```

</br>

## ✅ 프로젝트에서 경험하고 배운 것
- JSONData 파싱
     - [X] 파싱한 JSON 데이터와 매핑할 모델 설계
     - [X] `keyDecodingStrategy`을 사용한 SnakeCase를 CamelCase로 변환하는 디코딩 구현 </br></br>
- URL Session을 활용한 서버와의 통신
     - [X] `URLComponents`를 이용해 URL의 Path와 QueryItem을 받아 url 주소 생성
     - [X] `URLSession`과 관련 타입들을 사용해 API생성 및 서버에서 데이터를 받아오는 로직 구현
     - [X] 받아오는 데이터의 HTTPURLResponse, mimeType, error를 체크하면서 `dataTask`생성하는 로직 구현</br></br>
- Unit Test를 통한 설계 검증
     - [X] 서버에서 받아오는 데이터와 같은 형식의 테스트용 Asset data를 이용해 `DTO`와 커스텀한 `Decoding` 메서드의 정상동작을 `UnitTest` 진행
     - [X] 네트워크 상태와 무관하게 서버와 통신하는 로직을 테스트할 수 있도록 `Mock`을 이용한 `UnitTest` 진행

</br>

## ⏰ 타임라인

| 🕛 Step 1|  |
| :--------: | -------- |
| 1 | DTO구현 - JSON 데이터와 매핑할 `Market`, `Page` 타입 구현    |
| 2 | `URLSession`을 사용한 서버와의 통신 로직 구현 | 
| 3 | `Mock`으로 서버 통신 로직을 네트워크 상태와 무관하게 unitTes 진행 | 
<details>
<summary>[Details - Step1 타입별 기능 설명] </summary>

#### 1️⃣ DTO - `Market` 구조체, `Page` 구조체 
- 서버에서 제공되는 JSON파일과 매핑하는 타입입니다.
- STEP1에서는 디코딩만 사용하고 있어서 `Decodable`을 채택하였습니다.

#### 2️⃣ `MarketURLSessionProvider` 클래스
- 서버에서 데이터를 받아오는 기능을 합니다,
- `fetchData(url:, type:, completionHandler:)`메서드
    - `HTTPURLResponse`, `mimeType`, `error`를 확인하고 서버에서 데이터를 받아와 디코딩 합니다.
    
#### 3️⃣ `Request` 열거형
- [HealthChekcer], [상품 리스트 조회], [상품 상세 조회] 데이터를 조회할 수 있는 url주소를 case로 갖고있습니다.

#### 4️⃣ `NetworkError` 열거형
- 서버와의 통신 중 발생가능한 Error를 case로 갖고있습니다.

#### 5️⃣ `URLComponents` extension
- `healthCheckUrl` 메서드
    - 서버와 소통이 정상인지 확인하는 주소인 `healthCheckUrl`을 리턴합니다.
- `marketUrl(path:, queryItems:)` 메서드
    - path와 queryItems를 배열로 받아 Market의 baseUrl을 바탕으로 url 주소를 생성 후 리턴합니다.

#### 6️⃣ `JSONDecoder` Extension
- `decodeFromSnakeCase(type:, from:)`메서드
    - JSON타입의 데이터를 decoding합니다.
    - `decodeFromSnakeCase` 메서드를 구현했습니다.
    - `keyDecodingStrategy`로 `.convertFromSnakeCase`를 적용했습니다.
    - `dateDecodingStrategy`로 `.formatted(DateFormatter.dateFormatter)`를 적용했습니다

#### 7️⃣ MockURLSession
- `URLSessionProtocol`, `MockURLSession` 클래스, `MockURLSessionDataTask`클래스 , `SampleData` 열거형
    - 네트워크 상태와 무관하게 URLSession작동을 확인하는 단위 테스트(Unit Test)에 사용하는 타입 입니다.

#### 8️⃣ Unit Test - `DecodeTests` 클래스, `MockURLSessionTests` 클래스
- `DecodeTests` 클래스
    - 제공된 JSON 데이터를 `Market` 타입으로 Parsing 할 수 있는지에 대한 단위 테스트(Unit Test)입니다.
- `MockURLSessionTests` 클래스
    - `MockURLSession`과 `SampleData`를 이용해 네트워크 상태와 무관하게 URLSession작동이 정상적인지 확인하는 단위 테스트(Unit Test) 입니다.
</details>

</br>

## 💭 고민한 부분

### 1️⃣ URL의 주소 생성 방법과 네임스페이스
- 주소의 quetyItm과 Path만 변경해서 url을 만드는 방법을 고민했습니다.
- url 주소생성은 `URLComponents`타입을 `extension해` `path`와 `queryItems`를 연결하는 `makeUrl`메서드를 생성했습니다. 
- url의 네임스페이스로 정리할 때 `makeUrl` 메서드를 사용하는데, argument로 주소정보를 전달해줘야하기 때문에 url을 타입 연산 프로퍼티로 정리할지, case로 정리할지 고민했습니다.
- enum의 case에서도 associated Value(연관값)을 사용할 수 있어서 `case productDetail(productNumber: Int)`와 같이 사용한 case로 정리했습니다.


### 2️⃣ JSON snake_case를 CamelCase로 변환하는 방법을 고민해 보았습니다.
- `Coding Key`와 `keyDecodingStrategy`를 사용하는 방법 중, `keyDecodingStrategy`를 사용하여 `convertFromSnakeCase`를 적용하였습니다.

### 3️⃣ 디코딩 메서드를 `decodeFromAsset`, `decodeFromServer` 2개로 구현하였다가 메서드 재사용을 위해 하나의메서드로 통일했습니다.
- 처음에는 에셋의 JSON 파일에서 디코딩하는 메서드와 서버에서 받아오는 JSON 파일을 디코딩 하는 메서드를 분리하여 작성하였다가 `decodeFromSnakeCase` 하나의 메서드에서 함께 처리하도록 구현하였습니다.

### 4️⃣ DecodeTests 유닛테스트 시, 테스트 케이스 내부를 타지 않고 바로 `success`로 반환되는 문제를 해결하기 위해 고민해 보았습니다.
- 기제공된 `products.json`파일에서 날짜 관련된 프로퍼티의 타입을 `Date`로 변경하여 주기 위해 `DateFormatter`를 구현하고 사용했는데, STEP 1-2에서 서버와 통신하면서 받아오는 날짜 형식이 달라 `NSDataAsset`을 디코딩하지 못해서 생기는 문제였습니다. ➡️ `Assets`에 등록된 날짜 형식을 서버와 같게 수정하여 주었습니다.

</br>

## 🚀 트러블 슈팅

### 1️⃣ DTO 타입 재사용
- [상품 리스트 조회]데이터에서 파싱해오는 `Page`타입의 `Key목록`은 [상품 상세조회]페이지에서 파싱해오는 `Page`타입의 Key목록에서 3가지 key가 누락되어있어 `Page`타입의 재사용에 있어 에러가 있었습니다.<br><br>
- ✅ **수정: 옵셔널타입 설정**
    - DTO 재사용을 위해 누락 되어있는 `description` / `images` / `vendor`  Key를 **옵셔널타입**으로 지정해 전자의 경우에서는 파싱하지 않고, 후자의 경우에선 파싱할 수 있게 했습니다.

### 2️⃣ Mock 을 이용한 Network Unit Test에 사용할 SampleData의 mimeType 설정
- `HTTPURLResponse`를 Mock으로 인스턴스를 만들어 유닛테스트를 할 때, mimeType이 `nil`이라 데이터의 mimeType을 확인하는 로직에 걸려 에러가 나는 문제가 있었습니다. 
- mimeType은 get 속성으로 읽기전용이라 인스턴스 생성 후 외부에서 속성값을 주입할 수 없었습니다.<br><br>
- ✅ **수정: override**  
    - HTTPURLResponse를 상속받는 MockHTTPURLResponse타입을 구현해 mimeType프로퍼티를 override해 server에서 파싱해오는 `application/json`의 값을 갖도록했고, MockHTTPURLResponse로 인스턴스를 사용했습니다 <br>
        ```swift
        final class MockHTTPURLResponse: HTTPURLResponse {
            override var mimeType: String {
                return "application/json"
            }
        }
        ```         
       
### 3️⃣ `fetchData(url:, type:, completionHandler:)`메서드로 가져온 서버의 data를 함수 외부로 return하는 법
- 이 메서드는 서버에서 data를 받아오는 기능을 합니다. 즉 호출 시 Data를 return해 줘야하는데 메서드 내부에서 사용되는 핵심 메서드인 dataTask메서드의 CompletionHandler를 사용해야해서 return타입을 구현하는 데 어려움이 있었습니다
    - 우선 URLSession의 dataTask메서드의 return타입이 Void타입으로 지정되어있었습니다
    - dataTask메서드 외부의 변수에 data를 담는 방법은 클로저의 값 캡쳐 속성때문에 불가능했습니다.<br><br>
- ✅ **수정: Result타입사용**
    - completionHandler에 Result<Success, Failure>타입을 프로퍼티로 갖는 클로저를 사용했습니다.
    - dataTask메서드 내부에서 data를 .success(_)에 저장하도록 했습니다
    - 서버통신 작업이 비동기적이기 때문에 작업이 완료된 후 호출되는 completionHandler가 정상작동 될 수 있도록 @escaping 키워드를 사용했습니다.<br><br>
    ```swift
    func fetchData<T: Decodable>(url: URL,
                                 type: T.Type,
                                 completionHandler: @escaping (Result<T, NetworkError>) -> Void) {
        let dataTask = session.dataTask(with: url) { data, response, error in
            ...
            completionHandler(.success(decodedData))
        }
        
        dataTask.resume()
    } 
    ```
    
</br>    
    
## 🔗 참고 링크

[공식문서]
- [URLSession](https://developer.apple.com/documentation/foundation/urlsession)
- [Fetching Website Data into Memory](https://developer.apple.com/documentation/foundation/url_loading_system/fetching_website_data_into_memory)
- [URLComponents](https://developer.apple.com/documentation/foundation/urlcomponents)
- [queryItems](https://developer.apple.com/documentation/foundation/urlcomponents/1779966-queryitems)
- [JSONDecoder.KeyDecodingStrategy](https://developer.apple.com/documentation/foundation/jsondecoder/keydecodingstrategy)

[그 외 참고문서]
- [네트워크 상태와 무관한 테스트를 작성하는 방법](https://velog.io/@dacodaco/iOS-%EB%84%A4%ED%8A%B8%EC%9B%8C%ED%81%AC-%EC%83%81%ED%83%9C%EC%99%80-%EB%AC%B4%EA%B4%80%ED%95%9C-%ED%85%8C%EC%8A%A4%ED%8A%B8%EB%A5%BC-%EC%9E%91%EC%84%B1%ED%95%98%EB%8A%94-%EB%B0%A9%EB%B2%95)
- [네트워크와 무관한 URLSession Unit Test](https://wody.tistory.com/10)
