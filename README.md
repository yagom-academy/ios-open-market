# Open Market ReadME

- Kyo와 LJ가 만든 Open Market App입니다.

## 목차
1. [팀 소개](#팀-소개)
2. [GroundRule](#ground-rule)
3. [Code Convention](#code-convention)
4. [실행 화면](#실행-화면)
5. [Diagram](#diagram)
6. [폴더 구조](#폴더-구조)
7. [타임라인](#타임라인)
8. [기술적 도전](#기술적-도전)
9. [트러블 슈팅 및 고민](#트러블-슈팅-및-고민)
10. [일일 스크럼](#일일-스크럼)
11. [참고 링크](#참고-링크)


## 팀 소개
 |[Kyo](https://github.com/KyoPak)|[LJ](https://github.com/lj-7-77)|
 |:---:|:---:|
| <img width="180px" img style="border: 2px solid lightgray; border-radius: 90px;-moz-border-radius: 90px;-khtml-border-radius: 90px;-webkit-border-radius: 90px;" src= "https://user-images.githubusercontent.com/59204352/193524215-4f9636e8-1cdb-49f1-9a17-1e4fe8d76655.PNG" >|<img width="180px" img style="border: 2px solid lightgray; border-radius: 90px;-moz-border-radius: 90px;-khtml-border-radius: 90px;-webkit-border-radius: 90px;" src= "https://i.imgur.com/BHXYIyl.jpg">|

## Ground Rule

[Ground Rule 바로가기](https://github.com/KyoPak/ios-open-market/wiki/GroundRule)

## Code Convention

[Code Convention 바로가기](https://github.com/KyoPak/ios-open-market/wiki/Code-Convention)

## 실행 화면

### ▶️ Step-1 실행화면 - 네트워크 구현

<details>
<summary> 
펼쳐보기
</summary>

|**HealthCheck**|<img width = 100, src = "https://i.imgur.com/gYPRWVK.png">|
|:---:|:---|
|**ProductList**|<img width = 7000, src = "https://i.imgur.com/OCWXSIH.png">|
|**ProductDetail**|<img width = 700, src ="https://i.imgur.com/POfRE6k.png">|

</details>


### ▶️ Step-2 실행화면 - CollectionView

<details>
<summary> 
펼쳐보기
</summary>

|**기본실행**|**Indicator적용**|**Cache적용**|
|:--:|:--:|:--:|
|<img src="https://i.imgur.com/sYKmYBJ.gif" width=220>|<img src="https://i.imgur.com/h3xn3i7.gif" width=220>|<img src="https://i.imgur.com/GDTosnM.gif" width=220>|

</details>

### ▶️ Step-3 실행화면

<details>
<summary> 
펼쳐보기
</summary>

|**기본실행**|**상품등록**|**이미지등록 최대5장**|**키보드타입,콘텐츠영역보장**|
|:--:|:--:|:--:|:--:|
|<img src="https://i.imgur.com/xZgF7Uv.gif" width=220> |<img src="https://i.imgur.com/AJZRF6r.gif" width=220> |<img src="https://i.imgur.com/KiDbcAU.gif" width=210>|<img src="https://i.imgur.com/6JpDuqh.gif" width=190>|
    
    
</details>

### ▶️ Step-4 실행화면

    
|**기본실행**|**상품수정**|**상품삭제**|**Alert**|
|:--:|:--:|:--:|:--:|
|<img src="https://i.imgur.com/EcLhpH3.gif" width=220> |<img src="https://i.imgur.com/RiBuMAG.gif" width=220>| <img src="https://i.imgur.com/VTPXA5m.gif" width=215> | <img src="https://i.imgur.com/Zzwf0xf.gif" width=225> |



## Diagram

### Class Diagram
대략적으로 나타낸 Class Diagram입니다.
![](https://i.imgur.com/L9FwSJ6.jpg)
 
## 폴더 구조

```
OpenMarket
├── DecodeManagerTests
│   └── DecodeManagerTests.swift
├── NetworkManagerTest
│   ├── NetworkManagerTest.swift
│   └── TestData.swift
├── OpenMarket
│   ├── AppDelegate.swift
│   ├── SceneDelegate.swift
│   ├── Info.plist
│   ├── Base.lproj
│   │   └── LaunchScreen.storyboard
│   ├── Resources
│   │   └── Assets.xcassets
│   ├── Common
│   │   ├── Error.swift
│   │   └── Protocol
│   │       └── ReuseIdentifierProtocol+Extension.swift
│   ├── Controllers
│   │   ├── ImageCacheManager.swift
│   │   ├── AddViewController.swift
│   │   ├── DetailViewController.swift
│   │   ├── MainViewController.swift
│   │   ├── ModifyViewController.swift
│   │   └── ProductViewController.swift
│   ├── Extensions
│   │   ├── Formatter+Extension.swift
│   │   ├── UIImage+Extension.swift
│   │   ├── UILabel+Extension.swift
│   │   ├── UIViewController+Extension.swift
│   │   └── URLComponents+Extension.swift
│   ├── Models
│   │   ├── DecodeManager.swift
│   │   ├── NewProduct.swift
│   │   ├── Product.swift
│   │   └── ProductPage.swift
│   ├── Network
│   │   ├── MockURLSession
│   │   │   └── MockURLSession.swift
│   │   ├── NetworkManager.swift
│   │   ├── NetworkRequest.swift
│   │   └── Protocols
│   │       ├── URLSessionDataTaskProtocol.swift
│   │       └── URLSessionProtocol.swift
│   └── Views
│       ├── Cells
│       │   ├── AddProductCollectionViewCell.swift
│       │   ├── DetailProductCollectionViewCell.swift
│       │   ├── GridCollectionViewCell.swift
│       │   └── ListCollectionViewCell.swift
│       ├── MainView.swift
│       ├── DetailProductView.swift
│       ├── ProductView.swift
│       ├── AddProductView.swift
│       └── ModifyProductView.swift
└── README.md                
```

##  타임라인
### 👟 Step 1

- Model 구현
    - ✅ 파싱한 JSON 데이터와 매핑할 모델 설계
    - ✅ CodingKeys 프로토콜의 활용 
    - ✅ Json파일과 서버 데이터 모두 적용하기 위한 keyDecodingStrategy 사용
- UnitTest 
    - ✅ 단위 테스트(Unit Test)를 통한 설계의 검증
    - ✅ Test Double(Mock)을 이용한 네트워크 테스트 
- Network
    - ✅ URL Session을 활용한 서버와의 통신
    - ✅ Mock Test를 위한 Network 추상화
- Error Handling
    - ✅ ResultType을 적용한 에러처리

<details>
<summary> 
펼쳐보기
</summary>
    
1️⃣ NetworkRequest
    - 필요한 작업case별로 `requestURL`이라는 URL타입으로 바꿔주는 연산프로퍼티가 존재하는 타입입니다.
    
2️⃣ NetworkManager
    - 네트워크에 관련된 작업을 담당하는 클래스입니다.
    - 가장 처음에는 Singleton 패턴을 구현하였었습니다. 하지만 step1-3에서 Moct Test 구현을 위해 초기화하는 방식을 바꿨습니다.
    - `checkHealth()`는 서버에 요청이 잘 되었다는 응답값을 받기 위한 Request메서드입니다.
        - 초기에는 escaping 클로저를 사용하지 않았지만, Test 진행하며 `responseStatusCode` 값을 가져오기 위해 escaping 클로저를 사용하였습니다.
    - `fetchData()`는 서버에 데이터를 요청하는 메서드입니다.
        - productList와 productDetail 데이터를 가져오는 메서드이며 이 두가지의 요청은 각각 Decode하는 방식이 다르기 때문에 제네릭을 사용하였습니다.
        - 그리고 추후에 받아온 데이터를 사용하기 위해 escaping 클로저를 사용하였습니다.
    
3️⃣ URLSessionProtocol
    - NetworkManager에서 `MockURLSession`과 `URLSession`을 상황에 맞게 사용하게끔 추상화를 한 프로토콜입니다.
    - 내부에서 필수적으로 구현해야할 `dataTask()`메서드를 새롭게 정의하였습니다.
    
4️⃣ URLSession Extension
    - `URLSessionProtocol`을 채택한 후, 내부에서 프로토콜에서 정의한 메서드를 구현해주었습니다. Mock이 아닌 실제 사용될 `URLSession`이기 때문에 프로토콜에서 정의한 메서드의 반환값을 실제 `dataTask()`메서드를 호출하는 방식으로 구현하였습니다.
    
5️⃣ MockURLSession
    - dataTask
        - `MockURLSession`이 실행할 `dataTask()`메서드입니다.
        - 실제 네트워크에 요청을 하는 것이 아니기 때문에 곧바로 `return`이 되게끔 하였습니다.
    - makeMockSenderSession
        - 이 타입 메서드는 `MockURLSession`의 Mock응답을 만드는 메서드입니다. 실제 네트워크에 요청을 해서 응답값을 받아오는 목적이 아니기 때문에 이 메서드를 통해 Mock응답을 만들었습니다.

 
</details>


### 👟 Step 2
- CollectionView
    - ✅ Collection View의 활용
    - ✅ Custom Cell 구현 (List, Grid)
- Image Asynchronous 처리
    - ✅ Image 비동기로 처리
    - ✅ Image 표기 시 Image가 변경되는 이슈 해결
- Cache
    - ✅ NSCache 사용
- UI
    - ✅ Segmented Control 사용
    - ✅ Indicator View 사용

<details>
<summary> 
펼쳐보기
</summary>

1️⃣ MainView
    - `segmentedControl`과 `listLayout`, `gridLayout`, `collectionLayout`이 있는 view입니다.
    - segmentedControl에서 `List`와 `Grid`를 누를 때 마다, `layoutStatus`라는 Property Observer을 사용하여 필요한 메서드가 호출될수 있도록 구현하였습니다.
    - `collectionViewLayout`이 변경되는 `changeLayout()` 메서드가 호출되게 끔 구현하였습니다. 그리고 `collectionView`가 `reload`되게끔 하였습니다.
    
    
2️⃣ ListCollectionViewCell
    - List Layout을 구성할 CollectionViewCell 내부 요소와 오토레이아웃을 구현하였습니다.
    
3️⃣ GridCollectionViewCell
    - Grid Layout을 구성할 CollectionViewCell 내부 요소와 오토레이아웃을 구현하였습니다. 
    
4️⃣ AddViewController, AddProductView
    - `UIBarButtonItem`인 `+`버튼을 눌렀을 때 전환될 다음 뷰(`AddProductView`)를 담당하는 뷰컨트롤러입니다.
    
5️⃣ ImageCacheManager
    - 이미지캐싱을 위한 클래스 타입입니다.
    
6️⃣ UILabel+Extension
    - 할인 전 가격Label에 취소선을 표시해주는 메서드 `applyStrikeThroughStyle`를 구현해주었습니다.

    
</details>

### 👟 Step 3
- CollectionView
    - ✅ Collection View의 활용
    - ✅ Cell 내부 Button Action Delegate 처리 
- Network
    - ✅ multipart/form-data의 구조 파악
    - ✅ URLSession을 활용한 multipart/form-data 요청 전송
    - ✅ NetworkManager POST, PATCH, DELETE Method 구현
    
- 추가 구현 
    - ✅ Pagination 구현
    - ✅ PHPickerView 구현
    - ✅ Image 표기 시 Image가 변경되는 이슈 해결

<details>
<summary> 
펼쳐보기
</summary>

 1️⃣ RootProductViewController
 - 상품등록과 상품수정의 공통기능(NavigationItem-cancel버튼,done버튼)을 가진 뷰컨트롤러입니다.
 - AddViewController와 ModifyViewController가 이 클래스를 상속받아 버튼을 눌렀을 때 alert각각 역할에 맞는 기능을 수행하도록 구현하였습니다.
 - showView 전역변수를 선언하여 AddViewController에서는 AddProductView를, ModifyViewController에서는 ModifyProductView를 보여주도록 구현하였습니다

 2️⃣ AddViewController
 - 상품등록 시 이미지를 첨부하는 기능을 PHPickerView를 활용하여 구현하였습니다.
 - ImageCollectionViewCellDelegate 프로토콜을 채택하여 등록가능한 최대 이미지개수와 asset타입(이미지, 라이브포토, 비디오)을 이미지만 가능하도록 설정하였습니다.

 3️⃣ NewProduct
 
 - 상품등록을 위해 POST 할 때 사용하기 위한 타입입니다.

 4️⃣ NetworkManager - postData(url:newData:completion:), patchData(url:), fetchDeleteDataURI(to: url), deleteProduct(url:)
 
 - postData(url:newData:completion:) : 상품등록할 때 http 메세지를 작성하고, 등록할 상품데이터를 보내주는 메서드입니다.
 - patchData(url:)` : 상품수정 시 수정할 데이터를 encoding하여 보내주는 메서드입니다.
 - fetchDeleteDataURI(to: url) : 삭제할 상품의 URI 응답값을 받아오는 메서드입니다. 
 - deleteProduct(url:) : 삭제할 상품의 URI를 받아온 후 해당 URI를 삭제요청하는 메서드입니다.
 - UIImage+Extension

 5️⃣ 이미지 리사이징을 위한 메서드들을 확장하여 구현하였습니다.
 - compressTo(expectedSizeInKb:) : compressionQuality를 줄여나가는 메서드입니다.
 - resize(expectedSizeInKb:) : width, height를 줄여나가는 메서드입니다.

 </details>
 
### 👟 Step 4
- Alert
    - ✅ 상황에 적합한 Alert 활용
    - ✅ UIAlertController 액션의 completion handler 활용
    - ✅ UICollectionView 를 통한 좌우 스크롤 기능 구현

- Network
    - ✅ NetworkManager UPDATE, DELETE Method 구현 및 적용


## 기술적 도전
### ⚙️ Network
<details>
<summary> 
펼쳐보기
</summary>
    
- `URLSession`과 `URLSession`의 `shared` 인스턴스를 사용하여 Network 통신을 진행하였습니다.
- `URLSession`의 Task타입에는 DataTask, UploadTask, DownloadTask, StreamTask 등이 있고, STEP 1에서는 `Request`했을 때, DataTask 객체를 사용하여 데이터를 받아오는 것을 확인할 수 있었습니다.
- 💡 데이터를 앱으로 반환하는 방법에는 세가지(async, delegate, completion handler)가 있습니다. 그 중 `completion handler`를 이용하는 방법을 사용하였고, 대부분의 네트워킹API와 마찬가지로 URLSession도 비동기이기 때문에 escaping 클로저를 사용하였습니다. 
    
</details> 

### ⚙️ Test Double
    
<details>
<summary> 
펼쳐보기
</summary>
       
테스트 더블에는 Dummy, Stub, Fake, Spy, Mock 등이 있습니다. 명확히 구분해서 사용하지는 않지만, 실제와 가장 유사하게 구현된 `Mock`객체를 선택하여 구현하였습니다. `Mock`은 행위기반테스트로 예상되는 행위들에 대한 시나리오를 만들어 놓고 시나리오대로 동작했는지에 대한 여부를 확인합니다.
- 💡 `MockURLSession`과 `MockURLSessionDataTask`를 만들고, 그에 따른 요청 시 우리의 예상대로 정해놓은 Mock응답이 잘 받아지는지 확인하였습니다.
- 💡 추가적으로 `URLSessionProtocol`을 채택한 URLSession을 사용하다보니 의존성도 분리가 되지않았을까라는 생각이 들었습니다.
</details>
        
### ⚙️ Indicator View
    
<details>
<summary> 
펼쳐보기
</summary>
      
사용자에게 이미지가 로드되는 시간동안 비어있는 이미지를 보여주지 않기 위해서 사용하였습니다.
UIActivityIndicaotrView는 기본적으로 UIView를 상속하는 클래스입니다.
indicator 애니메이션을 `startAnimating()` 메서드와 `stopAnimating()` 메서드로 control할 수 있습니다.
hideWhenStopped 프로퍼티를 true로 하면 Indicator 애니메이션이 멈추면 뷰는 자동으로 hide됩니다.

    
- 💡 가장 먼저 `Indicator View`를 `productImageView`와 동일한 위치에 위치시켰습니다
- `collectionView(collectionView:, cellForItemAt indexPath:)` 메서드에서 데이터를 받아오는 `setupData()`메서드 실행 전에 `startAnimating()`을 호출하였습니다.
- 이미지 업로드하는 `uploadImage()`메서드에서 `productImageView`에 `image`를 담은 후 `stopAnimating()`으로 멈추도록 구현하였습니다.    
</details>

### ⚙️ Cache
    
<details>
<summary> 
펼쳐보기
</summary>
       
일단 Cache는 자주 접근하는 리소스에 접근하는 시간을 단축하기 위해 사용됩니다.
즉, Cache에 데이터를 미리 복사해 놓으면 계산이나 접근 시간 없이 더 빠른속도로 데이터에 접근할 수 있게 됩니다.
프로젝트에서 사용한 `NSCache`는 `Key-Value`쌍을 임시로 저장하는데 사용되는 변경가능한 Collection입니다.
NSCache는 자체적으로 메모리가 너무 많이 사용되지 않도록 제거되는 정책을 소유하고 있으며 iOS에서는 메모리 캐싱으로 사용됩니다. 때문에 앱이 종료될 경우 리소스들은 자동으로 OS에 반환됩니다.
    
- 💡 Cache를 생성하는 ImageCacheManager를 싱글톤 패턴으로 생성하였습니다. 
- 💡 이미지를 가져오기 전, 캐싱된 내용에 해당 이미지가 존재하는지 `MainViewController`에서 먼저 검사합니다.
    갖고있다면 그 이미지를 사용하고 cell을 반환하고, 갖고있지 않다면 NetworkManager 객체의 `fetchImage()`를 통해 비동기처리로 이미지를 load 합니다. 
    가져온 이미지를 `setObject(image, forKey:)` 메서드로 캐시에 저장 후 이미지를 바꿔주었습니다. 

```swift
if indexPath == collectionView.indexPath(for: cell) {
    ImageCacheManager.shared.setObject(image, forKey: cacheKey)
    // cell update
    ...
}
```
    
</details>

### ⚙️ Pagination
<details>
<summary> 
펼쳐보기
</summary>
- 보여줄 데이터를 처음에 Load해올 때 모두 가져오는 것이 아닌, Scroll이 내려감에 따라 데이터를 가져오는 것을 Pagination이라고 합니다. 페이지 번호를 클릭하여 바뀐 페이지 번호에 대한 새로운 URL에 대한 데이터를 서버에 요청해야합니다. 
- 💡 앱의 로직 특성상 스크롤을 내리면 자동적으로 pageNo가 추가되면서 정해진 갯수만큼을 서버에서 가지고 올 수 있도록 구현하였습니다. 그리고 스크롤을 내릴 때마다 서버에 요청하게 됩니다.
- 이때, 스크롤을 내릴때마다 `scrollViewDidScroll(_ scrollView: UIScrollView)` 메서드가 자동으로 호출이 되고 이 메서드 내부에서 바뀐 Page에서 데이터를 가져오도록 구현하였습니다.
    
</details>


### ⚙️ PHPickerView
<details>
<summary> 
펼쳐보기
</summary>

- 서버에 올릴 상품의 이미지를 PhotoLibrary에서 가져올 때, PHPickerView를 사용하였습니다.
PHPickerView를 사용함으로서 multi Select가 가능해졌기 때문에 여러장의 사진을 한번에 가져올 수 있었습니다. 
- 💡 먼저 `PHPickerConfiguratin` 객체를 생성하여 기본적인 configuration을 setup 후 
`PHPickerViewControllerDelegate`의 `picker(_ picker:, didFinishPicking results:)` 메서드를 구현해주었습니다.
이미지를 최대 5장까지 선택을 한 후에 가져와야했기때문에 아래 처럼 compacMap을 통해서 가져온 결과들을 가져왔습니다.

```swift
let itemProvides = results.compactMap { result in
    return result.itemProvider
}
```
    
</details>

### ⚙️ UIImagePicker
<details>
<summary> 
펼쳐보기
</summary>
    
- 서버에 올릴 상품의 이미지를 PHPickerView를 사용하여 가져왔었습니다.
하지만 PHPickerView에는 이미지 편집기능이 없었고, iOS14이상의 시뮬레이터에서 분홍색 꽃 이미지를 선택하면 이미지가 로드되지 않는 오류가 있었습니다. 해당 오류는 PHPickerView에서 
Heic 사진을 선택할 때 발생하는 iOS 시뮬레이터 문제였습니다. 
분홍색/보라색 꽃 이미지에서만 발생하고 정상 동작하는 다른 모든 이미지는 jpeg이며, heic 사진을 선택할 때 실제 장치에서 잘 작동한다는 자료 내용들을 찾을 수 있었습니다.
- 때문에 UIImagePicker로 구현 내용을 바꾸기로 하였습니다.

- 💡 먼저 picker라는 UIImagePickerController()객체를 생성후 아래와 같이 기본 setup을 해주었습니다.
    
```swift
picker.sourceType = .photoLibrary
picker.allowsEditing = true
```
그리고 아래와 같이 편집과 원본에 따라 동작을 다르게 구현하였습니다.
multi Select 동작은 `PHPicker` 와는 달리 사용할 수 없었지만 이미지 이슈가 없었고 이미지 편집 기능을 용할 수 있었습니다.
```swift
func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    if let image = info[.editedImage] as? UIImage {
        ...
    } else {
        if let image = info[.originalImage] as? UIImage {
            ...
        }
    }
    ...
}
```
    
</details>


### ⚙️ Multipart/form-Data
<details>
<summary> 
펼쳐보기
</summary>
    
파일 업로드를 구현할 때, 클라이언트가 파일을 등록해서 전송합니다.
이때 클라이언트가 보내는 HTTP 메시지는 `Content-Type 속성이 multipart/form-data로 지정`이 되고, 정해진 형식에 따라서 메시지를 인코딩하여 전송하게 됩니다.

이미지 파일도 문자로 이뤄져 있기 때문에 이미지 파일을 스펙에 맞게 문자로 생성해서 HTTP request body에 담아 서버로 전송하게 됩니다. 

<img src="https://i.imgur.com/Sy1RYMj.png" width=220> 
<img src="https://i.imgur.com/EXwIBsf.png" width=550>
    
    
- 💡  위와 같은 4개의 부분과 형식에 맞춰 구현을 진행하였습니다.
`request`의 `HeadrField`를 구성 후, 아래와 같이 별도의 메서드를 생성하여 데이터를 형식에 맞게 바꾸고, 이미지 데이터 또한 형식에 맞게 바꾼후 `HttpBody`로 사용하였습니다.
```swift
private func convertDataForm(named name: String, value: Data, boundary: String) -> Data {
        var data = Data()
        data.appendStringData("--\(boundary)\r\n")
        data.appendStringData("Content-Disposition: form-data; name=\"\(name)\"\r\n")
        data.appendStringData("\r\n")
        data.append(value)
        data.appendStringData("\r\n")
        return data
    }
     
private func convertFileDataForm(fieldName: String, fileName: String, mimeType: String, fileData: Data, boundary: String) -> Data {
        var data = Data()
        data.appendStringData("--\(boundary)\r\n")
        data.appendStringData("Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"\(fileName)\"\r\n")
        data.appendStringData("Content-Type: \(mimeType)\r\n\r\n")
        data.append(fileData)
        data.appendStringData("\r\n")
        return data
}
```

</details>


## 트러블 슈팅 및 고민
### 🔥 멀티 CodingKey ➡️ `keyDecodingStrategy`
    
<details>
<summary> 
펼쳐보기
</summary>

**문제 👀**

|Json|Server|
|------|------|
|![](https://i.imgur.com/3knTgMq.png)|![](https://i.imgur.com/H6GKQJy.png)|
    
- 처음에 JSON파일을 받고 해당 데이터에 대해서 `CodingKey` 프로토콜을 채택하여 구현하였습니다. 
- 하지만 JSON파일과 서버에서의 파일의 일부분의 키값이 달랐고, 모두 받아들일 수 있도록 멀티 코딩키를 사용하려했습니다. 하지만 선택적으로 초기화에서 코딩키를 선택하게 하는 것도 좋지만 다른 간단한 방법을 고민하였습니다.

**해결 🔥**
 
- 결과적으로는 `keyDecodingStrategy` 프로퍼티를 `convertFromSnakeCase`로 설정하여 사용하였습니다. 
- `json`파일의 항목명을 변환하여 모델타입의 변수와 매칭하는 방법이 더 간단하다 판단했습니다. 
- 현재 프로젝트에서는 키의 갯수가 많이 없었고, 파일이 snakeCase로 되어있었지만, 만약 `Parsing` 할 데이터의 키값이 조금 더 다양했다면 멀티 CodingKey 방법이 적합할 것이라고 생각됩니다.
- 멀티 CodingKey를 사용하여 Decode 부분에서 메서드 호출에 따라서 어떤 CodingKey를 사용할지 파라메터값으로 전달해주면 더욱 다양한 Case에서 대응이 가능할것이라고 생각합니다.
</details>

### 🔥 URLComponent 확장과 NetworkRequest enum으로 URL값 구성 

<details>
<summary> 
펼쳐보기
</summary>

**문제 👀**
- 초기에 사용해야할 `URL`을 String값으로 직접 할당을 하였었습니다.
- 추후에 페이지가 넘어가거나, 혹은 다른 정보를 불러오고 싶을 때는 기존의 문자열에서 다른 `QueryItem`과 `Path`가 필요하였습니다.
- 때문에 직접 하드코딩방식으로 URL을 불러오는 방식이 아닌 유동적으로 URL을 불러오는 방법이 필요하였습니다.

**해결 🔥**
- URL의 구성요소인 URLComponent 구조체를 확장하여 `createURL(path:,queryItem:)` 이라는 파라메터로 주어진 path와 QueryItem으로 URL을 Return하는 타입메서드를 구현하였습니다.
```swift 
static func createURL(path: String?, queryItem: [URLQueryItem]?) -> URL? {
    ...
}
```
- 그리고 NetworkRequest라는 enum 타입을 생성하여 작업 case에 맞는 URL들을 반환하도록 구현하였습니다.
- 내부적으로 어떻게 유동적으로 path와 queryItem에 대한 값을 전달할 것인지는 조금더 고민이 필요할 것 같습니다.


</details>


### 🔥 프로토콜에 정의한 dataTask()를 실제로 동작하게 만드는 방법
    
<details>
<summary> 
펼쳐보기
</summary>
    
```swift
protocol URLSessionProtocol {
    func dataTask(with request: ...,
                  completionHandler:
                  @escaping (...) -> Void) -> URLSessionDataTaskProtocol
}

extension URLSession: URLSessionProtocol {
    func dataTask(with request: ...,
                  completionHandler:
                  @escaping (...) -> Void) -> URLSessionDataTaskProtocol {
        return dataTask(with: request, completionHandler: completionHandler) as URLSessionDataTask
    }
}
```
**문제 👀**
- Mock Test를 하기 위해 실제 사용되는 URLSession과 Test시 사용될 `MockURLSession`을 `URLSessionProtocol`이라는 프로토콜을 채택하여 사용하였습니다.
- 그리고 해당 Protocol에서 공통적으로 사용되는 메서드인 dataTask()메서드를 정의하고 반환값으로 기존의 `URLSessionDataTask`가 아닌 `URLSessionDataTaskProtocol`을 반환하게 하였습니다.
- 그리고 실제로 이 메서드를 구현해야할 때, 진짜 `URLSession`이 이 메서드를 사용할 때 어떻게 `dataTask()`기능을 동작하게할까? 라는 고민이 있었습니다. 

**해결 🔥**
- `URLSessionDataTaskProtocol`을 반환하는 프로토콜에 정의한 `dataTask()`의 return 값으로 실제 존재하는 dataTask()메서드를 호출하였습니다. 
- 그리고 `URLSessionDataTask`타입이라는 것을 업캐스팅을 통해 명시하여 해결하였습니다.
    
</details>
    
### 🔥 Image 비동기 처리 
    
<details>
<summary> 
펼쳐보기
</summary>
    
**문제 및 해결 🔥**
- Image를 로드해올때 버벅이는 현상이 있었습니다. 
- 원인은 이미지를 서버로부터 load해오는 작업과 image를 그려주는 작업이 동일한 `Main Thread`에서 동작하기 때문이었습니다.
- 때문에 이미지를 서버로부터 가져오는 작업은 `global().asnyc`로 실행을 하였고, 비동기 내부에서 image를 대입하는 작업(UI를 그리는 작업)은 다시 `Main Thread`로 보내주어서 해결할 수 있었습니다.
    
```swift

// NetworkManager.swift
DispatchQueue.global().async {
    guard let data = try? Data(contentsOf: imageURL),
        let image = UIImage(data: data) else { return }   
    completionHandler(image)
}

// MainViewController.swift
NetworkManager.fetchImage(with: data.thumbnail) { image in
    DispatchQueue.main.async {                
    if indexPath == collectionView.indexPath(for: cell) {
        ImageCacheManager.shared.setObject(image, forKey: cacheKey)    
        // ex) cell.image = image
        }
    }
}
```
    
</details>

### 🔥 Image 표기 시 Image가 변경되는 이슈
    
<details>
<summary> 
펼쳐보기
</summary>
    
**문제 👀**

- 가장 처음에 구현을 하였을때 아래와 같이 구현을 하였고, 이미지 스크롤을 빠르게 내리고 멈추었을 경우 이미지가 바뀌는 오류가 있었습니다.
```swift
// MainViewController.swift
DispatchQueue.main.async { [weak self] in
    if indexPath == collectionView.indexPath(for: cell) {
        guard let data = self?.productData[indexPath.item] else { return }
            cell.setupData(with: data)
    }
}    

// List, GridCollectionViewCell.swift
func setupData(with productData: Product) {
    if let imageURL = URL(string: productData.thumbnail) {
        productImageView.loadImage(url: imageURL)
    }
    ...
}
    
// UIImageView+Extension.swift
func loadImage(url: URL) {
    DispatchQueue.global().async { [weak self] in
        if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
            DispatchQueue.main.async {
                self?.image = image                
            }
        }
    }
}
```
- 이 코드의 문제점은 `MainViewController`의 `indexPath`와 `collectionView.indexPath(for: cell)`를 비교하는 문장의 위치였습니다.

- 위와 같은 코드는 비동기이기 때문에 어떤 경우던지 저 조건문을 통과하게 됩니다. 
- 그렇기 때문에 빠르게 스크롤할 경우 재사용되는 하나의 셀에 이미지를 올리는 작업들이 쌓이게 되고 스크롤을 멈추면 셀에 그동안 쌓였던 작업들이 실행되면서 이미지들이 계속 바뀌게 됩니다. 또한 비동기이기 때문에 최종적으로 올라가야하는 이미지 또한 바뀌게 될수 있는 문제가 있었습니다.
    
**해결 🔥**
    
- 이미지을 받아오는 fetchImage()라는 메서드를 NetworkManager에 새롭게 구현하였습니다.
그리고 이미지가 모두 받아져오면 completionHandler로 image를 전달해주었습니다.
    
```swift
// NetworkManager.swift
func fetchImage(with stringURL: String, completionHandler: @escaping (UIImage) -> Void) {
    guard let imageURL = URL(string: stringURL) else { return }
        
    DispatchQueue.global().async {
        guard let data = try? Data(contentsOf: imageURL),
            let image = UIImage(data: data) else { return }
            
        completionHandler(image)
    }
}
    
// MainViewController.swift
networkManager.fetchImage(with: data.thumbnail) { image in
    DispatchQueue.main.async {
        if indexPath == collectionView.indexPath(for: cell) {
            productImageView.image = image
        }
    }
}
```    
- 이미지를 바꾸기 직전에 indexPath와 현재 collectionView의 indexPath와 비교하여 이미지를 넣어주었습니다.
- 여러 이미지들이 로드되는 동작 자체를 없앨 수는 없지만 이렇게 한다면 스크롤을 빠르게 내렸을때 이미지가 올라온 후에 이미지가 다시 바뀌는 이슈를 해결할 수 있었습니다.
    
    
</details>



### 🔥 레이블 변경 로직 
    
<details>
<summary> 
펼쳐보기
</summary>
    
**문제 👀**
    
| 할인가격Label 추가 | 정가 판매 |
|:--:|:--:| 
|![](https://i.imgur.com/y71yJPq.png)|![](https://i.imgur.com/VTfQGL3.png)|

- 위의 그림과 같이 할인하는 경우 할인된 가격`Label`을 추가해야했습니다.
- 처음의 방법은 할인률이 존재한다면 할인된 가격`Label`을 `addSubView` 하고, `prepareForReuse()`에서 해당 할인 가격 Label을 remove해주는 방식으로 구현을 했습니다. 
- 하지만 이렇게 `Cell` 마다 `View`를 그려주고 `remove` 해준다면 상당한 리소스가 요구될 것이고 앱의 동작에 부담이 갈것이라고 생각하고 다른 방안을 생각했습니다.
    
**해결 🔥** 
- 해당 뷰를 `Hidden`처리하는 방식을 선택했습니다.
- 아래 처럼 할인률이 없는 경우는 할인가격을 `Hidden`처리하고 그렇지 않은 경우은 그대로 할인 `Label`을 보여주도록 하였습니다.
```swift
private func setupPriceLabel() {
    if discountPrice == Double.zero {
        productSalePriceLabel.isHidden = true
    } else {
    ...    
}
    
private func clearPriceLabel() {
    productPriceLabel.isHidden = false
    productPriceLabel.textColor = .gray
    productPriceLabel.attributedText = .none
}
```   
</details>

### 🔥 Pagination 중복 데이터를 로드해오는 이슈
    
<details>
<summary> 
펼쳐보기
</summary>

**문제 👀**
메인화면에서 스크롤 바를 내리면, 이미 받아온 데이터를 포함하여 다시 전체 데이터를 로드해오는 문제가 있었습니다. 그래서 스크롤이 아래로 내려갈수록, 이전보다 더 많은 양의 데이터를 다시 받아와야 했기때문에 로드시간이 점점 더 길어졌습니다. 

**해결 🔥**
- `MainViewController`에서 추가로 보여줄 데이터만 받아와서 기존 데이터에 추가하는 방법으로 해결하였습니다.
- 기존에는 `itemsPerPage`라는 데이터를 몇개 불러올 것인지에 대한 프로퍼티를 스크롤을 내릴때 늘려주었다면 변경 후에는 `pageNo`라는 페이지를 넘겨서 기존에 받은 데이터는 받아오지 않도록 구현하였습니다.
- 그리고 빠르게 스크롤할 경우에 데이터를 로드해오는 메서드가 매우 여러번 호출되는 문제가 남아있었습니다. 
- 데이터를 로드해오는 메서드 내부에 `ScrollState`라는 플래그를 구현하여 로드 중인 경우에는 메서드가 호출되지 않도록 구현하고 데이터를 가져오는 비동기처리 부분에서 하나라도 완료가 된다면 idle상태로 변경하여 호출가능하도록 하였습니다.
- 이렇게 플래그를 사용함으로써 스크롤을 빠르게 내리는 동안에는 데이터를 불러오지 않게 구현하였습니다.
    

</details>

### 🔥 상품등록 CollectionViewCell 내부 Button의 Action 전달
    
<details>
<summary> 
펼쳐보기
</summary>

**문제 👀**
    
상품등록하는 화면의 `CollectionViewCell`의 이미지 추가 버튼을 누르게 되면 상품등록`ViewController`의 `PHPickerView`가 나타나야 했습니다.
하지만 Cell객체를 `ViewController`내부에서 가지고 있는 부분은 `UICollectionViewDataSource` 프로토콜을 채택받아 생성해야만하는 메서드들 밖에 없었습니다.

**해결 🔥**
- Delegate 패턴을 사용하였습니다. Cell 내부에 `buttonDelegate`라는 위임자를 생성해놓았습니다.
- `AddViewController`의 `cell.buttonDelegate = self`가 여러번 호출되는 문제는 남아있지만 의존성 문제를 피해갈수 있었습니다. 
    
```swift
// ImageCollectionViewCell.swift
protocol ImageCollectionViewCellDelegate: AnyObject {
    func imageCollectionViewCell(_ isShowPicker: Bool)
}

final class ImageCollectionViewCell: UICollectionViewCell {
    weak var buttonDelegate: ImageCollectionViewCellDelegate?
    ...
    @objc func ...() {
        buttonDelegate?.imageCollectionViewCell(true)
    }
}
    
// AddViewController.swift
func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = ... {
    ...
    }
    cell.buttonDelegate = self
    ...
}
```
    

</details>

### 🔥 UIViewController을 확장하여 Alert 재사용 확대
    
<details>
<summary> 
펼쳐보기
</summary>

**문제 👀**
- POST, PATCH, DELETE를 한 후에 서버에서의 응답에 따른 성공 Alert, 오류 Alert를 나타내야 했고, Alert의 Action으로 전화면으로 돌아가거나 현재의 화면에 그대로 머물러 있어야 했습니다.

**해결 🔥**
UIViewController을 Extension하여 저희가 사용하고자하는 Alert의 형태를 만들었으며, completion을 사용하여 Alert Action 그 이후의 동작도 Custom하게 정의해 줄 수 있었습니다.

```swift
extension UIViewController {
    func showAlert(alertText: String, alertMessage: String, completion: (() -> (Void))?) {
        let alert = UIAlertController(title: alertText, message: alertMessage, preferredStyle: .alert)
        let confirm = UIAlertAction(title: "확인", style: .default) {  _ in
            if let completion = completion {
                completion()
            }
        }
        alert.addAction(confirm)
        self.present(alert, animated: true)
    }
}

```

</details>


    
## 일일 스크럼

[일일 스크럼 바로가기](https://github.com/KyoPak/ios-open-market/wiki/Scrum)

## 참고 링크

[공식문서]
- [Swift Language Guide - URLSession](https://developer.apple.com/documentation/foundation/urlsession)
    
- [Fetching Website Data into Memory](https://developer.apple.com/documentation/foundation/url_loading_system/fetching_website_data_into_memory)
    
- [URL Loading System](https://developer.apple.com/documentation/foundation/url_loading_system)
    
- [URLSessionDataTask](https://developer.apple.com/documentation/foundation/urlsessiondatatask)
    
- [Swift Language Guide - Closure - Escaping Closures](https://docs.swift.org/swift-book/LanguageGuide/Closures.html)

- [UICollectionView](https://developer.apple.com/documentation/uikit/uicollectionview/)

- [NSURLCache](https://developer.apple.com/documentation/foundation/nsurlcache/)

- [UIActivityIndicatorView](https://developer.apple.com/documentation/uikit/uiactivityindicatorview/)

- [Data Entry - iOS - Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/patterns/entering-data/)

