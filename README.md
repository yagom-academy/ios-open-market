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
  - STEP2: 테이블뷰 UI 구현
- **2022-07-13(수)** 
  - STEP2: Segment 컨트롤 구현
- **2022-07-14(목)** - STEP1 Merged
    - Modern Collection view 공부 
- **2022-07-15(금)** 
  - Modern Collection View 기반으로 서버에서 fetch한 데이터를 출력하도록 변경
  - 하나의 CollectionView에서 Layout만을 변경하여 사용할 수 있게 구현 중
### UML

**Class Diagram(220713 STEP1 작성 기준)**
![](https://i.imgur.com/zx8UY5K.png)

### FileTree
```

├── OpenMarket
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
[STEP2]()
[STEP3]()

### 기능 설명
- 상품 상세정보를 표현할 `Product`, 상품 리스트를 받아올 `ProductPage` 데이터 타입을 구현.
  - 각각의 데이터 타입은 디코딩을위해 Codable, CollectionView에서 사용을 위해 Hashable 채택
- Data와 디코딩할 데이터 타입을 파라미터로 받아 디코딩해주는 `decode`메서드 구현
  -  Generic으로 디코딩 할 수 있게 구현
- URLSession 프레임워크를 활용하여 서버로부터 `ProductPage` 타입을 completion 핸들러로 넘겨주는 `dataTask` 메서드와 에 메서드를 프로퍼티로 갖는 `NetworkManager` 클래스 구현
- `SegmentController`를 `NavigationItem`의 title view로 지정하여 각 화면을 이동하도록 함
- ModernCollection View를 활용하여 리스트 형태와 그리드 형태로 데이터를 출력하도록 구현
- 

### 트러블 슈팅
- URLSession dataTask 시점 맞추기 -> 확인중
    - dataTask.resume() 실행 후 바로 데이터가 바로 받아와 지는 것이 아님을 인지.
    - 네트워킹한 데이터에 접근하는 메서드에서 nil 오류 -> 데이터가 받아지기 전에 접근
    - escaping closure를 이용해서

- modern Collection View 레이아웃 교체 이슈 -> 해결중
    - 세그먼트 전환시, 현재있던 하위뷰를 제거해준 뒤 세그먼트에 해당하는 layout과 dataSource 를 모두 재생성 해주며 뷰 전환
    - 뷰 전환마다 네트워킹이 이루어져 비용적 측면에서 좋지 않다고 판단
    - 한번의 네트워킹만 이루어지도록 해결중
- modern Collection View 이미지 축소 이슈 -> 해결중
    - list view 로드 시, 몇몇 셀의 축소현상 발생
    - 스크롤을 맨밑까지 한번 갔다오면 축소되었던 셀 정상화
    - 로드 시에도 정상적인 셀을 출력하도록 해결중
