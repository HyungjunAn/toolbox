---
layout: post
title: Dockerfile 작성법
author: An Hyungjun
categories: [docker]
tags: [infra, docker, virtualization, summary]
---
<!---->

{% raw %} 
<!-- START -->

Doockerfile 작성 방법을 정리한다.

# Dockerfile
- 사용자가 원하는 이미지를 저장하기 위해 사용하는 코드
- IaC(Infrastructure as a Code)로서 버전 관리가 용이함

## 기본 작성법
- 기본 형식

```bash
<COMMAND> <PARAMETER>
	# COMMAND는 대문자
```

- 주석: #

## 이미지 빌드

```bash
$ docker build [OPTION] <PATH>

# 옵션
	-t, --tag
	-f, --file: Dockerfile 이름이 Dockerfile이 아닐 경우 지정
```

## 명령어

```bash
#=============================================================
# FROM: 기초 이미지 지정
#-------------------------------------------------------------
FROM <IMAGE>
FROM <IMAGE>:<TAG>
FROM <IMAGE>@<DIGEST>

#=============================================================
# RUN: 빌드 시 실행
#-------------------------------------------------------------
RUN <COMMAND>

# 줄바꿈 \

#=============================================================
# CMD, ENTRYPOINT: 빌드 한 이미지로 생성된 컨테이너가 실행될 때 실행
#-------------------------------------------------------------
CMD <COMMAND>
	# 단독으로 쓰면 컨테이너 실행 시 해당 명령이 수행됨
	# ENTRYPOINT와 함께 있으면 ENTRYPOINT의 명령어의 인자로 동작함
	# docker run 시 명령어와 함께 동작시키면 CMD가 컨테이너 실행 시의 명령어로 대체됨

ENTRYPOINT <COMMAND>
	# docker run 시 항상 동작하게 됨
	# --entrypoint 옵션을 통해 변경 가능

#=============================================================
# shell vs. exec: 명령 실행 방식의 차이(RUN, CMD, ENTRYPOINT 모두 동일)
#-------------------------------------------------------------
	# shell 방식: 명령을 Shell 내에서 실행("/bin/sh -c <COMMAND>"와 동일)
	ex) RUN echo $USER

	# exec 방식: 명령을 직접 실행(특징: 설정했던 변수값을 모름)
	ex) RUN ["echo", "$USER"]

#=============================================================
# ONBUILD: 본 이미지가 또 다른 빌드에서 베이스 이미지로 사용될 때 실행
#-------------------------------------------------------------
ONBUILD <COMMAND>
	
#=============================================================
# STOPSIGNAL: signal 전송
#-------------------------------------------------------------
STOPSIGNAL <SIGNAL>

#=============================================================
# HEALTHCHECK: 프로세스 정상동작여부 확인
#-------------------------------------------------------------
HEALTHCHECK [OPTION] CMD <COMMAND>
	옵션
		--interval: 간격(기본: 30s)
		--timeout: 타임아웃(기본: 30s)
		--retries: 타임아웃 횟수(기본: 3)
	"docker ps"로 확인 가능

#=============================================================
# ENV: 환경변수 지정
#-------------------------------------------------------------
# 한 번에 하나의 설정
ENV <KEY> <VALUE>

# 한 번에 여러 개 설정 가능
ENV <KEY>=<VALUE>

ENV <KEY1>=<VALUE1> \
	<KEY2>=<VALUE2>

#=============================================================
# WORKDIR: 프로세스 실행 위치 지정(기본값: /)
#-------------------------------------------------------------
WORKDIR <PATH>
	상대, 절대 경로 모두 가능
	반복 사용 가능(RUN 등이 순서에 영향을 받음)
	ENV로 설정한 환경 변수 사용 가능
	영향을 받는 명령어: RUN, CMD, ENTRYPOINT, COPY, ADD

#=============================================================
# USER: 사용자 지정
#-------------------------------------------------------------
USER <USER_ID>
	존재하는 사용자여야 함
	(RUN useradd 등을 통해 없던 사용자를 만드는 방식으로 사용할 수 있음)

#=============================================================
# LABEL: 이미지의 부가 정보 지정
#-------------------------------------------------------------
LABEL <KEY>=<VALUE>
	기능에는 영향이 없음
	"docker image inspect"를 통해 확인 가능

#=============================================================
# EXPOSE: 네트워크로 노출할 포트 지정
#-------------------------------------------------------------
EXPOSE <PORT>
	컨테이너 내부 포트를 변경하는 것이 아님

#=============================================================
# ARG: 빌드 시에만 사용되는 변수 지정
#-------------------------------------------------------------
ARG <KEY>=<VALUE>
	빌드 시 --build-arg 옵션으로 변경 가능(존재 한다면)

#=============================================================
# SHELL: shell 방식 명령 실행 시 사용할 쉘 지정(기본: /bin/sh -c)
#-------------------------------------------------------------
SHELL ["<SHELL_PATH>", "<PARAMETER>"]

#=============================================================
# ADD: 이미지에 호스트 또는 네트워크 위치의 파일을 추가
#-------------------------------------------------------------
ADD <ORIGIN_PATH> <IMAGE_PATH>
ADD ["<ORIGIN_PATH>" "<IMAGE_PATH>"]
	tar, zip 등 압축, 아카이브 포맷은 자동으로 압축해제함
	url에서 받은 리소스는 압축해제 하지 않음

#=============================================================
# COPY: 빌드 시 다른 컨테이너로부터 파일 복사
#-------------------------------------------------------------
COPY <CONTAINER_PATH> <PATH>

#=============================================================
# VOLUME: 컨테이너 실행 시 볼륨 마운트 위치 지정
#-------------------------------------------------------------
VOLUME <MOUNT_POINT>
VOLUME ["<MOUNT_POINT1>", "<MOUNT_POINT2>", "MOUNT_POINT3>"]
	임의의 이름의 볼륨을 생성해서 마운트 포인트에 연결함
	사용자가 볼륨 이름을 지정하는 런타임 옵션 또는 "docker volume" 사용의 경우 이름이 겹치는 문제가 발생할 수 있음

```

