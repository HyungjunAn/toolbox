---
layout: post
title: Git 사용법 요약
author: An Hyungjun
categories: [devtool]
tags: [git, summary]
---

## tag

### tag 붙이기 - Lightweight
	$ git tag <TAG_NAME>
	$ git tag <TAG_NAME> <COMMIT_HASH>

### tag 붙이기 - Annotated
	$ git tag -a <TAG_NAME> -m "<TAG_MSG>"

### 원격 저장소에 tag 반영
	$ git push origin <TAG_NAME>
	$ git push origin --tags // 모든 tag 업로드
	
### tag 삭제
	$ git tag -d <TAG_NAME>
	$ git push origin :<TAG_NAME>	// 원격 저장소의 tag 삭제

### git tag 확인용 설정
	
~/.gitconfig 맨 아랫줄에 다음 추가

(다음부터는 $ git ahj 명령으로 commit, tag 내용 확인 가능)
```
[alias]
ahj = log --color --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit	
```

-------------------------------------------------------------

## patch and apply

### apply
	$ git apply <PATCH>
	
### patch from log
	$ git log -p -<NUM_OF_COMMIT>
	$ git log -p -1
	$ git log -p -2

-------------------------------------------------------------

## reset

### 파일 까지 해당 시점으로
	$ git reset --hard
	
### n개 Commit 전으로
	$ git reset HEAD^n
	$ git reset HEAD~n

### 특정 파일을 특정 시점으로
	$ git reset -q <tree-ish> <FILE>
	$ git reset -q HEAD^ <FILE>
	
### 원격 branch reset
	$ git reset --hard <RESET_POINT>
	$ git push -f origin <BRANCH>
	// -f 옵션 필수

-------------------------------------------------------------

## submodule

### submodule update from remote
	$ git submodule update --remote

-------------------------------------------------------------

## alias "~/.gitconfig"

```bash
[alias]
	custom = log --color --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit
    pl = log --color --pretty=format:'%Cred%h%Creset - %s' --abbrev-commit
    pl-tag = log --color --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %C(bold blue)<%an>%Creset' --abbrev-commit
```

-------------------------------------------------------------

## git config(계정 설정)

### global
	$ git config --global user.name "NAME"
	$ git config --global user.email NAME@NAME.com

### 모듈별
	$ git config user.name "NAME"
	$ git config user.email NAME@NAME.com

### editor 설정
	$ git config --global core.editor "gvim"
	
-------------------------------------------------------------
	
## ETC

### 한글 파일명 이상하게 나올 때
	$ git config --global core.quotepath false
