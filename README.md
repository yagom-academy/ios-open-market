# 오픈 마켓 README.md

## 프로젝트 저장소
> 프로젝트 기간: 2022-07-11 ~ 2022-07-29</br>
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
-  URL Session을 활용한 서버와의 통신을 통해 전달받은 JSON 데이터와 매핑할 모델을 활용
-  Modern CollectionView를 이용해 List, Grid 방식으로 마켓의 물품을 표시하도록 구현
## UML
### [ClassDiagram]
![](https://i.imgur.com/oAYPB70.jpg)

## 폴더 구조
```
├── OpenMarket
│   ├── Controller
│   │   ├── OpenMarketViewController.swift
│   │   └── ProductRegistrationViewController.swift
│   ├── Model
│   │   ├── Data
│   │   │   ├── ImageCacheManager.swift
│   │   │   ├── OpenMarketRepository.swift
│   │   │   └── OpenMarketRequest.swift
│   │   ├── Enum
│   │   │   ├── Currency.swift
│   │   │   ├── NameSpace.swift
│   │   │   └── Section.swift
│   │   ├── Error
│   │   │   ├── CodableError.swift
│   │   │   ├── DataError.swift
│   │   │   └── NetworkError.swift
│   │   ├── Extension
│   │   │   ├── Int+extension.swift
│   │   │   └── UIView+extension.swift
│   │   ├── JSONModel
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
│   ├── Resources
│   │   ├── AppDelegate.swift
│   │   ├── Assets.xcassets
│   │   │   ├── Contents.json
│   │   │   └── MockData.dataset
│   │   │       ├── Contents.json
│   │   │       └── MockData.json
│   │   ├── Info.plist
│   │   └── SceneDelegate.swift
│   ├── TestDouble
│   │   └── MockSession.swift
│   └── View
│       ├── Base.lproj
│       │   └── LaunchScreen.storyboard
│       ├── GridCollecntionView.swift
│       ├── GridCollectionViewCell.swift
│       ├── ListCollectionView.swift
│       ├── ListCollectionViewCell.swift
│       └── ProductRegistrationView.swift
└── OpenMarketTests
    ├── ParsingTests.swift
    └── RequestTests.swift
```



## 구현내용  
|||
|:---:|:---:|
|레이아웃 변경 화면|화면 스크롤|
| <img src = "https://i.imgur.com/9OxGWib.gif" width="300" height="600">| <img src = "https://i.imgur.com/nYey8oC.gif" width="300" height="600"> |
|리스트 화면 새로고침|그리드 화면 새로고침|
| <img src = "https://i.imgur.com/1TMvjwp.gif" width="300" height="600">| <img src = "https://i.imgur.com/VRFrIcf.gif" width="300" height="600"> |
|새 상품 등록|상품 설명 키보드 내 키보드 내리는 버튼 구현|
| <img src = "https://i.imgur.com/kBW2zhO.gif" width="300" height="600">| <img src = "https://i.imgur.com/HDMGd5o.gif" width="300" height="600"> |

## 키워드
- JSON Decoder
- URLSession
- MockSession
- Unit Test
- Asynchronous Tests
- Collection View
- Mordern Collection View
- Compositional Layout
- List Configuration
- UISegmentedControl
- UIActivityIndicatorView
- UICollectionViewDiffableDataSource
- NSMutableAttributedString
- asynchronous data fetching
- UIImagePickerController
- UITextView
- UITextViewDelegate
- Keyboard
## 참고문서
- [URLSession](https://developer.apple.com/documentation/foundation/urlsession)
    - [Fetching Website Data into Memory](https://developer.apple.com/documentation/foundation/url_loading_system/fetching_website_data_into_memory)
- [UICollectionView](https://developer.apple.com/documentation/uikit/uicollectionview)
    - [Modern cell configuration](https://developer.apple.com/videos/play/wwdc2020/10027/)
    - [Lists in UICollectionView](https://developer.apple.com/videos/play/wwdc2020/10026)
    - [Implementing Modern Collection Views](https://developer.apple.com/documentation/uikit/views_and_controls/collection_views/implementing_modern_collection_views)
- [Data Entry - iOS - Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/patterns/entering-data/)
- [UIAlertController](https://developer.apple.com/documentation/uikit/uialertcontroller)
## 핵심경험
- [x] 프로토콜을 이용하여 네트워크 구성을 파악하고 추상화 하는 경험을 할 수 있었다.
- [x] 네트워크가 없는 상황에서 Unit Test를 위하여 MockSession Test 구현해서 테스트하는 경험을 할 수 있었다.
- [x] URLSession을 위한 네트워크 타입을 구현해서 실제 서버와의 통신을 통해 데이터를 받아오는 경험을 할 수 있었다.
- [x] JSONParsing을 통해 JSON 파일을 데이터로 불러오는 경험을 할 수 있었다.
- [x] Modern CollectionView를 활용하여 뷰를 구성하는 경험을 할 수 있었다.
- [x] SegmentedControl을 활용하여 뷰의 내용을 실시간으로 변경하는 경험을 할 수 있었다.
- [x] UIActivityIndicatorView를 활용하여 로딩화면을 구현하는 경험을 할 수 있었다.
- [x] UIRefreshControl을 활용하여 화면의 데이터를 변경하는 새로고침 하는 기능을 구현하는 경험을 할 수 있었다.
- [x] 데이터 비동기 처리를 통한 앱 성능 최적화 경험을 할 수 있었다.
- [x] multipart/form-data의 구조를 사용해서 POST 하여 데이터를 서버로 올리는 경험을 할 수 있었다. 
- [x] TextField, TextView의 입력하는 방식으로 키보드를 사용하는 경험을 할 수 있었다.
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
### UICollectionView
- **`데이터를 표시하는 컬렉션 뷰`**
    - Mordern Collection View 방식의 List Configuration을 활용한 List layout 컬렉션 뷰
    - Mordern Collection View 방식의 Compositional Layout 활용한 Grid layout 컬렉션 뷰
### UISegmentedControl
- **`UISegmentedControl을 통한 화면 전환`**
### UIActivityIndicatorView
- **`로딩 상태를 나타내기 위한 비동기식 뷰 구현`**
### UIRefreshControl
- **`데이터의 새로고침 기능을 구현하기 위한 UIRefreshControl 사용`**
### UIImagePickerController
- **`사진첩에서 이미지를 가져오는 기능을 구현`**

