# 오픈 마켓 
> 프로젝트 기간 2022-05-09 ~ 2022-05-20

팀원 : [두기](https://github.com/doogie97), [minseong](https://github.com/Minseong-yagom) / 리뷰어 : [LinSaeng](https://github.com/jungseungyeo)

## 실행화면
![](https://i.imgur.com/0acLn8e.gif)

## 기능 구현
- 파싱한 JSON 데이터와 매핑할 모델 설계
- CodingKeys 프로토콜의 활용
- URL Session을 활용한 서버와의 통신
- 네트워크 상황과 무관한 네트워킹 데이터 타입의 단위 테스트(Unit Test)
- 파싱한 데이터를 CollectionView를 활용한 UI구성
- SegmentController를 이용해 CollectionView 레이아웃변경
- 네트워크로부터 얻은 ImageData를 Cache를 이용해 재사용

## Trouble Shooting
### 1. test만을를 위해 session을 var로 선언해야 하는지?
![](https://i.imgur.com/i6KLpct.png)

실제 사용에 있어서 NetworkHandler가 선언된 이후 session은 변경될 일이 없으나 test에서 기존에 만들어준 가짜 객체인 session을 넣어주기 위해 var로 선언해주는 것이 맞는지 고민함

-> 은닉화를 위반하여 매우 위험한 코드이기 때문에 추상화를 하고 init을 통해 가짜 객체를 할당할 수 있도록 변경함

### 2. API요청 메서드의 추상화
![](https://i.imgur.com/ZcSeMih.png)
최초에는 이런식으로 해서 HTTP메서드 GET에 한정됐다

![](https://i.imgur.com/ZzrzV5m.png)

근데 이렇게 각 http메서드 마다 필요한 모델을 APIable이라는 프로토콜로 추상화 시켜 만들어주었고

![](https://i.imgur.com/CJitziJ.png)
위와 같이 APIable을 체택한 모델들은 모두 들어 올 수 있게 구성하여 request메서드 하나로 모든 HTTP메서드를 사용 할 수 있게 되었다
(아직은 GET이 외의 HTTP 메서드들은 기능 구현이 되지 않은 상태)

### 3. 세그먼트를 변경하였을 때 셀의 위치
![](https://i.imgur.com/3Ao8bO9.png)

LIST모드 최 상단에서 GRID모드로 바꿨을 때 cell의 위치가 최 상단이 아닌 현상이 있었음(반대도 마찬가지)
어느 정도 위치를 공유 하는 것 같기는 한데 변경 후 index를 확인 해봤을 때 최상단의 cell이 바로 나오지 않아 화면의 비율 만큼 offset 지정을 해줌

![](https://i.imgur.com/3Ptcz96.png)

변경 후

![2022-05-20__5_41_44_AdobeCreativeCloudExpress](https://user-images.githubusercontent.com/94295586/169499133-3372fdcc-8911-4fb8-ac7b-86eff642afcb.gif)


### 4. cell 추상화 방법의 문제점

ItemCellable프로토콜을 통해 LIST cell과 GRID cell을 추상화 해주고자 했으나 최초에는 프로퍼티를 통해 추상화를 하였음

![](https://i.imgur.com/Z8wN7Fu.png)

이는 추상화가 되기는 했으나 프로퍼티 수정을 위해 get set으로 구현되어 외부에 그대로 노출되게 되었으며 은닉화 위반되어 의도치 않은 변경을 유발하는 문제점이 발생 할 가능성이 생김

![](https://i.imgur.com/Mmm6i0d.png)

-> 메서드로 추상화함으로써 프로퍼티 직접접근이 아닌 메서드를 통해 UI업데이트 진행하였다.

![](https://i.imgur.com/8pIjffx.png)

### 5. cell을 구성할 때 마다 이미 다운로드된 data와 동일한 data를 표시함에도 또 다시 서버와 통신을 하여 똑같은 data를 다운하는 문제

![](https://i.imgur.com/5ibSZse.png)

최초에는 위와 같이 getItemPage안에서 cell을 구성하는 메서드를 호출하다보니 cell이 화면에 나타날 때 마다 서버와 통신하는 문제가 발생
(cell에 표시되는 건 ItemPage안에 있는 Item배열의 Item하나인데 이 Item하나를 가져오기 위해 계속해서 서버와 통신하며 ItemPage를 가져오는 것은 비효율적이라고 생각)

![](https://i.imgur.com/Inp0iFZ.png)

![](https://i.imgur.com/NbkKnAV.png)

-> ItemPage의 Item배열을 저장해 사용하는 로직으로 변경

![](https://i.imgur.com/Sbu7Kk0.png)

저장한 Item의 프로퍼티에는 thumbnail주소가 있는데 이 이미지는 cache에 담아 사용하기로 함

<이유> 
1. cell에 이미지를 할당해 줄 때 마다 서버에서 다운로드 하면 비효율적
2. 그렇다고 5번의 item과 같이 배열로 저장할까 했으나 이미지는 메모리를 과하게 차지할 위험이 있음

-> thumbnail을 key로, 다운한 image를 value로 cache에 담아주게 되었으며 어플이 종료되면 사라지는 NSCache로 구현하였음

## 배운 개념
- 프로토콜을 활용한 추상화
- Collection View
- UICollectionViewCompositionalLayout
- CollectionView의 prefetch
- URLSession
- Networking
- NSCache
- HTTP
- Result타입
- @escaping


## 커밋 룰
Commit message
커밋 제목은 최대 50자 입력

💎feat : 새로운 기능 구현

✏️chore : 사소한 코드 수정, 내부 파일 수정, 파일 이동 등

🔨fix : 버그, 오류 해결

📝docs : README나 WIKI 등의 문서 개정

♻️refactor : 수정이 있을 때 사용 (이름변경, 코드 스타일 변경 등)

⚰️del : 쓸모없는 코드 삭제

🔬test : 테스트 코드 수정

📱storyboard : 스토리 보드를 수정 했을 때
