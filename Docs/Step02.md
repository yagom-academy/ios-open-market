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
    
[STEP2PR](https://github.com/yagom-academy/ios-open-market/pull/189)
