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
  
#### Week 2
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
  - BonusSTEP: 로컬캐싱 구현 시도중
### UML

**Class Diagram(220713 STEP1 작성 기준)**
![](https://i.imgur.com/zx8UY5K.png)

### FileTree

```
├── OpenMarket
│   ├── Extensions
│   │   ├── Int+Extensions
│   │   ├── UIImageView+Extensions
│   │   └── UILabel+Extensions
│   ├── Command
│   │   └── URLCommand
│   ├── Utility
│   │   ├── JsonDecoder
│   │   └── URLSession
│   ├── Model
│   │   ├── ProductPage
│   │   ├── Product
│   │   └── Currency
│   ├── AppDelegate
│   ├── SceneDelegate
│   ├── MainViewController
│   ├── ListCell
│   └── GridCell
└── DataFetchTests
    └── DataFetchTests
```
### PR
[STEP1](https://github.com/yagom-academy/ios-open-market/pull/174)
[STEP2](https://github.com/yagom-academy/ios-open-market/pull/183)
[STEP3]()
### UI 
#### Cell
![](https://i.imgur.com/PxAAPtX.jpg)
![](https://i.imgur.com/EHA2lc0.jpg)

### 기능 설명
- 상품 상세정보를 표현할 `Product`, 상품 리스트를 받아올 `ProductPage` 데이터 타입을 구현.
  - 각각의 데이터 타입은 디코딩을위해 Codable, CollectionView에서 사용을 위해 Hashable 채택
- Data와 디코딩할 데이터 타입을 파라미터로 받아 디코딩해주는 `decode`메서드 구현
  -  Generic으로 디코딩 할 수 있게 구현
- URLSession 프레임워크를 활용하여 서버로부터 `ProductPage` 타입을 completion 핸들러로 넘겨주는 `dataTask` 메서드와 에 메서드를 프로퍼티로 갖는 `NetworkManager` 클래스 구현
- `SegmentController`를 `NavigationItem`의 title view로 지정하여 각 화면을 이동하도록 함
- ModernCollection View를 활용하여 리스트 형태와 그리드 형태로 데이터를 출력하도록 구현
- `ActivityIndicator`를 활용하여 데이터 로드시에 작업중임을 나타내게 구현

### 트러블 슈팅
- URLSession dataTask 시점 맞추기 -> 해결
    - dataTask.resume() 실행 후 바로 데이터가 바로 받아와 지는 것이 아님을 인지.
    - 네트워킹한 데이터에 접근하는 메서드에서 nil 오류 -> 이는 비동기적으로 작동하면서 출력되는 현상임을 확인
    - 네트워킹시간과 UI업데이트 로직을 현재 정확하게 이해하여 원하는 시점에서 자유롭게 사용할 수 있도록 코드를 다시 분석함.

- modern Collection View 레이아웃 교체 이슈 -> 해결
    - 세그먼트 전환시, 현재있던 하위뷰를 제거해준 뒤 세그먼트에 해당하는 layout과 dataSource 를 모두 재생성 해주며 뷰 전환
    - 뷰 전환마다 네트워킹이 이루어져 비용적 측면에서 좋지 않다고 판단
    - 최초에 데이터 로드시 데이터를 fetch하며, 이후 새로고침, 목록 추가와 같은 네트워킹이 필요한 시점에만 fetch하는 메서드를 호출하면 될것으로 예상
- modern Collection View 이미지 축소 이슈 -> 해결
    - list view 로드 시, 몇몇 셀의 축소현상 발생
    - 스크롤을 맨밑까지 한번 갔다오면 축소되었던 셀 정상화
    - 최초에는 기본적으로 apple에서 제공해주는 리스트 레이아웃 코드를 사용하여 코드를 작성했음, 다만 default List layout에서 custom Cell 을 사용하는것 + reuse 되면서 일어나는 문제라고 판단함
    - List Layout 자체를 compositionalLayout을 활용하여 작성함으로써 해결.
