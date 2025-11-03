## 📚 프로젝트 소개
카카오 API 기반으로 책 검색 앱 만들기

<br>

## 🎤 프로젝트 설명
> 사용자가 책을 검색하면, 상세 정보를 확인할 수 있으며
원하는 책을 담기/삭제할 수 있는 iOS 앱 입니다.

> Kakao Book REST API를 사용해 책 데이터를 받아오고, 
책 데이터 저장은 CoreData를 활용합니다.

<br>

## ⚒️ 개발 환경
<img src="https://img.shields.io/badge/swift-%23FA7343.svg?&style=for-the-badge&logo=swift&logoColor=white" /> 

<br>

![Static Badge](https://img.shields.io/badge/iOS-18.5-blue)
![Static Badge](https://img.shields.io/badge/Xcode-16-green)
![Static Badge](https://img.shields.io/badge/SnapKit-5.7.1-beige)

<br>

## ✏️ 와이어프레임
<img width="750" height="340" alt="image" src="https://github.com/user-attachments/assets/e99c3cc1-7b2e-4b78-8f6e-cdd6d8bc4587" />

<br>
<br>

## 🍎 구동 화면
| 검색 화면 | 상세 보기 및 최근 본 책 | 가장 최근 본 책 왼쪽부터 추가 |
|:-:|:-:|:-:|
| <img src="https://github.com/user-attachments/assets/ca55ddb9-3e9e-485e-bb4e-a16974d997a9" width="75%"> | <img src="https://github.com/user-attachments/assets/1b9c922e-7e39-411f-af75-edd9cc9efffc" width="75%"> | <img src="https://github.com/user-attachments/assets/99377507-f8ab-4a8f-945e-6d9d0f285617" width="75%">

<br>

| 책 담기 | 개별 삭제 | 전체 삭제 | 
|:-:|:-:| :-:|
<img src="https://github.com/user-attachments/assets/1519bd2c-92a9-40ca-97c6-31f81f00f100" width="75%"> | <img src="https://github.com/user-attachments/assets/89861288-8344-4ef5-bae9-83589f25d3b2" width="75%"> | <img src="https://github.com/user-attachments/assets/f5bea931-6245-4125-8fa0-fbc399b72ba0" width="75%">

<br>

## 🖋️ Git FLow
```
1. develop 브랜치에서 새로운 브랜치를 생성한다.
2. 만든 브랜치에서 작업한다.
3. 커밋은 기능마다 쪼개서 작성한다.
4. 에러가 없으면 작업중인 브랜치에 push한다.
5. develop 브랜치에 merge 한다.
6. merge 후 pull해서 이상이 없는지 모두 확인한다.
```

<br>

## 🖋️ Git Commit
```
add : 새로운 파일 및 폴더 추가
    Ex) [Add] 물건 사진 Resources폴더에 추가
feat : 새로운 기능 추가
    Ex) [Feat] 메인 페이지에 카테고리 기능 추가
fix : 버그 수정
    Ex) [Fix] 물건 버튼 클릭 시 장바구니에 들어가지 않는 버그 수정
refactor : 기능 변경 없이 코드 구조를 개선(가독성, 성능 향상 등)
    Ex) [Refactor] 중복되는 로직 유틸 함수로 분리
docs : README, 주석 등 문서 추가 또는 수정(코드 변경 없음)
    Ex) [Docs] git ReadMe 변경
Chore :  빌드 설정, 패키지 매니저 구성 등 기타 작업
    Ex) Chore: 폴더 경로 수정 및 SnapKit패키지 재설치
revert :  이전 커밋을 되돌리는 작업
    Ex) [Revert] “Feat: 메인 페이지에 카테고리 기능 추가” 커밋 되돌리기
```

<br>

## 📁 Foldering
```
├── BookSearchApp
│  
├── App
|   ├── AppDelegate.swift
|   ├── Info.plist
|   ├── LaunchScreenViewController.swift
│   └── SceneDelegate.swift
│   │
├── Model
|   ├── CoreData
│   │   ├── BookModelEntity+CoreDataClass.swift
│   │   └── BookSearchModel.Entity
│   │
├── Resource
│   └── Assets.xcassets
│   │
├── View
│   ├── Cell
│   │   ├── RecentBookCell.swift
│   │   ├── SearchCell.swift
│   │   └── SearchResultCell.swift
│   │
│   ├── Header
│   │   ├── RecentBookHeaderView.swift
│   │   └── ResultHeaderView.swift
├── ViewController
|   ├── BookDetailViewController.swift
|   ├── ContainBookViewController.swift
|   ├── MainViewController.swift
│   └── SearchViewCotroller.swift
|   |
├── ViewModel
│   └── SearchViewModel.swift
``` 
