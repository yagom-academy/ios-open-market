# 오픈마켓 README

###### tags: `README`

### 제목: 오픈마켓

### 팀원
<table><tr><td valign="top" width="50%" align="center" border="1">
    
[보리사랑](https://github.com/yusw10)
</td><td valign="top" width="50%" align="center">

[웡빙](https://github.com/wongbingg)        
</td></tr>
<tr><td valign="top" width="50%">

![](https://i.imgur.com/B1ztdKo.gif)

</td><td valign="top" width="50%">
        
![](https://i.imgur.com/fQDo8rV.jpg)
</td></tr>
</table>


### 타임라인

#### Week 1
<details>
    
- **2022-07-11(월)** 
  - STEP1-1: 데이터를 받아줄 모델타입 구현
  - STEP1-1: decode과정 unit 테스트
- **2022-07-12(화)** - STEP1 PR 
  - STEP1-2: URLSession을 이용한 네트워킹 구현
  - STEP2-1: 테이블뷰 UI 구현
- **2022-07-13(수)** 
  - STEP2-1: Segment 컨트롤 구현
- **2022-07-14(목)** - STEP1 Merged
    - Modern Collection view 공부 
- **2022-07-15(금)** 
  - Modern Collection View 기반으로 서버에서 fetch한 데이터를 출력하도록 변경
  - 하나의 CollectionView에서 Layout만을 변경하여 사용할 수 있게 구현 
    
</details>

#### Week 2
<details>
    
- **2022-07-18(월)** 
  - STEP2-2: 가격레이블의 조건별 UI 지정, 네비게이션 바에 +버튼 추가, List 뷰에서 스크롤 시 셀높이 축소현상에 관련한 오토레이아웃 재설정 시도 
- **2022-07-19(화)** - STEP2 PR
  - STEP2-2: 네트워킹이 이루어지는 동안에 Activity Indicator 구현
  - STEP2 PR
- **2022-07-20(수)** 
  - STEP2 Comment 
  - Cache 에 대한 개인 공부
- **2022-07-21(목)** 
  - STEP2 피드백 수정: 불필요한 주석제거, 접근제어자 변경, 중복 메서드 제거, activity indicator 계층구조를 변경
- **2022-07-22(금)** 
  - BonusSTEP: 로컬캐싱 구현
</details>

#### Week 3
<details>
    
- **2022-07-25(월)** 
  - STEP 3: HTTP Method(Get) 구현
- **2022-07-26(화)** - STEP2 PR
  - STEP 3: HTTP Method(Post) 구현 
- **2022-07-27(수)** 
  - STEP 3: HTTP Method(PATCH, DELETE) 구현
- **2022-07-28(목)** 
  - 상품을 등록,수정하는 뷰구현
  - 기기의 앨범에 접근하여 사진을 가져오는 UIPickerView 이용
- **2022-07-29(금)** 
  - 셀 선택시 수정 화면으로 넘어가도록 구현
  - 텍스트 필드 별 맞춤 키보드 및 키보드가 Content를 가리지 않도록 구현 중
</details>    

#### Week 4
<details>
    
- **2022-08-01(월)** 
  - Keyboard 가 TextView 를 가리지 않도록 구현
  - 최신정보를 가져오는 새로고침 구현
  - 스크롤을 최하단으로 내렸을 시, 다음 20개의 상품을 불러오도록 구현
- **2022-08-02(화)** - STEP2 PR
  - STEP 3: MVC 패턴으로 분리 
  - MainViewController 에서 들고있던 모델을 모델타입으로 따로 분리
  - 모델이 변경되면 Notification을 통해 뷰컨트롤러에 전달 
- **2022-08-03(수)** 
  - layout 이 변경됨에 따라 DataSource를 바꿔줄 때 생기는 충돌오류 해결
- **2022-08-04(목)** 
  - 상세화면 UI구현
  - 사진들을 횡스크롤로 페이징
  - 사진의 총 갯수 당 현재 페이지를 알려줄 수 있는 pagingLabel 구현
  - 수정/삭제를 선택할 수 있는 액션시트 구현
- **2022-08-05(금)** 
  - 셀 선택시 수정 화면으로 넘어가도록 구현
  - 텍스트 필드 별 맞춤 키보드 및 키보드가 Content를 가리지 않도록 구현 중
</details>    
    
### UML

**Class Diagram(220713 STEP1 작성 기준)**
<img src=https://i.imgur.com/16SzQXv.png width=90%>


### FileTree

```
.
├── OpenMarket
│   ├── Model
│   │   ├── ProductPage
│   │   ├── Product
│   │   ├── Currency
│   │   ├── ProductDetail
│   │   ├── ProductRegistration
│   │   ├── ModificationData
│   │   └── ProductListManager
│   ├── Controller
│   │   ├── MainViewController
│   │   ├── ProductSetupViewController
│   │   └── ProductDetailViewController
│   ├── View
│   │   ├── ListCell
│   │   ├── GridCell
│   │   ├── ProductSetupView
│   │   ├── ProductDetailView
│   │   └── ProductImageView
│   ├── Extensions
│   │   ├── Double+Extensions
│   │   ├── NotificationName+Extensions
│   │   ├── UIImageView+Extensions
│   │   ├── UILabel+Extensions
│   │   └── UITextField+Extensions
│   ├── Command
│   │   └── URLCommand
│   ├── Utility
│   │   ├── JsonDecoder
│   │   ├── URLSession
│   │   └── ImageCacheManager
│   ├── AppDelegate
│   └── SceneDelegate
└── DataFetchTests
    └── DataFetchTests
```
### PR
[STEP1](https://github.com/yagom-academy/ios-open-market/pull/174)
[STEP2](https://github.com/yagom-academy/ios-open-market/pull/183)
[STEP3](https://github.com/yagom-academy/ios-open-market/pull/195)
[STEP4](https://github.com/yagom-academy/ios-open-market/pull/201)

### UI 
#### Cell
<img src=https://i.imgur.com/PxAAPtX.jpg width=70%>
<img src=https://i.imgur.com/EHA2lc0.jpg width=70%>

#### 상품등록,수정 View
<img src=https://i.imgur.com/ble3ylj.jpg width=70%>

#### 상품 상세정보 View
<img src=https://i.imgur.com/nEVmuaZ.jpg width=70%>

| List/ Grid|새로고침| 상품등록 |
|:---:|:---:|:---:|
|<img src=https://user-images.githubusercontent.com/95671495/183015514-d80e1ad3-6a95-4ebf-a8aa-de9cb54cbdd5.gif width=60%>|<img src=https://user-images.githubusercontent.com/95671495/183015201-33ed2ee9-fe46-45f4-a5fb-e5c913510bae.gif width=60%>|<img src=https://i.imgur.com/yiM8nLm.gif width=220>
|위 세그먼트 컨트롤을 통해 layout을 변경|새로고침 구현|HTTP POST 메서드를 적용

|상품수정|상품삭제| 상품의 이미지 최대 5장까지 추가 |
|:---:|:---:|:---:|
|<img src=https://i.imgur.com/3Ydem8y.gif width=220>|<img src=https://i.imgur.com/GzlhscO.gif width=220>|<img src=https://i.imgur.com/akdwW0Q.gif width=220>|
|HTTP PETCH 메서드를 적용| HTTP DELETE 메서드를 적용| 업로드 이미지를 5장으로 제한|

### 기능 설명
- 상품 상세정보를 표현할 `Product`, 상품 리스트를 받아올 `ProductPage` 데이터 타입을 구현.
  - 각각의 데이터 타입은 디코딩을위해 Codable, CollectionView에서 사용을 위해 Hashable 채택
- Data와 디코딩할 데이터 타입을 파라미터로 받아 디코딩해주는 `decode`메서드 구현
  -  Generic으로 디코딩 할 수 있게 구현
- URLSession 프레임워크를 활용하여 서버로부터 `ProductPage` 타입을 completion 핸들러로 넘겨주는 `dataTask` 메서드와 에 메서드를 프로퍼티로 갖는 `NetworkManager` 클래스 구현
- `SegmentController`를 `NavigationItem`의 title view로 지정하여 각 화면을 이동하도록 함
- ModernCollection View를 활용하여 리스트 형태와 그리드 형태로 데이터를 출력하도록 구현
- `ActivityIndicator`를 활용하여 데이터 로드시에 작업중임을 나타내게 구현
- URLSession 프레임워크를 활용하여 HTTP METHOD(GET, POST, PATCH, DELETE)를 구현, 서버로부터 데이터 통신하도록 함
  - 통신시 디코딩될 데이터 타입을 구현(ProductDetail, ProductPage, etc)
- UIImagePickerView를 통하여 기기의 사진첩에 접근, 서버에 등록할 제품의 이미지를 선택하도록 구현
- TextField별로 다른 종류의 키보드로 타이핑 할 수 있도록 함.
- 상품 상세 정보 화면에서 등록된 이미지가 몇번째 사진인지 페이징 인덱스를 표시하며 사진이 정 가운데 오도록 함
- 상세 정보 화면에서 네비게이션 아이템을 통해 수정과 삭제를 액션시트로 선택할 수 있도록 구현
- 삭제 시 액션시트에서 TextField를 통해 비밀번호를 비교 후 DELETE REQUEST 진행
- 리스트와 그리드 뷰의 최상단에서 다시 위로 스크롤 시 서버로부터 가장 최신의 데이터를 받아오도록 새로고침 구현
- 리스트와 그리드 뷰의 최하단에서 스크롤 시 목록을 이어서 볼 수 있도록 Infinite scroll 구현

### 트러블 슈팅
- URLSession dataTask 시점 맞추기 -> **해결**
    - dataTask.resume() 실행 후 바로 데이터가 바로 받아와 지는 것이 아님을 인지.
    - 네트워킹한 데이터에 접근하는 메서드에서 nil 오류 -> 이는 비동기적으로 작동하면서 출력되는 현상임을 확인
    - 네트워킹시간과 UI업데이트 로직을 현재 정확하게 이해하여 원하는 시점에서 자유롭게 사용할 수 있도록 코드를 다시 분석함.

- modern Collection View 레이아웃 교체 이슈 -> **해결**
    - 세그먼트 전환시, 현재있던 하위뷰를 제거해준 뒤 세그먼트에 해당하는 layout과 dataSource 를 모두 재생성 해주며 뷰 전환
    - 뷰 전환마다 네트워킹이 이루어져 비용적 측면에서 좋지 않다고 판단
    - 최초에 데이터 로드시 데이터를 fetch하며, 이후 새로고침, 목록 추가와 같은 네트워킹이 필요한 시점에만 fetch하는 메서드를 호출하면 될것으로 예상

- modern Collection View 이미지 축소 이슈 -> **해결**
    - list view 로드 시, 몇몇 셀의 축소현상 발생
    - 스크롤을 맨밑까지 한번 갔다오면 축소되었던 셀 정상화
    - 최초에는 기본적으로 apple에서 제공해주는 리스트 레이아웃 코드를 사용하여 코드를 작성했음, 다만 default List layout에서 custom Cell 을 사용하는것 + reuse 되면서 일어나는 문제라고 판단함
    - List Layout 자체를 compositionalLayout을 활용하여 작성함으로써 해결.

- 가격을 받아오는 타입이 Int이지만 , 서버에 올라간 데이터가 Double 타입일 때 HTTP GET 오류 -> **해결**
    - 캠퍼 중 한명이 처음으로 Double 타입의 숫자(0.75$) 로 게시물을 올렸는데, 이 하나 때문에 전체 데이터가 받아와지지 않았다. 
    - 가격을 받아오는 타입을 Double로 변경해주어 해결 

- IPhone 12 미니 스크롤뷰 이슈 -> 해결
  - 다른 시뮬레이터 기기 및 실기기(Iphone 8+)에서는 확인 되지 않으나 아이폰 12 미니를 시뮬레이터로 동작시킬 경우 UIImagePickerController로 부터 받아온 이미지를 담는 HorizonalStackview에 알수 없는 선이 생성됨 
  - <img src=https://i.imgur.com/bQsTJnZ.png width=40%>
  - 다른 시뮬레이터에서는 확인 되지 않아 단순 시뮬레이터 오류인지 확인 중
  - 아이폰 12 시뮬레이터 오류...
  
- text/Plain 형태의 서버 response 디코딩 이슈 -> **해결**
  - 기존의 데이터 타입은 application/json형태로 response의 data가 옴.
  - 다만 DELETE를 위해 SECRET 키를 발급 받는 과정에서는 text/plain 형태로 와서 기존의 JSON 형태만을 decoding하는 decode 메서드로는 처리가 불가
  - text/plain 형태의 응답 데이터도 String 타입으로 바로 디코딩해줄 수 있도록 변경함.

- 키보드가 컨텐츠 영역을 가리지 않도록 프레임의 y값을 수정 -> **해결 중**
  - 키보드가 올라오는 시점에서 키보드 view의 height값을 불러와 그만큼 view의 y값이 올라가게 지정 하려함
  - 키보드가 화면에 나오게 했을 때 올라가게 구현하였으나, 제대로 올라가지 않는 이슈 해결 중 
  
- text/plain 타입의 Response 디코딩이슈 -> 해결
  - 오픈마켓 서버에서 삭제 secret을 조회하는 POST 메서드는 text/plain 타입으로 response data가 오게 되어있습니다. 하지만 저희가 구현한 decoding 메서드는 application/json 타입의 데이터만 처리할 수 있게 구현되어 있었고, 다음과 같이 디코드 메서드 앞에 코드를 추가하여 해결할 수 있었습니다.
```swift
if type == String.self {
    return String(data: data, encoding: .utf8) as? T
}
```
