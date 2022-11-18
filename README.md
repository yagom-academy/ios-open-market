# 오픈마켓 🏬

## 📖 목차

1. [소개](#-소개)
2. [프로젝트 구조](#-프로젝트-구조)
3. [구현 내용](#-구현-내용)
4. [타임라인](#-타임라인)
5. [실행 화면](#-실행-화면)
6. [트러블 슈팅 & 어려웠던 점](#-트러블-슈팅--어려웠던-점)
7. [참고 링크](#-참고-링크)

## 😁 소개

[stone](https://github.com/lws2269), [로빈](https://github.com/yuvinrho)의 오픈마켓 프로젝트 앱입니다.

- KeyWords
    - JSONParse
    - URLSession
    - CodingKeys프로토콜 활용
    - Unit Test를 통한 설계 검증
        - Test Double - Stub
## 🛠 프로젝트 구조

### 📊 UML
### STEP2 구현 이후 추가예정입니다.


### 🌲 Tree
```
.
├── OpenMarket/
│   ├── Models/
│   │   ├── Item.swift
│   │   ├── ItemList.swfit
│   │   └── Currency.swift
│   ├── Views/
│   │   ├── Main.storyboard
│   │   └── LaunchScreen.storyboard  
│   ├── Controllers/
│   │   └── ViewControllers.swift
│   ├── Resource/
│   │   └── Assets.xcassets
│   ├── Network/
│   │   ├── NetworkManager.swift
│   │   ├── NetworkError.swift
│   │   └── Mock/
│   │       ├── StubURLSession.swift
│   │       └── URLSessionProtocol.swift
│   ├── AppDelegate.swift
│   ├── SceneDelegate.swift
│   └── info.plist
├── ParsingTests/
│   └── ParsingTests.swift
├── NetworkingTets/
│   └── NetworkingTets.swift
└── MockTests/
    └── MockTests.swift
```
## 📌 구현 내용
### Model
- **Item**, **ItemList**
    - `URLSession`을 통해 서버에서 데이터를 받을 때, JSON데이터에 따라 설계된 모델
- **Currency**
    - `Item`모델의 currency타입에 맞는 화폐단위의 `enum`타입

### Network
### NetworkManager
```swift
func checkAPIHealth(completion: @escaping (Bool) -> Void)
```
- `NetworkManager`가 가지고 있는 `baseURL`이 정상상태인지 매개변수로 `completion`을 통하여 Bool 값을 전달하는 함수입니다.
    - 서버가 정상상태라면 true, 연결할 수 없다면 false를 전달합니다.
```swift
func fetchItemList(pageNo: Int, pageCount: Int, 
              completion: @escaping (Result<ItemList, NetworkError>) -> Void)
```
- `GET`요청에 보낼 파라미터 `pageNo`, `pageCount` 두 값을 받아 서버에서 `ItemList` 값을 받아오면 `completion`을 통해 데이터를 전달하는 함수입니다.
    - 네트워크 통신시 `error`, 200번 대를 제외한 `statusCode`, `JSONDecode` 실패시 그에 맞는 NetworkError타입의 에러를 `completion`을 통해 전달합니다.
```swift
func fetchItem(productId: Int, 
          completion: @escaping (Result<Item, NetworkError>) -> ())
```
- `GET`요청에 보낼 파라미터 `productId` 값을 받아 서버에서 `Item` 값을 받아오면 `completion`을 통해 데이터를 전달하는 함수입니다.
    - 네트워크 통신시 `error`, 200번 대를 제외한 `statusCode`, `JSONDecode` 실패시 그에 맞는 NetworkError타입의 에러를 `completion`을 통해 전달합니다.

### NetworkError
- DataSessionTask 에서 전달한 Error확인을 위한 enum 타입


## 📱 실행 화면
### STEP2 구현 이후 추가예정입니다.

## ⏰ 타임라인


<details>
<summary>Step1 타임라인</summary>
<div markdown="1">       

- **2022.11.15**
    - `Item`, `ItemsList` 모델 타입 정의  
    - Json파일을 모델 타입에 맞게 파싱 및 테스트코드 작성
    - `NetworkingManager`, `NetworkError` 타입 정의
    - 서버에서 데이터 가져오는 메서드 구현
    - Networking 테스트코드 작성
    
- **2022.11.16**
    - `URLSessionProtocol` 정의
    - `StubURLSession` 정의
    - 네트워크 Mock 테스트 작성
    - 코드, 네이밍, 프로젝트 디렉토리 구조 수정
    - Step1 PR 작성
    
    
- **2022.11.17**
    - 네이밍, 코드 컨벤션 수정
    - Step1 Merged
    
</div>
</details>


## ❓ 트러블 슈팅 & 어려웠던 점

### 샘플 Json데이터와 서버에서 받아온 Json데이터가 다른 문제
- 샘플 json데이터를 이용해 모델타입으로 파싱은 성공했으나, 서버에서 json데이터를 받아올 때 파싱이 안되는 문제가 있었습니다.

**샘플 데이터**
```json
{
  "page_no": 1,
  "items_per_page": 20,
  "total_count": 10,
  "offset": 0,
  "limit": 20,
  "last_page": 1,
  "has_next": false,
  "has_prev": false,
  "pages": [
    {
      "id": 20,
      "vendor_id": 3,
      "name": "Test Product",
      "thumbnail": "https://s3.ap-northeast-2.amazonaws.com/media.yagom-academy.kr/training-resources/3/thumb/5a0cd56b6d3411ecabfa97fd953cf965.jpg",
      "currency": "KRW",
      "price": 0,
      "bargain_price": 0,
      "discounted_price": 0,
      "stock": 0,
      "created_at": "2022-01-04T00:00:00.00",
      "issued_at": "2022-01-04T00:00:00.00"
    }
  ]
}
```
**실제통신시 데이터**
```json
{
  "pageNo": 1,
  "itemsPerPage": 1,
  "totalCount": 113,
  "offset": 0,
  "limit": 1,
  "lastPage": 113,
  "hasNext": true,
  "hasPrev": false,
  "pages": [
    {
      "id": 193,
      "vendor_id": 29,
      "vendorName": "wongbing",
      "name": "테스트",
      "description": "Post테스트용",
      "thumbnail": "https://s3.ap-northeast-2.amazonaws.com/media.yagom-academy.kr/training-resources/29/20221115/2e4728b864ef11eda917ff060c8f69d7_thumb.png",
      "currency": "KRW",
      "price": 1200.0,
      "bargain_price": 1200.0,
      "discounted_price": 0.0,
      "stock": 3,
      "created_at": "2022-11-15T00:00:00",
      "issued_at": "2022-11-15T00:00:00"
    }
  ]
}
```
#### 해결방안
- 샘플 JSON 데이터의 page_no, items_per_page, total_count와 같이 Snake case로 정의되어 있는 부분을 Codingkeys프로토콜을 사용해 Camel case로 매핑했었는데, 해당 매핑하는 부분을 지움으로써 모델의 프로퍼티 네이밍과 통신시 데이터 네이밍을 동일하게하여 해결했습니다.


---


## 📖 참고 링크

### 공식문서
[Swift Language Guide - Closures](https://docs.swift.org/swift-book/LanguageGuide/Closures.html)



---

[🔝 맨 위로 이동하기](#오픈마켓-🏬)
