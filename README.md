
# 🛒 오픈 마켓

## 💾 프로젝트 저장소
>**프로젝트 기간** : 2022-07-11 ~ 2022-07-22<br>
**소개** : 네트워크 통신을 통해 상품 API를 가져와 물건을 매매있는 앱입니다. <br>
**리뷰어** : [**라이언**](https://github.com/ryan-son)

## 👥 팀원
    
| 현이 | 언체인 |
|:---:|:---:|
|<img src = "https://i.imgur.com/0UjNUFH.jpg" width="250" height="250">|<img src = "https://i.imgur.com/GlPnCo7.png" width="250" height="250">|
|[Github](https://github.com/seohyeon2)|[Github](https://github.com/unchain123)|

---

## 🛠 개발환경 및 라이브러리
[![swift](https://img.shields.io/badge/swift-5.6-orange)]()
[![xcode](https://img.shields.io/badge/Xcode-13.4.1-blue)]()
[![swiftLint](https://img.shields.io/badge/SwiftLint-13.2-green)]()
---

## 🕖 타임라인: 시간 순으로 프로젝트의 주요 진행 척도를 표시

### Week 1
- **2022-07-04 (월)** 
  - URLSession에 대해서 파악하기 위해 공부
 
- **2022-07-05 (화)**
  - STEP1 PR

- **2022-07-06 (수)**
  - URLSession에 대해 다시 공부하고 collectionView공부

- **2022-07-07 (목)**
  - 1차 리뷰 수정
  
- **2022-07-08 (금)**
  - Readme.md 작성 및 1차 리뷰 수정


---

## ✏️ 프로젝트 내용

### 💻 핵심 기능 경험
- [x] 파싱한 JSON 데이터와 매핑할 모델 설계
- [x] URL Session을 활용한 서버와의 통신
- [x] CodingKeys 프로토콜의 활용
- [x] Safe Area을 고려한 오토 레이아웃 구현
- [x] Collection View의 활용
- [x] Mordern Collection View 활용


### ⚙️ 코드 소개

#### MockURLSessionDataTask
- 기존의 URLSessionDataTask와 같은 역할을 하며 MockData를 이용하기 위해 만들어준 클래스입니다.

#### MockURLSession
- URLSession과 같은 기능을 하며 MockData를 받아서 실제 서버와 연결된 것처럼 만들어 주는 클래스 입니다.

#### MarketInformation
- 서버 매핑 모델을 구현한 타입입니다.

#### URLSessionProtocol
- URLSession의 dataTask 메소드를 교체하기 위해 dataTask 랑 동일한 시그니처를 정의해둔 protocol 입니다.

#### NetworkManager
- URLSession을 통해 받아온 데이터를 디코딩합니다.

#### NetworkError
- NetworkManager의 fetch 메서드 시, 발생하는 에러들의 타입입니다.

#### ViewController
- 실제 API의 데이터를 가져오는 getProductList메서드가 담겨있습니다.

#### OpenMarketTests
- MockData를 이용하여 테스트를 진행 하였습니다.


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


---

### 참고한 페이지

- [네트워크 없이 URLSession 테스트하는 법1 - Wody](https://wody.tistory.com/10)
- [네트워크 없이 URLSession 테스트하는 법2 - Naljin](https://sujinnaljin.medium.com/swift-mock-%EC%9D%84-%EC%9D%B4%EC%9A%A9%ED%95%9C-network-unit-test-%ED%95%98%EA%B8%B0-a69570defb41)
- [XCTest 소요시간 단축하기 - sujin.Ro](https://soojin.ro/blog/application-library-test)
