---
layout: post
title: Cloud Computing 기초
author: An Hyungjun
categories: [cloud]
tags: [infra, namespace, cloud, virtualization, summary]
---
<!---->

{% raw %} 
<!-- START -->

Cloud Computing 기초 내용을 정리한다.

# 용어 정리

## 시스템 기반
- 정의: 어플리케이션 사용자가 상시 이용할 수 있는 환경을 제공하는 기술 요소
- 요구사항에 의한 구분
	- 기능 요구사항: 어플리케이션의 목적
	- 비기능 요구사항: 시스템 성능, 신뢰성, 확장성, 유지보수성, 보안 등에 관련
- 주요 구성 요소: 하드웨어, 네트워크, 운영체제, 미들웨어

## 데이터센터
- 시스템 기반의 구성요소를 제공하는 시설
- 분류
	- IDC(Internet Data Center)
	- CDC(Cloud Data Center)

## 클라우드 컴퓨팅
- 원격 컴퓨터의 자원을 활용하는 기술
- 언제, 어디서나
- 사용한 만큼 비용을 지불함

### 한계점
- 아주 높은 가용성(ex. 완벽한 무중단)을 보장해주지는 못 함
- 데이터 저장 위치를 특정할 수 없음
- 특수 디바이스, 특수 플랫폼에 대해서는 지원 불가
- 비용이 항상 저렴하다고 볼 수는 없음

## 인프라 구성 방식
- On-Premises: 시스템 기반을 직접 구축, 운용
- Public Cloud: 불특정 다수에게 제공하는 클라우드 서비스
- Private Cloud: 특정 대상에게 제공하는 클라우드 서비스

## 클라우드 서비스 유형
- IaaS(Infrastructure as a Service): 서버, OS, 네트워크, 저장소 등을 제공
- PaaS(Platform as a Service): 소프트웨어 개발 및 운영 환경을 제공
- SaaS(Software as a Service): 소프트웨어까지 제공(ex. google docs)

## 서버 가상화
- 가상 머신을 생성하는 기술
- 호스트로부터 시스템 자원을 할당받음
- 자원 분배를 위한 파티셔닝 기술이 필요

## 하이퍼바이저(Hypervisor)
- 서버 가상화에서 파티셔닝을 지원하기 위한 소프트웨어
- 가상 머신의 리소스 할당 및 관리를 지원하며 리소스간 접근을 방지(격리)함
- 종류
	- Type 1 (Native / Bare-metal): 하드웨어에서 직접 하이퍼바이저가 실행됨
	- Type 2 (Hosted): 운영체제에서 하이퍼바이저를 실행

## SELinux(Security-Enhanced Linux)
- 기본 권한 관리 방식(DAC)의 취약 요소를 해결함
- 개체 기반으로 규칙을 제어함(MAC)
- 설정
	- disabled: SELinux 동작 안 함(커널 모듈 로드 X)
	- enforcing: SELinux 커널 모듈 로드됨
	- permissive: 

```bash
# 설정값 확인
$ getenforce

# 기본값 설정(Disable <-> enforcing, permissive 전환 시 reboot 필요)
$ vi /etc/selinux/config

# 일시적 설정(부팅 후엔 cofig 따라 감)
$ setenforce 0
$ setenforce 1
$ setenforce disabled
$ setenforce enforcing
$ setenforce permissive
```

## netfilter
- 네트워크 패킷 처리 기능을 담당하는 Linux 커널 모듈
- 기능
	- NAT(Network Address Translation): 사설 네트워크에서 주소 및 포트 변환
	- Packet Filtering: 패킷 허용 및 차단
	- Packet Mangling: 패킷 통과시 헤더 변경

## iptables
- Linux의 방화벽 제어 기능

## 컨테이너 가상화
- 하드웨어의 가상화 지원을 필요로 하지 않음(host os 위에서 컨테이너 엔진이 가상화를 처리함)
- 컨테이너 구동을 위한 별도의 운영체제가 필요하지 않음
- 컨테이너에는 애플리케이션, 라이브러리, 설정 파일만 존재

## 컨테이너 런타임
- 저수준: LXC, runC
- 고수준: containerd, docker, CRI(Container Runtime Interface: ex. Kubernetes)

# 격리 기술
- namespace: 이름을 격리하는 기반 기술
- 주요 명령어: unshare

## PID namespace 격리

```bash
# ex
$ pstree
$ sudo unshare --fork --pid --mount-proc /bin/bash
$ pstree
```

## network namespace 격리
- 참고(사설IP 대역)
	- A클래스	10.0.0.0/8		10.0.0.0 ~ 10.255.255.255
	- B클래스	172.16.0.0/12	172.16.0.0 ~ 172.31.255.255
	- C클래스	192.168.0.0/16	192.168.0.0 ~ 192.168.255.255

```bash
#=============================================================
# ip 정보 확인
#-------------------------------------------------------------
$ ip addr show
$ ip a s
#=============================================================

#=============================================================
# unshare을 이용한 격리
#-------------------------------------------------------------
$ sudo unshare --fork --pid --mount-proc --net /bin/bash
#=============================================================

#=============================================================
# ip명령어를 이용한 격리
#-------------------------------------------------------------
# Network Namespace 추가
$ sudo ip netns add test_ns

# Network Namespace 확인
$ sudo ip netns list

# 생성한 Namespace에서 Interface 확인
$ sudo ip netns exec test_ns ip link

# lo Interface 활성화
$ sudo ip netns exec test_ns ip link set lo up

# Namespace에서 사용할 인터페이스 쌍 생성
$ sudo ip link add veth0 type veth peer name veth1

# Host의 veth0 인터페이스 활성화
$ sudo ip link set veth0 up

# veth0 IP 할당
$ sudo ip addr add <IP_ADDR>/<PORT> dev veth0

# veth1을 test_ns에 할당
$ sudo ip link set veth1 netns test_ns

# test_ns의 veth1 활성화
$ sudo ip netns exec test_ns ip link set veth1 up

# veth1 IP 할당
$ sudo ip netns exec test_ns ip addr add <IP>/<PORT> dev veth1
#-------------------------------------------------------------
```

