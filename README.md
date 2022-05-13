# 🛍 오픈 마켓

>프로젝트 기간 2022.05.09 ~ 2022.05.20
>
>팀원 : [marisol](https://github.com/marisol-develop), [Eddy](https://github.com/kimkyunghun3) / 리뷰어 : [린생](https://github.com/jungseungyeo)

## 목차

- [프로젝트 소개](#프로젝트-소개)
- [UML](#UML)
- [키워드](#키워드)
- [고민한점](#고민한점)
- [배운개념](#배운개념)

## 프로젝트 소개

오픈마켓 만들기!


## UML
![](https://i.imgur.com/7gT8slu.jpg)

## 개발환경 및 라이브러리
![swift](https://img.shields.io/badge/swift-5.5-orange)
![xcode](https://img.shields.io/badge/Xcode-13.0-blue)
![iOS](https://img.shields.io/badge/iOS-13.0-yellow)

## 키워드

`git flow` `Test Double` `URLSession` `StubURLSession` `Protocol Oriented Programming` `추상화` `json` `HTTP method` `decode` `escaping closure`

## 고민한점

- URL을 어떻게 조합해서 만들어줘야 할까?
- 하나의 NetworkManager로 네트워크 통신 성공시 여러 타입의 데이터를 디코딩하기 위한 제네릭 타입 사용
- dataTask 속 error의 에러처리 표현
- init Deprecated
- test code에서 강제언래핑 사용가능여부
- HTTPURLResponse 에 대한 궁금증

### 자세한 고민 보기

#### [STEP1]()


## 배운개념

### 📌 1. URL을 어떻게 조합해서 만들어줘야 할까?

네트워크에 요청을 보내는 GET 역할을 하는 execute 메서드에서 사용할 url을 어떻게 만들어줄지 고민했습니다.
공통으로 사용되는 hostAPI, path 등을 API enum에 static let으로 선언해주고, case 별로 돌면서 enum 메서드에서 연관값을 입력받아 쿼리를 완성한 뒤에, hostAPI와 Path와 쿼리를 합쳐 url을 만들어주었습니다.

```swift
enum API {
    static let hostAPI = "https://market-training.yagom-academy.kr"
    static let productPath = "/api/products"
    static let healthCheckerPath = "/healthChecker"
    
    case productList(pageNo: Int, itemsPerPage: Int)
    case productDetail(productId: Int)
    case healthChecker
    
    func generateURL() -> String {
        switch self {
        case .productList(let pageNo, let itemsPerPage):
            return API.hostAPI + API.productPath + "?page_no=\(pageNo)&items_per_page=\(itemsPerPage)"
        case .productDetail(let productId):
            return API.hostAPI + API.productPath + "/\(productId)"
        case .healthChecker:
            return API.hostAPI + API.healthCheckerPath
        }
    }
}
```

### 📌 2. 하나의 NetworkManager로 네트워크 통신 성공시 여러 타입의 데이터를 디코딩하기 위한 제네릭 타입 사용

Product, ProductDetail, Application HealthChecker 3가지 타입의 데이터를 하나의 GET 메서드를 사용해서 가져올 수 있도록 NetworkManager에 Decodable을 채택하는 제네릭 타입을 선언해주었습니다. 처음에는 ProductNetworkManager와 HealthCheckerNetworkManager 2개의 타입을 만들어주었는데, String이 Decodable 프로토콜을 채택하고 있다는 것을 알게되어 하나로 사용할 수 있었습니다.

