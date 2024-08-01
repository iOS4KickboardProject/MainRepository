# 🛴 KickBoard App

![kickboard](https://github.com/user-attachments/assets/8b210631-e307-40d0-b32a-9ab2043f6cf6)
<br>

## 프로젝트 소개
Firebase, KakaoMap을 활용하여 서버와 통신이 가능한 공유 킥보드 앱을 구현해봤습니다
<br>

## 팀원 구성

<div align="center">

| **이득령** | **박승환** | **김수빈** | **백시훈** |
| :------: |  :------: | :------: | :------: |
| [<img src="https://avatars.githubusercontent.com/u/164954344?v=4" height=150 width=150> <br/> @dx._.xk7](https://github.com/DeukRyoeng) | [<img src="https://avatars.githubusercontent.com/u/107488193?v=4" height=150 width=150> <br/> @sh990920](https://github.com/sh990920) | [<img src="https://ca.slack-edge.com/T06B9PCLY1E-U06TMKGPEUE-ff52ad5856ae-512" height=150 width=150> <br/> @soobeen](https://github.com/soobeen27) | [<img src="https://github.com/user-attachments/assets/7a3e9243-d653-4bae-ae6f-b9dcb564b2d8" height=150 width=150> <br/> @likelyLime](https://github.com/LikelyLime) |

</div>

<br>

## 1. 개발 환경

- Front : UIkit, SnapKit, KakaoMapSDK
- Back-end : Firebase
- 버전 및 이슈관리 : Github, Github Project
- 협업 툴 : Slack, Notion, Zep
- 
<br>

## 2. 브랜치 전략
### 브랜치 전략

- Git-flow 전략을 기반으로 main, develop 브랜치와 Name 보조 브랜치를 운용했습니다.
- main, develop, Feat 브랜치로 나누어 개발을 하였습니다.
    - **main** 브랜치는 배포 단계에서만 사용하는 브랜치입니다.
    - **develop** 브랜치는 개발 단계에서 git-flow의 master 역할을 하는 브랜치입니다.
    - **Name** 각 개발자의 이름브랜치는 기능 단위로 독립적인 개발 환경을 위하여 사용하였습니다.

<br>

## 3. 프로젝트 구조

```
├── kickBoardProject
│   ├── Assets.xcassets
│   │   ├── AccentColor.colorset
│   │   │   └── Contents.json
│   │   ├── AppIcon.appiconset
│   │   │   └── Contents.json
│   │   ├── Contents.json
│   │   ├── currentLocation.imageset
│   │   │   ├── Contents.json
│   │   │   └── currentLocation.png
│   │   ├── kickboard.imageset
│   │   │   ├── Contents.json
│   │   │   └── kickboard.png
│   │   ├── kickboardpic.imageset
│   │   │   ├── Contents.json
│   │   │   └── kickboard.jpeg
│   │   └── logo.imageset
│   │       ├── Contents.json
│   │       └── logo.png
│   ├── Base.lproj
│   │   └── LaunchScreen.storyboard
│   ├── GoogleService-Info.plist
│   ├── Info.plist
│   ├── config
│   │   ├── AppDelegate.swift
│   │   └── SceneDelegate.swift
│   ├── controller
│   │   ├── CreateUserView.swift
│   │   ├── CreateUserViewController.swift
│   │   ├── KakaoMapVC.swift
│   │   ├── KakaoMapViewController.swift
│   │   ├── KickboardAddController.swift
│   │   ├── LoginView.swift
│   │   ├── LoginViewController.swift
│   │   ├── MyPageViewController.swift
│   │   ├── QRcodeViewcontroller.swift
│   │   ├── RentModalViewcontroller.swift
│   │   ├── TabBarController.swift
│   │   └── ViewController.swift
│   ├── model
│   │   ├── History.swift
│   │   ├── Kickboard.swift
│   │   └── UserModel.swift
│   ├── repository
│   │   ├── HistoryRepository.swift
│   │   ├── KickboardRepository.swift
│   │   └── UserRepository.swift
│   └── view
│       ├── AddedKickboardCell.swift
│       ├── HistoryCell.swift
│       ├── KickBoardAddView.swift
│       ├── MyPageView.swift
│       ├── RentModalView.swift
│       └── addPoi.swift
└── kickBoardProject.xcodeproj
    ├── project.pbxproj
    ├── project.xcworkspace
    │   ├── contents.xcworkspacedata
    │   ├── xcshareddata
    │   │   ├── IDEWorkspaceChecks.plist
    │   │   └── swiftpm
    │   │       ├── Package.resolved
    │   │       └── configuration
    │   └── xcuserdata
    │       └── dx._.xk7.xcuserdatad
    │           └── UserInterfaceState.xcuserstate
    └── xcuserdata
        └── dx._.xk7.xcuserdatad
            ├── xcdebugger
            │   └── Breakpoints_v2.xcbkptlist
            └── xcschemes
                └── xcschememanagement.plist

```

<br>

## 4. 역할 분담

### 이득령

- **UI, Function**
     페이지 : 지도뷰
     Po클릭 이벤트, 맵 라이프라사이클, firebase통신, 현재위치불러오기, 카메라이동

<br>
    
### 박승환

- **UI, Function**
페이지 : 킥보드 등록 페이지
현재 위치 찾기 기능
킥보드 배터리 정보 등록
킥보드 등록 기능

<br>

### 장수빈
- **UI, Function**
page
마이페이지 뷰
로그아웃 기능
내가 등록한 킥보드, 킥보드 이용내역 테이블 뷰
현재 유저 status(이용중인 킥보드, 배터리)
마이페이지 뷰
로그아웃 기능
내가 등록한 킥보드, 킥보드 이용내역 테이블 뷰
현재 유저 status(이용중인 킥보드, 배터리)
렌트모달 뷰
킥보드 ID, 이미지, 배터리, 주행가능거리 표시
UITabBar , NavigationViewController
네비게이션컨트롤러에서 탭바로 이동 후 탭바는 각각의 네비게이션 컨트롤러를 가지고
각각 네비게이션 아이템, 타이틀을 가짐, 로그아웃시 처음 화면으로 돌아가기

<br>

### 백시훈
- **UI, Function**
로그인 화면
회원가입 화면
파이어스토어 연결
로그인 기능
회원가입기능
UserDefault를 이용한 자동로그인 기능
회원가입 시 유효성 검사
<br>

### 개발 기간 : 2024-07-22 ~ 2024-07-28 (day 7)
<br>
##### 로그인 화면
 - **로그인 화면/회원가입 화면**
 - **userDefauts를 활용하여 자동로그인을 구현**
 ##### 지도 페이지
-  **UTabBarController 를 활용하여 다양한 메뉴 화면에 접근할 수 있도록 바를 제공**
-  **유저가 킥보드를 대여하게 되면 지도에서 킥보드 삭제**
##### 킥보드 등록 페이지
-  **유저는 킥보드를 등록할 수 있고 등록된 킥보드는 저도 위에 표시**
-  **킥보드를 등록 위치 현위치 설정**
##### 마이페이지
-  **킥보드 이용중인지 아닌지의 여부를 표시 ✓ 킥보드 이용내역을 표시**
-  **로그아웃 버튼이 있어서 버튼 클릭시 로그인화면으로 돌아가도록 구현**
-  **내가 등록한 킥보드 보기**
-  **내가 등록한 킥보드 삭제**
-  **킥보드 반납 및 위치 지정**
## FireBase사용 후기

### 박승환
• 장점
1. 파이어베이스와 Swift 간의 연동이 상당히 간편했습니다. Firebase SDK 를 이용 해서 빠르게 프로젝트에 연결할 수 있었고 별다른 설정 없이도 데이터를 주고받을 수 있었습니다.
2. 파이어베이스는 데이터를 json 형식으로 제공하여 Swift 에서 관리하기 쉬웠습니다.

• 단점
1. 파이어베이스는 데이터베이스지만 보편적으로 데이터베이스에서 사용하는 제약조 건이 부족해 데이터 무결성을 유지하는데 조금 힘들었습니다.

2. 파이어베이스는 잘못된 컬럼으로 데이터를 넣었을 때 파이어베이스가 별도로 처리 하지 않고 값이 그대로 수용되어 데이터 구조나 잘못된 데이터를 수정하는 과정에 서 문제가 생길 가능성이 높았습니다
<br>

### 장수빈

- 쉬운 방법으로 서버를 사용하는 방식이라 생각했는데 쉽지 않았습니다. 이번 프로젝트 에서는 다른 파트를 받아 써보지 못했지만 다음에 사용할 기회가 있다면 좀 더 공부해봐야겠습니다.

<br>

### 백시훈
- 파이어 베이스에서 연동과 store를 사용하는것은 쉬웠으나 그로인해 git에 푸쉬하면서
package가 사라지거나 꼬이는 경우가 자주 발생하여 고생하였다.
