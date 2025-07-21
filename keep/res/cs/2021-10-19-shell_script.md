---
layout: post
title: Shell Programming(쉘 스크립트) 요약
author: An Hyungjun
categories: [language]
tags: [linux, summary]
---

## 해시뱅(hash bang)!!
- 쉘 스크립트의 시작은 반드시 #!로 시작해야 함
- 해시뱅 뒤에는 쉘 스크립트 인터프리터 경로가 지정되며 반드시 절대 경로로 지정해야 함
```bash
	#!/bin/bash
	# this is comment
	echo "hello, world"
```

-------------------------------------------------------------

## 프로그램 종료

### ?: 종료 상태 변수
- 이전 명령의 종료 상태 또는 코드를 알 수 있음
```bash
	ls; echo $?
```

### exit: 프로그램 종료
```bash
	exit <EXIT_CODE>		// 0 <= EXIT_CODE <= 255

	exit 200
```

-------------------------------------------------------------

## 스크립트 실행
- 실행 권한 필요
```bash
	$ chmod 777 run.sh
	$ ./run.sh
```

-------------------------------------------------------------

## 출력

### echo: 표준 출력
```bash
	// 기본 출력
	echo "hello, world"
	
	// 개행 없이 출력
	echo -n "hello, world"
```

### printf
- C의 printf와 유사
```bash
	printf "%d, %f, %o, %s, %x, %X\n" 379 379 379 379 379 379
```

-------------------------------------------------------------

## 입력

### read: 표준 입력(줄 단위)
- 변수보다 더 많은 단어가 입력되면 남는 것들은 마지막 변수에 저장
- 입력하지 않으면 빈 값으로 채움
```bash
	read [-options] [variable...]
	
	// 기본
	read name
	read name1 name2
	
	// <NUM> 갯수만 읽어오기
	read -n <NUM> name1 name2 name3...
	
	// prompt 사용
	read -p "name: " name
	
	// -s: 입력 시 화면에 출력하지 않음
	read -s password
	
	// 내장 변수 REPLY 이용
	read
	echo $REPLY
```

-------------------------------------------------------------

## 변수와 연산

### 변수
- 쉘 스크립트에는 타입 개념이 없음 기본적으로 모두 "문자열"
- =: 대입 연산자
```bash
	// 대입연산자 앞 뒤에는 공백이 없어야 함
	var1="hello"
```
- 변수 참조: 달러 기호를 사용해야함(선언 시 사용할 수 없음)
```bash
	echo $var1		// hello
	echo ${var1}		// hello
	echo "$var1"		// hello
	echo '$var1'		// $var1
	echo "'$var1'"	// 'hello'
	echo \$var1		// $var1
```
- 명령어 결과를 변수로
```bash
	str=`date`
	echo $str

	str=$(pwd)
	echo $str
```

### 정수 연산
- declare: 정수 선언
```bash
	declare -i num=0
	echo $num

	num=4
	echo=$num

	# 변수 연산
	num=$num1+$num2

	# 진법 설정 (2 ~ 32진수까지 가능)
	num=2#1011
	num=8#1011
	num=16#1011
	
	# -------------------------------------------------------------
	# Error Case
	# -------------------------------------------------------------
	# type error
	num="invalid"
	num=0.5

	# 표현식에는 공백 불가
	num = 1 + 2
```
	- i 옵션 사용해야함(?)
	- 타입은 무조건 uint32

- let: 수치 연산 저장
```bash
	let ret=1+1	
	echo "1+1="$ret

	# 거듭 제곱
	let ret=2**10

	# 복합 대입
	let ret+=1

	# 단항연산
	let ret=++num
	let ret=num++

	# 비교 연산(==, != 말고는 따옴표를 써야 함)
	let ret=0\>1
	let ret=0'>='1
	let "ret=0>=1"
	let ret=0==1
	let ret=0!=1
	
	let 'ret = 1 + 1'
	let "ret = 1 + 1"
	
	# -------------------------------------------------------------
	# Error Case
	# -------------------------------------------------------------
	# 공백 사용 불가(사용하려면 큰 또는 작은 따옴표로 묶어야 함)
	let ret = 1 + 1
```

### expr, [], (()): 수식 처리 편의성 향상
- expr
```bash
	expr 1 + 2
	expr 1 \* 2
	expr 1 \<= 2
	expr 1 != 2
	expr 1 \| 0
	expr 1 \& 0
	
	# 다른 변수에 저장하려면 명쳥 치환 "$()" 필요
	ret=$(expr 1 + 2)
	
	# 와일드 카드는 백슬래시 필요
	ret=$(expr $n1 \* $n2)
```

