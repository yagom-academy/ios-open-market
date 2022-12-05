# 오픈마켓 Ⅱ


# README DAY
# 🏦iOS Open Market Ⅱ🏦

## 🗒︎목차
1. [소개](#-소개)
2. [개발환경 및 라이브러리](#-개발환경-및-라이브러리)
3. [팀원](#-팀원)
4. [타임라인](#-타임라인)
5. [파일구조](#-파일구조)
6. [UML](#-UML)
7. [실행화면](#-실행-화면)
8. [트러블 슈팅 및 고민](#-트러블-슈팅-및-고민)
9. [참고링크](#-참고-링크)


## 👋 소개
[Aaron](https://github.com/hashswim), [Jpush](https://github.com/jjpush)의 오픈마켓 어플리케이션


## 💻 개발환경 및 라이브러리
[![swift](https://img.shields.io/badge/swift-5.6-orange)]()
[![xcode](https://img.shields.io/badge/Xcode-14.1.1-blue)]()


## 🧑 팀원
|<img src = "https://i.imgur.com/I8UdM0C.png" width=200 height=170>|<img src = "https://i.imgur.com/0T2iLVJ.jpg" width=200 height=170> 
|:--:|:--:|
|[Aaron](https://github.com/hashswim)|[Jpush](https://github.com/jjpush)|


## 🕖 타임라인

### Open market Ⅰ
#### STEP1
- ProductsList, Product 타입 구현
- JSON 파싱 UnitTest 작성
- NetworkManager 타입 구현
- completionHandler 비동기 처리
- HTTP GET 메서드 구현

#### STEP2
- NavigationContoller 생성
- segmentedControl 생성
- ListCell, GridCell 생성
- 각 셀의 DiffableDataSource (iOS 13)
    - snapshot 
- compositionallayout 적용 (iOS 14)
- autoLayout 적용

### Open market Ⅱ
#### STEP 1
- HTTP POST, PATCH 메서드 구현
- 상품 등록 화면 UI 구성
- `UIImagePickerController`를 활용해 이미지 업로드 구현




## 💾 파일구조
```
└── OpenMarket
    ├── AppDelegate
    ├── SceneDelegate
    ├── MainViewContorller
    ├── AddProductViewContorller
    ├── Constant
    ├── CollectionView
    │   ├── Grid
    │   │   └── GridCell.swift
    │   └── List
    │       └── ListCell.swift
    │
    ├── Network
    │   ├── NetworkManager
    │   ├── JSONParser
    │   └── RequestType
    │
    ├── Product
    │   ├── Image
    │   ├── ProductLIst
    │   ├── Product
    │   └── Vendor
    └── ParsingTests
        └── ParsingTests
    
    
```

## 📊 UML
> ![](https://i.imgur.com/Xx85tpm.jpg)


## 💻 실행 화면


|상품 리스트|상품 사진 선택|상품 등록|
|:--:|:--:|:--:|
|<img src = "https://i.imgur.com/R8ajVX9.gif" width=280 height=450>|<img src = "https://i.imgur.com/R8ajVX9.gif" width=280 height=450>|<img src = "https://i.imgur.com/CXurSX5.gif" width=280 height=450>|






## 🎯 트러블 슈팅 및 고민

### fetch() 메서드의 네트워크 비동기 처리에 대한 고민. 
URLsession의 dataTask를 생성 resume 메서드를 실행하고 반환값을 받으면 비동기적으로 처리되어 `ViewController`에서 반영되지 않는 부분에 대해서 고민을 했습니다.
해당 부분에 대해서는 컴플리션 핸들러를 `escaping`을 통해 사용하는 방법과 `withoutActuallyEscaping` 메서드를 사용하는 방법중 `escaping` 을 사용하는 방법으로 해결했습니다. 

```swift!
func fetch(type: requestType, completion: @escaping (completionable) -> Void) {
        ...
        
        switch type {
        case .healthChecker:
            getHealthChecker(url) { statusCode in
                completion(statusCode)
            }
        case .searchProductList(_, _):
            getProductsList(url) { productsList in
                completion(productsList)
            }
        case .searchProductDetail(_):
            getProductDetail(url) { product in
                completion(product)
            }
        }
    }
```
```swift!
func getHealthChecker(_ url: URL, completion: @escaping (Int) -> Void) {
    let dataTask = URLSession.shared.dataTask(with: url) { data, response, error in
        ...
    }
    dataTask.resume()
}
```

### Completionable 프로토콜에 대한 고민

구현을 하는 방법을 생각해 보았습니다.
1. 각 작업별로 메서드를 구현한다.
2. completion의 파라미터로 작업에 대한 데이터를 받는다.

여기서 저희는 2번을 경험해 보고 싶어서 fetch메서드에 어떤 작업이 들어와도 유연하게 대응할 수 있도록 completion에 실행할 파라미터를 넣어주었습니다.

```swift
func fetch(작업, completion: (작업타입) -> Void) {
    switch 작업 {
    case 1작업:
        1작업() { completion(1작업타입) }
    case 2작업:
        2작업() { completion(2작업타입) }
    case 3작업:
        3작업() { completion(3작업타입) }
    }
}
```

작업1은 Int
작업2는 ProductsList
작업3은 Product

를 반환하고 있기 때문에

completionable이라는 프로토콜을 만들어 각 타입에 채택해 준 후 값을 사용할 때 풀어서 사용하도록 했습니다.

```swift
networkManager.fetch(type: 작업) { result in
            // 1. int일 경우
            if let result = result as? Int { 
                print(result)
            // 2. ProductsList일 경우
            } else if let result = result as? ProductsList { 
                print(result)
            // 3. Product일 경우
            } else if let result = result as? Product { 
                print(result)
            }
        }
```

하지만 이런 방법은 fetch 메서드를 사용할 때 마다 `if let`의 사용이 불가피 하다는 치명적인 단점이 있어서 메서드를 따로 만드는 1번 방법으로 구현 했습니다.

### 뷰의 형태가 잘 나타나지 않는 문제

|해결 전| 해결 후|
|:--:|:--:|
|<img src="https://i.imgur.com/jMHEcJ0.jpg" width=350/>|<img src="https://i.imgur.com/YAoIU9D.png" width=370/>|


셀을 처음 불러올 때 오토레이아웃이 깨지고 재사용될 때에도 뷰의 높이를 잡지못하는 문제가 있었습니다. 셀의 높이를 지정할 때 직접 지정해주지 않고 컨트롤러가 자동으로 계산해서 지정할 수 있도록 `estimated()` 사이즈를 지정해주었는데 이부분에서 생긴 문제였습니다.

`estimated`의 의미를 생각하며 추정할 수 있도록 이미지의 높이와 레이블의 높이를 더해주어 추정값을 넣어주어 해결했습니다.

### HTTP POST 메서드 작업 시 
이미지를 `Data` 타입으로 변환 후 `append`시 크기가 너무 커서 nil로 표시되는 문제
```swift!
extension NetworkManager {
    func postProductLists(params: Product, images: [UIImage], completion: @escaping () -> Void) {
        ...
        
        var data = Data()
        
        do {
            ...
            data.append(image.pngData()!)
            //string 변환 시 nil 출력
            print(String(data: data, encoding: .utf8)!)
                
            ...
        } catch {
            print(error)
        }
    }
}
```
함께 고민하다가 
테스트 진행 시 임의로 `UIImage`로 변환하여 하나하나 확인해 보는 방법으로 테스트를 진행했습니다.

### Cache를 사용시 같은 값을 불러 와 업데이트가 되지 않음
```swift!
let cache: URLCache = {
        let cache = URLCache.shared
        cache.memoryCapacity = 0
        cache.diskCapacity = 0
        return cache
    }()
```
cache의 저장 용량을 0으로 해서 매번 업데이트 하도록 진행했습니다.
이후 수정해 캐시를 활용해 볼 생각입니다.

## 📚 참고 링크

[URLSession](https://developer.apple.com/documentation/foundation/urlsession)
[Fetching Website Data into Memory](https://developer.apple.com/documentation/foundation/url_loading_system/fetching_website_data_into_memory)
[CollectionView]()
[CollectionViewDiffableDataSource](https://developer.apple.com/documentation/uikit/uicollectionviewdiffabledatasource)
[CollectionViewCompositionallayout](https://developer.apple.com/documentation/uikit/uicollectionviewcompositionallayout)

----

## 💻 개발환경 및 라이브러리
[![swift](https://img.shields.io/badge/swift-5.6-orange)]()
[![xcode](https://img.shields.io/badge/Xcode-13.4.1-blue)]()
  