## UID(User ID, Unique ID) namespace 격리

```bash
$ sudo unshare --fork --pid --mount-proc --user /bin/bash

# 컨테이너 한정으로 root인 UID로 격리
$ sudo unshare --fork --pid --mount-proc --user --map-root-user /bin/bash

# UID 격리 확인
$ cat /etc/shadow
```

## 파일시스템(mount)
- 격리는 아님

```bash
$ mkdir /tmp/mount_test
$ sudo unshare --fork --pid --mount-proc --mount /bin/bash
$ mount -n -t tmpfs tmpfs /tmp/mount_test
$ touch /tmp/mount_test/hello
```

## UTS namespace 격리

```bash
$ sudo unshare --fork --pid --mount-proc --uts /bin/bash
	$ hostname
	$ hostname test
	$ hostname
	$ exit
$ hostname
```
- uts 옵션으로 격리를 하지 않을 경우 호스트도 변경됨

## IPC 격리

```bash
$ ipcs
$ ipcmk -Q
$ ipcs
$ unshare --ipc --map-root-user --fork --pid --mount-proc /bin/bash
$ ipcs
```

## 파일 격리(chroot)

```bash
$ sudo mkdir /newroot
$ ldd /bin/bash
        linux-vdso.so.1 (0x00007ffcb2999000)
        libtinfo.so.6 => /lib64/libtinfo.so.6 (0x00007f6ced58d000)
        libdl.so.2 => /lib64/libdl.so.2 (0x00007f6ced389000)
        libc.so.6 => /lib64/libc.so.6 (0x00007f6cecfde000)
        /lib64/ld-linux-x86-64.so.2 (0x00007f6ced7b8000)
$ sudo mkdir /newroot/lib64
$ sudo cp /lib64/libtinfo.so.6 /newroot/lib64/
$ sudo cp /lib64/libdl.so.2 /newroot/lib64/
$ sudo cp /lib64/libc.so.6 /newroot/lib64/
$ sudo cp /lib64/ld-linux-x86-64.so.2 /newroot/lib64/
$ sudo chroot /newroot

# 외장 명령어(error return 됨)
$ ls

# 내장 명령어
$ pwd
$ exit
```
- 추후 컨테이너 관리 시 불필요한 파일을 사용하지 않게 하는 장점도 있음

## cgroup(Control Group)
- 자원을 제한하기 위한 용도로 사용됨

```bash
#=============================================================
# cpu 사용량 제한 예시
#=============================================================

# 프로세스 cgroup 정보 확인
$ ps -O cgroup

# cgroup 관리도구 설치
$ sudo yum search cgroup-tools
$ sudo yum -y install libcgroup-tools.x86_64

# cgroup 생성
$ sudo cgcreate -a ec2-user -g cpu:test
$ ls -l /sys/fs/cgroup/cpu/

# cpu 제한 설정
$ sudo cgset -r cpu.cfs_quota_us=10000 test

# cgroup 설정을 하지 않은 프로세스 실행 사용량 확인
$ sha1sum /dev/zero &
$ top
$ kill %1

# cgroup 설정을 사용한 프로세스 실행 및 사용량 확인
$ sudo cgexec -g cpu:test sha1sum /dev/zero &
$ top
$ sudo pkill sha1sum
```

## Network Bridge
- Software Bridge: 가상 NIC와 하드웨어 NIC를 연결하는 방법
- NAT, NAPT: 사설 네트워크 내의 호스트가 외부와 통신하기 위한 변환방법

## OverlayFS
- 중첩 가능한 파일시스템(Union Filesystem)임
- 구조
	- Lower: 겹침 구조에서 아래에 위치하는 다수 층
	- Upper: 겹침 구조에서 최상단 하나의 층
	- Merge: 겹침 구조에서 Lower와 Upper를 하나로 겹쳐서 보는 통합 뷰
	- Work: overlay 계층에 작업이 적용되기 전의 파일을 저장하는 위치

```bash
#=============================================================
# Overlayfs 테스트
#=============================================================

# Overlayfs 모듈 확인
$ lsmod | grep overlay

# 계층별 디렉토리 생성
$ sudo -i
$ mkdir -p /overlay/{lower,upper,merge,work}

# 각 계층별로 파일 생성
$ cd /overlay
$ echo lower > lower/fileA
$ echo upper > upper/fileB

# OverlayFS 마운트
$ sudo mount -t overlay overlay -o lowerdir=lower/,upperdir=upper/,workdir=work/ merge/

# 각 계층별 파일 확인
$ ls -l lower
$ ls -l upper
$ ls -l merge

# merge에서 수정 후 lower 계층의 파일 수정 및 결과 확인
	# lower가 수정되지는 않고 upper가 수정됨
$ echo modified >> merge/fileA

# merge에서 수정 후 upper 계층의 파일 수정 및 결과 확인
$ echo modified >> merge/fileB

# merge에서 lower 계층 및 upper 계층의 파일 삭제 및 결과 확인
	# upper의 파일이 삭제되고 대신 lower의 파일이 삭제되었음을 표시하기 위한 포인터가 남음
$ rm merge/fileA
$ rm merge/fileB
```

{% endraw %}
