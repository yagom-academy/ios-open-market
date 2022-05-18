# 오픈마켓 I
> 프로젝트 기간 2022.05.09 ~ 2022.05.20 </br>
팀원 : [@Lingo](https://github.com/llingo) [@쿼카](https://github.com/Quokkaaa) / 리뷰어 : [@혀나노나](https://github.com/hyunable)

## 목차

- [키워드](#키워드)
- [STEP 1](#STEP-1)
    + [고민 및 해결한 점](#고민-및-해결한-점)
    + [조언받고 싶은 점](#조언받고-싶은-점)
- [STEP 2](#STEP-2)
    + [고민 및 알게된 점](#고민-및-알게된-점)
    + [해결한 점](#해결한-점)
    + [조언받고 싶은 점](#조언받고-싶은-점)
- [그라운드 룰](#그라운드-룰)
    + [활동시간](#활동시간)
    + [코딩 컨벤션](#코딩-컨벤션) 

---

## 키워드
- `URLSession`
- `URLSessionDataTask`
- `Mock 객체`
- `HTTP Request / Response`
- `Result 타입`
- `@escaping Closure`
- `UICollectionView`
- `UIActivityIndicator`
- `UISegmentControl`
- `AutoLayout`

---

## STEP 1
### 고민 및 해결한 점

**MockURLSession을 구현할때 URLSession 상속하는 것과 URLSessionProtocol 프로토콜을 채택하는 것을 고민했습니다.**
URLSession을 상속받아 재정의하여 사용하게되면 호출할때 재정의된것이 호출되며 동시에 에러발생시 부가적인 오류가 생길 수 있도 있지않을까 ?? 라는 의견이있었습니다. 혹시 모를 수 있기에 안전하다고 생각되는 프로토콜을 채택하였습니다.

**MockURLSession에 대해**
실제 네트워크로 서버와 통신하는 URLSession 객체를 대체할 MockURLSession을 어떻게 구현할 지를 고민했습니다.


**설계에 대해**
서버로부터 받은 데이터를 전달하는 과정에서 객체 간의 담당하는 계층에 따라 다음의 장단점이 있었습니다.

- 계층이 많은 경우 : 세분화하면 유지 보수하기 쉬워지고 확장과 변경이 쉬워지는 장점이 있지만 구조가 복잡하고 이해하기 힘들었습니다. 
- 계층이 적은 경우 : 코드를 이해하기는 쉬우나 변경이 어렵게 되어 유지보수하기 힘들어지는 단점이 있었습니다.

URLSession과 서버와의 데이터 통신이라는 개념 이해를 위해 계층을 줄여 이해하기 쉽게 구현했습니다.

### 조언받고 싶은 점
**`init() was deprecated in iOS 13.0` 에러가 발생하는이유에 대해서 궁금합니다.**

---

## STEP 2
### 고민 및 알게된 점

- UICollectionViewLayout과 UICollectionViewFlowLayout의 개념과 차이점에 대해 공부했고 UICollectionViewLayout은 추상 클래스이므로 서브클래싱하여 구현해야한다는 것을 알게되었습니다.
- minimumInterItemSpacing, minimumLineSpacing의 개념과 Scroll 방향에 따라 차이점을 알게되었습니다.
(vertical의 interitemSpacing은 가로방향이고 lineSpacing은 세로라인의 간격을 말한다. horizental일 경우에는 vertical과 반대로 적용됨)
- UICollectionViewDataSource는 컬렉션 뷰에서 필수로 제공해야하며 Data를 관리하고 해당 content를 표현하는데 필요한 View를 만든다는 것을 알게되었습니다.
- .systemColor와 color의 차이점을 알게되었습니다.
- 기본의 FlowLayout은 `Section-Item`으로 구현되어있어 하나의 Section안에 다른 레이아웃을 적용하기 힘들었지만 iOS 13부터 CompositionalLayout에서 `Section-Group-Item`의 Group 계층을 추가하여 한 Section에서 여러 그룹을 가지고 각 그룹별로 다른 레이아웃을 적용할 수 있도록 변경된 것을 알 수 있었습니다.
- FlowLayout을 사용하여 CollectionView를 TableView 같은 리스트의 형태로 구성할 수 있을지에 대해 고민했습니다.
- UICollectionViewCell의 크기를 조절하는 방법을 고민했고 itemSize 프로퍼티를 변경하는 방법으로 진행했습니다. 공식 문서에는 FlowLayout Delegate의 [collectionView:sizeForItemAt](https://developer.apple.com/documentation/uikit/uicollectionviewdelegateflowlayout/1617708-collectionview) 메서드를 구현하지 않으면 itemSize 프로퍼티를 통해 크기를 구성하게된다는 것과 Cell의 크기를 조절하는 방법에는 여러가지 방법이 있다는 사실을 알 수 있었습니다. [참고) 셀 크기를 조절하는 방법](https://gyuios.tistory.com/124)
- 네비게이션 바에는 View를 넣을 수 있는 설정이 있으며 구현된 segmentControl을 네비게이션 바의 `navigationItem.titleView = segmentControl`로 할당하였습니다.
- lazy var와 let에 대해 고민했습니다. lazy var로 프로퍼티를 생성하면 내부에 self를 사용할 수 있습니다. 그래서 내부에 self 넣어야하거나 부가적인 설정이 많을 경우에는 lazy var로 설정해주었고 그 외에는 let으로 설정해주었습니다. 왜냐하면 멀티스레드 환경에서 두번이상의 초기화가 될 수 있다는 단점이 존재하기 때문에 구분했습니다.
- cell의 테두리에 실선을 적용하는 방법, bolder적용하는 방법에 대해 학습하였습니다.
	- border 적용시 볼더색상, 볼더의 두께, 볼더의 굴곡 이 3가지를 적용
- init(frame: ), init?(coder: ) 이 두 가지에서 코드로 생성하면 init(frame:)이 보통 실행되는데 실패했을경우 init?(coder:)도 호출이 될 수 있기 때문에 양측 init에 모두 UI를 구성하는 메서드를 넣어주는게 안전하다는 것을 알게되었습니다.


**DispatchQueue.main.async 안에 reloadData를 해줘야하는 이유**

![](https://i.imgur.com/ik0mPNP.png)
![](https://i.imgur.com/iBEPXoe.png)

`loadProductListData` 메서드내에서 비동기방식으로 처리가되기때문에 다른 Thread에서 
`self.productList = productList ` 코드와 같이 값을 할당해준다. 
이 처리하는 Thread를 6번 Thread라고 가정하면 6번이 didSet을 불러잃으킨것이고 
그런데 19 번줄에 있는 `productList`의 didSet프로퍼티는 Thread 6번에서 호출이되었기때문에 main이 아닌 다른스레드에 있는상황이다. 고로 main에 전달을 해주어야하는 상황인 것이다.

만일 `DispatchQueue.main.async{}`로 처리가 되지않았다면 6번 Thread가 `self.collectionView.reloadData()`인 UI작업을 처리하게되기때문에 에러가 발생할 것이다.

**콘솔 로그에 아래의 메시지 대해**
```
Will attempt to recover by breaking constraint 
<NSLayoutConstraint:0x600003d27020 UIStackView:0x14e50d800.bottom == OpenMarket.MyCollectionViewCell:0x14e50d580.bottom   (active)>

Make a symbolic breakpoint at UIViewAlertForUnsatisfiableConstraints to catch this in the debugger.
The methods in the UIConstraintBasedLayoutDebugging category on UIView listed in <UIKitCore/UIView.h> may also be helpful.
```
오토레이아웃을 코드로 작성할 때 `translatesAutoresizingMaskIntoConstraints = false`로 하지 않으면 나타나는 문제인 것을 알 수 있었습니다.

**SegmentControl의 스타일 변경에 대해**
과거 SegmentControl은 파란 테두리의 형태로 되어있고 요구사항도 파란 테두리의 과거 형태로 되어있었습니다. 애플에서 iOS 버전을 올리면서 SegmentControl의 기본 UI를 변경한 것을 알 수 있었고 이번 프로젝트에서는 제공하는 형태를 사용했습니다.

**CollectionView의 List와 Grid 레이아웃 변경에 대해**
List와 Grid를 클릭했을때 UI 구성이 바뀌는 로직을 어떻게 구성할지 고민했고 List, Grid 형태의 2개의 셀을 구현하여 SegmentControl의 값이 변경될 때 선택된 Index에 따라 Layout과 셀을 변경하고 collectionView를 reload 해주는 방식으로 구현했습니다.

---

### 해결한 점
**itemSize 프로퍼티와 Delegate 메서드애 대해**
itemSize 프로퍼티를 변경하여도 고정된 List 크기만 나오는 문제가 있었습니다. Delegate로 셀의 크기를 정해주는 메서드로 사이즈를 정해주게 되면 itemSize 프로퍼티를 변경하더라도 Delegate메서드가 우선적으로 적용된다는 것을 알게되어 Delegate에 구현된 메서드를 제거하여 해결할 수 있었습니다.

**ReloadData를 하지 않았을 때 발생하는 에러**
List에서 Grid로 변경 후 다시 List로 돌아올 때 아래 첨부된 사진처럼 Layout은 변경이 되었지만 Cell의 구성, 오토레이아웃이 변경되지 않는 문제가 있었습니다. 

<img width="200px" src="https://i.imgur.com/vPEYwjP.png"/> <br/>

이를 해결하기 위해 collectionView.reloadData()를 해줘 DataSource 메서드의 재호출을 통해 모든 셀을 갱신하도록 변경하여 해결할 수 있었습니다.

**가격 및 할인 가격 Label의 길이가 길어질 때 오류에 대해**
List 목록 화면에서 priceLabel 1,2의 문자열 길이가 길어질 경우에 대한 오류 해결
![](https://i.imgur.com/AuhPce5.png)
=> 어떤 레이블의 크기를 줄여야하는지 모르겠다는 에러로 파악했습니다. 그래서 label.setContentCompressionResistancePriority(_,for:)메서드로 중요하지 않은 label의 priority를
낮춰주는 방식으로 해결하였습니다.

---

### 조언받고 싶은 점

**🔥 @escaping 클로저 내부에서 self를 참조하는 것에 대해**
loadProductListData 메서드의 클로저 내부에서 self를 캡처하기 때문에 강한 참조가 발생할 수 있는 가능성이 있을 것이라고 생각했고 `weak self` 캡처리스트를 사용해야할지 말지를 고민했습니다.
[You don't (always) need [weak self]](https://medium.com/@almalehdev/you-dont-always-need-weak-self-a778bec505ef) 글을 참고하여 캡처된 self가 클로저 자체를 소유하고 있지 않기 때문에 강한참조 문제가 없을 거라고 판단하였고 `Xcode -> Instrument`의 Leaks를 통해 메모리 누수 및 강한 참조가 발생하는 지 확인해본 결과 메모리 누수가 발생하지 않기 때문에 `weak self`를 써주지 않기로 판단했습니다. 저희의 생각을 맞는 것인지 놓친 점이 없는지 궁금합니다.

**셀(Cell) 재사용에 대해**
List셀일 때의 StackView axis가 horizental이고 Grid셀일 때는 verical인 점과 중복되는 코드가 많아보였습니다. 그래서 셀을 재사용할 수 있지 않을까? 라는 아이디어로 하나의 셀에 StackView의 설정을 바꾸는 방법을 시도해보았습니다. 하나의 셀의 StackView의 설정을 변경하도록 했을때 장단점이 무엇일지 고민해보았으며 크게 `가독성 vs 재사용성`으로 정의할 수 있었습니다.

> 재사용을 위해 List, Grid를 하나의 셀로 합칠 것이냐, 가독성을 위해 List, Grid 셀을 구분해줄 것이냐! 🤔

**1) 셀이 1개일 경우**

- 장점
    - 코드의 재사용성 증가
- 단점
    - 사이드이펙트가 발생
    - 코드를 리펙토링할때 번거로울 것 같다.

**2) 셀이 2개일 경우**
- 장점
	- list와 grid cell의 구분이 명확해져 가독성이 좋다.
	- 보편적으로 cell을 두개로 구분하여 구현을 하고있기에 문제가 발생할때 캠퍼들과 얘기를 나눠볼 수 있을것같다.
- 단점
	- 중복 코드 발생

저희가 생각했을때는 재사용을 위해 하나의 셀로 구현하면 List일 때와 Grid일 때의 로직을 하나의 셀이 처리하기 때문에 조건식에 따른 설정을 변경해야하므로 사이드이펙트가 발생하는 것 같았으며 확장성과 유지보수 측면에서도 기능이 추가되었을때 수정하기 까다롭지 않을까?라고 판단했습니다. 따라서, List와 Grid 셀을 구분해서 진행했습니다.

- 1. 스택 뷰의 Axis 설정을 변경하여 하나의 셀에 두가지 기능을 하는 방법에 대해 어떻게 생각하시는 지
- 2. 현업에서는 재사용과 가독성에 대해 고민할 때 우선하는 것이나 결정하는 기준이 있으신지 

궁금합니다.

**UI의 하드코딩에 대해**
View와 ViewController을 분리를 시도해보면서 View를 초기화할 때 frame의 width와 height를 390pt와 같이 상수로 입력하는 것은 UI의 하드코딩이라고 생각했고 UIScreen.main.bounds의 Width와 height를 할당해주었습니다.현직에서는 오토레이아웃이나 frame을 설정할 때 

- 1. UI를 구현할 때 일부분은 상수로 구현하시는 지
- 2. 상수를 사용하지 않는다면 주로 어떤 방식으로 사용하시는 지

궁금합니다.

**layout 변경시 발생하는 Animation 에러에 대해**
layout을 setCollectionViewLayout의 animated을 true로 설정하여 변경하면 아래의 에러메세지가 발생했습니다.
```
2022-05-17 17:14:46.948737+0900 OpenMarket[66055:10091602] [Snapshotting] 
Snapshotting a view (0x15b914200, OpenMarket.ProductGridCollectionViewCell) 
that has not been rendered at least once requires afterScreenUpdates:YES.
```
false로 변경해주며 발생하지 않기 때문에 Animation 과정에서 발생한 문제로 판단했지만 정확한 이유를 찾지 못했습니다.

**RealodData시 1초미만의 멈춤현상에 대해**

reLoadData list -> grid, grid -> list로 변경할때 약 1초미만의  정지가 발생하였습니다. 이게 동작하는 내부적인 로직에 대해 잘 이해하고있는지 확인을 받고 싶어서 질문드립니다.🤔 🤔

```
ViewController 초기화 시 collectionView를 생성함
ColletionView: 어이~ DataSource씨 화면에 셀 몇개 만들어야 돼유?
DataSource: productList.count개요.
ColletionView: ㅇㅋ 그러면 각 Cell 어떻게 만들까유?
DataSource: segmentControl에 따라 list와 grid셀 다르니깐 구분해서 만들어줘!
ColletionView: ㅇㅋ 

=> reloadData 실행시
ColletionView: 현재 보여지고 있는 화면의 item들을 다 삭제하고 다시 cell 만들게~ (위 과정을 반복)
```

> realodData를 실행하면 컬렉션뷰에 현재 표시되는 항목을 삭제하고 DataSource의 현재상태를 기준으로 다시 Cell을 만듭니다. 효율성을 위해 컬렉션뷰는 보이는 cell과 cell의 보조 view만 표시합니다.라는 공식문서의 내용을 참고해보았습니다.

---

## 그라운드 룰

### 활동시간
### 📚 공통
**아침 스크럼**
> 10시에 시작해서 최대 11시까지

- 전날 공부한 것을 공유
- 모르는 내용을 서로 묻기
- 금일 해야할 일

### 세션 있는 날 (월/목)
- 세션 후) 17시 ~ 18시
- 식사 후) 20시 ~ 22시+

### 세션 없는 날 (화/수/금)
- 식사 후) 14시 30분 ~ 18시
- 식사 후) 20시 ~ 22시+

---

### 코딩 컨벤션
- Swift Lint 적용
- UI를 코드로 구현하기

**Swift 코드 스타일**
- 코드 스타일은 [스타일쉐어 가이드 컨벤션](https://github.com/StyleShare/swift-style-guide#%EC%A4%84%EB%B0%94%EA%BF%88)에 따라 진행한다.

**커밋 규칙**
- 커밋 제목은 최대 50자 입력
- 본문은 한 줄 최대 72자 입력

**커밋 제목 규칙**
- 제목 끝에 마침표(.) 금지, 한글로 작성

**커밋 메세지**
```
feat: [기능] 새로운 기능 구현.
fix: [버그] 버그 오류 해결.
refactor: [리팩토링] 코드 리팩토링 / 전면 수정이 있을 때 사용합니다
style: [스타일] 코드 형식, 정렬, 주석 등의 변경 (코드 포맷팅, 세미콜론 누락, 코드 자체의 변경이 없는 경우)
test: [테스트] 테스트 추가, 테스트 리팩토링(제품 코드 수정 없음, 테스트 코드에 관련된 모든 변경에 해당)
docs: [문서] 문서 수정 / README나 Wiki 등의 문서 개정.
chore: [환경설정] 코드 수정, 내부 파일 수정
```

**브랜치 이름 규칙**
`STEP1`, `STEP2`
