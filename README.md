# 오픈마켓

## 프로젝트 소개
오픈마켓을 창설하여 상품을 관리해본다.

> 프로젝트 기간: 2022-07-11 ~ 2022-07-22</br>
> 팀원: [수꿍](https://github.com/Jeon-Minsu), [케이](https://github.com/KayAhnDS), [데릭](https://github.com/derrickkim0109) </br>
리뷰어: [제이슨](https://github.com/ehgud0670)</br>
그라운드롤: [GroundRule](https://github.com/Jeon-Minsu/ios-open-market/blob/STEP01/Docs/GroundRule.md)

## 📑 목차

- [🧑🏻‍💻🧑🏻‍💻 개발자 소개](#-개발자-소개)
- [💡 키워드](#-키워드)
- [🤔 핵심경험](#-핵심경험)
- [📱 실행 화면](#-실행-화면)
- [🗂 폴더 구조](#-폴더-구조)
- [📝 기능설명](#-기능설명)
- [🚀 TroubleShooting](#-TroubleShooting)
- [📚 참고문서](#-참고문서)
- [1️⃣ STEP 1](https://github.com/Jeon-Minsu/ios-open-market/blob/STEP01/Docs/Step01.md)
- [2️⃣ STEP 2](https://github.com/Jeon-Minsu/ios-open-market/blob/STEP02/Docs/Step02.md)


## 🧑🏻‍💻🧑🏻‍💻 개발자 소개

|케이|수꿍|데릭|
|:---:|:---:|:---:|
|<image src = "https://user-images.githubusercontent.com/99063327/178641788-995112c1-924a-4768-b46b-c9bf3a04a994.jpeg" width="250" height="250">| <image src = "https://i.imgur.com/6HkYdmp.png" width="250" height="250">|<image src = "https://avatars.githubusercontent.com/u/59466342?v=4" width="250" height="250">
|[케이](https://github.com/KayAhnDS)|[수꿍](https://github.com/Jeon-Minsu)|[데릭](https://github.com/derrickkim0109)|

## 💡 키워드

- `POP`, `protocol`, `extension`
- `URL`, `URLSession`, `URLDataTask`
- `dataTask`, `completion` 
- `Data`
- `URLResponse`, `HTTPURLResponse`, `statusCode`
- `Error`
- `resume`
- `Result Type`, `escaping closure`
- `JSONDecoder`
- `Generics`
- `Codable`, `CodingKeys`
- `Server Mapping Model`, `Entity`, `ViewModel`, `Hashable`
- `String`, `NSAttributedString`, `strikethroughStyle`
- `Int`, `NumberFormatter`
- `UISegmentedControl`, `addTarget`, `selectedSegmentIndex`
- `UICollectionView`, `UICollectionViewDiffableDataSource`
- `UICollectionViewCompositionalLayout`, `NSCollectionLayoutSize`, `NSCollectionLayoutItem`, `NSCollectionLayoutGroup`, `NSCollectionLayoutSection`
- `CellRegistration`, `dequeueConfiguredReusableCell`
- `layer`, `borderColor`, `borderWidth`, `cornerRadius`
- `NSDiffableDataSourceSnapshot`, `appendSections`, `appendItems`, `apply`
- `AutoLayout`, `prepareForReuse`

    
## 🤔 핵심경험
    
- [x] 파싱한 JSON 데이터와 매핑할 모델 설계
- [x] URL Session을 활용한 서버와의 통신
- [x] CodingKeys 프로토콜의 활용
- [x] 네트워크 상황과 무관한 네트워킹 데이터 타입의 단위 테스트(Unit Test)
- [x] Safe Area을 고려한 오토 레이아웃 구현
- [x] Collection View의 활용
- [x] Mordern Collection View 활용

## 📱 실행 화면(기능 설명)

|메인 화면(List)|메인 화면(Grid)|
|:--:|:--:|
|![초기화면 스크롤](https://user-images.githubusercontent.com/99063327/180361852-320b164c-8b3d-4cd7-b088-86179e295aa9.gif)|![그리드화면 스크롤](https://user-images.githubusercontent.com/99063327/180361837-60da3f9c-3717-4f5c-b393-71c658b69298.gif)|
|오픈 마켓의 상품 목록을 List 화면으로 표시|오픈 마켓의 상품 목록을 Grid 화면으로 표시|

    
## 🗂 폴더 구조

```
└── OpenMarket
    ├── OpenMarket
    │   ├── Extension
    │   │   ├── String+Extensions.swift
    │   │   └── Int+Extensions.swift
    │   ├── Application
    │   │   ├── AppDelegate.swift
    │   │   ├── SceneDelegate.swift
    │   │   ├── Presentation
    │   │   │   ├── View
    │   │   │   │   ├── GridCollectionCell.swift
    │   │   │   │   └── ListCollectionCell.swift
    │   │   │   └── ViewController
    │   │   │       └── MarketProductsViewController.swift
    │   │   └── Domain
    │   │       └── Model
    │   │           ├── ProductList.swift
    │   │           ├── Product.swift
    │   │           └── ProductEntity.swift
    │   ├── Networking
    │   │   ├── Protocol
    │   │   │   ├── URLSessionProtocol.swift
    │   │   │   └── URLSessionDataTaskProtocol.swift
    │   │   ├── NetworkProvider.swift
    │   │   └── NetworkError.swift
    │   └── Resource
    │       ├── Info
    │       ├── Assets
    │       └── LaunchScreen
    ├── Mock
    │   ├── MockURLSession.swift
    │   ├── MockURLSessionDataTask.swift
    │   └── Mock.json
    └── MockTests
        └── MockTests.swift
```

## 📝 기능설명
    
### 네트워크 통신을 담당할 타입을 설계하고 구현
    - ProductList, Product
        - 서버 API 데이터 형식을 고려하여 모델 타입 구현
    - NetworkProvider
        - 서버로부터 데이터를 받아오는 기능을 수행
        - 기능을 수행한 위한 protocol, extension 별도 생성
    - NetworkError
        - 서버로부터 데이터를 받아오는 도중 발생하는 에러 표현

### CollectionView Cell을 각 Layout 별로 분리하여 구현 
    - GridCollectionCell, ListCollectionCell
        - CollectionView의 Cell 타입 구현 
    - ProductEntity
        - 서버 매핑 타입 중 Cell에 필요한 타입들 별도 구현
    
### Utilities 
    - String+Extensions
        - String 자료형을 확장시켜 필요 메서드 관리
            * strikeThrough - 해당 문자열의 처음부터 입력 받은 수의 인덱스까지 strikethroughStyle 적용.
    - Int+Extensions
        - Int 자료형을 확장시켜 필요 메서드 관리
            * numberFormatter - 10진수로 변환하고 String 타입으로 변환 후 반환

## 🚀 TroubleShooting
    
### STEP 2

#### T1. AutoLayout
    
- 하나의 Cell을 통하여 List에서 Grid로의 AutoLayout을 설정하기 위해 이전에 설정된 List Layout의 Constraints을 제거한 후, Grid의 Constraints를 설정하려 하였으나, 이미 Cell이 생성된 이후에 Constraint를 제거하기 위한 시도를 하기 때문에 오토레이아웃이 정상적으로 설정되지 않는 문제가 발생되었습니다. 이에 notification 등을 통해 알림을 바탕으로 해결할 수 있을까도 고민해보았으나, 해당 방법은 오히려 과하다고 판단하여, 위의 문제를 해결하기 위하여 list, grid 레이아웃을 위한 각각의 셀을 만든 다음, 서로 다른 오토레이아웃을 적용해 문제를 해결하였습니다.

#### T2. Server Mapping Model - Entity - ViewModel
    
- 서버로부터 데이터를 요청하여, 이에 대한 응답을 받은 다음, 이를 JSON 데이터 형식으로 변환하여, 해당 데이터를 저장하고, 관리되어야 하는 데이터의 집합을 만들 필요성을 느꼈습니다. 이에, 서버로부터 데이터를 요청하는 부분은 NetworkProvider 인스턴스를 생성하여 URL을 입력받아 requestAndDecode 메서드를 실행하였습니다. 다음으로, 응답을 받은 다음, 이를 JSON 데이터 형식으로 변환하는 부분은 서버로부터의 응답을 바탕으로 성공, 실패 케이스를 분기하여, 서버로부터 성공적으로 응답을 받을시, STEP1에서 구현한 서버 매핑 모델인 ProductList 구조체에 담은 다음, 실제 필요한 데이터를 추출하여 저장 및 관리하기 위해 ProductEntity 구조체를 생성하여 이를 처리하였습니다. 위의 방법들을 통하여 '서버 매핑 모델 - Entity - ViewModel'의 구조를 구현하고자 하였습니다.

## 📚 참고문서

- [URLSession](https://developer.apple.com/documentation/foundation/urlsession)
    - [Fetching Website Data into Memory](https://developer.apple.com/documentation/foundation/url_loading_system/fetching_website_data_into_memory)
- [UICollectionView](https://developer.apple.com/documentation/uikit/uicollectionview)
    - [Modern cell configuration](https://developer.apple.com/videos/play/wwdc2020/10027/)
    - [Lists in UICollectionView](https://camp.yagom-academy.kr/camp/61d414e5e4081120ba7884d2/projects/62caa0aa41131548559889b6)
    - [Implementing Modern Collection Views](https://developer.apple.com/documentation/uikit/views_and_controls/collection_views/implementing_modern_collection_views)
--- 