- []: 편의성 Up!!
```bash
	ret=$[1 + 2]

	# '*', "<="에 백슬래시 필요 없음
	ret=$[1 * 2]
	ret=$[n1 <= n2]

	# 변수 사용 시 '$'필요 없음
	ret=$[n1 * n2]
	ret=$[n1++]
```

- (()): 산술 연산 전용
```bash
	((ret = ret + 1))
	
	# 연산에 백슬래시, 변수에 명령 치환 "$()" 필요 없음
	((ret += 1))
	((ret = 1 * 2))
	((ret = n1 <= n2))
	
	# 결과를 명령 치환을 이용해 변수에 저장 가능
	ret=$((1 * 2))
```

### bc: 부동 소수점 연산
```bash
```

-------------------------------------------------------------

## 문자열 처리

```bash
	# 길이
		${#<변수>}

	# 부분 문자열 추출
		# ${<변수>:<시작>:<길이>}
		# 시작: 0 부터 / 길이 안 쓰면 끝까지

	# 부분 문자열 삭제
		# 앞에서 가장 짧게 일치:	${<변수>#<부분문자열>}
		# 앞에서 가장 길게 일치:	${<변수>##<부분문자열>}
		# 뒤에서 가장 짧게 일치:	${<변수>%<부분문자열>}
		# 뒤에서 가장 길게 일치:	${<변수>%%<부분문자열>}

		str="ABCDEFABCDEFG"; echo ${str#A*F}
		str="ABCDEFABCDEFG"; echo ${str##A*F}
		str="ABCDEFABCDEFG"; echo ${str%D*F}
		str="ABCDEFABCDEFG"; echo ${str##D*F}

	# 부분 문자열 치환
		# 처음 일치하는 부분 문자열 치환:		${<변수>/<부분문자열>/<치환문자열>}
		# 모든 일치하는 부분 문자열 치환:		${<변수>//<부분문자열>/<치환문자열>}
		# 문자열이 부분문자열로 시작하면 치환:	${<변수>/#<부분문자열>/<치환문자열>}
		# 문자열이 부분문자열로 끝나면 치환:	${<변수>/%<부분문자열>/<치환문자열>}
```

-------------------------------------------------------------

## 분기문 if
```bash
	# 문법
		if <CONDITION1>
		then
			...
		elif <CONDITION2>
		then
			...
		else
			...
		fi

		if <CONDITION1>; then
			...
		fi

		if <CMD>; then
			...
		fi
```
```bash
	# Condition type 1: test 명령어
		// 산술 비교
		test $n1 -eq $n2		// ==	(EQual)
		test $n1 -ne $n2		// !=	(Not Equal)
		test $n1 -gt $n2		// >	(Greater Than)
		test $n1 -ge $n2		// >=	(Greater Equal)
		test $n1 -lt $n2		// <	(Less Than)
		test $n1 -le $n2		// <=	(Less Equal)

		// 문자열 비교
		test -n $str			// 빈 문자열이 아니면 참
		test $str				

		test $str1 = $str2		// 같다면 참
		test $str1 == $str2

		test $str1 != $str2		// 다르면 참

		test -z $str			// 빈 문자열이면 참

		// 파일 비교
		test -b $FILE		// 블럭 디바이스이면 참
		test -c $FILE		// 문자 디바이스이면 참
		test -d $FILE 		// 디렉토리이면 참
		test -e $FILE		// 존재하면 참
		test -f $FILE		// 존재하고 정규파일이면 참
		test -L $FILE		// 심볼릭 링크이면 참
		test -p $FILE		// 파이프이면 참
		test -r $FILE		// 현재 사용자가 읽을 수 있으면 참
		test -s $FILE		// 존재하고 그 크기가 0보다 크면 참
		test -S $FILE		// 소켓 디바이스이면 참
		test -w $FILE		// 현재 사용자가 쓸 수 있으면 참
		test -x $FILE		// 현재 사용자가 실행할 수 있으면 참
		test $FILE1 -nt $FILE2		// FILE1이 더 최근 파일이면 참
		test $FILE1 -ot $FILE2		// FILE1이 더 오래된 파일이면 참
	

	# Condition type 2: []		// test 대체
		# test와 동일하게 사용됨
		# !!반드시 앞 뒤로 공백이 있어야 함!!

		if [ $n1 -eq 0 ]; then
			...
		fi

	# Condition type 3: ()		// 산술식
		if (( (($n1 % 2)) == 0 )); then
			echo "even"
		else
			echo "odd"
		fi
	
	# Condition type 4: [[]]	// 정규 표현식
		# 앞 뒤로 공백 필수
		# $str =~ <REGEX>

		if [[ ! "$str" =~ ^-?[0-9]+$ ]]; then
			echo "str is not an integer"
		fi

	# Logical Operator
	|--------|----|----------|
	|Operator|test|[[]], (())|
	|--------|----|----------|
	|AND     |-a  | &&       |
	|OR      |-o  | ||       |
	|NOT     |!   | !        |
	|--------|----|----------|

	ex. 
		if [ $VAL = 0 ] || [ $VAL = 1 ]
		then
			...
		fi
```

