# 오픈마켓 

## 🙋🏻‍♂️ 프로젝트 소개
오픈마켓 어플 입니다 

> 프로젝트 기간: 2022-07-11 ~ 2022-07-22</br>
> 팀원: [백곰](https://github.com/Baek-Gom-95), [브래드](https://github.com/bradheo65) </br>
리뷰어: [Corn](https://github.com/protocorn93)</br>
그라운드롤: [GroundRule](https://github.com/Jeon-Minsu/ios-open-market/tree/step01/Docs/GroundRule.md)

## 📑 목차

- [🧑🏻‍💻🧑🏻‍💻 개발자 소개](#-개발자-소개)
- [📈 UML](#-UML)
- [💡 키워드](#-키워드)
- [🤔 핵심경험](#-핵심경험)
- [📚 참고문서](#-참고문서)
- [📝 기능설명](#-기능설명)
- [🚀 TroubleShooting](#-TroubleShooting)
    - [🚀 STEP 1](#-STEP-1)
    - [🚀 STEP 2](#-STEP-2)

- STEP별 상세 내용
    - [1️⃣ STEP 1](https://github.com/bradheo65/ios-open-market/blob/Step1/Docs/Step01.md)
    - [1️⃣ STEP 2](https://github.com/bradheo65/ios-open-market/blob/Step2-3/Docs/Step02.md)

## 🧑🏻‍💻🧑🏻‍💻 개발자 소개

|||
|:---:|:---:|
|<image src = "https://user-images.githubusercontent.com/45350356/174251611-46adf61c-93fa-42a0-815b-2c998af1c258.png" width="250" height="250">| <image src = "https://i.imgur.com/c17eEk8.jpg" width="250" height="250">
|[브래드](https://github.com/bradheo65)|[백곰](https://github.com/Baek-Gom-95)|

## 📈 UML

### [ClassDiagram]

![image](https://user-images.githubusercontent.com/45350356/180371284-247a4c8b-9009-41f5-bfe0-0f0db453d708.png)


## 💡 키워드
- HTTP
- URLSession
- URLSession Unit Test
- AutoLayout
- URLSession GET
- CollectionView
- Modern CollectionView
    
## 🤔 핵심경험
- [x] 파싱한 JSON 데이터와 매핑할 모델 설계
- [x] URL Session을 활용한 서버와의 통신
- [x] CodingKeys 프로토콜의 활용
- [x] 네트워크 상황과 무관한 네트워킹 데이터 타입의 단위 테스트(Unit Test)
- [x] Safe Area을 고려한 오토 레이아웃 구현
- [x] Collection View의 활용
- [x] Mordern Collection View 활용


## 📚 참고문서
- URLSession
    - Fetching Website Data into Memory
- UICollectionView
    - Modern cell configuration
    - Lists in UICollectionView
    - Implementing Modern Collection Views


## 📝 기능설명
- URLCollection: URL주소를 Enum 타입으로 만들어주었습니다
- CustomError: Error 타입을 모아놓은곳 입니다
- ProductListResponse: API 주소에서 가져온 Json 타입의 상품 리스트 데이터들을 담을 Model 구조체 입니다
- Product: API 주소에서 가져온 Json 타입의 상품의 상세 데이터들을 담을 Model 구조체 입니다
- JsonParser 
    - dataTask(): 매개변수로 받은 URL 주소를 GET 방식으로 서버와 데이터를 주고받은후 Escaping Closure로 결과값을 반환해 줍니다.
- MockURLSession: 네트워크가 연결되지 않은 상태에서 Unit Test를 진행할때 사용할 코드 입니다
- PaddingLabel: Label에 Padding 기능을 구현하기 위한 코드입니다
- String+Extension
    - func strikeThrough(): DisCountPrice가 있으면 Label에 CancelLine 을 만들어줄 함수입니다
- ViewController: SegmentSwitch 를 컨트롤 하고 세그먼트 Select 에 따라 List 와 Grid 화면을 보여주는 코드 입니다.
- FirstViewController: UICollectionView List 화면을 구현하는 코드 입니다 
- SecondViewController: UICollectionView Grid 화면을 구현하는 코드 입니다

    
## 🚀 TroubleShooting
    
### 🚀 STEP 1

#### T1. HTTP method `POST` 테스트
`POST` method 를 통해 서버에 테스트 데이터를 API문서를 보면서 필요한 정보에 대해 Json 형식으로 `POST`를 해주었지만, 계속해서 `400` 에러가 발생되었습니다. 알고 보니 해당 서버 접근에 필요한 `id` 와 `password`가 아직 할당 받지 못해서 발생된 에러였습니다.    

#### T2. 네트워크가 연결되지 않을 때 네트워크 Unit 테스트
네트워크 Unit 테스트 목적: 인터넷에 의존하기 떄문에 테스트를 신뢰할 수 없어서, 실제 서버와 통신하면 의도치 않은 결과 도출될 수 있음. 실제 서버에 영향이 갈 수 도 있어 테스트가 필수적이다. 하지만 테스트 코드 직접 작성하고 나서 실행 시 결과 값이 클로저의 데이터값을 확인하는 것이기 때문에 비동기적으로 실행되서 무조건 `SUCCESS`로 되어서 비동기 테스트에 대한 지식이 필요하다.
    
### 🚀 STEP 2

#### T1. UI 생성 시 스토리보드 vs 코드
이번 프로젝트에서 스토리보드를 활용해 UI를 설계해보았는데, 코드로 설계했을 때와 많이 달랐습니다. 개인적으로 느끼기에는 큰 틀을 그릴때는 스토리보드가 빠르고 쉽게 가능 했지만 막상 세세한 설정을 해야할 상황에서는 코드로 하는 게 좋다고 느껴졌습니다. 특히 이번프로젝트에서 오토레아웃에 대한 고민을 많이 해봤을때 스토리보드로 하는 것보단 코드로 했으면 어떗을까 생각이 들었습니다. 다음 UI 설계시 코드로 하는 방향에 대해서 좀 더 생각해 보는게 좋을 것 같습니다.

#### T2. CollectionViewCell 재사용 문제
API에서 데이터를 적게 가져올 때는 문제가 없었지만, 데이터의 갯수가 30~40개가 넘어가게 되면 스크롤 시 해당 라벨에 대한 정보가 섞인 현상을 볼 수 있었습니다. 해결 방법에 대해서 생각해보았는데 셀 재사용시 호출되는 메소드 `prepareForReuse()`를 통해 해결해보긴 했지만 [애플에서는 `prepareForReuse()`에서 cell의 item을 초기화해주거나 변경시켜주는 기능 시 사용을 지양한다고 나와 있어 사용을 다른 생각을 해보았습니다.](https://developer.apple.com/documentation/uikit/uicollectionreusableview/1620141-prepareforreuse) 
아래 구문에 해당 내용이 나와 있었습니다.
>Override this method in your subclass to reset properties to their default values and make the view ready to use again. Don’t use this method to assign any new data to the view; that’s the responsibility of your data source object.
    
그래서 cell이 생성되는 메소드 `func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell`에서 각 라벨들의 데이터들을 초기화시켜주고 재 할당해주는 방식으로 코드를 작성해보니 원하는대로 동작하게 되었습니다. 무조건 `prepareForReuse()`사용해서 재사용성에 대한 고민을 해결했을텐데 생각의 전환이 되는 계기가 되었습니다.

#### T3. 데이터 로드 시 로딩 창 구현
요구사항에 데이터가 로드할 떄까지 별도로 로딩 창을 띄어주는 뷰를 추가해야 했었습니다. 그래서 `viewDidLoad` 해당 실행하는 함수를 넣어 실행해보니 `viewDidLoad` 메소드 내에 선언되어 있는 메소드들이 다 종료가 되어야지 첫 view가 보여주어서 별도로 로딩 창이 나오지 않았습니다. view 라이프 사이클에 대해 생각해 보았고 `viewDidAppear`에서 컬렉션뷰에 데이터를 넣어주는 메소드를 넣어주고 나머지는 `viewDidLoad`를 넣어줘서 로딩 창을 구현했고 API에서 데이터를 가져오는 시점에서 애니메이션을 종료시켜주고 컬렉션뷰를 `reloadData()` 메소드를 넣어주어 컬렉션뷰를 다시 그려주는 로직으로 구현해 해결했습니다.
    
#### T4. Grid CollectionView Column 2Line 으로 만들기 및 Cell 간격 띄우기
Grid 형태의 CollectionView 에서 2열형태 및 Cell 간격을 띄워주는 Layout이 요구사항이었습니다 처음엔 스토리보드로 하려고 했지만 Attributes inspector 에도 설정하는곳이 없어 UICollectionVIewDelegateFlowLayout 에 있는 Cell의 크기를 설정해주고 Cell사이의 Spacing 을 설정해주는 코드로 해당 요구사항을 구현했습니다.
    

## 2️⃣ STEP 2

### STEP 2 Questions 

#### Q1. UI 생성 시 스토리보드 vs 코드
아래 TroubleShooting에서 저희가 고민한 점에 대해서 UI설계시 스토리보드와 코드 중 어느 것으로 설계를 할 것인지에 대한 기준이 있는지 콘의 생각이 궁금합니다!
    
#### Q2. 한 ViewController에서 많은 view 생성
스토리보드로 구현하다 보니 CollectionView의 형태에 따른 view를 보여줄때 `containerView`를 써서 구현을 했습니다. 구현하고 나서 `Debug View Hierarchy`를 보니 한 화면에 많은 화면?이 나오는 걸 볼 수 있었는데 성능상 문제가 없을 지, 현업에서는 view를 한 화면에 구현을 해줄떄 어떤 방식으로 하는지 궁금합니다.
    
### STEP 2 Answers 


---
### STEP 2 TroubleShooting
    
#### T1. UI 생성 시 스토리보드 vs 코드
이번 프로젝트에서 스토리보드를 활용해 UI를 설계해보았는데, 코드로 설계했을 때와 많이 달랐습니다. 개인적으로 느끼기에는 큰 틀을 그릴때는 스토리보드가 빠르고 쉽게 가능 했지만 막상 세세한 설정을 해야할 상황에서는 코드로 하는 게 좋다고 느껴졌습니다. 특히 이번프로젝트에서 오토레아웃에 대한 고민을 많이 해봤을때 스토리보드로 하는 것보단 코드로 했으면 어떗을까 생각이 들었습니다. 다음 UI 설계시 코드로 하는 방향에 대해서 좀 더 생각해 보는게 좋을 것 같습니다.

#### T2. CollectionViewCell 재사용 문제
API에서 데이터를 적게 가져올 때는 문제가 없었지만, 데이터의 갯수가 30~40개가 넘어가게 되면 스크롤 시 해당 라벨에 대한 정보가 섞인 현상을 볼 수 있었습니다. 해결 방법에 대해서 생각해보았는데 셀 재사용시 호출되는 메소드 `prepareForReuse()`를 통해 해결해보긴 했지만 [애플에서는 `prepareForReuse()`에서 cell의 item을 초기화해주거나 변경시켜주는 기능 시 사용을 지양한다고 나와 있어 사용을 다른 생각을 해보았습니다.](https://developer.apple.com/documentation/uikit/uicollectionreusableview/1620141-prepareforreuse) 
아래 구문에 해당 내용이 나와 있었습니다.
>Override this method in your subclass to reset properties to their default values and make the view ready to use again. Don’t use this method to assign any new data to the view; that’s the responsibility of your data source object.
    
그래서 cell이 생성되는 메소드 `func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell`에서 각 라벨들의 데이터들을 초기화시켜주고 재 할당해주는 방식으로 코드를 작성해보니 원하는대로 동작하게 되었습니다. 무조건 `prepareForReuse()`사용해서 재사용성에 대한 고민을 해결했을텐데 생각의 전환이 되는 계기가 되었습니다.

#### T3. 데이터 로드 시 로딩 창 구현
요구사항에 데이터가 로드할 떄까지 별도로 로딩 창을 띄어주는 뷰를 추가해야 했었습니다. 그래서 `viewDidLoad` 해당 실행하는 함수를 넣어 실행해보니 `viewDidLoad` 메소드 내에 선언되어 있는 메소드들이 다 종료가 되어야지 첫 view가 보여주어서 별도로 로딩 창이 나오지 않았습니다. view 라이프 사이클에 대해 생각해 보았고 `viewDidAppear`에서 컬렉션뷰에 데이터를 넣어주는 메소드를 넣어주고 나머지는 `viewDidLoad`를 넣어줘서 로딩 창을 구현했고 API에서 데이터를 가져오는 시점에서 애니메이션을 종료시켜주고 컬렉션뷰를 `reloadData()` 메소드를 넣어주어 컬렉션뷰를 다시 그려주는 로직으로 구현해 해결했습니다.
    
#### T4. Grid CollectionView Column 2Line 으로 만들기 및 Cell 간격 띄우기
Grid 형태의 CollectionView 에서 2열형태 및 Cell 간격을 띄워주는 Layout이 요구사항이었습니다 처음엔 스토리보드로 하려고 했지만 Attributes inspector 에도 설정하는곳이 없어 UICollectionVIewDelegateFlowLayout 에 있는 Cell의 크기를 설정해주고 Cell사이의 Spacing 을 설정해주는 코드로 해당 요구사항을 구현했습니다.
    
---
    
### STEP 2 Concepts
- Json
- URLSession
- HTTP Method
- AutoLayout
- URLSession GET
---
### STEP 2 Reviews And Updates
    
[STEP2PR]()
