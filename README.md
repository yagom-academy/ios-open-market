# 🏪 Open Market 🏪
> 프로젝트 기간: 2022-11-14 ~ 2022-11-25 (2주)

## 🗒︎목차
1. [소개](#-소개)
2. [개발환경 및 라이브러리](#-개발환경-및-라이브러리)
3. [팀원](#-팀원)
4. [타임라인](#-타임라인)
5. [파일구조](#-파일구조)
6. [UML](#-uml)
7. [실행화면](#-실행-화면)
8. [트러블 슈팅 및 고민](#-트러블-슈팅-및-고민)
9. [참고링크](#-참고-링크)

## 👋 소개
- API 서버와 통신하여 데이터를 구축하고, Collection View를 사용해 UI를 구현해 오픈 마켓을 제작하는 프로젝트 입니다.
- URLSession, JSON parsing, UICollectionView 개념을 기반으로 제작되었습니다.

<br>

## 💻 개발환경 및 라이브러리
[![swift](https://img.shields.io/badge/swift-5.6-orange)]()
[![macOS](https://img.shields.io/badge/macOS_Deployment_Target-14.0-blue)]()

<br>

## 🧑 팀원
|애쉬|som|
|:---:|:---:|
|<img src= "https://avatars.githubusercontent.com/u/101683977?v=4" width ="200">|<img src = "https://i.imgur.com/eSlMmiI.png" width=200 height=200>|


<br>

## 🕖 타임라인

### STEP-1
- 2022.11.15
  - JSON 데이터의 Model 타입 구현 [![feat](https://img.shields.io/badge/feat-green)]()
  - Item타입의 유닛 테스트 진행 [![test](https://img.shields.io/badge/test-purple)]()
  - URLSessionManager 타입 내 dataTask 및 GET 관련 메서드 구현 [![feat](https://img.shields.io/badge/feat-green)]()

- 2022.11.16
  - HTTPMethod 열거형 추가 [![refactor](https://img.shields.io/badge/refactor-blue)]()
  - NameSpace 추가 [![refactor](https://img.shields.io/badge/refactor-blue)]()
  - URLSessionManager 타입 삭제 [![fix](https://img.shields.io/badge/fix-orange)]()
  - HTTPManager, JSONConverter, NetworkManager 타입 구현 및 테스트 코드 작성 [![feat](https://img.shields.io/badge/feat-green)]()
  - 서버 JSON데이터와 동일한 프로퍼티로 Item 타입 수정 [![refactor](https://img.shields.io/badge/refactor-blue)]()

- 2022.11.17
  - class -> struct로 변경 [![refactor](https://img.shields.io/badge/refactor-blue)]()
  - 네트워크 오류 처리 메서드 추가 [![feat](https://img.shields.io/badge/feat-green)]()
  - OpenMarketURLComponent 타입 추가 [![feat](https://img.shields.io/badge/feat-green)]()
  - Item과 ItemList의 JSON 데이터를 가져오는 메서드 통합 [![refactor](https://img.shields.io/badge/refactor-blue)]()
  - getJSONData 메서드에 data 타입 매개변수 추가 [![refactor](https://img.shields.io/badge/refactor-blue)]()

- 2022.11.18
  - STEP1 `README.md` 업데이트 [![docs](https://img.shields.io/badge/docs-yellow)]()

- 2022.11.21
  - HTTPManager, JSONConverter Singleton 패턴 적용 [![refactor](https://img.shields.io/badge/refactor-blue)]()

### STEP-2
- 2022.11.22
  - navigation contoller 및 navigation Item 추가 [![feat](https://img.shields.io/badge/feat-green)]()
  - MainVC에 ItemList JSON 데이터 디코딩 코드 추가 [![feat](https://img.shields.io/badge/feat-green)]()

- 2022.11.25
  - STEP2 `README.md` 업데이트 [![docs](https://img.shields.io/badge/docs-yellow)]()

- 2022.11.27
  - ListCollectionViewCell & GridCollectionViewCell의 오토레이아웃 및 로딩 뷰 설정 [![feat](https://img.shields.io/badge/feat-green)]()
  - itemList 데이터를 diffableDataSource와 snapshot으로 저장하도록 수정 [![feat](https://img.shields.io/badge/feat-green)]()
  - createListLayout, configureListHierarchy, configureListDataSource 메서드 구현 [![feat](https://img.shields.io/badge/feat-green)]()
  - createGridLayout, configureGridHierarchy, configureGridDataSource 메서드 구현 [![feat](https://img.shields.io/badge/feat-green)]()
  - ListCell & GridCell의 configureContent 메서드 구현 [![feat](https://img.shields.io/badge/feat-green)]()
  - segmentedControl의 attribute 구현, didChangeValue 메서드 구현, viewDidLoad에 호출 [![feat](https://img.shields.io/badge/feat-green)]()
  - getImageData 메서드 구현 및 캐시 사용 [![feat](https://img.shields.io/badge/feat-green)]()
  - NumberFormatter 및 NameSpace 적용 [![feat](https://img.shields.io/badge/feat-green)]()

- 2022.11.30
  - viewDidLoad의 메서드 호출 부분 정리 및 final 키워드 삽입 [![refactor](https://img.shields.io/badge/refactor-blue)]()
  - OperMarketURL과 Component 열거형 통합 [![refactor](https://img.shields.io/badge/refactor-blue)]()
  - configureHierarchy 메서드 수정 [![fix](https://img.shields.io/badge/fix-orange)]()
  - configureContent 메서드 분리, configureItemImage 약한 참조로 수정 [![fix](https://img.shields.io/badge/fix-orange)]()

- 2022.12.01
  - collectionView & dataSource를 옵셔널로 수정 [![refactor](https://img.shields.io/badge/refactor-blue)]()
  - plusButton 메서드 내에서 구현 [![refactor](https://img.shields.io/badge/refactor-blue)]()
  - 코드 컨벤션 통일 [![refactor](https://img.shields.io/badge/refactor-blue)]()



<br>

## 💾 파일구조
```
OpenMarket
├── Model
│   ├── HTTPManager
│   ├── JSONConverter
│   ├── NetworkManager
│   ├── ImageCacheManager
│   ├── Namespace
│   ├── ItemList
│   ├── Item
│   ├── Currency
│   └── NumberFormatter
├── View
│   ├── ListCollectionViewCell
│   └── GridCollectionViewCell 
├── Controller
│   ├── MainViewController
│   └── EmptyViewContoller
└── OpenMarketTests
    └── OpenMarketTests
```

<br>

## 📊 UML
![](https://i.imgur.com/OwHL6ax.jpg)





<br>

## 💻 실행 화면
| 기본 화면 | List 화면 | Grid 화면 |
|:----:|:----:|:----:|
|![오픈마켓 - 세그먼트컨트롤](https://user-images.githubusercontent.com/94514250/203892634-70918cba-62da-43af-bc41-87993fc1ebc0.gif)|![오픈마켓 - list 화면](https://user-images.githubusercontent.com/94514250/203892498-5c249cfd-562d-4146-8a0f-bb5c3bdf3a4c.gif)|![오픈마켓 - grid 화면](https://user-images.githubusercontent.com/94514250/203892511-be9a9597-9327-44b4-8fc1-235526f15ff6.gif)|




<br>

## 🎯 트러블 슈팅 및 고민
- 테스트 파일에서 `@testable import <프로젝트명>`로 import가 불가한 문제
  - 소스 파일 별로 test 파일의 TargetMembership을 추가하는 방식으로 해결했었습니다.
  - 추후 프로젝트 규모가 커지는 경우, TargetMembership을 계속 체크해주는 것은 비효율적인 방법이라고 생각했습니다.
  - 해당 문제의 근본적인 원인은 프로젝트 소스 파일에 1개 이상의 오류가 있는 경우, test 파일에서 import가 불가한 것으로 노티되는 것이었습니다.
  - 소스 파일의 모든 오류를 해결하고, `@testable import <프로젝트명>`을 사용해 import 하는 것으로 해결했습니다.

- Get 요청을 보냈을 때 원하는 Data를 전달받지 못하는 문제
  - 처음에는 네트워크 통신 쪽 구현이 잘못되었나 싶어 네트워크 통신 타입을 계속 고치다가 디버깅을 통해 디코딩하는 과정에서 문제가 생겼다는 것을 알게 되었습니다. 그리고 POSTMAN으로 서버의 JSON 데이터를 받아온 결과, 테스트용 데이터와 서버용 데이터가 다르다는 사실을 알게 되었습니다🤣
    |서버용|테스트용|
    |:----:|:----:|
    |![](https://i.imgur.com/t1M36l8.png)|![](https://i.imgur.com/gwHEsqV.png)|
    
    서버용에는 `description`과 `vendorName`이 있지만 테스트용에는 해당 데이터가 없어 일어난 오류였습니다. 

- ItemList vs Item의 서버 JSON Data가 상이한 문제
  - ItemList vs. Item의 서버 JSON Data도 venderName의 유무의 차이가 있어 Model 타입에서 venderName을 옵셔널로 구현했습니다. 

    | ItemList의 서버 JSON Data | Item의 서버 JSON Data |
    |:----:|:----:|
    |![스크린샷 2022-11-17 오후 8 23 45](https://user-images.githubusercontent.com/94514250/202434062-57034da5-0842-42e6-82ed-60672c7dcb9c.png)|![스크린샷 2022-11-17 오후 8 23 17](https://user-images.githubusercontent.com/94514250/202433999-b81ef6b5-7bbd-40bf-a92b-13b656e6f604.png)|

- NetworkManager 타입 get 메서드의 코드 중복도가 높은 문제
  - 아래의 코드를 보면 ItemList와 Item의 데이터를 가지고 오는 메서드를 각각 구현하였습니다. 
      ```swift
    func getItemListData(completion: @escaping (ItemList?) -> Void) {
            HTTPManager.requestGet(url: OpenMarketURL.base + OpenMarketURL.itemPage) { data in
                guard let data: ItemList = JSONConverter.decodeData(data: data) else {
                    return
                }
                completion(data)
            }
        }

        func getItemData(completion: @escaping (Item?) -> Void) {
            HTTPManager.requestGet(url: OpenMarketURL.base + OpenMarketURL.product) { data in
                guard let data: Item = JSONConverter.decodeData(data: data) else {
                    return
                }
                completion(data)
            }
        }
    ```
    그러나 차이점은 URL이 다르다는 점과 데이터를 가져올 Model타입이 다르다는 점 외에는 공통된 부분이 많은 코드라 기능을 합치는 작업을 진행했습니다. 
    ```swift
    func getJSONData<T: Codable>(url: String, type: T.Type, completion: @escaping (T) -> Void) {
        HTTPManager.requestGet(url: url) { data in
            guard let data: T = JSONConverter.decodeData(data: data) else {
                return
            }

            completion(data)
        }
    }
    ```
    2가지 차이점을 파라미터를 통해 URL은 String, 타입은 Generic으로 구현하였습니다. 
    
- **Compositional layout vs Flow layout**
어떤 layout으로 Collection View를 구현할지 고민한 결과, Compositional layout으로 구현하기로 했습니다. List와 Grid의 화면이 전환될 때의 애니메이션이 매끄럽고, `UICollectionViewDiffableDataSource`가 데이터 및 사용자 인터페이스에 대한 업데이트를 간단하고 효율적으로 관리하는 데 필요한 동작을 제공하기 때문입니다.
또한, List와 Grid layout 구성 시 group의 count 숫자만 레이아웃에 따라 수정하면 되는 간편함이 있기 때문에 이번 프로젝트를 구현함에 있어 적합한 기술이라고 생각했습니다.
    ```swift
    private func createGridLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(0.3))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        let spacing = CGFloat(10)
        group.interItemSpacing = .fixed(spacing)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = spacing
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    ```

- **SceneDelegate에 ViewController이랑 UINavigationController 다 추가했는데.. 왜 안 뜰까?**
`Main.storyboard` 파일을 지웠음에도 `Could not find a storyboard named 'Main'` 오류가 지속적으로 발생하여 SceneDelegate의 구현 코드가 문제가 있다고 생각했었습니다. 하지만, 이후 아래 포스팅을 통해 문제의 원인을 확인하고 해결하였습니다.☺️
[[iOS][Swift] - 스토리보드 없이 코드로만 UI 구현하기 (SceneDelegate에서 window설정)](https://velog.io/@lina0322/iOSSwift-%EC%8A%A4%ED%86%A0%EB%A6%AC%EB%B3%B4%EB%93%9C-%EC%97%86%EC%9D%B4-%EC%BD%94%EB%93%9C%EB%A1%9C%EB%A7%8C-UI-%EA%B5%AC%ED%98%84%ED%95%98%EA%B8%B0-SceneDelegate%EC%97%90%EC%84%9C-window%EC%84%A4%EC%A0%95)
Info.plist에서 스토리보드 이름이 등록된 부분을 삭제하여 코드로 구현한 ViewController를 화면에 나타내었습니다.

- **이미지 로딩 후 해당 셀에서 벗어나는 문제**
아래의 자료와 같이, 이미지가 로딩될 때 해당 셀이 아닌 다른 셀에 나타났다가 다시 해당 셀에 뜨는 문제가 생겼습니다.
(*[시원한 폭포]의 이미지 참고)
![](https://i.imgur.com/p8Neh81.gif)

```swift
class ListCollectionViewCell: UICollectionViewCell {
    var product: Item?
    
    func configureContent(item: Item) {
        self.product = item
        
        NetworkManager().getImageData(url: url) { image in
            DispatchQueue.main.async {
                if item == self.product {
                    self.thumbnailView.image = image
                    self.loadingView.stopAnimating()
                    self.loadingView.isHidden = true
                }
            }
        }
    }
}
```
컬렉션 뷰의 셀에 이미지를 등록할 때, MainViewController의 `configureListDataSource()` 메서드에서 completion handler를 통해 `cell.configureContent(item: item)`를 호출하게 됩니다. 이 때, item의 값을 handler에서 캡쳐해서 사용하게 되는데, 유저가 스크롤을 하다보니 당시에 캡쳐한 item값과 셀이 보여지는 순간의 item값이 다를 수 있어 발생하는 문제라고 생각하였습니다. 그래서 셀을 등록할 때, 셀의 데이터 타입(Item)과 product 프로퍼티의 타입(Item)이 같은 지 비교하는 조건문을 넣어 해당 문제 해결했습니다.

<br>

## 📚 참고 링크
- [Apple Developer - URLSession](https://developer.apple.com/documentation/foundation/urlsession) 
- [Apple Developer - Fetching Website Data into Memory](https://developer.apple.com/documentation/foundation/url_loading_system/fetching_website_data_into_memory) 
- [Apple Developer - Implementing Modern Collection Views](https://developer.apple.com/documentation/uikit/views_and_controls/collection_views/implementing_modern_collection_views)
- [Apple Developer - Updating Collection Views Using Diffable Data Sources](https://developer.apple.com/documentation/uikit/views_and_controls/collection_views/updating_collection_views_using_diffable_data_sources)
- [Apple Developer - Customizing Your App’s Navigation Bar](https://developer.apple.com/documentation/uikit/uinavigationcontroller/customizing_your_app_s_navigation_bar)
- [Apple Developer - NSCache](https://developer.apple.com/documentation/foundation/nscache)
- [네트워크 구현에 도움을 받은 블로그](https://bibi6666667.tistory.com/m/359)
- [네트워크 튜토리얼 사이트](https://www.kodeco.com/3244963-urlsession-tutorial-getting-started#toc-anchor-001)
- [스토리보드 없이 코드로만 UI 구현하기](https://velog.io/@lina0322/iOSSwift-%EC%8A%A4%ED%86%A0%EB%A6%AC%EB%B3%B4%EB%93%9C-%EC%97%86%EC%9D%B4-%EC%BD%94%EB%93%9C%EB%A1%9C%EB%A7%8C-UI-%EA%B5%AC%ED%98%84%ED%95%98%EA%B8%B0-SceneDelegate%EC%97%90%EC%84%9C-window%EC%84%A4%EC%A0%95)


