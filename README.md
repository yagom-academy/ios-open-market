# 💵 오픈마켓
REST API와의 연동을 통해 간단한 마켓기능을 사용해볼 수 있는 앱입니다.<br>
서버와 통신하여 받아온 마켓판매 리스트를 화면에 보여줍니다.<br>
사용자 기호에 따라 List 형식 또는 Grid 형식으로 상품리스트를 볼 수 있습니다.<br>

</br>

## 📖 목차
1. [팀 소개](#-팀-소개)
2. [기능 소개](#-기능-소개)
3. [Class Diagram](#-class-diagram)
4. [폴더 구조](#-폴더-구조)
5. [프로젝트에서 경험하고 배운 것](#-프로젝트에서-경험하고-배운-것)
6. [타임라인](#-타임라인)
7. [고민한 부분](#-고민한-부분)
8. [트러블 슈팅](#-트러블-슈팅)
9. [참고 링크](#-참고-링크)

</br>

## 🌱 팀 소개
 |[mene](https://github.com/JaeKimdev)|[써니쿠키](https://github.com/sunny-maeng)|
 |:---:|:---:|
| <img width="180px" img style="border: 2px solid lightgray; border-radius: 90px;-moz-border-radius: 90px;-khtml-border-radius: 90px;-webkit-border-radius: 90px;" src="https://avatars.githubusercontent.com/u/84453688?v=4">| <img width="180px" img style="border: 2px solid lightgray; border-radius: 90px;-moz-border-radius: 90px;-khtml-border-radius: 90px;-webkit-border-radius: 90px;" src="https://avatars.githubusercontent.com/u/107384230?v=4">|

</br>

## 🛠 기능 소개
- step3 진행 후, 화면 gif생성 update 예정입니다

</br>

## 👀 Class Diagram
|Model |
| :-------------------------------------------: |
| <img src = "https://i.imgur.com/Hogo141.png"> |


</br>

## 🗂 폴더 구조
```
├── OpenMarket
│   ├── AppDelegate.swift
│   ├── Assets.xcassets
│   │   ├── loading.imageset
│   │   ├── loading-6356630.png
│   │   └── testData.dataset
│   ├── MockURLSession
│   │   ├── MockHTTPURLResponse.swift
│   │   ├── MockURLSession.swift
│   │   ├── MockURLSessionDataTask.swift
│   │   ├── SampleData.swift
│   │   └── URLSessionProtocol.swift
│   ├── Model
│   │   ├── DataType
│   │   │   ├── Market.swift
│   │   │   └── Page.swift
│   │   ├── Extension
│   │   │   └── DateFormatter+Extension.swift
│   │   ├── ImageCache
│   │   │   └── ImageCacheProvider.swift
│   │   └── URLSession
│   │       ├── Decodable+Extension.swift
│   │       ├── MockURLSession
│   │       ├── NetworkError.swift
│   │       ├── Request.swift
│   │       ├── URLComponents+Extension.swift
│   │       └── URLSessionProvider.swift
│   ├── SceneDelegate.swift
│   ├── View
│   │   └── Base.lproj
│   │       ├── LaunchScreen.storyboard
│   │       └── Main.storyboard
│   └── ViewController
│       ├── Extension
│       │   └── NSMutableAttributedString+Extension.swift
│       ├── MainViewController.swift
│       ├── MarketGridCell.swift
│       ├── MarketGridViewController.swift
│       ├── MarketListCell.swift
│       └── MarketListViewController.swift
└── UnitTest
    ├── DecodeTests
    │   └── DecodeTests.swift
    └── MockURLSessionTests
        └── MockURLSessionTests.swift
```

</br>

## ✅ 프로젝트에서 경험하고 배운 것
- **JSONData 파싱**
     - [X] 파싱한 JSON 데이터와 매핑할 모델 설계
     - [X] `keyDecodingStrategy`을 사용한 SnakeCase를 CamelCase로 변환하는 디코딩 구현 </br></br>
- **URL Session을 활용한 서버와의 통신**
     - [X] `URLComponents`를 이용해 URL의 Path와 QueryItem을 받아 url 주소 생성
     - [X] `URLSession`과 관련 타입들을 사용해 API생성 및 서버에서 데이터를 받아오는 로직 구현
     - [X] 받아오는 데이터의 HTTPURLResponse, mimeType, error를 체크하면서 `dataTask`생성하는 로직 구현</br></br>
- **Unit Test를 통한 설계 검증**
     - [X] 서버에서 받아오는 데이터와 같은 형식의 테스트용 Asset data를 이용해 `DTO`와 커스텀한 `Decoding` 메서드의 정상동작을 `UnitTest` 진행
     - [X] 네트워크 상태와 무관하게 서버와 통신하는 로직을 테스트할 수 있도록 `Mock`을 이용한 `UnitTest` 진행</br></br>
- **Segment 활용**
     - [X] View 전환에 Segment 활용 </br></br>
- **Modern Collection View 활용**
    - [X] Modern Collection View를 이용한 ListView 이해와 
    - [X] Modern Collection View를 이용한 CollectionView 제작
    - [X] DifferaleData 적용
    - [X] 속성구현의 Configuration관련 타입들 적용 </br></br>

</br>

## ⏰ 타임라인

| 🕛 Step 1|  |
| :--------: | -------- |
| 1 | DTO구현 - JSON 데이터와 매핑할 `Market`, `Page` 타입 구현    |
| 2 | `URLSession`을 사용한 서버와의 통신 로직 구현 | 
| 3 | `Mock`으로 서버 통신 로직을 네트워크 상태와 무관하게 unitTes 진행 | 
<details>
<summary>[Details - Step1 타입별 기능 설명] </summary>

#### 1️⃣ DTO - `Market` 구조체, `Page` 구조체 
- 서버에서 제공되는 JSON파일과 매핑하는 타입입니다.
- STEP1에서는 디코딩만 사용하고 있어서 `Decodable`을 채택하였습니다.

#### 2️⃣ `MarketURLSessionProvider` 클래스
- 서버에서 데이터를 받아오는 기능을 합니다,
- `fetchData(url:, type:, completionHandler:)`메서드
    - `HTTPURLResponse`, `mimeType`, `error`를 확인하고 서버에서 데이터를 받아와 디코딩 합니다.
    
#### 3️⃣ `Request` 열거형
- [HealthChekcer], [상품 리스트 조회], [상품 상세 조회] 데이터를 조회할 수 있는 url주소를 case로 갖고있습니다.

#### 4️⃣ `NetworkError` 열거형
- 서버와의 통신 중 발생가능한 Error를 case로 갖고있습니다.

#### 5️⃣ `URLComponents` extension
- `healthCheckUrl` 메서드
    - 서버와 소통이 정상인지 확인하는 주소인 `healthCheckUrl`을 리턴합니다.
- `marketUrl(path:, queryItems:)` 메서드
    - path와 queryItems를 배열로 받아 Market의 baseUrl을 바탕으로 url 주소를 생성 후 리턴합니다.

#### 6️⃣ `JSONDecoder` Extension
- `decodeFromSnakeCase(type:, from:)`메서드
    - JSON타입의 데이터를 decoding합니다.
    - `decodeFromSnakeCase` 메서드를 구현했습니다.
    - `keyDecodingStrategy`로 `.convertFromSnakeCase`를 적용했습니다.
    - `dateDecodingStrategy`로 `.formatted(DateFormatter.dateFormatter)`를 적용했습니다

#### 7️⃣ MockURLSession
- `URLSessionProtocol`, `MockURLSession` 클래스, `MockURLSessionDataTask`클래스 , `SampleData` 열거형
    - 네트워크 상태와 무관하게 URLSession작동을 확인하는 단위 테스트(Unit Test)에 사용하는 타입 입니다.

#### 8️⃣ Unit Test - `DecodeTests` 클래스, `MockURLSessionTests` 클래스
- `DecodeTests` 클래스
    - 제공된 JSON 데이터를 `Market` 타입으로 Parsing 할 수 있는지에 대한 단위 테스트(Unit Test)입니다.
- `MockURLSessionTests` 클래스
    - `MockURLSession`과 `SampleData`를 이용해 네트워크 상태와 무관하게 URLSession작동이 정상적인지 확인하는 단위 테스트(Unit Test) 입니다.
</details>
<br>

| 🕛 Step 2|                                                |
| :--------: | -------------------------------------------- |
| 1 | View 구현 - `Modern CollectionView`를 활용해 `ListCollectionView`구현  |
| 2 | View 구현 - `Modern CollectionView`를 활용해 2열 N행의 `CollectionView`구현  | 
| 3 | 이미지 다운로드 비동기 처리 & 이미지 다운로드 캐싱작업 구현 | 
<details>
<summary>[Details - Step2 타입별 기능 설명] </summary>

#### 1️⃣ `ImageCacheProvider` 클래스
- 이미지 캐싱을 위해 `NSCache`를 싱글톤으로 구현했습니다.
#### 2️⃣ `MainViewController` 클래스
- 스토리보드로 구현한 MainView를 컨트롤합니다.
- Segment로 제품 리스트를 보여주는 방식을 list 또는 grid로 보여줍니다.
- `setUpSegmentControl()`메서드
    - segment의 배경색과 글자색을 꾸며줍니다
- `changeView(_:)`
    - segment index를 이용해 보여주고싶은 View와 보여지지 않아야 할 뷰를 `isHidden`속성으로 컨트롤합니다.
#### 3️⃣ `MarketListViewController` 클래스
- 서버에서 가져온 마켓의 상품목록을 List 형태로 보여주는 View를 컨트롤합니다.
- `fetchMarketData()` 메서드
    - 서버에서 Market데이터를 다운받고 성공시, ListView를 화면에 보여줍니다.
- `createListLayout()` 메서드
    - List형태의 Layout을 반환합니다.
- `configureListView()` 메서드
    - `createListLayout()`로 만들어진 List형태의 레이아웃을 이용한 ListView를 superView의 전체 사이즈로 씌워줍니다.
- `configureDataSource()`
    - DataSource를 활용해 cell의 컨텐츠를 구성하고 리스트 형태의 뷰에 Cell을 등록 및 snapshot을 찍어놓습니다.
#### 4️⃣ `MarketListCell` 클래스
- ListView에 담길 Cell의 레이아웃과 컨텐츠를 구성합니다
- `configureCell(page:, completionHandler:)` 메서드
    - 상품이미지, 상품이름, 가격, 잔여수량을 Cell의 컨텐츠로 구성합니다.
- `setupLayout()` 메서드
    - Cell의 레이아웃을 구성합니다.
    - 내장되어 있는 `subtitleCell`에 label과 imageView가 담긴 StackView를 추가합니다.
    - 컨텐츠뷰의 오토레이아웃을 구성합니다. 
#### 5️⃣ `MarketGridViewController` 클래스
- 서버에서 가져온 마켓의 상품목록을 Grid 형태로 보여주는 View를 컨트롤합니다.
- `fetchMarketData()` 메서드
    - 서버에서 Market데이터를 다운받고 성공시, 리스트뷰를 화면에 보여줍니다.
- `setupGridLayout()` 메서드
    - 2열 N행 형태의 Layout을 반환합니다.
- `setupGridFrameLayout()` 메서드
    - setupGridLayout() 으로 만들어진 2열 N행 레이아웃을 이용한 GridView를 superView의 전체 사이즈로 씌워줍니다.
- `configureDataSource()` 메서드
    - DataSource를 활용해 cell의 컨텐츠를 구성하고 그리드형태의 뷰에 Cell을 등록 및 snapshot을 찍어놓습니다.
#### 5️⃣ `MarketGridCell`
- `configureCell(page:, completionHandler:)` 메서드
    - 상품이미지, 상품이름, 가격, 잔여수량을 Cell의 컨텐츠로 구성합니다.
- `setupLayout()` 메서드
    - Cell의 레이아웃을 구성합니다.
    - ImageView와 Label 3개를 Vertical StackView로 묶고 Cell의 오토레이아웃을 구성합니다.
#### 5️⃣ `NSMutableAttributedString` Extension
- `strikethrough(string:)` 메서드
    - String에 빨간취소선을 추가하고 글씨 색을 빨간색으로 변환해 NSMutableAttributedString 타입으로 반환합니다
- `normal(string)` 메서드
    - String을 NSMutableAttributedString 타입을 반환합니다.
- `orangeColor(string:)` 메서드
    - String 글씨 색을 오렌지색으로 변환해 NSMutableAttributedString 타입으로 반환합니다.
</details>
</br>

## 💭 고민한 부분

<details>
<summary>[STEP 1 -고민한 부분]</summary>

### 1️⃣ URL의 주소 생성 방법과 네임스페이스
- 주소의 quetyItm과 Path만 변경해서 url을 만드는 방법을 고민했습니다.
- url 주소생성은 `URLComponents`타입을 `extension해` `path`와 `queryItems`를 연결하는 `makeUrl`메서드를 생성했습니다. 
- url의 네임스페이스로 정리할 때 `makeUrl` 메서드를 사용하는데, argument로 주소정보를 전달해줘야하기 때문에 url을 타입 연산 프로퍼티로 정리할지, case로 정리할지 고민했습니다.
- enum의 case에서도 associated Value(연관값)을 사용할 수 있어서 `case productDetail(productNumber: Int)`와 같이 사용한 case로 정리했습니다.

### 2️⃣ JSON snake_case를 CamelCase로 변환하는 방법
- `Coding Key`와 `keyDecodingStrategy`를 사용하는 방법 중, `keyDecodingStrategy`를 사용하여 `convertFromSnakeCase`를 적용하였습니다.

### 3️⃣ 디코딩 메서드 통일
- 처음에는 `에셋의 JSON 파일`에서 디코딩하는 메서드와 `서버에서 받아오는 JSON 파일`을 디코딩 하는 메서드를 분리하여 작성하였다가 `decodeFromSnakeCase`속성을 이용해 하나의 메서드에서 처리하도록 통일했습니다.

### 4️⃣ DecodeTests 유닛테스트 시, 테스트 케이스 내부를 타지 않고 바로 `success`로 반환되는 문제를 해결
- 기제공된 `products.json`파일에서 날짜 관련된 프로퍼티의 타입을 `Date`로 변경하여 주기 위해 `DateFormatter`를 구현하고 사용했는데, STEP 1-2에서 서버와 통신하면서 받아오는 날짜 형식이 달라 `NSDataAsset`을 디코딩하지 못해서 생기는 문제였습니다. ➡️ `Assets`에 등록된 날짜 형식을 서버와 같게 수정하여 주었습니다.

</details>
<br>

<details>
<summary>[STEP 2 -고민한 부분]</summary>

### 1️⃣ 썸네일 이미지의 비동기 작업
- 서버에서 가져오는 썸네일 이미지의 url값을 이용해 사진을 넣어줄 때, `init(contentsOf:)`메서드를 사용해 Data를 가져왔는데 공식문서에 네트워크 기반 URL을 이용해 이 메서드를 사용 할 때는 비동기 작업으로 처리해 주라고 하여 URLSession을 이용한 `fetchImage`메서드를 만들어 비동기로 처리했습니다.

### 2️⃣ 요구사항에 맞춰 List Cell의 `>`의 상단배치

|요구사항|Disclosure<br>이용 시|
|:--:|:--:
|![](https://i.imgur.com/WbKY4EI.png)|![](https://i.imgur.com/XnSpod7.png)|

- 셀의 accessory `disclosure`를 사용 시 셀의 가운데로 표기되고, 위치를 바꿔줄 수가 없었습니다.
- accessory대신 `UIImageView`를 이용해 잔여수량 label과 우측 '>' UIImageView를 `StackView`로 담아주고 Alignment를 `Top`으로 설정해 주었습니다.

### 3️⃣ 한 레이블의 String에 부분적으로 ~~취소선~~과 색상을 바꾸는 방법  
- 세가지 방법을 사용해보고 적용이 가능한 `NSMutableAttributedString` 속성을 사용했습니다
- 첫번째로 `AttributedString`을 extension해 속성을 변경하는 시도를 했습니다.
    ➡️ `AttributedString`과 기본 `String`타입이 맞지않아 한레이블에서 구현이 어려웠습니다.
- 두번째로, `UILabel`을 extention하여 label에 적용하는 방법을 시도했습니다.
    ➡️ GridView에선 사용이 가능했지만 ListView에서는 기본Cell을 사용하다보니 label에 직접 접근할 수 없어 사용이 어려웠습니다.   
- 최종적으론 `NSMutableAttributedString`을 extention하여 취소선과 색상 변경을 하도록 구현했습니다.
  ➡️ 일부만 속성을 변경해줘야 해서, 속성변경이 없는 String타입은 `append`로 연결해 사용했습니다.
    ```swift
    func strikethrough(string: String) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: string)
        attributedString.addAttribute(NSMutableAttributedString.Key.strikethroughStyle,
                                      value: NSUnderlineStyle.single.rawValue,
                                      range: NSMakeRange(0, attributedString.length))
        // ... 위와 동일하게 글씨색을 빨간색으로 바꾸는 속성 부여
        return attributedString
    }

    func normal(string: String) -> NSMutableAttributedString {
        self.append(NSAttributedString(string: string))

        return self
    }
    ```

### 6️⃣ 이미지다운 딜레이의 화면표현방법과 캐싱작업
- 이미지다운의 비동기작업으로 이미지 용량에 따른 각기다른 delay가 있었습니다
- 처음엔 `UIActivityIndicatorView`를 이용해 이미지 로딩을 표현하고 싶었습니다 
    ➡️ `UICollectionViewListCell의` 기본 셀인 `.subtitleCell`을 사용하는 구성이라 addSubView나, View레이블의 접근이 어려웠고, `UIListContentConfiguration`을 이용해 특성을 잡아줘야하는데 이미지뷰대신 indicator를 넣어주려니 타입 문제와, addSubView가 되지않는 문제가 있어 적용하지 못했습니다.
- `LaunchScreen`도 생각해 보았습니다. 처음에 런치스크린을 노출해 주고 데이터를 받아오는 시간을 벌어보려 했는데 보여줄 수 있는 정보는 먼저 보여주는 것이 좋을 것 같아 적용을 보류했습니다.
- 최종적으론, 로딩 image 하나를 Asset으로 등록하여 작업전까지 로딩이미지가 보이도록 처리했습니다
- 더불어 작업 성능을 위해 이미지를 캐싱해놓도록 했습니다.
    
</details>
</br>

## 🚀 트러블 슈팅

### **👣 STEP 1**
### 1️⃣ DTO 타입 재사용
- [상품 리스트 조회]데이터에서 파싱해오는 `Page`타입의 `Key목록`은 [상품 상세조회]페이지에서 파싱해오는 `Page`타입의 Key목록에서 3가지 key가 누락되어있어 `Page`타입의 재사용에 있어 에러가 있었습니다.<br><br>
- ✅ **수정: 옵셔널타입 설정**
    - DTO 재사용을 위해 누락 되어있는 `description` / `images` / `vendor`  Key를 **옵셔널타입**으로 지정해 전자의 경우에서는 파싱하지 않고, 후자의 경우에선 파싱할 수 있게 했습니다.

### 2️⃣ Mock 을 이용한 Network Unit Test에 사용할 SampleData의 mimeType 설정
- `HTTPURLResponse`를 Mock으로 인스턴스를 만들어 유닛테스트를 할 때, mimeType이 `nil`이라 데이터의 mimeType을 확인하는 로직에 걸려 에러가 나는 문제가 있었습니다. 
- mimeType은 get 속성으로 읽기전용이라 인스턴스 생성 후 외부에서 속성값을 주입할 수 없었습니다.<br><br>
- ✅ **수정: override**  
    - HTTPURLResponse를 상속받는 MockHTTPURLResponse타입을 구현해 mimeType프로퍼티를 override해 server에서 파싱해오는 `application/json`의 값을 갖도록했고, MockHTTPURLResponse로 인스턴스를 사용했습니다 <br>
        ```swift
        final class MockHTTPURLResponse: HTTPURLResponse {
            override var mimeType: String {
                return "application/json"
            }
        }
        ```         
       
### 3️⃣ `fetchData(url:, type:, completionHandler:)`메서드로 가져온 서버의 data를 함수 외부로 return하는 법
- 이 메서드는 서버에서 data를 받아오는 기능을 합니다. 즉 호출 시 Data를 return해 줘야하는데 메서드 내부에서 사용되는 핵심 메서드인 dataTask메서드의 CompletionHandler를 사용해야해서 return타입을 구현하는 데 어려움이 있었습니다
    - 우선 URLSession의 dataTask메서드의 return타입이 Void타입으로 지정되어있었습니다
    - dataTask메서드 외부의 변수에 data를 담는 방법은 클로저의 값 캡쳐 속성때문에 불가능했습니다.<br><br>
- ✅ **수정: Result타입사용**
    - completionHandler에 Result<Success, Failure>타입을 프로퍼티로 갖는 클로저를 사용했습니다.
    - dataTask메서드 내부에서 data를 .success(_)에 저장하도록 했습니다
    - 서버통신 작업이 비동기적이기 때문에 작업이 완료된 후 호출되는 completionHandler가 정상작동 될 수 있도록 @escaping 키워드를 사용했습니다.<br><br>
    ```swift
    func fetchData<T: Decodable>(url: URL,
                                 type: T.Type,
                                 completionHandler: @escaping (Result<T, NetworkError>) -> Void) {
        let dataTask = session.dataTask(with: url) { data, response, error in
            ...
            completionHandler(.success(decodedData))
        }
        
        dataTask.resume()
    } 
    ```
### **👣 STEP 2**
### 1️⃣ 기본 이미지가 등록되어 있지 않아 로딩 시 셀의 크기가 각각 다른 문제
- Modern Collection Views에서는 셀의 사이즈가 자동으로 지정되어 List뷰 로딩 시 레이블의 크기만큼 셀의 크기가 먼저 정해지고 이미지가 로딩되면 이후에 셀이 커지면서 각각 다른 크기의 셀로 작동되는 문제가 있었습니다.

    <img width = 200, src = "https://i.imgur.com/oN1iL7v.png"></br>

- ✅ **수정: PlaceHolder사용 및 `reservedLayoutSize`속성 사용**
    - `content.imageProperties.reservedLayoutSize` 프로퍼티를 이용해 바뀔 사이즈를 지정해주고 로딩모양을 표시하는 이미지를 `PlaceHolder`로 넣어주어 셀의 크기가 먼저 잡히도록 처리했습니다. <br>
        ```swift
        content.image = UIImage(named: "loading")
        content.imageProperties.reservedLayoutSize = CGSize(width: 70, height: 70)
        content.imageProperties.maximumSize = CGSize(width: 70, height: 70)
        ```

### 2️⃣ 빠르게 스크롤 했을 대 Cell의 위치가 뒤죽박죽 섞이는 문제
- 데이터를 서버에서 비동기로 가져오면서 List와 Grid에서 스크롤을 빠르게 했을 때, Cell의 위치가 뒤죽박죽되고 다른 이미지가 들어있다가 순식간에 다시 정상이미지가 돌아오는 등, Cell이 제자리를 찾지 못하는 문제가 있었습니다.

    <img width = 200, src = "https://i.imgur.com/xe6R3pE.gif"></br>

- ✅ **수정: indexPath가 같을 때에만 Cell의 컨텐츠를 구성**
    - cell 이 제자리를 찾을 수 있도록 indexPath를 이용했습니다.
    - `UICollectionView.CellRegistration`메서드에서 사용할 수 있는 `indexPath`값과 `UICollectionView`의 `indexPath` 값이 같을 때에만 cell의 content를 생성하도록 하였습니다.

- ✅ **indexPath 비교를 위한 CompletionHandler 적용**
    - 컨텐츠를 구성하는 기능의 `configureCell` 메서드에서 3가지 `UICollectionView`, `Cell타입`, `IndexPath` 를 매개변수로 받아야 메서드를 사용하는 곳에서 전달인자를 이용해 비교가 가능했습니다.
    - 매개변수사용 대신 `completionHandler` 로 `@escaping` 클로저를 사용해 뷰컨에서 `indexPath`를 비교하도록 구현했습니다. <br>
        ```swift
        // class MarketListCell
         func configureCell(page: Page,
                           completionHandler: @escaping (() -> Void) -> Void) {
         //  ... (셀의 콘텐츠를 구성)
            DispatchQueue.main.async {
                let updateConfiguration = {
                    self.pageListContentView.configuration = content
                    }
                completionHandler(updateConfiguration)
            }
         }

        // class MarketListViewController
        private func configureDataSource() {
            let cellRegistration =    UICollectionView.CellRegistration<MarketListCell, Page> {
            (cell, indexPath, page) in
            cell.configureCell(page: page) { updateConfiguration in
                if indexPath == self.listView.indexPath(for: cell) {
                    updateConfiguration()
                }
            }
        //  ... 
        ```

</br>
    
## 🔗 참고 링크

[공식문서]
- [URLSession](https://developer.apple.com/documentation/foundation/urlsession)
- [Fetching Website Data into Memory](https://developer.apple.com/documentation/foundation/url_loading_system/fetching_website_data_into_memory)
- [URLComponents](https://developer.apple.com/documentation/foundation/urlcomponents)
- [queryItems](https://developer.apple.com/documentation/foundation/urlcomponents/1779966-queryitems)
- [JSONDecoder.KeyDecodingStrategy](https://developer.apple.com/documentation/foundation/jsondecoder/keydecodingstrategy)
- [Implementing Modern Collection Views](https://developer.apple.com/documentation/uikit/views_and_controls/collection_views/implementing_modern_collection_views)
- [UICellAccessory](https://developer.apple.com/documentation/uikit/uicellaccessory?changes=latest_major)
- [WWDC2020 - Advances in UICollectionView](https://developer.apple.com/videos/play/wwdc2020/10097)
- [WWDC2020 - Lists in UICollectionView](https://developer.apple.com/videos/play/wwdc2020/10026)
- [Asynchronously Loading Images into Table and Collection Views](https://developer.apple.com/documentation/uikit/views_and_controls/table_views/asynchronously_loading_images_into_table_and_collection_views)
- [NSMutableAttributedString](https://developer.apple.com/documentation/foundation/nsmutableattributedstring)
- [NSCache](https://developer.apple.com/documentation/foundation/nscache)

[그 외 참고문서]
- [네트워크 상태와 무관한 테스트를 작성하는 방법](https://velog.io/@dacodaco/iOS-%EB%84%A4%ED%8A%B8%EC%9B%8C%ED%81%AC-%EC%83%81%ED%83%9C%EC%99%80-%EB%AC%B4%EA%B4%80%ED%95%9C-%ED%85%8C%EC%8A%A4%ED%8A%B8%EB%A5%BC-%EC%9E%91%EC%84%B1%ED%95%98%EB%8A%94-%EB%B0%A9%EB%B2%95)
- [네트워크와 무관한 URLSession Unit Test](https://wody.tistory.com/10)
- [Modern Collection Views with Compositional Layouts](https://www.kodeco.com/5436806-modern-collection-views-with-compositional-layouts#toc-anchor-004)
- [Modern Collection View - List 구현](https://leechamin.tistory.com/555#Modern%--Collection%--View%--%EA%B-%AC%ED%--%--)
- [Cell configuration](https://velog.io/@leeyoungwoozz/iOS-Cell-configuration)
- [이미지 캐싱 사용해보기](https://hryang.tistory.com/29)

