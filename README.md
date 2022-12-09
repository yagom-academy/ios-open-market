# 오픈마켓

## 목차
1. [소개](#1소개)
2. [팀원](#2팀원)
3. [타임라인](#3타임라인)
4. [다이어그램](#4다이어그램)
5. [실행 화면](#5실행화면)
6. [트러블 슈팅](#6트러블-슈팅)
7. [핵심 경험](#7프로젝트-수행-중-핵심-경험)
8. [추가적으로 공부해야 하는 것](#8추가적으로-공부해야-하는-것)
9. [참고 링크](#8참고-링크)

## 1.소개
- OpenMarket API를 받아와서 뷰를 만드는 Project
- 등록된 상품, 상품 등록 기능 구현

<br>

## 2.팀원
| Minii | Baem |
| :---: | :---: |
| <img src=https://i.imgur.com/itNH4NF.png width="155" height="150">| <img src=https://i.imgur.com/jrW5RQj.png width="155" height="150" > |
|  [@Minii_GitHub](https://github.com/leegyoungmin) | [@Baem_GitHub](https://github.com/dylan-yoon) |

<br>

## 3.타임라인
**[STEP-1]**
- 221114
![](https://i.imgur.com/zhtbEMH.png)
    - 네트워크 타입 구현

- 221115
![](https://i.imgur.com/fpVv2mZ.png)
    - 네트워크 타입 Unit Test 구현

- 221116
    ![](https://i.imgur.com/NJIEwAJ.png)
    - URLSession을 이용하여 네트워킹

- 221117

    ![](https://i.imgur.com/14CmxmD.png)
    - 폴더링 및 API 타입 프로토콜로 정의 및 공통화
- 221118 : STEP1 - PR

    ![](https://i.imgur.com/C0j2WOn.png)
    - Test Double 작성

**[STEP-2]**
- 221121 - REFACTORING
    - 리펙토링
    ![](https://i.imgur.com/GbaovNU.png)
- 221122
    - 개인 학습
- 221123
    ![](https://i.imgur.com/3EHdEqN.png)
    - ListView, GridView 구현
    
- 221124
    ![](https://i.imgur.com/eahJC7b.png)
    - stock 품절 처리 및 Grid Item Cell Autolayout 설정
    
- 221125 : STEP2 - PR
    ![](https://i.imgur.com/r5WJ9mN.png)
    - 다음화면 및 readme 작성
    
**[STEP-3]**
- 221128 : PR Refactoring
    ![](https://i.imgur.com/Q2ocslY.png)
    - STEP2 Refctoring
    
- 221130 & 221201 
    ![](https://i.imgur.com/wZJnc68.png)
    ![](https://i.imgur.com/EnxJrUR.png)
    - ProductCell 구현 및 Indicator 구현
    
- 221202
    ![](https://i.imgur.com/6v2o1fQ.png)
    - API POST 메서드 구현
    
- 221205 : Merge
    ![](https://i.imgur.com/5SyPJhf.png)
    - KeyBoard에 따른 화면 조정
    
- 221206 
    ![](https://i.imgur.com/eIZaEa3.png)
    - ImagePicker 구현
    
- 221207
    ![](https://i.imgur.com/xISSKrd.png)
    - 각 에러 타입에 따른 알림창 구현 
- 221208 : PR
    ![](https://i.imgur.com/gr9a8km.png)
    - 데이터 전송 후 데이터 reFetching 메서드 구현 및 뷰 업데이트
    - PR 발송

<br>

## 4.다이어그램
- 파일 구조
```bash
├── Controller
│   ├── ProductsViewController.swift
│   └── RegisterProductViewController.swift
├── Extensions
│   ├── Common
│   │   ├── UIImage.swift
│   │   ├── UIStackView.swift
│   │   ├── UITextField.swift
│   │   └── UITextView.swift
│   └── Networking
│       ├── Dictionary+.swift
│       ├── Mockable+.swift
│       └── NSMutableData +.swift
├── Model
│   ├── Checker
│   │   ├── Common
│   │   │   └── RegisterError.swift
│   │   └── RegisterProductChecker.swift
│   └── Networking
│       ├── APIType.swift
│       ├── Common
│       │   ├── HTTPBody.swift
│       │   ├── HTTPMethod.swift
│       │   ├── PostParameter.swift
│       │   └── TestDouble
│       │       ├── StubURLSession.swift
│       │       └── URLSessionProtocol.swift
│       ├── DTO
│       │   ├── Currency.swift
│       │   ├── Product.swift
│       │   └── ProductListResponse.swift
│       ├── HttpBodyConvertible.swift
│       ├── NetworkError.swift
│       ├── NetworkManager.swift
│       └── NetworkTypes
│           └── OpenMarketAPI.swift
└── View
    ├── Base.lproj
    ├── ProductCollectionView
    │   ├── Cells
    │   │   ├── ProductGridItemCell.swift
    │   │   └── ProductListItemCell.swift
    │   └── ProductItemCellContent.swift
    └── RegisterProductCollectionView
        └── RegisterCollectionImageCell.swift
```

- 네트워크 관련 UML
![](https://i.imgur.com/X7hKyNV.png)

## 5.실행화면
#### STEP1
![testCoverage](https://i.imgur.com/2UZW8hG.png)

![netWorkView](https://i.imgur.com/M18lPLd.png)

#### STEP2


| 상품 목록 화면 | 상품 등록 화면 | 상품 상세 화면 |
| :--------: | :--------: | :--------: |
| <img src = "https://i.imgur.com/bGnwwdP.gif" height = "600"> | <img src="https://i.imgur.com/5FF7gBB.gif" height = "600"> | 추가 예정     |

## 6.트러블 슈팅
### JSON 파일과 서버의 응답 JSON의 형식이 다른 것
- 요구사항 내에서 JSON 파일을 통해서 구현한 타입을 검증하려고 하였습니다. 하지만, 응답 데이터의 형식이 달라서 고민하게 되었습니다.
- JSON 파일에 대한 테스트를 진행하지만, 실질적으로 필요한 데이터는 응답에 대한 테스트라고 생각하였습니다.
- 또한, 다양한 로컬 데이터를 진행하는 것보다 Mock을 활용한 네트워킹이 주된 테스트의 의미라고 생각하여서 응답 데이터에 맞춰서 로컬 데이터를 변경하였습니다.
    
### POP를 활용한 URL 구성

```swift
class NetworkManager {
    let baseURL: String = "https://openmarket.yagom-academy.kr"
    
    func requestHealthChecker() {
        // URL 생성
        guard let url = URL(string: baseURL + "/healthChecker") else {
            return
        }
        ...
    }
    
    func requestProductListSearching() {
        //URL 생성
        guard let url = URL(string: baseURL + "/api/products?page_no=1&items_per_page=100" ) else {
            return
        }
        ...
    }
    
    func requestDetailProductListSearching(_ id: Int) {
        //URL 생성
        guard let url = URL(string: baseURL + "/api/products" + "/\(id)") else {
            return
        }
        ...
    }
}
```
```swift
protocol APIType {
    var baseURL: String { get }
    var path: String { get }
    var params: [String: String] { get }
    
    func generateURL() -> URL?
}


struct NetworkManager<T: Decodable> {
    private var session: URLSession = URLSession(configuration: .default)
    
    func fetchData(endPoint: APIType, completion: @escaping (Result<T, NetworkError>) -> Void) {
        guard let url = endPoint.generateURL() else {
            completion(.failure(.invalidURL))
            return
        }
        ...
    }
}
```
- 처음 네트워크를 구성할 때에는 각가의 API의 URL에 따라서 구현했습니다. 하지만, 각각의 Query와 Path가 유동적으로 변경되어야 한다고 생각하였습니다.
- 위와 같은 문제를 해결하기 위해서 Alamofire`와 `Moya` 라이브러리들이 활용한 방법을 참고하여서 구현하게 되었습니다.
- `Moya` 라이브러리에서 활용한 방법인 각각의 API들을 한개의 프로토콜로 채택하여서 확장성을 고려하는 부분을 참고하여서 구현했으며, `Alamofire`에서 활용한 쿼리에 세부사항을 참고하여서 구현하였습니다.
- 이에 대해서 네트워크를 구성할 수 있는 프로토콜을 통해서 공통화를 할 수 있도록 하였고, 이를 통해서 요청을 보낼 수 있는 URL 타입을 구성할 수 있도록 하였습니다.
- 하지만, 위와 같은 방식을 활용하여 각각의 타입별로 객체를 생성하도록 하여야 하는 문제점이 있습니다. 이를 해결하기 위해서 더 공부하고, 수정할 수 있도록 하여야 할 것 같습니다.
<br>

### 데이터가 설정된 후, CollectionView가 변경되지 않는 문제 
- 데이터가 설정된 후, CollectionView가 변경되지 않는 문제
    - fetchData 함수를 통해서 데이터를 불러온 뒤, 데이터가 설정되었을 때, `CollectionView`가 자동으로 업데이트 되지 않는 문제가 발생하였습니다.
    - 뷰를 업데이트 하기 위해서 `dispatchQueue.main.async` 내부에서 데이터를 설정할 수 있도록 하였습니다.
    - 하지만, 클로저 내부에서 데이터를 설정하고, 뷰에 대한 업데이트를 하는 것이 적절한 역할이 아니라고 생각하였습니다.
    - 그래서, 프로퍼티 옵저버를 활용하여서 `CollectionView`를 업데이트 할 수 있도록 하였습니다.
- 변경전
    ```swift
        func fetchData() {
            let endPoint = OpenMarketAPI.productsList(
                pageNumber: currentPage,
                rowCount: 200
            )
            
            productResponseNetworkManager.fetchData(endPoint: endPoint) { result in
                switch result {
                case .success(let data):
                    DispatchQueue.main.async {
                        self.productsData = data
                        self.collectionView.reloadData()
                    }

                case .failure(let error):
                    print(error)
                }
            }
        }
    ```
- 변경후
    ```swift
        private var productsData: ProductListResponse? {
            didSet {
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
    ```
### 이미지를 로드하는 과정에서 작업 직접 실행하여, 로딩이 늦는 문제
- 이미지를 로드 하는 과정을 `cellForItemAt` 메서드 내부에서 이미지를 로드하도록 구현하였습니다.
- 하지만, 이로 인해서 다음과 같은 문제가 발생하였습니다.
    1. 현재 cell의 이미지 로드 작업이 이전의 실행한 작업으로 인해서 늦게 작업하는 경우가 발생함.
    2. 현재 작업을 수행하기 전에 이전의 작업한 결과가 현재 cell에 들어오는 경우가 발생함.
- 다음과 같은 문제를 해결하기 위해서 `cellForItemAt` 메서드에서는 이미지 로드 Task를 설정할 수 있도록 하고, 이를 Cell이 수행할 수 있도록 하였습니다.
- 또한, `prepareForReuse` 메서드 내부에서 작업을 취소할 수 있도록 하였습니다.

### 사진 한개의 용량과 전체 이미지의 사이즈
```swift
func downSampling(scale: Double) -> UIImage {
    guard let data = self.jpegData(compressionQuality: 0.5), 
          let imageSource = CGImageSourceCreateWithData(data as CFData, nil) else {
        return self
    }
        
    let maxPixel = min(self.size.width, self.size.height) * scale
    let downSampleOptions = [
        kCGImageSourceCreateThumbnailFromImageAlways: true,
        kCGImageSourceShouldCacheImmediately: true,
        kCGImageSourceCreateThumbnailWithTransform: true,
        kCGImageSourceThumbnailMaxPixelSize: maxPixel
    ] as CFDictionary
        
    guard let downSampledImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, downSampleOptions) else {
            return self
    }
        
    let newImage = UIImage(cgImage: downSampledImage)
        
    return newImage
}
```
- API 문서의 이미지의 용량에 대한 요구 사항이 있었습니다. 이에 대해서 전체 30kb가 아닌 한개의 이미지가 30kb가 되는 것으로 생각하였습니다. 하지만, 실질적인 API 통신의 요구 사항은 여러 장의 이미지의 용량의 합이 30kb가 되는 것이였습니다.
- 이에 대해서 수정하는 과정에서 어떤 방식으로 이미지의 용량을 제한 해야 하는 것인지 고민하게 되었습니다.
- 합에 대한 조건을 통해서 이미지의 사이즈를 줄일 것인지, 한개의 이미지의 용량을 제한 할 것인지에 대해서 고민하였습니다.
- 이에 대한 결론으로 이미지를 모두 받아 둔 후, 데이터를 압축시키는 것은 사용자에게 좋은 UX를 제공하지 못한다고 판단하여서 한개의 이미지의 사이즈를 30kb / 전체 이미지의 개수로 계산하여서 제한하였습니다.
- 위의 코드를 통해서 이미지의 최대 픽셀의 사이즈를 조절함으로써 데이터의 양을 줄이도록 했습니다.

## 8.추가적으로 공부해야 하는 것
### 비대한 ViewController
![Massive ViewController](https://developer.apple.com/library/archive/documentation/General/Conceptual/DevPedia-CocoaCore/Art/model_view_controller_2x.png)
<br>
- MVC 아키텍처 패턴을 활용하서 구성하였습니다. 이 과정에서 `Delegate`와 `DataSource`를 `Controller`로 지정되는 구문이 많아서 메서드를 가지고 있음으로써 `Controller`가 비대해졌다고 생각이 듭니다.
- 또한, `ViewController`가 `View`에 대한 요소들을 가지고 있고, 이에 대한 `Constraint`를 구성하는 것이 적절한지에 대해서 고민하게 되었습니다.
- 이에 대해서 추가적으로 MVC의 단점을 보안할 수 있는 점에 대해서 공부하려고 합니다.

## 9.참고 링크
- Apple Developer 
    - [Generic](https://docs.swift.org/swift-book/LanguageGuide/Generics.html)
    - [Choosing Between Structures and Classes](https://developer.apple.com/documentation/swift/choosing-between-structures-and-classes)
    - [Attributedtext](https://developer.apple.com/documentation/uikit/uilabel/1620542-attributedtext)
    - [Data Entry - iOS - Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/ios/user-interaction/data-entry/)
    - [UIImagePicker](https://developer.apple.com/documentation/uikit/uiimagepickercontroller)
- Swift Programming Language
    - [클로저 캡쳐(캡쳐 값)](https://docs.swift.org/swift-book/LanguageGuide/Closures.html)
    - [클로저의 강한 참조](https://docs.swift.org/swift-book/LanguageGuide/AutomaticReferenceCounting.html#ID56)
- 야곰닷넷
    - [동시성 프로그래밍](https://yagom.net/courses/%EB%8F%99%EC%8B%9C%EC%84%B1-%ED%94%84%EB%A1%9C%EA%B7%B8%EB%9E%98%EB%B0%8D-concurrency-programming/)
    - [Test Double](https://yagom.net/courses/unit-test-작성하기/lessons/테스트를-위한-객체-만들기/topic/test-double/)
    - [URLSession](https://developer.apple.com/documentation/foundation/urlsession)
    - [UIAlertController](https://developer.apple.com/documentation/uikit/uialertcontroller)
- MDN
    - [mdn POST](https://developer.mozilla.org/ko/docs/Web/HTTP/Methods/POST)
---
[🔝 맨 위로 이동하기](#오픈마켓)
