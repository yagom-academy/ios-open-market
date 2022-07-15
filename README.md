# 오픈마켓 🏪
> 기간: 2022-07-11 ~ 2022-07-22
>
> 팀원: [Hugh](https://github.com/Hugh-github), [Kiwi](https://github.com/kiwi1023)
>
> 리뷰어: [Jake](https://github.com/jryoun1)

# 목차
* [프로젝트 소개](#프로젝트-소개)
    * [개발환경 및 라이브러리](#개발환경-및-라이브러리)
* [구현내용](#구현내용)
* [키워드](#키워드)
* [핵심경험](#핵심경험)
* [기능설명](#기능설명)
    * [STEP 1](#STEP1)


# 프로젝트 소개
오픈마켓 앱을 iOS 어플리케이션으로 구현해보는 프로젝트입니다.
다양한 작품들과 해당 작품에 대한 상세한 설명을 볼 수 있습니다.

### 개발환경 및 라이브러리
[![swift](https://img.shields.io/badge/swift-5.6-orange)]()
[![xcode](https://img.shields.io/badge/Xcode-13.3-blue)]()

# UML
추후 추가 예정


# 구현내용
추후 추가 예정

# 키워드

`URLSession`,`GCD`, `Synchronous`,`Asynchronous`, `Thread`, `Concurrent Programming`, `Functional Programming`,`Modern Collection View`, `Delegation`, `MVC`, `Design Patterns`

# 핵심경험

- [x] 파싱한 JSON 데이터와 매핑할 모델 설계
- [x] URL Session을 활용한 서버와의 통신
- [x] CodingKeys 프로토콜의 활용
- [ ] Safe Area을 고려한 오토 레이아웃 구현
- [ ] Collection View의 활용
- [ ] Mordern Collection View 활용
- [x]  네트워크 상황과 무관한 네트워킹 데이터 타입의 단위 테스트(Unit Test)
 - [ ] 로컬 캐시 구현

# STEP1

## 기능설명

#### `ItmeList`, `Page` 
+ 서버에서 받아오는 JSON 파일과 매칭할 데이터 모델
#### `OpenMarketURLSession` 
+ `getMethod`를 통해 서버에 있는 데이터를 조회하는 로직 구현
#### `RequestType` 
+ http Request Method를 정의하는 타입
#### `URLSessionProtocol` 
+ 의존성 주입 및 Mock test를 위해 생성한 프로토콜
#### `MockURLSessionDataTask` : 
+ `URLSessionDataTask` 상속받아 `resume()` 재정의
#### `MockURLSession` 
+ `OperMarketURLSession`에 주입하기 위해 `URLSessionProtocol` 채택

## 배운개념📚

1. MockData를 이용한 Network Unit Test 하기
    + 서버가 구현되지 않은 상태에서 테스트를 진행할 필요가 있다. 또한 네트워크 통신을 통해 테스트를 진행하게 되면 단위 테스트의 속도도 느려지고 인터넷 연결에 의존하기 때문에 테스트를 신뢰할 수 없다.
2. URL Session
    + URLSession을 이용해 서버와 데이터를 주고 받고 @escaping closure를 이용해 받아온 데이터를 활용할 수 있었다.

3. 비동기 단위 테스트
    + `expectation`, `fullfill()`, `wait`을 이용해 비동기 단위 테스트를 할 수 있다. wait에 설정한 시간(초) 이내에 테스트를 성공하지 못한다면 실패로 처리한다.

## 고민한점🤔
1. dataTask 과정에서 에러가 발생하면 어떻게 에러를 처리해야 하는지 고민했습니다. dataTask 메서드에 존재하는 escaping closure 같은 경우 throws 키워드가 존재하지 않아 에러를 던질 방법이 존재하지 않았습니다. 에러가 발생할 경우 해당 에러들을 처리해 주는 방법을 고민한 결과 Result 타입을 사용했습니다.

2. URLSession 내부에서 getMethod를 구현할 당시 파라미터를 클로저로 받은다음 escaping키워드 처리해야하는 이유에 대해서 고민을 하게 되었습니다. 알아본 결과 URLSession과 관련된 메서드들은 기본적으로 비동기 처리를 하고 있습니다. 그렇기 때문에 서버에서 받아온 data를 외부에서 사용하려면 data를 클로저의 파라미터로 받은 다음 @escaping 키워드를 사용하여 메서드가 종료된 후에 사용가능하게 만들어 주어야한다는 것을 알게 되었습니다.

## 궁금한점🧐
1. URLSession의 dataTask 메서드를 호출할때 아래의 사진 1번에서는 싱글톤을 통해서 호출하고 있으나, 사진 2번에서는 session이란 상수에 URLSession의 인스턴스를 생성하고 호출을 하고 있습니다. 코드를 실행하는데 있어 두가지 방법의 차이가 딱히 보이지 않는데 혹시 두 방법의 차이점을 알고 계신게 있다면 알려주시면 정말 감사하겠습니다!

- **사진 1**
![](https://i.imgur.com/3hhTGPS.png)
- **사진 2**
![](https://i.imgur.com/zjIdZly.png)

2. 서버가 존재하고 해당 서버에서 데이터를 가져올 수 있다면 네트워크와 무관한 테스틀 진행하는 이유에는 어떤게 있는지 궁금합니다. 실제 서버와 통시하여 테스트를 진행하면 속도가 느리지만 더 직관적으로 확인할 수 있다고 생각합니다.

## 궁금한 점에 대한 답변 ❗️

***1.***

URLSession의 configuration에 대해서 공부해보시면 두 개의 차이점에 대해서 발견하실 수 있을 것 같습니다.
추가로 default인 싱글톤을 통해서 호출하는 dataTask는 configuration이 가능한지에 대해서도 알아보시면 좋을 것 같아요 🙏🏻

- URL session의 기능과 동작은 상당수가 세션을 생성할때 사용된 configuration의 종류에 따라서 결정된다. 싱글톤 shared 세션은 기초적인 요청에 사용되며 직접 생성한 것만큼 커스터마이징할 수 없다. 그렇지만 제한된 요구사항 내에서는 좋은 출발점이 된다.
 
***2.***

지금 작성하시는 테스트의 목적은 response가 ItemList타입으로 데이터가 잘 decode 되었는지 확인하는 테스트라고 생각해주시면 될 것 같습니다. 이는 2가지 과정이 포함된 것이라고 볼 수 있을 것 같네요.

1. response가 서버로부터 잘 내려오는가
2. 정상적으로 내려온 response를 decode해서 ItemList타입으로 잘 맵핑되는가

이때 1번의 경우에는 실제로 개발을 하다보면 아직 서버가 개발이 덜 된 상태에서도 클라이언트가 개발하는 경우도 있고, 클라이언트 개발자가 인터넷이 없는 환경에서도 코드를 작성할 수도 있습니다.
서버의 개발이 끝날때까지 기다렸다가 클라이언트가 개발하면 바람직하겠지만 그렇지 않은 경우들이 많기도 하고, 또 서버에서 어떠한 문제가 생길지 모르니 네트워크 통신도 하나의 의존성이라고 생각해주시면 좋을 것 같습니다.

따라서 네트워크라는 의존성을 배제하고나서 단순히 테스트를 하려는 목적인 2번을 달성하려면 mock데이터를 통해서 테스트를 할 수 있도록 코드를 작성하는 것이 중요합니다.
