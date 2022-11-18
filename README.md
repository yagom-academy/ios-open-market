# 🏬 오픈마켓 🏬

## 🗒︎ 목차
1. [소개](#-소개)
2. [개발환경 및 라이브러리](#-개발환경-및-라이브러리)
3. [팀원](#-팀원)
4. [타임라인](#-타임라인)
5. [파일구조](#-파일구조)
6. [UML](#-UML)
7. [실행화면](#-실행-화면)
8. [트러블 슈팅 및 고민](#-트러블-슈팅-및-고민)
9. [참고링크](#-참고-링크)

<br>

## 👋 소개

**서버와 통신이 가능한 오픈마켓 서비스 프로젝트 입니다**



<br>

## 💻 개발환경 및 라이브러리
[![swift](https://img.shields.io/badge/swift-5.6-orange)]()
[![macOS](https://img.shields.io/badge/macOS_Deployment_Target-13.2-blue)]()

<br>

## 🧑 팀원
|Zhilly|Dragon|
|:---:|:---:|
|<img src=https://user-images.githubusercontent.com/99257965/190572502-b7a41ed7-3c1b-44af-8b03-77d7e49d4705.png width=200>|<img src = "https://i.imgur.com/LI25l3O.png" width=200 height=200>| 

<br>

## 🕖 타임라인

### STEP 1
- STEP 1-1
    - 2022.11.14
        - JSON파일을 디코딩하여 저장할 모델 타입들 구현
        - JSONDecode Unit Test 작성
        - 폴더 구조화 및 리팩터링
- STEP 1-2
    - 2022.11.15
        - 서버와 통신을 하는 NetworkManager 타입 구현
        - NetworkError 타입 구현
        - 서버에서 보내는 Response에 따라 다르게 동작하는 로직 구현
        - 테스트 모델과 서버에서 받은 모델이 다른 이유로 모델 타입 수정
- STEP 1-3
    - 2022.11.16
        - NetworkManager타입이 외부요인과 관계없이 테스트 할 수 있도록 Mock 타입구현
        - Mock 타입을 이용해 NetworkManager Unit Test 작성
        - 전반적인 코드 리팩토링 및 그룹화, 은닉화 작업

<br>

## 💾 파일구조

### tree
```bash
.
└── OpenMarket
    ├── OpenMarket
    │   ├── Info.plist
    │   ├── Resources
    │   │   ├── Assets.xcassets
    │   │   │   └── products.dataset
    │   │   │       ├── Contents.json
    │   │   │       └── products.json
    │   │   └── Base.lproj
    │   │       └── LaunchScreen.storyboard
    │   └── Sources
    │       ├── App
    │       │   ├── AppDelegate.swift
    │       │   └── SceneDelegate.swift
    │       ├── Controller
    │       │   └── ViewController.swift
    │       ├── Model
    │       │   ├── JSONDecode+Extension.swift
    │       │   └── Network
    │       │       ├── Get
    │       │       │   ├── CurrencyEnum.swift
    │       │       │   ├── ProductDetail
    │       │       │   │   ├── Image.swift
    │       │       │   │   ├── ProductDetail.swift
    │       │       │   │   └── Vendor.swift
    │       │       │   └── ProductList
    │       │       │       ├── Page.swift
    │       │       │       └── ProductList.swift
    │       │       ├── NetworkEnum
    │       │       │   ├── HttpMethodEnum.swift
    │       │       │   ├── NetworkErrorEnum.swift
    │       │       │   └── ProductsAPIEnum.swift
    │       │       ├── NetworkManager.swift
    │       │       ├── URLSession+Extension.swift
    │       │       └── URLSessionProtocol.swift
    │       └── View
    │           └── Base.lproj
    │               └── Main.storyboard
    ├── JSONDecodeTests
    │   └── JSONDecodeTests.swift
    └── MockURLSessionTests
        ├── Mock
        │   ├── MockData.swift
        │   ├── MockURLSession.swift
        │   └── MockURLSessionDataTask.swift
        └── MockURLSessionTests.swift
```
<br>

## 📊 UML
(추후 작성)

<br>

## 💻 실행 화면

- STEP2에서 UI작업 후 추가 예정

<br>

## 🎯 트러블 슈팅 및 고민
> **서버 데이터타입과 `products.json`파일의 데이터타입이 다름**
- 서버 데이터 타입으로 `Testproducts.json`파일을 만들어 하나의 데이터타입으로 UnitTest를 수행했습니다

> **브랜치 전략**
- STEP-1이 3단계로 나눠져 있어서 브랜치를 어떻게 만들지 고민했었습니다. main에서 각각의 브랜치를 따로따로 만들어 주는 것보다, STEP-1브랜치를 생성하고 여기서 브랜치를 새로 만들어 주는 방식으로 진행했습니다. 만약 STEP-1-1이 끝난다면 STEP-1으로 Merge 시키는 방식으로 브랜치 전략을 세웠습니다.

<br>

## 📚 참고 링크
- [URLSession](https://developer.apple.com/documentation/foundation/urlsession) <br>
    - [Fetching Website Data into Memory](https://developer.apple.com/documentation/foundation/url_loading_system/fetching_website_data_into_memory) <br>
- [UICollectionView](https://developer.apple.com/documentation/uikit/uicollectionview) <br>
    - [Modern cell configuration](https://developer.apple.com/videos/play/wwdc2020/10027/) <br>
    - [Lists in UICollectionView](https://developer.apple.com/videos/play/wwdc2020/10026) <br>
    - [Implementing Modern Collection Views](https://developer.apple.com/documentation/uikit/views_and_controls/collection_views/implementing_modern_collection_views) <br>
