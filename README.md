# 오픈마켓 프로젝트 학습

### 타임라인

- 05/31(월)
  - 강의) Core Data, Database
  - API 모델 타입 구현, Unit Test 공부
- 06/01(화)
  - Mock Data 만들기 및 활용 방법
  - JSON Parse 공부
- 06/02(수)
  - Unit Test
- 06/03(목)
- 06/04(금)


<br>

### 학습키워드
- API 문서 보는 방법
- Unit Test
  - Mock Data
- JSON Parse
<br>

### 트러블슈팅 (Troubleshooting)
1. Type `ItemModification` does not conform to protocol `Decodable`
    - API 모델 타입 구현 시, `CodingKey` 를 통해 case를 재정의 할때 선언된 변수명과 일치하는지 확인해야한다.
    - 스펠링 오타로 인해 발생한 오류! 대충 보았을 때 왜 틀린지 알기 어려웠다.처음엔 프로토콜을 잘못 채택했다고 생각.
2. XCTAssertEqual failed
    - decoding한 data와 비교하는 객체의 값이 일치하지 않음. 이스케이프 문자 `\`로 인한 오류
    - 코드에서 json 문자열 안에 `\n`을 넣었을 때 된다면 `\`는 코드에서 문자열이 아닌 다른 내용을 구분하기 위해 사용되는 특별한 문자이기 때문에, 진짜 `\n`을 입력하려면 `\\n` 이라고 써줘야 한다. 참고로, 스위프트에서는 아래와 같이 문자열을 `#`으로 감싸면 `\\` 처리를 안해줘도 된다.
    
<br>

### 참고 사이트

<details>
<summary> 링크 </summary>
<div markdown="1">

<br>

Mock Data

- [[블로그] [TIL] 27. Mock Data - leeeeunz](https://velog.io/@leeeeunz/Project-2.-Mock-Data)
- [[블로그] Swift의 강력한 mock 객체 만들기 - Jon Reid](https://academy.realm.io/kr/posts/making-mock-objects-more-useful-try-swift-2017/)
- [ObjGen - Mock Data 만드는 사이트](https://beta5.objgen.com/json/local/design)
- [Mockaroo - Mock Data 만드는 사이트](https://www.mockaroo.com/)
- [databasetestdata - Mock Data 만드는 사이트](https://www.databasetestdata.com/)

Unit Test

- [[블로그] UnitTest의 사용법 - Zedd](https://zeddios.tistory.com/48)
- [[위키백과] 유닛테스트](https://ko.wikipedia.org/wiki/%EC%9C%A0%EB%8B%9B_%ED%85%8C%EC%8A%A4%ED%8A%B8)
- [[developer.apple] xctest](https://developer.apple.com/documentation/xctest/xctest)
- [[블로그] [iOS] Custom Mock Network Request - 민소네](http://minsone.github.io/ios/mac/ios-mock-network-request)
  
JSON, Codable(Encodable, Decodable)
- [Swift ) 왕초보를 위한 Codable / JSON Encoding and Decoding - Zedd](https://zeddios.tistory.com/373)
- [왕초보를 위한 JSON Parsing - 1 (JSON이란?) - Zedd](https://zeddios.tistory.com/90)
- [[블로그] 이스케이프 문자의 JSON Parse 오류에 대해 알아봅니다.](https://falsy.me/%EC%9D%B4%EC%8A%A4%EC%BC%80%EC%9D%B4%ED%94%84-%EB%AC%B8%EC%9E%90%EC%9D%98-json-parse-%EC%98%A4%EB%A5%98%EC%97%90-%EB%8C%80%ED%95%B4-%EC%95%8C%EC%95%84%EB%B4%85%EB%8B%88%EB%8B%A4/)
  
URLSession
- [[공식 프로그래밍 가이드] URL Loading System](https://developer.apple.com/documentation/foundation/url_loading_system)
- [[레퍼런스] URLSession](https://developer.apple.com/documentation/foundation/urlsession)
- [[웹사이트] Postman](https://www.postman.com/)
- [[레퍼런스] HTTP Request Methods](https://developer.mozilla.org/ko/docs/Web/HTTP/Methods)

</div>
</details>

<br>

# Step1

    
### API 모델 타입 구현

<details>
<summary>Response</summary>
<div markdown="1">

<br>

- ItemPage
  
```swift
struct ItemPage: Decodable {
    var page: Int
    var items: [ItemShortInfo]
}

struct ItemShortInfo: Decodable {
    var id: Int
    var title: String
    var price: Int
    var currency: String
    var stock: Int
    var discountedPrice: Int?
    var thumbnails: [String]
    var registrationDate: Int
    
    private enum CodingKeys: String, CodingKey {
        case id, title, price, currency, stock, thumbnails
        case discountedPrice = "discounted_price"
        case registrationDate = "registration_date"
    }
}
```
  
- ItemDetail
  

```swift
struct ItemDetail: Decodable {
    var id: Int
    var title: String
    var descriptions: String
    var price: Int
    var currency: String
    var stock: Int
    var discountedPrice: Int?
    var thumbnails: [String]
    var images: [String]
    var registrationDate: Int

    private enum CodingKeys: String, CodingKey {
        case id, title, descriptions, price, currency, stock, thumbnails, images
        case discountedPrice = "discounted_price"
        case registrationDate = "registration_date"
    }
}
```

</div>
</details>






<details>
<summary>Request</summary>
<div markdown="1">    
  
  <br>
  
- ItemRegistraion

```swift
struct ItemRegistration {
    var title: String
    var descriptions: String
    var price: Int
    var currency: String
    var stock: Int
    var discountedPrice: Int?
    var images: [String]
    var password: String
    
    private enum CodingKeys: String, CodingKey {
        case title, descriptions, price, currency, stock, images, password
        case discountedPrice = "discounted_price"
    }
}
```

- ItemModification
  
```swift
struct ItemModification {
    var title: String?
    var descriptions: String?
    var price: Int?
    var currency: String?
    var stock: Int?
    var discountedPrice: Int?
    var images: [String]?
    var password: String
    
    private enum CodingKeys: String, CodingKey {
        case title, descriptions, price, currency, stock, images, password
        case discountedPrice = "discounted_price"
    }
}
```
  
</div>
</details>

<br>

### Unit Test
- Mock Data 파일로 decoding 하고, 같은 정보를 가진 가짜 객체를 만들어 XCTAssertEqual로 비교 

