---
layout: post
title: 알쓸신잡
author: An Hyungjun
categories: []
tags: [summary]
---

문득문득 떠오르는 궁금증에 대한 해답을 정리하기 위한 포스팅이다.
주로 이걸 굳이 별도의 페이지로 정리를 해야 하나... 싶은 것들이 주를 이룬다.

--------------------------------------------------------------------------------

# TODO
- Process vs. Thread

--------------------------------------------------------------------------------

# VS.

## Framework vs. Library
- 표면적인 차이
	- Framework: 특정한 기능의 프로그램을 만들기 위해 상호 협력하는 클래스와 인터페이스의 집합
	- Library: 단순 활용이 가능한 도구들의 집합
- 제어의 역전(Inversion Of Control)에 의한 구분
	- Framework: 프레임워크가 프로그래머의 코드를 동작함
	- Library: 프로그래머의 코드가 라이브러리를 동작함
- 참고
	- [blog](https://mangkyu.tistory.com/4])

## UART vs. SPI vs. I2C
- 특징
	- UART: 비동기 시리얼 통신, 두 개의 핀으로 1:1 통신만 가능
	- SPI: 동기식 시리얼 통신, 1:N 통신 가능, 하드웨어 설계시 핀이 많이 필요
	- I2C: 동기식 시리얼 통신, N:N 통신 가능, 디바이스 당 핀을 2개(SCL, SDA)씩만 사용, 하드웨어적으로 단순, 소프트웨어 난이도가 상대적으로 높음(프로토콜)
- 참고
	- [blog](https://2innnnn0.tistory.com/11)
	- [blog](https://coder-in-war.tistory.com/entry/Network-02-I2C%EC%97%90-%EA%B4%80%ED%95%98%EC%97%AC)

--------------------------------------------------------------------------------

# Terminology

## GPIO(General-Purpose I/O)
- 개념: 마이크로 프로세서가 주변장치와 통신하기 위해 범용으로 사용되는 입출력 포트
- 참고
	- [wiki](https://ko.wikipedia.org/wiki/GPIO)
	- [blog](https://rakuraku.tistory.com/148)
	- [blog](https://junolefou.tistory.com/4)

## Blockchain(블록체인)
- 주요 개념: 블록(데이터 단뒤)의 (해싱)연결, 다수의 참여자를 통해 데이터의 위변조를 막는 장점이 있음
- 다수의 채굴기가 가장 최신(최장) 상태의 체인을 업데이트하기 위해 구동되며 이때 다양한 합의 알고리즘이 사용됨
- 위변조가 어려운 이유
	- 체인 구성 시 해싱이 사용되어 일부 블록의 위변조 발생 시 쉽게 인지 가능
	- 소규모 그룹이 위변조가된 가장 최장의 체인을 구성하기 어려움(계산적으로 불가능)

## EEPROM(Electrically Erasable PROM) or NVRAM(Non-Volatile RAM)
- On-Board 상태에서 사용자가 내용을 Byte 단위로 Read하거나 Write 할 수 있는 비휘발성 메모리
- Write가 느려서 자주 바뀌는 변수를 저장하는 용도로는 적절하지 않음
- 참고
	- [blog](https://treeroad.tistory.com/entry/Flash-Memory%EC%99%80-EEPROM-%EC%B0%A8%EC%9D%B4%EC%A0%90)

## Flash memory
- On-board 상태에서 사용자가 내용을 Byte 단위로 자유로이 Read 할 수 있지만, Write는 Page 또는 Sector 라고 불리는 Block 단위로만 수행 할 수 있는 변형된 EEPROM.
- EEPROM에 비해 Write가 훨씬 빠름
- 참고
	- [blog](https://treeroad.tistory.com/entry/Flash-Memory%EC%99%80-EEPROM-%EC%B0%A8%EC%9D%B4%EC%A0%90)

## AC 전원 케이블 종류
- 2구 8자 케이블
- 3구 클로버케이블
- 3구 각케이블

--------------------------------------------------------------------------------

# Question

## 커널은 프로세스인가?
- 개념
	- 커널은 유저 프로세스와 별도의 주소 공간에서 실행되는 프로세스이다.
	- 커널은 멀티쓰레드로 구현되기도 하고 멀티프로세스로 구현되기도 한다.
- 참고
	- [KLDP](https://kldp.org/node/82997)
