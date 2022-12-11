# 🏪 오픈 마켓

- 서버와 네트워킹하여 마켓의 상품들을 받아와 보여주는 어플입니다.

## 📖 목차
1. [팀 소개](#-팀-소개)
2. [기능 소개](#-기능-소개)
3. [Diagram](#-diagram)
4. [폴더 구조](#-폴더-구조)
5. [타임라인](#-타임라인)
6. [프로젝트에서 경험하고 배운 것](#-프로젝트에서-경험하고-배운-것)
7. [트러블 슈팅](#-트러블-슈팅)
8. [참고 링크](#-참고-링크)

## 🌱 팀 소개
 |[inho](https://github.com/inho-98)|[Hamo](https://github.com/lxodud)|[Jeremy](https://github.com/yjjem)|
 |:---:|:---:|:---:|
| <a href="https://github.com/inho-98"><img width="180px" src="https://user-images.githubusercontent.com/71054048/188081997-a9ac5789-ddd6-4682-abb1-90d2722cf998.jpg"></a>| <a href="https://github.com/lxodud"><img width="180px" src="https://i.imgur.com/ydRkDFq.jpg"></a>|<a href="https://github.com/yjjem"><img width="180px" src="https://i.imgur.com/RbVTB47.jpg"></a>|

## 🛠 기능 소개

|<img src="https://i.imgur.com/wqyWvRe.gif" width=180>|<img src="https://i.imgur.com/gyog05D.gif" width=180>| <img width="180px" src="https://i.imgur.com/G0zbobk.gif">|
|:-:|:-:|:-:|
|리스트 스크롤 화면|리스트와 그리드 화면 전환|그리드 스크롤 화면|

|<img src="https://i.imgur.com/nrZp4Ow.gif" width=180>|<img src="https://i.imgur.com/qqYShuX.gif" width=180>| <img width="180px" src="https://i.imgur.com/rz0aGIy.gif">|
|:-:|:-:|:-:|
|상품 등록 화면|키보드 타입와 화면 이동|이미지 추가 및 삭제버튼 구현|


## 👀 Diagram

|<img width=900, src="https://i.imgur.com/GDJh1Su.png">|
|---|

## 🗂 폴더 구조
```
OpenMarket
├── Model
│   ├── Error
│   │   ├── NetworkError.swift
│   │   ├── ErrorManager.swift
│   │   └── UserInputError.swift
│   ├── Network
│   │   ├── URLSessionProtocol.swift
│   │   ├── NetworkManager.swift
│   │   ├── UsetInputError.swift
│   │   └── NetworkRequest.swift
│   ├── DTO
│   │   ├── ProductData.swift
│   │   ├── ProductListData.swift
│   │   ├── PostProduct.swift
│   │   ├── Currency.swift
│   │   ├── VendorData.swift
│   │   └── ImageData.swift
│   ├── View
│   │   ├── GridCell.swift
│   │   ├── ListCell.swift
│   │   ├── ProductFormView
│   │   └── RegistrationImageCell.swift
│   ├── Controller
│   │   ├── AppDelegate.swift
│   │   ├── SceneDelegate.swift
│   │   ├── OpenMarketViewController.swift
│   │   ├── ProductRegistrationViewController.swift
│   │   ├── ProductEditViewController.swift
│   │   └── ProductDetailViewController.swift
│   ├── TestDouble
│   │   ├── DummyData
│   │   ├── StubURLSessionDataTask
│   │   └── StubURLSession
│   └── OpenMarketTests
│       ├── StubURLSessionTest
│       └── ProductListDataTest
├── Assets
├── Info.plist
└── README.md
```


## ⏰ 타임라인

|날짜|구현 내용|
|--|--| 
|22.11.15|<`step1` 시작>`ProductData`, `ProductListData`, `VendorData`, `ImageData` `DTO`타입 구현, 네트워킹을 담당할 `NetworkManager`타입 구현, `UnitTest`작성 |
|22.11.16|`OpenMarketError`타입 구현, `TestDouble`을 위한 `Dummuy`,`Stub`구현|
|22.11.17|`StubURLSessionTest`작성, 접근제어 및 파일분리|
|22.11.18|`NetworkManager`열거형에 연관값 적용 및 url에 매개변수 전달, 테스트 코드에 강제언래핑 제거|
|22.11.22|<`step2` 시작> 뷰에 `segemented control` 추가, `ProductCell`클래스 구현 및 `CollectionView`구현|
|22.11.23|이미지를 가져올 네트워킹 메서드 구현, 셀 높이를 수동을 지정하는 `preferredLayoutAttributesFitting`메서드 재정의, `cell`의 텍스트에 `attributedString` 적용, `GridCell`클래스 구현, 컬렉션뷰에 grid레이아웃 추가, 셀을 구성하는 메서드의 기능 분리|
|22.11.24|상품 추가 뷰를 보여주는 버튼과 액션 구현, `cell`에 이미지 로드 전 로딩 이미지 추가, 클래스에 `final` 적용 및 접근제어 추가|
|22.11.28|컬렉션 뷰의 스크롤이 제일 하단에 도달했을 때 상품을 20개씩 가져오도록 페이지네이션 구현|
|22.11.29|`diffable dataSource`를 사용하고 `CollectionView의 layout`을 변경했을 때 발생하는 버그 수정|
|22.12.01|Post 작업 헤더, 바디를 구성하는 메서드 구현|
|22.12.05|`ProductRegistrationView`, `imagesCollectionView layout`, `RegistrationImageCell` 구현|
|22.12.06|키보드 유무에 따른 UI 업데이트, ProductEditViewController 구현|
|22.12.07|이미지 캐싱, 이미지 리사이징 구현|
|22.12.08|상품 등록시 발생하는 입력 에러 처리, 상품 등록 중 이미지 삭제기능 구현|

<details>
<summary> Details - 구현 내용과 기능 설명 </summary>

### STEP 1-1
#### 1️⃣ `DTO`
- 데이터를 전달받을 타입들을 구현했습니다. 각 타입의 이름 뒤에는 데이터를 전달받을 목적임을 명시하기 위해 `Data`를 포함합니다.
    - `ProductListData`
    - `ProductData`
    - `VendorData`
    - `ImageData`

#### 2️⃣ `DummyData`
- 네트워크와 무관한 테스트를 작성하기 위해 Test Double을 작성

#### 3️⃣ `StubURLSession`
 
### STEP 1-2
#### 1️⃣ `UICollectionViewCompositionalLayout`
- 컬렉션뷰의 레이아웃을 구성할때, `CompositionLayout`객체를 이용하여 구현했습니다.
- 리스트 형식에 `ListConfiguration`와 그리드 형식에 `CompositionalLayout`과 섹션을 이용해서 구현하였습니다.

#### 2️⃣ `ListCell & GridCell`
- `ListCell`은 `UICollectionViewListCell`을 상속받아 `UIListContentView`에서 제공하는 기본 셀 타입의 구성을 이용합니다.
- `GridCell`은 커스텀 셀로 필요한 뷰들을 요구사항과 일치하게 구성합니다.

#### 3️⃣ `UICollectionView.CellRegistration`
- `CellRegistration`을 이용하여 컬렉션뷰에 셀을 등록하고, 각 셀을 구성하는 역할을 수행합니다. 제네릭타입으로 전달한 셀과 데이터 타입으로 셀을 구성하고, `registration`핸들러에서 셀의 프로퍼티에 값을 지정합니다.

#### 4️⃣ `UICollectionViewDiffableDataSource`
- 컬렉션뷰의 데이터 소스 객체로는 `DiffableDataSource`를 이용하였습니다.

### STEP 2-1
#### 1️⃣ `ProductFormView`
- 상품 등록과 상품 수정에 사용되는 양식을 구현한 뷰입니다.
    - 추가될 이미지와 이미지 추가 버튼을 `imagesCollectionView`와 `cell`로 보여줍니다.
    - 상품의 이름, 가격, 재고 등을 `textField & textView`로 입력받습니다.
    - 전체 요소들을 `scrollView`안에 포함하여 컨텐츠가 화면을 초과하면 스크롤 가능하도록 구현하였습니다.

#### 2️⃣ `ProductRegistrationViewController`
- 상품 등록을 위한 뷰컨트롤러 입니다.
    - 뷰에 입력받은 요소들을 확인하고, 조건이 충족된다면 `Done`버튼을 눌렀을때 상품 등록하는 `registerProduct`메서드가 실행됩니다.

#### 3️⃣ `ProductEditViewController`
- 상품 수정을 위한 뷰컨트롤러입니다.
    - 상품 등록과 같은 양식으로 이루어진 뷰를 보여주지만, 초기화면의 셀을 눌렀을때 해당 셀의 상품 정보를 이미지, 텍스트필드 등에 추가한 상태로 보여지게 됩니다.
    - 수정과 삭제 과정은 개인벤더 정보와 일치할때 진행할 수 있다고 생각하여, 현재에는 `Done`버튼에 액션을 추가하지 않았고 다음 스텝에서 기능을 구현할 예정입니다.

</details>

## ✅ 프로젝트에서 경험하고 배운 것
- CompositionalLayout을 이용한 리스트 구현  
    ☑️ UICollectionLayoutListConfiguration  
    ☑️ UICollectionViewListCell  
    ☑️ preferredLayoutAttributesFitting  
    ☑️ UICollectionViewDiffableDataSource  
- CompositionalLayout을 이용한 그리드 구현  
    ☑️ UICollectionViewCell  
    ☑️ UICollectionViewCompositionalLayout  
    ☑️ UICollectionViewDiffableDataSource  
- Segmented Control 적용과 활용  
    ☑️ UISegmentedControl  
    ☑️ addTarget  
- Post  
    ☑️ `multipart/form-data`의 구조 파악  
    ☑️ `http request` 구조 파악  
    ☑️ `uploadTask` 메서드 사용  
- Caching  
    ☑️ `NSCache`  
    ☑️ `URLCache`
- Keyboard 유무에 따라 동적으로 UI업데이트  
    ☑️ `Notification Center`  
    ☑️ `ImagePickerController`  
    ☑️ 텍스트필드의 입력값에 따른 키보드 설정  
    ☑️ 스크롤뷰의 `Content Inset`  
     
## 🚀 트러블 슈팅
## STEP 1-1
### 1️⃣ 로컬의 JSON (테스트할때 사용할)키 값과 API문서 상의 키 값이 다른 문제
|<img src="https://i.imgur.com/4Kl6HGR.png" width="300px"/> | <img src="https://i.imgur.com/cpGzC9E.png" width=500px/>|
|:-:|:-:|
|`API문서의 키 값`|`로컬 JSON파일의 키값`|

- 서버(pageNo)와 JSON(page_no)의 현재 페이지 번호의 key값이 일치하지 않는 문제점이 있었습니다. 
코딩키를 `pageNO`로 작성하면 `JSON`파일을 디코딩할 수 없었습니다.
이를 해결하기 위해 서버의 키와 JSON키 모두 `camelCase`로 변환하는 프로퍼티를 사용했습니다.

    ```swift
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase                 
    ```
해당 프로퍼티를 사용함으로써 아래와 같이 들어오는 `vendor_id` 키 값을 카멜케이스로 변환하여 원하는 케이스 네임으로 수정할 수 있었습니다.
|||
|--|--|
|API문서의 키|![](https://i.imgur.com/gFcg0AL.png)|
|코드로 구현한 키|`case vendorIdentifier = "vendorId"`|

### 2️⃣ 같은 상품 상세에 대해서 요구하는 키값이 서로 다른 문제
- 서버에 상품 리스트 조회, 상품 상세 조회 두 가지 요청을 보낼 때 받아오는 JSON파일의 키가 일치하지 않아서 ProductData DTO를 중복으로 사용하였을 때 디코딩이 되지 않는 문제가 있었습니다.
- `ProductList`에서는 `Product`의 `description`과 `vendorName`을 요구하고,
`Product`상세에서는 `images`와 `vendors`를 요구하는 부분을 어떻게 해결할지 고민후에 겹치지 않는 키에 해당하는 프로퍼티를 옵셔널 처리하여 해결하였습니다.

  ```swift
  struct ProductData: Decodable {    
      ...
      let vendorName: String?
      let description: String?
      let images: [ImageData]?
      let vendors: VendorData?
  }
  ```

### 3️⃣ 비동기로 동작하는 `dataTask`가 끝난 시점에 데이터를 받는 방법
- `NetworkManager`의 `loadData`메서드 내부에서 호출하는 `dataTask` 메서드는 파라미터인 `completionHandler`를 이용하여 `data, response, error`를 받을 수 있는데 비동기적으로 동작하기 때문에 끝나는 시점을 알수없어서 받아온 데이터를 어떻게 전달할지 고민이었습니다.
- `loadData의` 파라미터로 `escaping closure`를 받아서 `dataTask`의 `completionHandler`가 해당 클로저를 캡처하여 비동기적으로 작업이 끝난 시점에 캡처한 클로저를 호출하는 방법으로 해결하였습니다.

    ```swift
    func loadData<T: Decodable>(of request: NetworkRequest,
                                dataType: T.Type,
                                completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = request.url else { return }

        session.dataTask(with: url) { data, response, error in
            ...

            do {
                ...
                let data = try decoder.decode(T.self, from: data)
                completion(.success(data))
            } catch {
                completion(.failure(OpenMarketError.failedToParse))
            }
        }.resume()
    }
    ```


### 4️⃣ `Test Double`에서의 코드 흐름과 테스트를 위해 구현한 타입들
- 네트워크가 없는 환경에서도 테스트를 수행하기 위해서 네트워킹을 수행하는 `URLSession`과 `URLSessionDataTask`대신하는 `Stub`객체를 구현했습니다. 그래서 `DummyData`를 만들어놓고 이를 `dataTask`의 `completionHandler`까지 전달합니다.

    ```swift
    //테스트 코드 예시
    func test_productListData를받았을때_전달받은값을_리턴해야한다() {
        //given
        guard let url = NetworkRequest.productList.url else { return }

        let expectedData = """
                        {
                            ...
                            "totalCount": 116,
                            ...
                            
                            """.data(using: .utf8)
        let response = HTTPURLResponse(url: url,
                                       statusCode: 200,
                                       ...)
        let dummyData = DummyData(data: expectedData,
                                  response: response,
                                  error: nil)
        stubUrlSession.dummyData = dummyData

        //when
        sut.loadData(of: NetworkRequest.productList,
                        dataType: ProductListData.self) { result in
            switch result {
            case .success(let productListData):
            //then
                XCTAssertEqual(productListData.totalCount, 116)
            case .failure(let error):
                XCTFail("loadData failure: \(error)")
            }
        }
    }
    ```
    
    - 위 예시에서, 받아올 것이라고 예상되는 데이터를 작성하고, 응답이 성공한다고 가정해서 성공하는`response`를 작성하였습니다. 이 정보들을 `dummyData`에 포함하여 가짜 객체인 `stubUrlSession`에 전달하고, `NetworkManager`의 `loadData`메서드를 호출해서 의도한 결과와 일치하는지 확인합니다.
## STEP 1-2
### 1️⃣ 모던 컬렉션뷰를 이용한 컬렉션뷰 구현
- 컬렉션 뷰를 구현할때, `flowLayout`과 `dataSource` 대신, `composableLayout`과 `diffableDataSource`를 이용해서 구현하였습니다. 
- `snapshot`은 뷰의 데이터의 특정 시점의 상태를 나타내고 섹션별로 나누어서 원하는 섹션과 아이템으로 구성하고, `dataSource`의 `apply`메서드를 이용하여 `snapshot`의 데이터를 현재 `state`와 새 state를 비교하여 업데이트합니다.
- 애플의 `Implementing Modern Collection Views`를 기반으로 `Customize List Cells`를 구현하려했습니다. 
- 이때 `custom`한 `state`를 만들어서 활용할 수 있는데, 이번 프로젝트에서는 셀에서 선택, 하이라이트, 이동 등의 상태에 따른 변경이 없어서 `custom state`를 사용할 필요성이 없다고 생각하여 제외하였습니다.

### 2️⃣ `UICollectionViewListCell`의 크기를 커스텀으로 지정하는 방법
- `list`형태의 `collectionView`를 `cell`이 기본적으로 제공하는 레이아웃을 이용하여 아래 코드처럼 간편하게 만들었습니다.
그런데 셀이 `self-sizing`을 하여서 클릭되었을 때 의도치 않게 높이가 늘어나는 문제가 발생했습니다.
이를 셀이 레아이웃에 전달되기 전에 수동으로 크기를 조절할 수 있도록 하는`preferredLayoutAttributesFitting()` 메서드를 이용해서 커스텀한 `cell size`를 정해주어 해결하였습니다.
    ```swift
    let configure = UICollectionLayoutListConfiguration(appearance: .plain)
    let layout = UICollectionViewCompositionalLayout.list(using: configure)
    ```

### 3️⃣ 세그먼트 컨트롤을 이용하여 화면전환시 컬렉션뷰가 중첩되는 문제
|<img src="https://i.imgur.com/orXxNVB.jpg" width=600>|
|--|
- 세그먼트 컨트롤의 값에 따라 `grid` 레이아웃, `list` 레이아웃을 가지는 컬렉션 뷰를 다시 그려서 `viewController의` `root view`에 `addSubview`하여 화면이 전환되도록 구현했습니다.
- 이때 기존에 있던 `collectionView`가 사라지지 않고 중첩되는 문제가 있었습니다.
- `productCollectionView` 변수에 새로운 `collectionView`를 할당하기 때문에 참조가 사라져서 `deinit`될거라 생각했는데 `UIView의` `addSubView`를 사용하면 추가한 뷰를 강하게 참조하여서 `deinit`되지 않는다는 점을 확인하고, 자신을 상위 뷰로부터 해제하는 `removeFromSuperview()` 메서드를 사용하여 해결하였습니다.

### 4️⃣ 셀을 빠르게 스크롤했을때 셀의 데이터와 일치하지 않는 이미지가 로드되는 문제
- 네트워킹을 통해서 셀의 이미지를 서버에서 가져오는데 빠르게 스크롤했을 때 셀의 이미지가 여러번 바뀌는 문제가 있었습니다.
- 셀이 재사용될 때마다 이미지를 가져오는 작업이 생성되고 여러개의 작업들이 끝날때마다 셀의 이미지를 바꾸기 때문에 발생하는 문제였습니다.
- 네트워킹 작업을 생성하는 시점의 `indexPath`와 현재 `cell`의 `indexPath`를 비교하여 두 값이 같은 경우에만 이미지를 변경하여 해결하였습니다.
    ```swift
    if indexPath == self.productCollectionView.indexPath(for: cell) {
        cell.imageView.image = image
    }
    ```
### 5️⃣ `Diffable Datasource` 인스턴스를 만들 때 클로저 내부에서 `Cell Registration`을 생성할 때 발생하는 에러
![](https://i.imgur.com/OS0QY97.png)
- `CellRegistration을 diffabel datasource` 클로저 내부에서 만들면 위 그림과 같은 에러가 발생한다.
- 이 부분에 대해서 `UICollectionView.CellRegistration` 공식문서에 명시되어 있는데 아래 그림과 같다.

![](https://i.imgur.com/evOUc3i.png)
- 따라서 외부에서 `CellRegistration` 인스턴스를 생성하고 클로저 내부에서 사용하여 문제를 해결하였다.
    
## STEP 2-1
### 1️⃣ 상품 등록을 위한 `PostData`메서드 구현
- 상품 정보에 이미지 파일을 포함하고 있기 때문에 `POST`와 `multipart/form-data`형식을 이해해야 했습니다.
- 형식에 맞게 `request`의 헤더와 바디를 구성하고, 이미지를 데이터 형식으로 바디에 추가한 후 이를 `uploadTask`메서드의 매개변수로 전달합니다. (`request & data`)

### 2️⃣ 상품 등록 화면에서 사진 개수에 따른 `imagePicker` 구현?
- 상품 등록 화면에서 사진을 선택하기 위한 방법으로 `phpickerViewController`와 `imagePickerViewController` 2가지가 있습니다.
- 요구사항에 선택된 사진을 `crop`하는 기능이 추가되어야 하는데 `phpickerViewController`의 경우 `crop` 기능이 없기 때문에 `imagePickerViewController`를 선택하였습니다.

### 3️⃣ 키보드 높이만큼 스크롤뷰 올리기
- 텍스트뷰에 입력을 할 때 키보드가 올라와서 화면을 가리는 문제가 있어서 키보드가 올라왔을 때 키보드 높이만큼 `scrollView`의 `contentOffSet`을 높여주었습니다.
- `contentOffSet`을 조절하여도 `content`의 `height`가 증가하는게 아니기 때문에 스크롤하거나 타이핑을 하거나 스크롤했을 때 `contentOffSet`이 이전으로 변하는 문제가 발생했습니다.
- `scrollView`의 `contentInset`을 이용하여 키보드가 올라올 때 그 높이 만큼의 여백을 주고 내려갈 때 다시 0으로 만들어주어서 해결하였습니다.

### 4️⃣ 상품 등록, 수정 뷰에서 텍스트 필드, 텍스트 뷰를 제외한 곳을 터치했을 때 키보드 내리기
- 터치 이벤트가 `responder chain`을 타고 내려오기 때문에 `viewController`에서 이벤트를 처리하는 `touchBegan`을 재정의하여 내부에서 `endEditing`을 호출하려 하였는데 특정 부분에서는 `viewController`가 이벤트를 처리하지 못하는 상황이 발생하였습니다.
- 해당 뷰에서 `viewController`위에 `scrollView`가 있게 그 위에 `contentView`가 있는 계층이었고 터치 이벤트를 `scrollView`가 가져가기 때문에 `viewController`에서 이벤트를 처리하지 못하는 문제임을 파악하고 `scrollView`에 `gesture`를 추가하여 터치 이벤트가 발생했을 때 `endEditing`하도록 하였습니다.

### 5️⃣ 유저의 입력을 확인하는 과정 및 POST 시도 제한
- `ProductFormView`에서 각각의 `TextField`의 요구사항 충족 및 타입을 확인하는 연산 프로퍼티를 구현했습니다.
- 상품 등록 조건을 충족하지 않으면 `nil`을 반환하도록하여 값이 `nil`이면 `POST`가 진행되지 않도록 구현했습니다.
```swift
var nameInput: String? {
    guard let text = productNameTextField.text,
          (3...100).contains(text.count) else { return nil } //글자수 제한
        return text
    }
}
...
```

### 6️⃣ `Done`버튼을 여러번 눌러 중복 `POST`되는 현상과 `POST`가 완료된 후에 `dismiss`작업
- `Done` 버튼을 여러번 누르면 한 게시물이 여러번 등록되는 문제가 있었습니다. 
- 이를 해결하기 위해 POST가 진행될 때 버튼이 한번 눌리면 `button`의 `isEnabled` 프로퍼티를 이용해서 비활성화 되도록 구현하였습니다.
- 상품 등록화면은 등록이 성공적으로 진행된 후에 내려가야 한다고 생각하여, 업로드를 수행하는 `postData`에 `completion handler`를 추가하여 작업이 완료된 후에 `dismiss`하도록 구현하였습니다.
```swift
networkManager.postData(request: request, data: data) {
    DispatchQueue.main.async {
        self.dismiss(animated: true)
    }
}
```



## 🔗 참고 링크

[공식문서]
- [📎 Closure](https://docs.swift.org/swift-book/LanguageGuide/Closures.html)
- [📎 URLSession](https://developer.apple.com/documentation/foundation/urlsession)
- [📎 URLSessionDataTask](https://developer.apple.com/documentation/foundation/url_loading_system/fetching_website_data_into_memory/)
- [📎 dataTask(with:completionHandler:)](https://developer.apple.com/documentation/foundation/urlsession/1410330-datatask/)
- [📎 uploadTask(with:from:completionHandler:)](https://developer.apple.com/documentation/foundation/urlsession/1411518-uploadtask)
- [📎 Fetching Website Data into Memory](https://developer.apple.com/documentation/foundation/url_loading_system/fetching_website_data_into_memory)
- [📎 Uploading Data to a Website](https://developer.apple.com/documentation/foundation/url_loading_system/uploading_data_to_a_website)
- [📎 Implementing Modern Collection Views](https://developer.apple.com/documentation/uikit/views_and_controls/collection_views/implementing_modern_collection_views)
- [📎 NSCache](https://developer.apple.com/documentation/foundation/nscache)
- [📎 URLCache](https://developer.apple.com/documentation/foundation/urlcache)
- [📎 URLCache.StoragePolicy](https://developer.apple.com/documentation/foundation/urlcache/storagepolicy)
- [📎 NSURLRequest.CachePolicy](https://developer.apple.com/documentation/foundation/nsurlrequest/cachepolicy)
- [📎 NSURLRequest.CachePolicy.useProtocolCachePolicy](https://developer.apple.com/documentation/foundation/nsurlrequest/cachepolicy)
- [📎 UIImagePickerController](https://developer.apple.com/documentation/uikit/uiimagepickercontroller)
- [📎 PHPickerViewController](https://developer.apple.com/documentation/photokit/phpickerviewcontroller)




[WWDC]
- [📎 Modern cell configuration](https://developer.apple.com/videos/play/wwdc2020/10027/)
- [📎 List in Collection View](https://developer.apple.com/videos/play/wwdc2020/10026)
- [📎 Advances in UICollectionView](https://developer.apple.com/videos/play/wwdc2020/10097/)
- [📎 Advances in Collection View Layout](https://developer.apple.com/videos/play/wwdc2019/215)

[그 외 참고문서] 

- [📎 개발자 소들이 - closure와 @escaping 이해하기](https://babbab2.tistory.com/164)
- [📎 jessesquires - why optional closures in Swift are escaping](https://www.jessesquires.com/blog/2018/06/10/why-optional-swift-closures-are-escaping/)
- [📎 클로저 정복하기(3/3)](https://babbab2.tistory.com/83)
- [📎 Mock을 이용한 UnitTest](https://sujinnaljin.medium.com/swift-mock-%EC%9D%84-%EC%9D%B4%EC%9A%A9%ED%95%9C-network-unit-test-%ED%95%98%EA%B8%B0-a69570defb41)
- [📎 xUnit Patterns.com - Test Double](http://xunitpatterns.com/Test%20Double.html)
- [📎 Steven Curtis - Stubbing, Mocking or Faking](https://medium.com/swlh/stubbing-mocking-or-faking-5674a07bc3db)
