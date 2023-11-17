> 👆🏻 여기 햄버거 버튼을 눌러 목차를 확인하세요.

## 1. 프로젝트 소개

<img width="900" alt="image" src="https://user-images.githubusercontent.com/53863005/278953655-02aae5ad-379e-492c-8b67-a123df396d99.png">

> 마음 한 켠에 자리잡은 불필요한 감정은 메모를 통해 해소하세요. 휘발이에 쌓인 **감정쓰레기**를 자동으로 **휘발**시켜 드릴게요.

- **개요:** iOS 앱개발 프로젝트
- **팀원:** [이대현](https://github.com/hidaehyunlee), [김서온](https://github.com/anfgbwl), [김도윤](https://github.com/doyuny), [서동준](https://github.com/june-hehe) 총 4명
- **개발 기간:** 2023/10/10 ~ 2023/11/17
- **프로젝트 저장소**: [Github 바로가기](https://github.com/hidaehyunlee/HWIBAL)
- **서비스 주소**: [AppStore 바로가기](https://apps.apple.com/kr/app/%EC%95%84-%ED%9C%98%EB%B0%9C/id6471419210)
- **시연영상**:
https://github.com/hidaehyunlee/HWIBAL/assets/139306158/34415461-8574-4920-a92a-220cb125dccb

<br>

## 2. Interface

![interface 001](https://github.com/hidaehyunlee/HWIBAL/assets/139306158/3101025b-a312-4d0a-9051-713314a37b6c)

<br>

## 3. 기술구조

- **UI**: `UIKit`, `SnapKit`, `Figma`
- **Communication**: `Slack`, `Gather`, `Notion`
- **Architecture**: `MVC`
  - Model: CoreData, UserDefaults 등과 연결되어 영속적으로 관리할 Raw한 데이터 모델
    - Service: Model의 데이터를 View에 표시할 내용으로 정리하고 변환하며, CRUD와 추가 비즈니스 로직을 제공하는 클래스
  - View: UI 컴포넌트를 생성하고 오토레이아웃을 설정하는 클래스
  - ViewController: Navigation, Event, Life Cycle 등을 담당하는 클래스
- **Data** **Storage**: `CoreData`, `UserDefaults`
- **Library**/**Framework**:
  - [SnapKit](https://github.com/SnapKit/SnapKit): UIKit에서 AutoLayout을 보다 쉽게 작성하기 위해 도입하였습니다.
  - [EventBus](https://github.com/swiftarium/EventBus): 특정 상황(이벤트)이 발생했을 때 특정 동작을 수행하기 위해 도입하였습니다.
  - [GoogleSignIn-iOS](https://github.com/google/GoogleSignIn-iOS): 소셜 회원가입을 지원하기 위해 도입하였습니다.
  - [DGCharts](https://developer.apple.com/documentation/Charts): 감정쓰레기 데이터를 그래프로 시각화하기 위해 도입하였습니다.
  - [AVFAudio](https://developer.apple.com/documentation/avfaudio): AVAudioPlayer와 AVAudioRecorder를 사용하기 위해 도입하였습니다.
  - [DSWaveformImage](https://github.com/dmrschmidt/DSWaveformImage): Audio Visualizer를 구현하기 위해 도입하였습니다.

<br>

## 4. 프로젝트 관리

### 4.1. 일정 및 화면별 세부정책

🔗 [프로젝트 관리시트 바로가기](https://docs.google.com/spreadsheets/d/1Xh4y6FqQQsccTn6iG3ArMeJX8OvLOkX86jnjIZrqA0k/edit#gid=1115838130)

- Google Spreadsheets를 사용해 프로젝트 일정을 관리했습니다.
- 화면별 Test Case를 생성하고 각 TC Item에 맞는 Expected Result를 작성해 화면별 세부정책을 수립했습니다.



### 4.2. 와이어프레임

🔗 [Figma 바로가기](https://www.figma.com/file/dzDWbY4xDzeRMc0DwirjPp/HWIBAL?type=design&node-id=1-743&mode=design&t=iQj4D30SdnBWVb1C-0)

<img width="900" alt="image" src="https://user-images.githubusercontent.com/53863005/278954894-6fa80995-87b4-498a-a46c-55ea21c98b24.png">

- IA(정보구조)를 기반으로 화면을 구성했습니다.



### 4.3. 커뮤니케이션 전략

- **Git-Flow 전략**
  - `main` : 최종적으로 완성되었을때 사용할 배포용 브랜치
  - `dev` : 유지 보수와 기술개발 등 하기위해 메인에서 생성한 브랜치, 안정성을 위해 main이 아닌 dev를 default 브랜치로 설정
  - `feature`: 기능 개발 브랜치,
    - 작업 진행시 최신 dev에서 `feature-작업명`으로 생성
    - 기능작업이 완료 된 후 **dev로 PR 생성**
- **Commit Message 전략**
  - [FEAT] : 👍 새 기능 구현
  - [FIX] : 🐛 기존 기능/버그 수정
  - [RENAME] : ✏️ 파일 혹은 폴더명을 수정하거나 옮기는 작업만인 경우
  - [DOCS] : 📚 주석/문서 수정
  - [TEST] : 📝 테스트 코드
  - [MERGE] : ✅ 병합
  - [CONFLICT] : 💥🚚  병합 시 충돌 해결
- **Pull Request 전략**
  - 커밋 후에 push하고 Draft PR 생성
    - Reviewers : 현재 PR을 리뷰를 해 줄 팀원을 지정
    - Assignees : 현재 PR 작업의 담당자(본인)를 지정
  - PR 생성 후 슬랙 채널에 공유해서 리뷰를 부탁해주세요.
  - UI 변경이 있다면 PR에 꼭 **스크린샷**을 남겨주세요.
    - 스크린샷 첨부시 width=300로 변경해주세요.
- **Merge 전략**
  - 최소 1명의 승인을 받아야 merge 가능
    - `Approve` : Comment와 무관하게 리뷰어가 승인을 하는 것으로, 머지해도 괜찮다는 의견을 보내는 것
    - `Request changes` : 말 그대로 변경을 요청하는 것으로, 승인을 거부하는 것. 단, 이 경우 수정사항을 분명하게 comment로 전달해주세요.
  - Reviewers의 comments 및 승인이 완료되면 Assignees가 dev에 merge

- **Trouble Shootings 관리**
  - Github Issue 사용
    - dev 브랜치에서 발견한 버그, 앱 크래시 등을 기록합니다.
    - Assignees에 해당 기능을 맡은 팀원을 등록해주시고, 에러가 발생하는 시나리오(과정)를 자세히 적어주세요. 스크린샷도 있으면 좋습니다.
  - Issue를 close 할 때는 해결한 방법 혹은 해결한 `PR number`를 멘션해주세요.



### 4.4. 기술적 의사결정

<img width="879" alt="기술적 의사결정" src="https://github.com/hidaehyunlee/HWIBAL/assets/139306158/79ddd1ed-4254-433b-8b85-a883d0aba24e">

- **Codebased UI**
  - 헙업 및 복잡한 레이아웃에 대응하기위해 코드베이스로 UI 구현
  - 스토리보드 보다 더 복잡한 레이아웃 구현 가능
  - 커스텀 UI 컴포넌트 재사용 가능

- **Library**
  - AVFoundation & AVFAudio
    - 미디어파일 중 오디오 파일만 다루면돼서, AVPlayer대신 더 가벼운 AVAudioPlayer 선택
    - AVAudioPlayer 클래스를 사용하기 위해 AVFoundation 프레임워크 추가
    - AVFAudio를 통해 오디오 세션 관리에 필요한 기능 제공

  - DGCharts
    - UIKit로 차트를 구현하기 위해, 직관적이고 다양한 차트를 그리기 위해 선택

  - GoogleSignIn
    - OAuth를 사용함으로써 편리함과 보안상의 이점을 취함
    - google만 사용해도 충분했기 때문에, 굳이 카카오 넣어서 의존성 추가하고 싶지 않았음

  - SnapKit
    - 복잡한 AutoLayout 제약조건을 간결하게 표현 가능

- **RootView protocol**
  - controller가 view를 그릴 수 있는 것이 문제라고 판단
  - view로부터 발생한 비즈니스 로직만 실행하도록 controller의 역할을 제한
  - controller의 기본 view 대신 프로토콜을 상속한 view가 loadView 시점에 실행

- **Model**
  - 굳이 추가적인 의존성을 높이면서까지 realm을 사용할 필요가 있을지 고민
  - firebase는 유저 모니터링 용도라고만 생각
  - 이후 User와 Report는 firebase로 연동하여 관리하도록 함
 
- **NotificationCenter**
  - 뷰에서 이벤트를 전달하는 방식을 고민
  - 하나의 이벤트로 바뀌어야할 UI가 많음!
  - 이벤트를 브로드캐스트로 전달할 수 있는 NotificationCenter를 선택
 
<br>

## 5. 트러블슈팅

<img width="1117" alt="Untitled" src="https://github.com/hidaehyunlee/HWIBAL/assets/139306158/6ea15aff-d324-44fe-a228-b1d5af0b94e2">

- '맨 처음으로' 버튼 클릭시 large transform 애니메이션 적용 오류
- 특정 item에서 동일한 오디오 소스를 재생하는 문제
- 컬렉션뷰 기준으로 오토레이아웃 못잡는 문제

<img width="1118" alt="Untitled (1)" src="https://github.com/hidaehyunlee/HWIBAL/assets/139306158/696638ce-0a6f-4a1d-9cad-7951e17fd12e">

- 자동삭제 로직 설계의 어려움
- 컬렉션뷰 스크롤 시 페이지 넘버링 함수 호출 반복으로 불필요한 메모리 사용

<img width="1116" alt="Untitled (2)" src="https://github.com/hidaehyunlee/HWIBAL/assets/139306158/ecf15eff-091c-41b2-a8a2-567000ea42ad">

- 키보드 올라왔을 때 textView의 크기가 달라지는 이슈 발생
- 녹음된 오디오 파일을 저장할 때 유일한 파일 이름을 생성하는 기능이 필요
- 녹음된 오디오 파일에 접근하려면 문서 디렉토리에 접근해야 함

<img width="1119" alt="Untitled (3)" src="https://github.com/hidaehyunlee/HWIBAL/assets/139306158/2e6ace7c-ee0b-4f12-b010-8dd82247f374">

- SE 기기 테스트 시 해상도 깨짐 이슈
- ToolTip 노출시 주변 UI 불투명하게 적용했으나, NaviBar 버튼은 적용 안됨
