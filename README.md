# 오픈 마켓

## 프로젝트 저장소
> 프로젝트 기간: 2022-07-11 ~ 2022-07-22</br>
> 팀원: [바드](https://github.com/bar-d), [그루트](https://github.com/Groot-94)</br>
리뷰어: [@Charlie](https://github.com/kcharliek)</br>
그라운드롤: [GroundRule - Wiki](https://github.com/bar-d/ios-open-market/wiki/Ground-Rules)

## 📑 목차
- [개발자 소개](#개발자-소개)
- [프로젝트 소개](#프로젝트-소개)
- [UML](#UML)
- [폴더 구조](#폴더-구조)
- [구현내용](#구현내용)
- [키워드](#키워드)
- [참고문서](#참고문서)
- [핵심경험](#핵심경험)
- [기능설명](#기능설명)
- [TroubleShooting - Wiki](https://github.com/bar-d/ios-open-market/wiki/TroubleShooting)
- [1️⃣ Step1 - Wiki](https://github.com/bar-d/ios-open-market/wiki/Step1)
- [2️⃣ Step2 - Wiki](https://github.com/bar-d/ios-open-market/wiki/Step2)
## 개발자 소개
|바드|그루트|
|:---:|:---:|
| <img src = "https://i.imgur.com/k9hX1UH.png" width="250" height="250">| <img src = "https://i.imgur.com/Cxc3e7j.jpg" width="250" height="250"> |
|[바드](https://github.com/bar-d)|[그루트](https://github.com/Groot-94)|


## 프로젝트 소개
- REST_API를 이용하여 서버와 통신하여 Data를 관리하는 오픈 마켓 프로젝트
    
## UML  
### [ClassDiagram]
![](https://i.imgur.com/tUyiMcO.png)

## 폴더 구조
```
  ├── OpenMarket
  │   ├── Model
  │   │   ├── Error
  │   │   │   ├── CodableError.swift
  │   │   │   ├── DataError.swift
  │   │   │   └── NetworkError.swift
  │   │   ├── JSONModel
  │   │   │   ├── Currency.swift
  │   │   │   ├── ProductDetail.swift
  │   │   │   ├── ProductImage.swift
  │   │   │   ├── ProductsDetailList.swift
  │   │   │   ├── ProductsList.swift
  │   │   │   ├── RegisterationProduct.swift
  │   │   │   └── SecretProducts.swift
  │   │   └── Network
  │   │       ├── APIRequest.swift
  │   │       ├── MyURLSession.swift
  │   │       └── SessionProtocol.swift
  │   ├── View
  │   │    ├── LaunchScreen.storyboard
  │   │    └── Main.storyboard              
  │   ├── Controller
  │   │    └── ViewController   
  │   ├── Resources
  │   │    ├── AppDelegate.swift
  │   │    ├── Assets.xcassets
  │   │    ├── Info.plist
  │   │    └── SceneDelegate.swift
  │   ├── TestDouble
  │   │   └── MockSession.swift
  │   │
  │   └── OpenMarketTests
  │       ├── ParsingTests.swift
  │       └── RequestTests.swift
  └── README.md
```


## 구현내용  
<!-- ||||
|:---:|:---:|:---:|
|<img src = "" width="200" height="500">    |<img src = "" width="200" height="500">|<img src = "" width="200" height="500">| -->
## 키워드
- JSON Decoder
- URLSession
- MockSession
- Unit Test
- Asynchronous Tests
## 참고문서
- [URLSession](https://developer.apple.com/documentation/foundation/urlsession)
    - [Fetching Website Data into Memory](https://developer.apple.com/documentation/foundation/url_loading_system/fetching_website_data_into_memory)
- [UICollectionView](https://developer.apple.com/documentation/uikit/uicollectionview)
    - [Modern cell configuration](https://developer.apple.com/videos/play/wwdc2020/10027/)
    - [Lists in UICollectionView](https://developer.apple.com/videos/play/wwdc2020/10026)
    - [Implementing Modern Collection Views](https://developer.apple.com/documentation/uikit/views_and_controls/collection_views/implementing_modern_collection_views)
## 핵심경험
- 프로토콜을 이용하여 네트워크 구성을 파악하고 추상화 하는 경험을 할 수 있었다.
- 네트워크가 없는 상황에서 Unit Test를 위하여 MockSession Test 구현해서 테스트하는 경험을 할 수 있었다.
- URLSession을 위한 MyURLsession을 구현해서 실제 서버와의 통신을 통해 데이터를 받아오는 경험을 할 수 있었다.
- JSONParsing을 통해 JSON 파일을 데이터로 불러오는 경험을 할 수 있엇다.
## 기능설명
### Network
- **`네트워크 통신을 하는데 필요한 타입들 구현`**
    - APIRequest
    - MyURLSession
    - SessionProtocol


### JSONModel
- **`Json Data decoding, encoding을 위한 타입들 구현`**
    - Currency
    - ProductDetail
    - ProductImage
    - ProductsDetailList
    - ProductsList
    - RegistrationProduct
    - SecretProducts

### Error
- **`Error 처리를 하기 위해 각 타입별로 Error 타입들 구현`**
    - CodableError
    - DataError
    - NetworkError


### TestDouble
- **`URLSession 테스트를 하기위한 MockSession 타입 구현`**
    - MockSession

### OpenMarketTests
- **`OpenMarket 모듈들의 Unit Test를 위한 타입 구현`**
    - ParsingTests
    - RequestTests
