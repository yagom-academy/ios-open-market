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
- [STEP 1 : 네트워킹 타입 구현](#STEP-1--네트워킹-타입-구현)
    + [고민했던 것](#1-1-고민했던-것)
    + [의문점](#1-2-의문점)
    + [Trouble Shooting](#1-3-Trouble-Shooting)
    + [배운 개념](#1-4-배운-개념)
    + [PR 후 개선사항](#1-5-PR-후-개선사항)
- [STEP 2 : 상품 목록 화면 구현](#STEP-2--상품-목록-화면-구현)
    + [고민했던 것](#2-1-고민했던-것)
    + [의문점](#2-2-의문점)
    + [Trouble Shooting](#2-3-Trouble-Shooting)
    + [배운 개념](#2-4-배운-개념)
- [STEP Bouns : 로컬 캐시 구현](#STEP-Bonus--로컬-캐시-구현)
    + [고민했던 것](#3-1-고민했던-것)
    + [의문점](#3-2-의문점)
    + [Trouble Shooting](#3-3-Trouble-Shooting)
    + [배운 개념](#3-4-배운-개념)
    + [PR 후 개선사항](#3-5-PR-후-개선사항)

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
- `UICollectionView` `UICollectionViewFlowLayout`
- `Xib File`
- `UISegmentedControl`
- `UIActivityIndicatorView`
- `reloadData`
- `UIScrollViewDelegate`
- `NSCache`

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


## 1-4 배운 개념

- `multipart/form-data`
- API문서 읽는 방법
- 파싱한 JSON 데이터와 매핑할 모델 설계
    - `CodingKeys` 프로토콜의 활용
- URL Session을 활용한 서버와의 통신
    - `URLRequest`를 설정하는 방법
    - Testable한 네트워크 코드 작성하기
        - 네트워크 상황과 무관한 네트워킹 데이터 타입의 단위 테스트(Unit Test)

## 1-5 PR 후 개선사항

- 테스트 코드에 중복되는 부분을 개선
    - 빠진 주석 및 줄바꿈을 수정
- Image의 프로퍼티 네이밍을 명확하게 수정
- 하드코딩 되어있는 문자열을 따로 enum 타입으로 빼주어 개선
- 에러의 네이밍을 명확하게 개선
- Parser, Parsable의 네이밍을 JSON을 덧붙혀 명확하게 개선
- 접근제어가 붙어있지 않은 프로퍼티에 접근제어를 추가
- Address의 네이밍을 명확하게 개선 (APIAddress)

[![top](https://img.shields.io/badge/top-%23000000.svg?&amp;style=for-the-badge&amp;logo=Acclaim&amp;logoColor=white&amp;)](#오픈-마켓)


# STEP 2 : 상품 목록 화면 구현

상품목록을 볼 수 있는 화면을 구현합니다.

## 2-1 고민했던 것

- `CollectionView` 하나로 Cell 두개를 활용하여 화면을 전환하기
    - Custom Cell을 구현하고, 두개의 레이아웃을 만들어 셀만 바꿔주는 방식으로 목록화면 구성
    - `FlowLayout`을 활용하여 Cell의 레이아웃을 구성
    - 서버에서 상품 목록을 불러오는 부분과 뷰를 그리는 부분 비동기 처리 구현
- CollectionView cell 각각 xib로 구현
    - `CollectionView`의 `GridCell`, `ListCell`을 각각 xib파일을 생성하여 storyboard로 구현하였고 두개의 xib에 대한 코드는 `ProductCell` 하나의 cell로 구성
- Network를 통해 data를 가져와 `CollectionView`를 구성
    - API의 Data를 가져오기 위해 productList Search하는 `request` 생성하여 `networkManager`의 `fetch()`로 network를 진행하였고 가져온 `data`로  `collectionViewload`하였다.
        
        ```swift
        let request = networkManager.requestListSearch(page: 1, itemsPerPage: 10) else {
        ...        
        networkManager.fetch(request: request, decodingType: Products.self) { result in
            switch result {
                case .success(let products):
                   self.productList = products.pages
                   self.collectionViewLoad()
                ...
        ```
        
- `CollectionView`를 재구성하는 경우 `reloadData()` 사용
    - `SegmentControl`을 이용해 `flowlayout`을 변경하는 경우  `CollectionView`를 재구성하기 위해 reloadData를 사용하였다.
        
        ```swift
        // list -> gird, grid -> list로 변경
        @IBAction private func switchSegmentedControl(_ sender: UISegmentedControl) {
                switch sender.selectedSegmentIndex {
                case 0:
                    currentCellIdentifier = ProductCell.listIdentifier
                    collectionView.setUpListFlowLayout()
                    collectionView.scrollToTop()
                    collectionView.reloadData()
        ```
        
- alert을 이용한 `Error Handling`
    - OpenMarket app에서 발생한 error는 alert 창을 띄워 error를 나타내었다.
    - `localizedError` 프로토콜의 `errorDescription`을 이용하여 description을 정의하였고 `error.localizedDescription`으로 error Message를 출력하도록 에러처리.
- 상품등록 버튼 Segue
    - HIG를 참고하여 상품등록 버튼을 눌렀을 때 `Navigation` 형태가 아니라 `Modal`로 띄우도록 구성
    - Navigation Bar를 활용하여 취소 버튼을 구성

## 2-2 의문점

- collectionview의 flowlayout을 변경할 때 `AutoLayout 충돌 관련 경고`가 뜨는데, 해결 방법을 모르겠다.
- `SegmentControl`을 활용하여 List나 Grid를 전환할 때 생기는 약간의 딜레이의 원인을 모르겠다.

## 2-3 Trouble Shooting

### 1. Segument Control을 이용하여 화면전환 시 스크롤 위치가 정상적이지 않은 경우

![https://i.imgur.com/DRtK0Xs.gif](https://i.imgur.com/DRtK0Xs.gif)

- `상황`  FlowLayout을 활용하여 화면을 전환할 때, 스크롤이 상단에 위치하는게 아니라 제멋대로인 위치에 가있는 현상이 발생했다.
- `이유` 레이아웃이 서로 다르기 때문에 스크롤의 좌표도 다른 것으로 추측이 되었다.
- `해결` 따라서 이 부분을 화면을 전환할 때 스크롤의 위치를 상단에 위치하게 설정해주니 해결되었다.
    
    ```swift
    extension UIScrollView {
        func scrollToTop() {
            let topOffset = CGPoint(x: 0, y: -contentInset.top)
            setContentOffset(topOffset, animated: false)
        }
    }
    ```
    

## 2-4 배운 개념

- `UICollectionView`  `UICollectionViewFlowLayout`
- `Networking`을 통한 뷰에 대한 비동기 처리
- `reloadData`
- `Xib File`
- `UISegmentedControl`
- `UIActivityIndicatorView`

## 2-5 PR 후 개선사항

- Asset에 등록되어있는 이미지 설정값 수정
- 전반적인 네이밍 수정
- 삼항연산자로 조건문 개선
- 빠져있는 접근제어 추가
- 동적으로 레이아웃을 잡을 수 있도록 **UICollectionViewDelegateFlowLayout**을 채택
    - 가로모드, 세로모드에서도 레이아웃이 뭉개지지 않도록 개선


[![top](https://img.shields.io/badge/top-%23000000.svg?&amp;style=for-the-badge&amp;logo=Acclaim&amp;logoColor=white&amp;)](#오픈-마켓)



# STEP Bonus : 로컬 캐시 구현

서버에서 받은 데이터를 로컬에 캐시합니다.

## 3-1 고민했던 것

- `Pagination`
    - 스크롤이 하단에 가까워지면 다음 페이지를 로드하도록 구성
    - `scrollViewDidScroll()`를 이용하여 구현
- `Cache`
    - 앱이 실행하는 동안 캐시를 가지고 있을 수 있도록 싱글톤 패턴으로 ImageManager 타입을 생성
    - Cell에서 URL로 이미지를 가져오던 부분을 캐싱처리를 하도록 구성
        
        ```swift
        if let cachedImage = ImageManager.shared.loadCachedData(for: url) {
            productImageView.image = cachedImage
        } else {
            ImageManager.shared.downloadImage(with: url) { image in
            ImageManager.shared.setCacheData(of: image, for: url)
            self.productImageView.image = image
            }
        }
        ```
        

## 3-2 의문점

- 스크롤 시 yOffset을 비정상적으로 카운트가 되는 부분이 문제여서 아직 풀리지 않았는데, 해당 부분을 그냥 넘어가도 되는건지[?] 약간의 찝찝함이 남는다.

## 3-3 Trouble Shooting

### 1. 스크롤 하는 현재 위치가 비정상적으로 카운트되는 현상

- 항상 뜨는 에러는 아니고, 간헐적으로 뜨는 에러다. 스크롤을 하단까지 했을 때 디코딩에 실패하는 경우가 있습니다. 디버깅을 해보니 결과는 아래와 같다.
- ![](https://i.imgur.com/jotGTB4.png)
- ![](https://i.imgur.com/YQuHS96.png)
- ![](https://i.imgur.com/ZLAl6se.png)
- 뷰컨트롤러 쪽에서 네트워크 매니저의 `fetch` 메소드를 사용하는 쪽에서 에러가 나는 것 같은데, 네트워크에서는 `success`로 데이터를 가져오긴 했으나 조회를 해보면 데이터가 비어있는 것을 확인할 수 있었다.
- ![](https://i.imgur.com/rHL8Ebf.png)
- Response를 확인해보면 `204`코드로 응답하고 있다.
- ![](https://i.imgur.com/EiaoQJ1.png)
- 스크롤 하는 부분에 중단점을 찍고 확인해보니 `currentPage`가 `104`가 되어있는 것도 확인되었다. 저 조건문이라면 104가 될 수가 없는데.. 어느순간 스크롤을 계산하는 부분(`yOffset`)에서 에러가 발생해서 비정상적으로 currentPage가 올라가는 것 같다.

```swift
if heightRemainBottomHeight < frameHeight ,
   let page = page, page.hasNext, page.pageNumber == currentPage {
    currentPage += 1
    self.requestProducts()
}
```

- 따라서 위와 같이 조건문을 하나 더 추가해서 안전하게 currentPage를 더해줄 수 있도록 임시방편으로 수정해주었다.

## 3-4 배운 개념

- `UIScrollViewDelegate`를 이용한 `pagination` 구현
- `Cache`의 대한 개념
    - `Caching`의 범위

[![top](https://img.shields.io/badge/top-%23000000.svg?&amp;style=for-the-badge&amp;logo=Acclaim&amp;logoColor=white&amp;)](#오픈-마켓)
