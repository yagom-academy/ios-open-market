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
    - multipart/form-data
    - UICollectionView
    - Diffable DataSource
## 🛠 프로젝트 구조

### 📊 UML
![](https://i.imgur.com/LDQxOYv.jpg)



### 🌲 Tree
```
.
├── OpenMarket/
│   ├── Extension/
│   │   ├── String+Extension.swift
│   │   └── Double+Extension.swift
│   │   ├── UIImage+Extension.swift
│   │   ├── Data+Extension.swift
│   ├── Models/
│   │   ├── Item.swift
│   │   ├── ImageCacheManager.swift
│   │   ├── ItemList.swfit
│   │   └── Currency.swift
│   ├── Views/
│   │   ├── ListCollectionViewCell.swift
│   │   ├── GridCollectionViewCell.swift
│   │   ├── GridUICollectionView.swift
│   │   └── ListUICollectionView.swift
│   │   └── ItemImageCollectionViewCell.swift
│   ├── Controllers/
│   │   ├── MainViewController.swift
│   │   ├── LoadingController.swift
│   │   ├── ImageCacheManager.swift
│   │   └── ItemAddViewController.swift
│   │   └── ItemEditViewController.swift
│   │   └── ItemViewController.swift
│   │   └── ItemInfomationViewController.swift
│   ├── Resource/
│   │   └── Assets.xcassets
│   ├── Network/
│   │   ├── NetworkManager.swift
│   │   ├── NetworkError.swift
│   │   ├── HTTPMethod.swift
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
## Model
- **Item**, **ItemList**
    - `URLSession`을 통해 서버에서 데이터를 받을 때, JSON데이터에 따라 설계된 모델
- **Currency**
    - `Item`모델의 currency타입에 맞는 화폐단위의 `enum`타입

## Network
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
    
```swift
func createRequestBody(params: [String: Data], images: [UIImage], boundary: String) -> Data 
```
- `POST`요청을 통해 상품을 등록하는 과정에서 `request.body` 내부의 값을 생성하는 함수입니다.
    - `params` : 상품 등록에 필요한 정보를 받는 인자입니다.
    - `images` : 상품 등록시 상품의 이미지를 받는 인자입니다. 배열의 형태로 여러 개의 이미지를 받습니다.
```swift
func addItem(params: [String: Any], images: [UIImage], completion: @escaping (Result<Item, NetworkError>) -> ())
```
- `POST`요청을 통해 상품을 등록하는 함수입니다. `completion`을 통하여 결과 값을 전달합니다. 
    - 성공시 `response`값으로 온 `Item`을 전달하고, 에러 가 발생하면 에러 타입을 전달합니다.
```swift
func deleteURI(productId: Int, password: String,  completion: @escaping (Result<String, NetworkError>) -> ())
```
- 상품 삭제에 필요한 URL를 생성하는 함수입니다. `completion`을 통하여 결과 값을 전달합니다. 
    - 성공시 상품 삭제에 필요한 URI를 전달하고, 에러가 발생하면 에러 타입을 전달합니다.
```swift
func deleteItem(productId: Int, password: String, completion: @escaping (Result<Item, NetworkError>) -> ()) 
```
- `DELETE`요청을 보냄으로써 상품을 삭제하는 함수입니다. `completion`을 통하여 결과 값을 전달합니다. 
    - 삭제 성공시 삭제한 `itme`을 전달하고, 에러가 발생하면 에러 타입을 전달합니다.
```swift
func editItem(productId: Int, params: [String: Any], completion: @escaping (Result<Item, NetworkError>) -> ())
```
- 아이템의 Id값인 `producId` 값과 수정될 값이 담긴 `params`값을 받아서 `PATCH`요청을 보내 상품을 수정하는 메서드입니다.`completion`을 통하여 결과 값을 전달합니다.
    - 성공시 수정된 `Item`값을 전달하고, 에러가 발생하면 에러 타입을 전달합니다.
### NetworkError
- DataSessionTask 에서 전달한 Error확인을 위한 enum 타입


## Controller
### ImageCacheManager
```swift
final class ImageCacheManager {
    static let shared = NSCache<NSString, UIImage>()
    private init() {}
}
```

- 서버에서 받아온 상품 이미지를 저장하기 위한 임시저장소 입니다

### LoadingController
```swift
 static func showLoading() {
        DispatchQueue.main.async {
            guard let window = UIApplication.shared.windows.last else { return }
            let loadingIndicatorView: UIActivityIndicatorView
            if let existedView = window.subviews.first(where: { $0 is UIActivityIndicatorView } ) as? UIActivityIndicatorView {
                loadingIndicatorView = existedView
            } else {
                loadingIndicatorView = UIActivityIndicatorView(style: .large)
                loadingIndicatorView.frame = window.frame
                loadingIndicatorView.color = .brown
                loadingIndicatorView.backgroundColor = .gray
                window.addSubview(loadingIndicatorView)
            }

            loadingIndicatorView.startAnimating()
        }
    }
```

- `showLoading()` : 처음 상품 리스트를 로드할 때, 사용자에게 로딩화면을 보여줍니다

```swift
static func hideLoading() {
        DispatchQueue.main.async {
            guard let window = UIApplication.shared.windows.last else { return }
            window.subviews.filter({ $0 is UIActivityIndicatorView }).forEach { $0.removeFromSuperview()
            }
        }
    }
```

- `hideLoading()` : 로딩이 끝난 후 로딩화면을 숨깁니다

### MainViewController
```swift
@objc private func changeItemView(_ sender: UISegmentedControl) {
    showCollectionType(segmentIndex: sender.selectedSegmentIndex)
}

private func showCollectionType(segmentIndex: Int) {
    if segmentIndex == 0 {
        self.gridCollectionView.isHidden = true
        self.listCollectionView.isHidden = false
    } else {
        self.listCollectionView.isHidden = true
        self.gridCollectionView.isHidden = false
    }
}
```
- 사용자가 segmentedControl의 `LIST` 또는 `GRID` 버튼을 누르면, 상품목록을 List 또는 Grid 형태로 보여줍니다.
### ItemViewController
상품을 등록과 수정에서 상속받아 사용하는 클래스로 공통으로 사용되는 로직을 담고있습니다.
```swift
func showAlert(title, message, actionMessage, dismiss)
```
- 같은 형식으로 사용되는 `alert`의 갯수가 많아 메서드로 분리해주었습니다.
```swift
@objc func doneButtonTapped()
```
- 하위 네비게이션컨트롤러의 우측 버튼으로, 하위 뷰컨트롤러에서 재정의하여 사용합니다.
### ItemAddViewController
```swift
@objc private func presentAlbum()
```
- 앨범에서 이미지를 가져오는 메서드입니다. 이미지가 5개 이하일 경우에만 동작합니다.
```swift
func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
```
- 앨범에서 선택된 이미지를 itemImages와 imageStackView에 추가해주는 메서드입니다.
### ItemEditViewController
```swift
private func fetchItem()
```
- 컬렉션 뷰에서 전달받은 `itemId`를 통해 아이템의 정보를 가져오는 메서드입니다.

## Views
- Modern Collection View를 사용하여 구현한 리스트, 그리드 형태의 상품리스트입니다.
- 레이아웃은 `UICollectionViewCompositionalLayout`을 사용했습니다.
- 콜렉션 뷰의 셀 데이터는 `UICollectionViewDiffableDataSource`을 사용했습니다.

### ListUICollectionView
- 상품 목록을 테이블뷰와 같은 리스트 형태로 보여주는 콜렉션 뷰 입니다. 

### GridUICollectionView
- 상품 목록을 그리드 형태로 보여주는 콜렉션 뷰 입니다.

## Extension
### UIImage
```swift
extension UIImage {
    func compressTo(expectedSizeInKb:Int) -> Data? {
        let sizeInBytes = expectedSizeInKb * 1024
        var needCompress: Bool = true
        var imgData: Data?
        var compressingValue: CGFloat = 1.0
        
        while (needCompress && compressingValue > 0.0) {
            if let data: Data = self.jpegData(compressionQuality: compressingValue) {
            if data.count < sizeInBytes {
                needCompress = false
                imgData = data
            } else {
                compressingValue -= 0.1
            }
        }
    }
        
    if let data = imgData {
        if (data.count < sizeInBytes) {
            return data
        }
    }
        return nil
    }
}
```
- `func compressTo(expectedSizeInKb:Int) -> Data?`
    - 이미지를 `jpegData(compressionQuality:)`함수로 인자로 받은 `KB`단위로 압축하는 메서드입니다.

## 📱 실행 화면
|           최초 페이지 진입시 Loading           |       `+`버튼 클릭시 빈 페이지       |
|:------------------------------------:|:------------------------------------:|
| ![](https://i.imgur.com/Y9KI2W9.gif) | ![](https://i.imgur.com/huerEUY.gif) |
|            **List View**             |            **Grid View**             |
| ![](https://i.imgur.com/djQk4nV.gif) | ![](https://i.imgur.com/FLAcAuJ.gif) |
|     **Market2 - 상품 등록**            |           **Market2 - 상품 수정**       |
| ![](https://i.imgur.com/Kq2zjmo.gif) | ![](https://i.imgur.com/X5mfg6O.gif) |






## ⏰ 타임라인


<details>
<summary>OpenMarket1 Step1 타임라인</summary>
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

<details>
<summary>OpenMarket1 Step2 타임라인</summary>
<div markdown="1">       
    
- **2022.11.20**
    - 코드로 UI 구현을 위한 스토리보드 삭제
    - SceneDelegate를 이용한 `Navigation` 컨트롤러 및 `RootView` 구성
- **2022.11.21**
    - `Modern Collection View`를 사용하여 `ListCollection` 구현
    - `NetWorkManager`를 통한 `CollectionView` 구현
- **2022.11.22**
    - `GridCollectionView` 구현, `Image` parse를 위한 `fetchImage()` 메서드 구현
    - `SegmentedControl`을 통한 `Grid`, `List` Switching 구현
    - 데이터를 받아오기 전 로딩 상태를 알 수 있는 `Spinner` 구현
- **2022.11.23**
    - `GridCollectionViewCell` 내부로직 변경 - **스택뷰 추가**
    - `NumberFormatter`추가
    - Step2 PR 작성
- **2022.11.25**
    - `NumberFormatter`리턴 타입 변경
    - 데이터 `fetch`시 실패경우와 Loading Spinner에 관한 로직 수정
    
</div>
</details>

<details>
<summary>OpenMarket2 Step1-2 타임라인</summary>
<div markdown="1">       
    
- **2022.11.29**
    - 상품 등록을 위한 Post메서드 `addItem` 메서드구현
    - 상품 등록에 필요한 httpBody를 구성하는 `createBody` 메서드구현
- **2022.11.30**
    - 상품 삭제를 위한 Delete메서드 `deleteItem` 메서드구현
    - 상품 삭제에 필요한 URI를 받아오는 메서드 `deleteURI` 메서드구현
    - 상품 수정을 위한 Patch메서드 `editItem` 메서드구현
    - HTTPMethod enum 타입 구현
    - `deleteURI`, `deleteItem` 메서드 리팩토링
- **2022.12.02**
    - `imagePickerController` 를 통한 이미지 가져오기구현
    - 상품 등록화면 구현 및 화면 전환 방식 수정
- **2022.12.07**
    - 수정, 등록화면에서 `done` 버튼 클릭시 값으로 parameter를 생성하는 메서드구현
    - 수정, 등록화면 뷰 스크롤뷰로 변경
    - 텍스트 뷰 클릭시 화면가리지 않게 수정
- **2022.12.08**
    - 수정, 등록화면에서 Number타입의 텍스트필드클릭시 키패드 변경되게 수정
    
</div>
</details>


<details>
<summary>OpenMarket2 Step2-2 타임라인</summary>
<div markdown="1">       
    
- **2022.12.08**
    - 아이템 상세페이지 레이아웃 구성
    
    
</div>
</details>


## ❓ 트러블 슈팅 & 어려웠던 점

### 1. 샘플 Json데이터와 서버에서 받아온 Json데이터가 다른 문제
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
### 1. 서버에 multipart/form 데이터 POST시 400번 에러발생한 문제
- 상품 등록을 위한 상품 이미지 및 정보를 multipart/form 데이터를 만들어 서버에 POST 하였을 때 HTTP Response가 400번 에러가 발생하여 POST가 되지 않았던 문제가 있었습니다.

#### 해결방안
- 기존 코드는 `params`의 key와 value를 http body에 각각 추가해주었습니다.
```swift
func createRequestBody(params: [String: Any], images: [UIImage], boundary: String) -> Data {
        let newLine = "\r\n"
        let boundaryPrefix = "--\(boundary + newLine)"
        
        var body = Data()
        
        for (key, value) in params {
            body.append(boundaryPrefix)
            body.append("Content-Disposition: form-data; name=\"\(key)\"\(newLine + newLine)")
            body.append(value)
            body.append(newLine)
        }
    
    // image 파일추가 부분
}
       
let params: [String: Any] = ["name": "눈온다", "description": "간식", "price": 1000, "currency": "KRW", "stock": 1, "secret": "snnq45ezg2tn9amy"]
request.httpBody = createRequestBody(params: ["params" : jsonData], images: [UIImage()], boundary: boundary)
       
```

- 서버에서 POST 요청시 `prams` 타입이 jsonObject여서, `params`를 jsonData로 변환해주어 해결하였습니다.
![](https://i.imgur.com/kETIfME.png)
```swift
let params: [String: Any] = ["name": "눈온다", "description": "간식", "price": 1000, "currency": "KRW", "stock": 1, "secret": "snnq45ezg2tn9amy"]
guard let jsonData = try? JSONSerialization.data(withJSONObject: params) else { return }
request.httpBody = createRequestBody(params: ["params" : jsonData], images: [UIImage()], boundary: boundary)
```


---

## 📖 참고 링크

### 공식문서
[Swift Language Guide - Closures](https://docs.swift.org/swift-book/LanguageGuide/Closures.html)

### 개인 블로그 문서
[[iOS - swift] UIActivityIndicatorView, loadingView, 로딩 뷰](https://ios-development.tistory.com/682)


---

[🔝 맨 위로 이동하기](#오픈마켓-)
