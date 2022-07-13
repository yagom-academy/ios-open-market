# 오픈마켓

## 프로젝트 소개
오픈마켓을 창설하여 상품을 관리해본다.

> 프로젝트 기간: 2022-07-11 ~ 2022-07-22</br>
> 팀원: [수꿍](https://github.com/Jeon-Minsu), [케이](https://github.com/KayAhnDS) </br>
리뷰어: [Wody](https://github.com/Wody95)</br>
그라운드롤: [GroundRule](https://github.com/Jeon-Minsu/ios-open-market/blob/STEP01/Docs/GroundRule.md)

## 📑 목차

- [🧑🏻‍💻🧑🏻‍💻 개발자 소개](#개발자-소개)
- [💡 키워드](#키워드)
- [🤔 핵심경험](#핵심경험)
- [📚 참고문서](#참고문서)
- [📝 기능설명](#기능설명)
- [🚀 TroubleShooting](#TroubleShooting)
- [1️⃣ STEP 1](https://github.com/Jeon-Minsu/ios-bank-manager/tree/step01/Docs/Step01.md)


## 🧑🏻‍💻🧑🏻‍💻 개발자 소개

|케이|수꿍|
|:---:|:---:|
|<image src = "https://user-images.githubusercontent.com/99063327/178641788-995112c1-924a-4768-b46b-c9bf3a04a994.jpeg" width="250" height="250">| <image src = "https://i.imgur.com/6HkYdmp.png" width="250" height="250">
|[케이](https://github.com/KayAhnDS)|[수꿍](https://github.com/Jeon-Minsu)|

## 💡 키워드

- `POP`, `protocol`, `extension`
- `URL`, `URLSession`, `URLDataTask`
- `dataTask`, `completion` 
- `Data`
- `URLResponse`, `HTTPURLResponse`, `statusCode`
- `Error`
- `resume`
- `Result Type`, `escaping closure`
- `JSONDecoder`
- `Generics`
- `Codable`, `CodingKeys`

## 🤔 핵심경험
    
- [x] 파싱한 JSON 데이터와 매핑할 모델 설계
- [x] URL Session을 활용한 서버와의 통신
- [x] CodingKeys 프로토콜의 활용
- [x] 네트워크 상황과 무관한 네트워킹 데이터 타입의 단위 테스트(Unit Test)


## 📚 참고문서

- [URLSession](https://developer.apple.com/documentation/foundation/urlsession)
    - [Fetching Website Data into Memory](https://developer.apple.com/documentation/foundation/url_loading_system/fetching_website_data_into_memory)
    
## 📝 기능설명
    
### 네트워크 통신을 담당할 타입을 설계하고 구현
    - JSONData
        - JSON 파일에 대한 parse, decode 기능 수행
    - WebPage, Product
        - 서버 API 데이터 형식을 고려하여 모델 타입 구현
    - URLData
        - 서버로부터 데이터를 받아오는 기능을 수행
        - 기능을 수행한 위한 protocol, extension 별도 생성
    - NetworkError
        - 서버로부터 데이터를 받아오는 도중 발생하는 에러 표현


## 🚀 TroubleShooting
    
### STEP 1

#### T1. 주고 받는 모델 타입의 불일치로 인한 통신 실패 해결.
- URLSession와 GET Method를 테스트를 했을때 값을 제대로 받아오지 못하는 문제를 만났습니다. 예를들어 서버에서는 Product 모델 타입의 정보를 주는데 클라이언트에서 받는 모델 타입이 WebPage이면 제대로된 통신이 이뤄질 수 없다는것을 확인하였습니다. 이후 서버에서 주는 형식이 클라이언트에서 받는 형식과 동일 해야 정상적으로 받아올 수 있는것을 확인하였습니다. 

    
#### T2. 하나의 파라미터에 서로 다른 두개의 타입 사용 고민 해결.
- fetchData메서드와 dataTask(with:) 메서드의 매개변수로 URL 타입과 URLRequest 타입을 모두 사용하기 위해 메서드 오버로딩을 생각했었습니다. protocol 선언후 두 타입이 채택하는 방법이 많은 양의 코드를 반복하는 오버로딩 방식보다 가독성과 효율적인 측면에서 낫다고 판단해 들어갈수있는 모든 타입이 특정 프로토콜을 채택하는 방식으로 문제를 해결했습니다.
--- 
