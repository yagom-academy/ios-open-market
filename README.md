# 오픈 마켓

1. 프로젝트 기간: 2022.01.03 - 2022.01.14
2. Ground Rules
    1. 시간
        - 시작시간 10시
        - 점심시간 12시~2시
        - 저녁시간 6시~7시 사이부터 2시간
    - 진행 계획
        - 프로젝트가 중심이 아닌 학습과 이유에 초점을 맞추기
        - 의문점을 그냥 넘어가지 않기
    - 스크럼
        - 10시에 스크럼 시작
3. 커밋 규칙
    1. 단위
        - 기능 단위
    - 메세지
        - 카르마 스타일

# 목차

- [키워드](#키워드)
- [STEP 1 : 모델/네트워킹 타입 구현](#STEP-1--네트워킹-타입-구현)
    + [고민했던 것](#1-1-고민했던-것)
    + [의문점](#1-2-의문점)
    + [Trouble Shooting](#1-3-Trouble-Shooting)
    + [배운 개념](#1-4-배운-개념)

# 키워드

- `의존성 주입(DI)`
- `URLSession`
    - `URLProtocol`
    - `URLRequest`
- `API`
- `HTTP` `TCP/IP`
    - `MIME-Type`
        - `multipart/form-data`
        - `application/json`
- `Result`
- `Codable` `CodingKey`
- `Async Test`

# STEP 1 : 네트워킹 타입 구현

- 네트워크 통신을 담당한 타입을 설계합니다.
- Mock 데이터를 활용하여 단위테스트를 수행합니다.

## 1-1 고민했던 것

### 1. 단일 책임 원칙(Single responsibility principle)

- 한 타입이 하나의 역할만 할 수 있도록 설계에 많은 고민을 해보았다.

### 2. CodingKeys 활용

실제 네트워크에서 내려오는 변수명이 스네이크 케이스를 사용하는 변수는 `Codingkey`를 이용하여 parsing하는 key를 바꿔주었으며 스네이크케이스를 사용하지 않는, 즉 타입의 변수명과 일치하면 rawValue를 명시할 필요가 없어 가독성을 위해 한 줄로 case를 합쳐주었다.

```swift
enum CodingKeys: String, CodingKey {
   case id, stock, name, thumbnail, currency, price, images, vendors
   case vendorID = "vendor_id"
   case bargainPrice = "bargain_price"
   case discountedPrice = "discounted_price"
   case createdAt = "created_at"
   case issuedAt = "issued_at"
}
```

### 3. NetworkManager와 Network

- Network하는 과정에서 역할마다 객체를 구분하여 구현하였다.
    - `Network` : dataTask()를 통해 SessionDataTask를 서버로 전송해 직접 네트워킹하는 객체
        
        ```swift
        func execute(request: URLRequest, completion: @escaping (Result<Data?, Error>) -> Void) {
                session.dataTask(with: request) { data, response, error in
                ...
        ```
        
    - `NetworkManager` : Network의 excute를 통해 data를 받아 decoding하는 fetch()를 가진 객체
        
        ```swift
        func fetch<T: Decodable>(request: URLRequest,
                                    decodingType: T.Type,
                                    completion: @escaping (Result<T, Error>) -> Void) {
                
             network.execute(request: request) { result in
        ```
        

### 4. Name Space

- 하드코딩을 개선하기 위해 enum 타입을 만들어 Address와 HTTPMethod의 값들을 분류해주었다.

### 5. Request, Response

- Request할 때, 그리고 Response하는 타입이 세부적으로 달라 ProductModification, ProductRegistration 등... 각 타입을 모두 구현하였다.

### 6. Overloading function

- 상품 삭제, 등록, 조회 등 여러가지 요청을 request 메소드 하나를 오버로딩을 활용하여 작성하였다.

### 7. Test Doubles

- 테스트 작성을 위해 의존성 주입을 활용하여 Mock, Stub 객체를 만들어 활용하였다.
- URLProtocol을 상속받은 클래스를 만들고 재정의를 해주었다.
    - 이 방법은 URLSession의 dataTask를 직접 Stub으로 만드는 방법도 있었지만, URLSessionDataTask를 채택한 타입에 init()을 정의하니 deprecated 경고가 떠서 이를 해결하기 위해 삭제 후 URLProtocol을 활용하는 방법으로 로직을 변경하였다.

## 1-2 의문점

- 비동기 메서드를 사용하는 동기 메서드는 비동기 메서드 테스트로 진행해야할까?
- URLProtocol과 URLSession의 관계가 정확하게 이해되지 않는다...
    - [https://developer.apple.com/videos/play/wwdc2018/417/](https://developer.apple.com/videos/play/wwdc2018/417/)
- Health Checker의 필요성을 모르겠다..
- 테스트 시 Request의 바디도 체크를 해야할까?

## 1-3 Trouble Shooting

<details>
<summary>1. URLSessionDataTask를 채택한 타입에 init()에 deprecated 경고..?</summary>
<div markdown="1">

### 1. URLSessionDataTask를 채택한 타입에 init()에 deprecated 경고..?

- `상황` URLSessionDataTask을 대체할 객체로 `StubURLSessionDataTask` 를 구현하다가 경고를 마주하게 되었다.

```swift
class StubURLSessionDataTask: URLSessionDataTask {
    var dummyData: DummyData?

    // init 부분에서 에러가 났다.
    init(dummy: DummyData?, completionHandler: DataTaskCompletionHandler?) {
        self.dummyData = dummy
        self.dummyData?.completionHandler = completionHandler
    }

    override func resume() {
        dummyData?.completion()
    }
}
```

> 'init()' was deprecated in iOS 13.0: Please use -[NSURLSession dataTaskWithRequest:] or other NSURLSession methods to create instances
> 
- 을 만들어 DummyData를 URLSessionDataTask에 전달하는 방식으로 Test를 진행하는 과정에서 경고가 나타났습니다.
- `이유` URLSessionDataTask `init()`이 IOS13 이후에 deprecatede되었기 때문이다. 해당 경고를 없애고 싶어서 구글링을 하다가 `URLProtocol`을 발견하게 되었다.
- `해결` URLProtocol을 상속받은 MockURLProtocol을 만들어서 URLSession configuration을 구성하는 방법으로 문제를 해결하고 기존에 만들었던 StubURLSessionDataTask, DummyData, MockSession 타입은 더이상 사용하지 않게되어 모두 삭제해주었다.
    - `URLProtocol`이란?
        - URL 데이터 로딩을 다루는 추상클래스
    - URLProtocol은 URLProtocolClient 프로토콜을 통해 네트워크 진행 상황을 전달한다.
    - 테스트 번들에서 MockURLProtocol 클래스를 만들고 메소드를 재정의 해준다.
    - 로드를 할 때 설정한 후 전달할 Data, Error, Response를 딕셔너리로 설정해준다.
        - 이 값은 URLProtocol에 연결하여 설정값을 세팅해주기 위한 값이 된다.
    - Unit Test를 위해 상속받아서 오버라이드 함으로써 커스텀 하여 Mock 객체를 새롭게 만들 수 있다.
        - 기존처럼 외부 네트워크에 요청을 직접 보내는 동작이 아니라, 요청을 가로채서 원하는 응답을 반환하게 끔 커스텀 하는 작업이다.
        - 즉 원래 같이 웹 서버에서 데이터를 불러오는 과정이 아니고, 내가 설정한 값(data, response)을 그대로 반환하게 만들어 주는 과정인 것이다.


</div>
</details>

<details>
<summary>2. multipart form-data 안에 이미지와 JSON을 같이 넣는 방법</summary>
<div markdown="1">

### 2. multipart form-data 안에 이미지와 JSON을 같이 넣는 방법

- `상황` JSON은 인코딩해서 바디에 추가해주면 되지만, `multipart form-data`의 경우 양식이 달랐다.
- `이유`  아래 양식에 맞춰서 JSON과 이미지파일을 변환해서 바디에 넣어주기 위해서 `multipart form-data`으로 `body`에 파일을 실어보는 작업을 찾아보았다.
    
    ```swift
    POST /test.html HTTP/1.1 // \r\n
    Host: example.org // \r\n
    Content-Type: multipart/form-data;boundary="boundary" // \r\n
     // \r\n
    --boundary // \r\n
    Content-Disposition: form-data; name="field1" // \r\n
    // \r\n
    value1 // \r\n
    --boundary // \r\n
    Content-Disposition: form-data; name="field2"; filename="example.txt" // \r\n
     // \r\n
    value2 // \r\n
    --boundary-- // \r\n
    ```
    
    - HTTP 통신 규격을 확인해서 JSON파일과 Image파일을 바디에 추가하게 코드를 짜야했다.
        - Content-Type이 multipart form-data로 지정되어 있어야한다.
        - 전송되는 파일 데이터의 구분자로 boundary에 지정되어있는 문자열을 이용한다.
        - 마지막에는 boundary 양옆에 `--` 를 붙여서 바디의 끝을 알린다.
        - header와 header를 구분하기 위해 개행문자를 추가한다. `\r\n`
        - header와 body를 구분하기 위해 개행문자 2개를 추가한다. `\r\n\r\n`
        - body에 포함되어있는 file data를 구분하기 위해 boundary를 넣어준다.
- `해결` 위에서 정리한 양식대로 바디를 추가하도록 코드를 작성하였다.


</div>
</details>


## **1-4 배운 개념**

- `multipart/form-data`
- API문서 읽는 방법
- 파싱한 JSON 데이터와 매핑할 모델 설계
    - `CodingKeys` 프로토콜의 활용
- URL Session을 활용한 서버와의 통신
    - `URLRequest`를 설정하는 방법
    - Testable한 네트워크 코드 작성하기
        - 네트워크 상황과 무관한 네트워킹 데이터 타입의 단위 테스트(Unit Test)

[![top](https://img.shields.io/badge/top-%23000000.svg?&amp;style=for-the-badge&amp;logo=Acclaim&amp;logoColor=white&amp;)](#오픈-마켓)

