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
    │   ├── MainViewContorller
    │   └── MainViewController+UpdateDelegate
    ├── ProductViewContorller
    │   ├── ProductViewController
    │   ├── ProductViewController+ImagePickerDelegate
    │   └── UIImage+Extension
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
|<img src = "https://i.imgur.com/R8ajVX9.gif" width=280 height=450>|<img src = "https://i.imgur.com/RCMGC5U.gif" width=280 height=450>|<img src = "https://i.imgur.com/CXurSX5.gif" width=280 height=450>|



## 🎯 트러블 슈팅 및 고민

### fetch() 메서드의 네트워크 비동기 처리에 대한 고민
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

### 상품 등록화면에서 이미지 뷰를 어떻게 처리할 지
`imagePickerController`를 사용해 등록된 이미지를 보여주는 부분에서 `scrollView`내부를 어떤 것으로 구현할 지에 대해 고민했습니다.
> <img src = "https://i.imgur.com/Swz6QmZ.png" width=450 height=230>
크게 `collectionView`와 `stackView`를 고민 하다가 `cell`의 재사용이 필요 없는 부분이라 빠른 구현과 처리를 용이하게 하기 위해 `stackView`를 사용해 이미지 추가 버튼을 담고 이미지가 추가 될 때 마다 이미지 뷰를 추가하는 방식으로 구현했습니다.
```swift!
picker.dismiss(animated: true) {
            ...
            if let img = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
                ...
                self.imageStackView.addArrangedSubview(imageView)
                
                if self.imageStackView.subviews.count == 5 {
                    self.addProductButton.isHidden = true
                    
                ...
                }
                
                ...
            } else {
                print("image nil")
            }
        }
```

### Cache를 사용시 같은 값을 불러 와 업데이트가 되지 않아서 고민
```swift!
let cache: URLCache = {
        let cache = URLCache.shared
        cache.memoryCapacity = 0
        cache.diskCapacity = 0
        return cache
    }()
```

최초 앱을 실행했을 때
`getProductsList(pageNo: 1, itemsPerPage: 40)` 를 실행하고
상품 등록 화면에서 Done 버튼을 누른 후 dissmiss 하며 상품 리스트 화면으로 돌아갈 때 
뷰를 새로 업데이트 하는 과정에서
한번 더 `getProductsList(pageNo: 1, itemsPerPage: 40)` 요청을 실행합니다.

제가 생각하기에는 이 과정에서 캐시에 똑같은 url 요청이 들어가 있어서 반환하는 것 같았습니다.
그래서 데이터의 stale을 판단해서 같은 요청이 들어오더라도 데이터가 stale 되었다면 통신을 하도록 하고 싶었습니다.

하지만 잘 해결되지 않아서 임시로 메모리와 디스크 캐시 사용량을 0으로 지정해 준 후 
캐시를 사용하지 않은 것 처럼 계속해서 통신을 하도록 해주었습니다.

stale을 체크할 수 있는 방법을 좀 더 찾아 해결할 예정입니다.

실행 화면입니다.
|capacity 10000 <br>(등록 시 새 상품이 나오지 않음)| capacity 0 <br>(등록 시 새 상품이 나옴)|
|:--:|:--:|
|![cacheCapacity10000](https://user-images.githubusercontent.com/82566116/206275376-ce4473e3-5aac-4926-98f8-c756b3511f29.gif) |![cacheCapacity0](https://user-images.githubusercontent.com/82566116/206275388-eac8bd3f-3c2c-4ded-9922-adb4fdab1328.gif)|

### priceStackView의 height가 애매모호한 점

![](https://i.imgur.com/RZ8ZfnK.png)

priceStackView 내에 
가격을 적는 부분과
통화를 정하는 segmentedControl이 들어있습니다.

priceStackView의 height를 segmentedControl에 걸어주거나
segmentedControl의 높이를 가격의 frame.height 로 지정해도 frame.height가 0 이라 지정이 되지 않았습니다.

코드 리뷰를 받아본 결과 정확한 이유는 찾을 수 없으나 segmentedControl이나 toggle 같은 뷰의 경우 
빈 뷰를 새로 만들어서 뷰에 넣어서 높이를 맞춰주어 높이를 체크하는 방법을 조언 받아 수정했습니다.


## 📚 참고 링크

[URLSession](https://developer.apple.com/documentation/foundation/urlsession)<br/>[Fetching Website Data into Memory](https://developer.apple.com/documentation/foundation/url_loading_system/fetching_website_data_into_memory)<br/>[CollectionView](https://developer.apple.com/documentation/uikit/uicollectionview)<br/>[CollectionViewDiffableDataSource](https://developer.apple.com/documentation/uikit/uicollectionviewdiffabledatasource)<br/>[CollectionViewCompositionallayout](https://developer.apple.com/documentation/uikit/uicollectionviewcompositionallayout)<br/>

----


## 💻 개발환경 및 라이브러리
[![swift](https://img.shields.io/badge/swift-5.6-orange)]()
[![xcode](https://img.shields.io/badge/Xcode-13.4.1-blue)]()
