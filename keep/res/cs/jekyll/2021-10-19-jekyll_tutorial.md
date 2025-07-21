---
layout: post
title: Jekyll(1) - Jekyll 설치 및 실행
author: An Hyungjun
categories: [jekyll]
tags: [jekyll, install, tutorial]
---

## Ruby 설치
- [windows](https://rubyinstaller.org/downloads/)
(msys 설치 필요, ridk install에서는 그냥 Enter)

## jekyll, bundle 설치
```
$ gem install jekyll bundler
```

## 원하는 Jekyll 테마(github 소스) 다운로드
```
```

## github 프로젝트 생성
반드시 아래 이름으로 생성되어야 함
```
<GITHUB_USERNAME>.github.io
```

## 로컬 프로젝트 폴더에서 빌드
```
$ cd <JEKYLL_PROJECT_PATH>
$ bundle install
$ bundle add webrick
```

## jekyll 로컬 실행
```
$ bundle exec jekyll serve
```
