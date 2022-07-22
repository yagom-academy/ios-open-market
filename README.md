
# 🛒 오픈 마켓

## 목차
* [프로젝트 저장소](#-💾-프로젝트-저장소)
* [팀원](#-👥-팀원)
* [실행화면](#-📺-실행-화면)
* [개발환경 및 라이브러리](#🛠-개발환경-및-라이브러리)
* [타임라인](#-🕖-타임라인:-시간-순으로-프로젝트의-주요-진행-척도를-표시)
    * [week1](#Week-1)
    * [week2](#Week-2)
* [프로젝트 내용](#✏️-프로젝트-내용)
    * [핵심 기능 경험](#💻-핵심-기능-경험)
    * [코드 소개](#⚙️-코드-소개)
* [트러블 슈팅](#🏀-TroubleShooting)
* [참고한 페이지](#참고한-페이지)

## 💾 프로젝트 저장소
>**프로젝트 기간** : 2022-07-11 ~ 2022-07-22<br>
**소개** : 네트워크 통신을 통해 상품 API를 가져와 물건을 매매하는 앱입니다. <br>
**리뷰어** : [**라이언**](https://github.com/ryan-son)

## 👥 팀원
    
| [현이](https://github.com/seohyeon2) | [언체인](https://github.com/unchain123) |
|:---:|:---:|
|<img src = "https://i.imgur.com/0UjNUFH.jpg" width="250" height="250">|<img src = "https://i.imgur.com/GlPnCo7.png" width="250" height="250">|

---
## 📺 실행 화면
| ListCollectionView | GridCollectionView |
|:---:|:---:|
|![](https://i.imgur.com/SBqTBAk.gif)|![](https://i.imgur.com/op5su98.gif)
|


## 🛠 개발환경 및 라이브러리
[![swift](https://img.shields.io/badge/swift-5.6-orange)]()
[![xcode](https://img.shields.io/badge/Xcode-13.4.1-blue)]()
[![swiftLint](https://img.shields.io/badge/SwiftLint-13.2-green)]()
---

## 🕖 타임라인: 시간 순으로 프로젝트의 주요 진행 척도를 표시

### Week 1
- **2022-07-11 (월)** 
  - URLSession에 대해서 파악하기 위해 공부
 
- **2022-07-12 (화)**
  - STEP1 PR

- **2022-07-13 (수)**
  - URLSession에 대해 다시 공부하고 collectionView공부

- **2022-07-14 (목)**
  - 1차 리뷰 수정
  
- **2022-07-15 (금)**
  - Readme.md 작성 및 1차 리뷰 수정


### Week 2
- **2022-07-18 (월)** 
  - URLSession에 대해서 파악하기 위해 공부
 
- **2022-07-19 (화)**
  - STEP1 리팩토링 및 머지

- **2022-07-20 (수)**
  - STEP2 List Collection View, Segmented Control 구현

- **2022-07-21 (목)**
  - STEP2 오토레이아웃 및 Grid 구현
  
- **2022-07-22 (금)**
  - Readme.md 작성 및 STEP2 PR 

---

## ✏️ 프로젝트 내용

### 💻 핵심 기능 경험
- [x] 파싱한 JSON 데이터와 매핑할 모델 설계
- [x] URL Session을 활용한 서버와의 통신
- [x] CodingKeys 프로토콜의 활용
- [x] 네트워크 상황과 무관한 네트워킹 데이터 타입의 단위 테스트(Unit Test)


### ⚙️ 코드 소개

#### Extension
- String 타입 확장을 통해 취소선을 그리는 메서드를 구현했습니다.

#### CollectionViewCell
- ListCollectionViewCell, GridCollectionViewCell를 구현한 클래스입니다.

#### MarketInformation
- 서버 매핑 모델을 구현한 타입입니다.

#### MainViewController
- UI Components, Segmented Control, API 처리를 구현한 뷰 컨트롤러입니다.


---
### 🏀 TroubleShooting

#### 1. Application Test VS Library Test

- ApplicationTest와 LibraryTest의 차이는 극명하다.
- ApplicationTest는 iOS앱과 관련된 부분을 검사할 때 주로 사용한다. 
- LibraryTest는 앱과 상관없는 로직을 테스트하기 위해 사용한다.
- 호스트 앱을 시뮬레이터에 설치할 필요가 없어서 테스트가 더 빠르고 이따금씩 동작이 불안정한 시뮬레이터의 영향을 덜받는다.
- 아래와 같이 기존의 테스트를 진행했을 때와 LivraryTest로 바꿔서 테스트를 진행했을 때 테스트당 걸리는 시간이 거의 10배에 가까운 유의미한 결과를 얻을 수 있었다.

|Application Test 걸린시간|Library Test 걸린시간|
|--|--|
|<img src = https://i.imgur.com/onFx9QR.png width = 400 height = 300> |<img src = https://i.imgur.com/OZAEbUi.png width = 700 height = 300>|

#### 2. URLSession Unit Test

- 비동기 테스트 시, 사진과 같이 XCTAssert 메서드가 호출조차 되지 않고 테스트가 끝나 버린다.
- `expectation(description:), fulfill(), wait(for:timeout:` 코드를 이용하였더니 비동기 작업을 기다리게 되어, 테스트가 가능하게 되었다. 
![](https://i.imgur.com/YaxLbBg.png)

#### 3. 네트워크 맵핑모델 트러블

- 네트워크에서 마지막 페이지까지 데이터를 받아오는 재귀함수를 만들었는데 마지막 페이지는 137이었는데 72번 페이지에서 재귀함수가 탈출하는 이슈가 발생했다.
- LLDB를 이용해 함수의 분기마다 확인을 했을 때 72번째 페이지를 디코딩 하는 과정에서 맵핑에 실패하여 함수를 탈출함.
- 문제가 생긴 키값(price, bargainPrice, discountedPrice)이 Double값이 아니라 Int로 모델을 만들었기 때문에 Double값을 나타내는 72번째 페이지에서는 맵핑을 실패 했던 것이었다.
- 문제가 있던 키값의 타입을 Double로 바꿔서 해결 할 수 있었다.
- 마켓의 상품가격들이 한화뿐만 아니라 USD등 외화도 포함이 되었기 때문에 Int로 하는 것은 제대로된 모델링이 아니었던 것 같다. 사소한 부분도 잘 확인해서 이런 실수를 하지 않도록 해야 겠다.

| 네트워크 맵핑모델 | 서버 정보 | 트러블 결과 |
|:--:|:--:|:--:|
|<img src = https://i.imgur.com/x9fe0O9.png width = 400 height = 200> |<img src = https://i.imgur.com/3BQxRVi.png width = 500 height = 200>|<img src = https://i.imgur.com/MoPV79O.png width = 500 height = 300>|


---


### 참고한 페이지        

- [Implementing Modern Collection Views](https://developer.apple.com/documentation/uikit/views_and_controls/collection_views/implementing_modern_collection_views)
