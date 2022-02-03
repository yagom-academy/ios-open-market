# 오픈마켓 

1. 프로젝트 기본정보
2. App 구동화면
3. 주요설계 포인트
4. 문제+해결과정
5. 기타 Lession Learn

## 🌀 1. Project Info.
- `Contributor` : yohan, July
- `협업방식` : 페어 프로그래밍 (commit 단위로 돌아가며 작성)
- `기간` : 21.12.20 ~ 21.12.31 (4 weeks)
- `기술 키워드`
    - Networking(URLSession)
    - HTTP 메시지
    - Accessiblity (Dynamic type)
    - CollectionView, Cell 재사용
    - Image Processing (resize, compression)
    - 변경이 용이한 코드

## 🌀 2. App 구동
|메인화면|상품등록|상품수정|
|------|---|---|
|![메인화면](https://user-images.githubusercontent.com/39155090/151993545-e32d4d1e-bac2-4e5b-9c85-5c3bd2dfa0f4.gif)| ![상품등록](https://user-images.githubusercontent.com/39155090/151993600-1743cd39-d265-4905-9b1d-fbde48aeb015.gif) | ![상품수정](https://user-images.githubusercontent.com/39155090/151993606-c160b2c4-b0a0-4f50-995a-e8627ea17296.gif) |

## 🌀 3. 주요설계

### 🔸 코드배치 & 구조
![image](https://user-images.githubusercontent.com/39155090/152005137-6c6f508b-7189-4a94-af35-20bc102f1aab.png)

### 🔸 Networking API
`NetworkingAPI`라는 네임스페이스를 통해 네트워크 API들을 호출할 수 있습니다. 이후 각 API 별로 필요한 HTTP 메시지를 구성한 후 URLSessionProtocol에 기본구현으로 제공되는 `requestDataTask()`를 통해 메시지를 전송합니다 (URLSession은 URLSessionProtocol을 채택합니다)
![image](https://user-images.githubusercontent.com/39155090/152009263-ddba3dbd-c27b-4e96-b4f7-80efae1a1587.png)

### 🔸 Image Processing
이미지는 합리적인 선에서 퀄리티를 유지하면서도 가능한 한 용량을 줄이려면 어떤 기준을 세워야 할지를 고민하였습니다. 이를 위해 이미지 크기와 압축. 2가지 방향으로 접근하였습니다

우선, 이미지 사이즈를 얼마나 줄일지에 대한 고민이 필요했습니다. 너무 작은 사이즈로 줄였다가는 추후에 큰 사이즈로 display하는 요구사항이 생길 경우 대응이 어렵기 때문입니다. 이를 위해 아이폰 사이즈를 고려하였습니다. 보통 이미지를 가로 너비보다 크게 디스플레이하는 일은 거의 없다는 점과 현재 출시된 가장 큰 아이폰 13 Pro Max의 가로 너비가 428pt인 점을 감안하면 가로/세로를 500pt로 resize하면 합리적이라 판단하였습니다

이후, JPEG 압축을 시도하였고 압축품질을 막연히 낮추기 보다는 서버의 요구사항인 300KB를 기준을 만족하는 최고 품질로 압축되도록 구현하였습니다

### 🔸 UICollectionViewDiffableDataSource
이번 프로젝트를 하며 CollectionView를 새로이 학습하고 구현해보았습니다. 그 과정에서 다양한 시행착오가 있었지만 가장 기억에 남는 것은 `DiffableDataSource`을 사용한 것입니다. 전통적인 `UICollectionViewDataSource`과는 달리 `snapshot`이라는 개념이 도입되었고 이전 snapshot과 이후 snapshot을 비교하여 변경된 부분에 대해서만 갱신을 하기에 성능면에서 우수하다는 점이 매력적이었습니다

## 🌀 4. 당면한 문제 + 해결과정

### 🔸 Cell 재사용에 따른 이미지 중복 업데이트 문제
Cell 이미지 업데이트는 현재 가지고 있는 URL로부터 이미지를 비동기로 로드하여 업데이트하는 방식으로 구현되어 있습니다. 이미지를 로드하는데는 시간이 어느정도 필요하므로 그 사이 Cell이 재사용되면 로딩 중이던 이미지가 의도치 않은 cell에 업데이트되는 문제가 발생하였습니다

이를 해결하기 위해 이미지 로딩 완료 시점에 "로딩된 이미지의 URL과 현재 업데이트하려는 cell의 URL을 비교"하여 일치하는 경우에만 실제로 업데이트가 수행되도록 개선하였습니다

<img src="https://user-images.githubusercontent.com/39155090/152328973-a8c055fb-6829-4fcd-b7aa-a03d8e781614.png" width="80%">

### 🔸 화면이 하나의 큰 View를 공유하는 문제
상품등록 화면과 상품수정 화면은 UI가 매우 유사하므로 코드를 재사용하는 것을 고려해볼 수 있습니다. 이를 위해, 두 화면의 view를 통째로 모델링한 `ProductEditingView`를 만들어 서로 다른 부분은 변경이 가능하도록 인터페이스 메서드를 구현해주었습니다. 이는 요구사항이 변경되지 않는다면 괜찮은 구현일 수 있으나, 만에 하나 두 화면의 다른 부분이 늘어난다면 (특히 어느 한 화면에만 있는 UI가 발생한다면) 변경이 매우 어려운 구조라는 문제가 있었습니다

이를 해결하기 위해 한 덩어리로 된 view를 세분화해주는게 필요했습니다. 세분화 level은 세세할수록 변경에는 용이하나 재사용성은 떨어지는 부분이 있어 미래에 변경될 가능성이 적은 "적당한 수준"으로 세분화하는 것이 타당해보였습니다. NavigationBar와 ImageScrollView는 코드규모가 어느정도 있으면서 요구사항이 변경될 가능성이 낮다 판단되어 별도의 타입으로 구현해주었고 그 외 TextField/TextView는 마찬가지로 개별 UI 단위로는 변경 가능성이 낮으나 코드규모가 작아 재사용성에 따른 이득이 크지 않으므로 별도의 Custom 타입으로 구현하지 않고 `UITextField`/`UITextView` 그대로 사용하였습니다

![image](https://user-images.githubusercontent.com/39155090/152344783-cad03b7e-3017-4ed2-8cf3-1a1283fc1657.png)

## 🌀 5. 기타 Lession Learn
### 🔸 Custom Type 정의 시, final 처리
Custom type을 정의하는 경우 이를 다시 상속해서 또 다른 Custom type을 만들어 쓰는 등 상속으로 인해 복잡도가 올라가 가독성이 낮아집니다. 규모가 큰 코드에서 이런 상속 구조를 파악하기 위해선 일일히 검색해야 하므로 자식 타입이 없는 경우 final 처리를 통해 수고를 덜 수 있습니다

### 🔸 네트워크 로딩으로 동시에 여러 개를 업데이트하는 경우에서의 순서 관리
현재 코드에서 상품상세화면에서 상품수정으로 넘어갈 경우 URL을 기반으로 해당 상품에 대해 서버가 가지고 있는 모든 이미지를 불러와 StackView에 넣어주는 구조입니다. 이처럼 네트워크 로딩으로 여러 개의 이미지를 받아와 업데이트해주는 경우에서 요청순서와 응답순서가 다를 수 있으므로 필요하다면 순서를 지켜주기 위해 추가 처리가 필요합니다

현재 코드에선 이를 위해 이미지가 들어갈 `UIImageView`를 StackView에 먼저 넣어놓고 인덱스를 사용하여 로딩이 완료된 이미지를 절절한 위치의 ImageView에 넣는 방식을 사용하고 있습니다

### 🔸 delegate 사용 시 참조순환 주의
`Grid`/`ListCollectionViewController`는 상위 ViewController의 presentation 수행을 위해 `viewPresentationDelegate`라는 프로퍼티를 가집니다. 이는 서로를 참조하는 상황이므로 반드시 한 쪽은 약한참조 처리를 해주어야 참조순환 문제가 발생하지 않으므로 주의가 필요합니다
