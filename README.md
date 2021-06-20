# 오픈마켓 프로젝트 학습

### 타임라인

- 05/31(Mon)
  - 강의) Core Data, Database
  - API 모델 타입 구현, Unit Test 공부
- 06/01(Tues)
  - Mock Data 만들기 및 활용 방법
  - JSON Parse 공부
- 06/02(Wed)
  - Unit Test
- 06/03(Thur)~04(Fri)
  - 테이블뷰 예제
  - 컬렉션뷰 예제
<br>

- 06/07(Mon)
  - 강의) Responder Chain / Touch Event
  - [네트워킹 테스트-우아한형제들](https://woowabros.github.io/swift/2020/12/20/ios-networking-and-testing.html)
- 06/08(Tues)
  - WWDC 2021 Keynote 02:00~04:00
- 06/09(Thur)
  - 강의) iOS File System

<br>

- 06/13(Mon)
  - 테이블뷰 UI
  - 컬렉션뷰 UI
- 06/14(Tues)
  - 강의) UIView Animation
  - URLSession dataTask
- 06/17(Thur)
  - 강의) Understanding Swift Performance
- 06/18(Fri)
  - NumberFormatter 적용
  - strikeThrough 적용
- 06/21(Mon)
  - UIActivityIndicatorView 
  - [매직넘버 뜻](https://namu.wiki/w/%EB%A7%A4%EC%A7%81%EB%84%98%EB%B2%84)
  
<br>

### 학습키워드
- API 문서 보는 방법
- Unit Test
  - Mock Data
- JSON Parse
- TableView + xib
- CollecionView + xib
- strikeThrough(취소선)
- NumberFormatter(세자리마다 콤마)
- URLSession

<br>

### 트러블슈팅 (Troubleshooting)
1. Type `ItemModification` does not conform to protocol `Decodable`
    - API 모델 타입 구현 시, `CodingKey` 를 통해 case를 재정의 할때 선언된 변수명과 일치하는지 확인해야한다.
    - 스펠링 오타로 인해 발생한 오류! 대충 보았을 때 왜 틀린지 알기 어려웠다.처음엔 프로토콜을 잘못 채택했다고 생각.
2. XCTAssertEqual failed
    - decoding한 data와 비교하는 객체의 값이 일치하지 않음. 이스케이프 문자 `\`로 인한 오류
    - 코드에서 json 문자열 안에 `\n`을 넣었을 때 된다면 `\`는 코드에서 문자열이 아닌 다른 내용을 구분하기 위해 사용되는 특별한 문자이기 때문에, 진짜 `\n`을 입력하려면 `\\n` 이라고 써줘야 한다. 참고로, 스위프트에서는 아래와 같이 문자열을 `#`으로 감싸면 `\\` 처리를 안해줘도 된다.
3. Thread 1:EXC_BAD_INSTRUCTION (code=EXC_I386_INVOP, subcode=0x0)
    - 강제추출하는 경우 나타나는 오류라고 나왔는데, 초록색 혹은 빨간색으로 경고가 나왔다. 나의 경우 테스트 클래스 이름을 `OpenMarketTests`에서 `OpenMarketTest`로 바꾸니 해결되었다. 뭐지?
4. Thread 1: "-[OpenMarket.ViewController ChangeViewBySegmentedControl:]: unrecognized selector sent to instance 0x7fc180404da0"
    - `@IBAction` 연결이 끊겨있어 다시 해주니 되었다.
5. Thread 1: "invalid nib registered for identifier (CustomCollectionViewCell) - nib must contain exactly one top level object which must be a UITableViewCell instance"
    - cell을 만들 때 collecionViewCell인데 tableView로 설정해서 생긴 오류
6. Thread 1: "could not dequeue a view of kind: UICollectionElementKindCell  identifier CustomCollectionViewCell - must register a nib or a class for the identifier or connect a prototype cell in a storyboard"
    - xib file identifier 확인
    - nib 설정 method가 CollecionViewCell이어도 tableView에 register되어 생긴 오류. 이거 찾는데 한세월
7. Thread 1: "[<OpenMarket.CustomCollectionViewCell 0x7f9acf311080> setValue:forUndefinedKey:]: this class is not key value coding-compliant for the key Label."
    - @IBOutlet이 제대로 연결되어 있지 않아 발생한 오류
8. OpenMarket[22849:170090] [] nw_protocol_get_quic_image_block_invoke dlopen libquic failed
    -  앱 실행과는 관계없는 오류?
9. CollectionViewCell - xib에서 제약을 주어도 오류가 남
    - 알고보니 내가 contentView를 지워서 그런 것이었다...
10. Cannot override 'strong' property with 'weak' property
    - [UITableViewCell has a member variable named imageView. You can change the name.](https://ddcode.net/2019/04/16/cannot-override-strong-property-with-weak-property/)
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
- [[블로그] iOS Networking and Testing - 우아한형제들](https://woowabros.github.io/swift/2020/12/20/ios-networking-and-testing.html)
  
JSON, Codable(Encodable, Decodable)
- [Swift ) 왕초보를 위한 Codable / JSON Encoding and Decoding - Zedd](https://zeddios.tistory.com/373)
- [왕초보를 위한 JSON Parsing - 1 (JSON이란?) - Zedd](https://zeddios.tistory.com/90)
- [[블로그] 이스케이프 문자의 JSON Parse 오류에 대해 알아봅니다.](https://falsy.me/%EC%9D%B4%EC%8A%A4%EC%BC%80%EC%9D%B4%ED%94%84-%EB%AC%B8%EC%9E%90%EC%9D%98-json-parse-%EC%98%A4%EB%A5%98%EC%97%90-%EB%8C%80%ED%95%B4-%EC%95%8C%EC%95%84%EB%B4%85%EB%8B%88%EB%8B%A4/)
  
URLSession
- [[공식 프로그래밍 가이드] URL Loading System](https://developer.apple.com/documentation/foundation/url_loading_system)
- [[레퍼런스] URLSession](https://developer.apple.com/documentation/foundation/urlsession)
- [[웹사이트] Postman](https://www.postman.com/)
- [[레퍼런스] HTTP Request Methods](https://developer.mozilla.org/ko/docs/Web/HTTP/Methods)

CollectionView
- [[유투브] 취준생을 위한 아이폰 앱개발 콜렉션뷰 콤포지셔널 레이아웃 fundamental Tutorial (2020) ios collectionView compositional layout](https://www.youtube.com/watch?v=kJMIx0GWYIw&t=398s)
  
NumberFormatter
- [[블로그] iOS에서 세 자리수 마다 콤마(,) 넣기 - 까칠코더](https://kka7.tistory.com/44)
  
strikeThrough
- ([[블로그] [iOS - swift] String에 strikeThrough 적용 (AttributedString)](https://ios-development.tistory.com/238))
  
UIActivityIndicatorView
- [[developer.apple - UIActivityIndicatorView]](https://developer.apple.com/documentation/uikit/uiactivityindicatorview)
- [[블로그]Activity Indicator iOS Tutorial](https://www.ioscreator.com/tutorials/activity-indicator-ios-tutorial-)
- [[블로그] iOS ) NavigationBar - Zedd](https://zeddios.tistory.com/574)
  
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
첫번째 시도
- Mock Data 파일로 decoding 하고, 같은 정보를 가진 가짜 객체를 만들어 XCTAssertEqual로 비교   

두번째 시도
- [iOS Networking and Testing](https://woowabros.github.io/swift/2020/12/20/ios-networking-and-testing.html)를 참고하여 URLSessionProtocol을 만들어봄.

<br>

# Step2
![화면 기록 2021-06-19 오전 12 29 59](https://user-images.githubusercontent.com/65153742/122584973-ee33aa80-d095-11eb-8eb2-57d08c8fb06b.gif)
### 구현 기능
- SegmentedControl을 통한 보기모드 변경
- discountedPrice 취소선 적용
- 상품 정보 표시
- 로드 중임을 표시 ❌
- 상품 등록 버튼 ❌