## 멀티 스테이지 빌드
- 리소스 관리 및 보안 측면에서의 장점을 위해 이미지를 분리하여 빌드 할 수 있음
- 빌드 이미지(용량 큼)와 실행 이미지(용량 작음)를 분리하는 예시

### 테스트
- file 구조

```bash
test_folder
	|- main.go
	|- Dockerfile
```

- main.go

```bash
package main

import (
        "fmt"
        "os"

        "github.com/urfave/cli"
)

func main() {
        app := cli.NewApp()
        app.Name = "Greeting"
        app.Version = "1.0.0"

        app.Flags = []cli.Flag{
                &cli.StringFlag{
                        Name:  "lang",
                        Value: "en",
                        Usage: "language for the greeting(es/fr/en)",
                },
        }

        app.Action = func(c *cli.Context) error {
                name := "world!"
                if c.NArg() > 0 {
                        name = c.Args().Get(0)
                }
                if c.String("lang") == "es" {
                        fmt.Println("Hola", name)
                } else if c.String("lang") == "fr" {
                        fmt.Println("Bonjour", name)
                } else {
                        fmt.Println("Hello", name)
                }
                return nil
        }

        app.Run(os.Args)
}
```

- Dockerfile

```bash
# 1. Build Image
FROM golang:1.13 AS builder

# Install dependencies
WORKDIR /go/src/github.com/asashiho/dockertext-greet
RUN go get -d -v github.com/urfave/cli

# Build modules
COPY main.go .
RUN GOOS=linux go build -a -o greet .

# ------------------------------
# 2. Production Image
FROM busybox
WORKDIR /opt/greet/bin

# Deploy modules
COPY --from=builder /go/src/github.com/asashiho/dockertext-greet/ .
ENTRYPOINT ["./greet"]
```

- 실행

```bash
$ docker build -t greet .
$ docker container run -it --rm greet abc
```


{% endraw %}
