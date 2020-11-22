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