## 분기문 case
```bash
	case $str in
		0) ...; exit;
		1) ...; exit;
		*) ...; exit;
	esac

	|--------------|--------------------|
	| Pattern      | Description        |
	|--------------|--------------------|
	| word)        | == word            |
	| [[:alpha:]]) | One alpabet        |
	| ???)         | three character    |
	| *.txt)       | wild card          |
	| *)           | wild card(default) |
	| q|Q)         | q or Q             |
	|--------------|--------------------|
```

## 삼항 연산자
```bash
	expr1 ? expr2 : expr3

	((n > 0 ? ++n : --n))
```

## 반복문 while: 조건이 참인동안 수행
```bash
	while <CONDITION>
	do
		...
			continue
		...
			break
	done
```

## 반복문 until: 조건이 거짓일동안 수행
```bash
	until <CONDITION>; do
		...
	done
```

## 반복문 for
```bash
	// 기본
	for i in 1 2 3 4 5; do
		echo "$i:"
	done

	// 문자열
	ns="1 2 3 4 5"
	for i in $ns; do
		echo "$i:"
	done

	// 명령어 치환
	for i in $(cat input.txt); do
		echo "$i:"
	done
```

## 배열
```bash
	// 선언 및 배정
	arr1=(1 2 3)
	arr2=([2]=1 [4]="word" [10]=$(pwd))
	arr3[2]=4

	// 참조
	arr=("alpha" "bravo" "Charlie")
	echo $arr
	echo ${arr[1]}
	echo ${arr[*]}
	# length
	echo ${#arr[@]}

	// 원소 삭제
	arr=("alpha" "bravo" "Charlie")
	unset arr[2]
	echo ${arr[*]}
	unset arr
	echo ${arr[*]}
```

## 함수
```bash
	function func {
		...
		return
	}
```
```bash
	# 매개변수 확인: $1 $2 ... ${10}
		# 10 이후의 매개변수는 {} 사용해야 함

	function isEven() {
		# 지역변수는 local 키워드를 반드시 붙혀야 함 / 아니면 전역으로 판단됨
		local ret=0

		if (( $1 % 2 )); then
			ret=0
		else 
			ret=1
		fi

		return $ret
	}

	# return 값 확인: ${?}
	isEven 1
	echo ${?}

	isEven 2
	echo ${?}
```
```bash
	# 매개 변수 개수: $#	// $0은 제외됨
	# 매개 변수를 순회하는 shift 명령어
	function printAll() {
		echo "num of param: $#"

		while [ -n "$1" ]; do
			echo -n "$1 "
			shift
		done
		echo
	}

	printAll 1 2 3 4
	printAll apple bravo charlie
```
```bash
	# 매개변수 확장
		# $* / $@: 모든 인자를 목록으로 확장함
		# "$*": 하나의 문자열로 확장
		# "$@": 각각의 문자열로 확장

	function printParam() {
		echo \$*: $*
		echo \$@: $@
		echo
		echo '"$*":'
		for arg in "$*"; do
			echo "$arg"
		done
		echo

		echo '"$@":'
		for arg in "$@"; do
			echo "$arg"
		done
	}

	printParam alpha bravo charlie
```
```bash
	# 스크립트 이름: $0
	echo $0
```

## 옵션처리
```bash
	while getopts "abc" opt; do
		case $opt in
			a) echo "-a"
			b) echo "-b"
			c) echo "-c"
			*) echo " wrong"
		esac
	done
```

## signal(시그널) 처리
```bash
	# 등록:
		# trap "<CMD>" <SIGNAL>
		# trap '<CMD>' <SIGNAL>
	# 해제: trap -- <SIGNAL>

	function mySig() {
		echo "mySig::'Ctrl + C'"
	}
	
	echo "set trap with cmd"
	trap "echo 'Ctrl + C'" SIGINT
	sleep 10
	
	echo "set trap with function"
	trap mySig SIGINT
	sleep 10
	
	echo "unset trap"
	trap -- SIGINT
	sleep 10

	# 스크립트 종료시에 실행될 동작 지정
	trap "echo 'Exit Script!!'" EXIT
```
