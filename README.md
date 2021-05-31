# 오픈마켓 프로젝트 학습


### 타임라인

- 05/31(월)
  - 강의) Core Data, Database
  - API 모델 타입 구현, Unit Test 공부
- 06/01(화)
- 06/02(수)
- 06/03(목)
- 06/04(금)


<br>

### 학습키워드
- API 문서 보는 방법
- Unit Test

<br>

### 트러블슈팅 (Troubleshooting)

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

