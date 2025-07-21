---
layout: post
title: Deep Learning 기초
author: An Hyungjun
categories: [AI]
tags: [ai, summary, deep learning, ml]
---

Deep Learning 기초 지식을 정리한다.

# 기초 용어

## 딥러닝
- 머신러닝의 여러 방법론 중 하나로 인공신경망에 기반함
- 인공지능 > 머신러닝 > 딥러닝
- 60 ~ 80년대에 이론적 배경은 정립되었으나 H/W 발달 등에 힘입어 2000년대에 들어 활발히 사용됨
- 결국은 손실함수(Loss Function)의 최적화가 목적

## 인공 신경망
- 사람의 신경 시스템을 모방한 학습 알고리즘
- 모델 스스로 데이터의 특성을 학습함(지도, 비지도 학습 모두 가능함)
- 명시적 프로그래밍의 한계(ex. 자율 주행)를 극복할 수 있음

## 퍼셉트론
- 인공 신경망의 한 종류
- 가중치, 편향(Bias), 비선형의 활성화(activation) 함수로 이뤄짐
- 활성화 함수를 사용하는 이유
	- 노이즈 제거 또는 학습 편의

### 가중치
- 노드간의 연결강도를 의미

### 선형 분류기
- 단층 퍼셉트론(1개 Input Layer + 1개 Output Layer로 구성)을 통해 선형 분류기를 구현할 수 있음
- 예시: AND, OR, NAND, NOR

### 비선형 문제
- MLP(Multi Layer Perceptron), 다층 퍼셉트론(Hidden Layer가 추가 되어 있음)을 통해 해결
- 예시: XOR

## Backpropogation(역전파)
- 복잡한 레이어의 신경망에서 가중치의 기울기를 계산할 수 있게 하는 방법
- 오차값을 뒤로 전파하면서 변수를 갱신하는 알고리즘

# TensorFlow
- 현재(2022년) 가장 널리 쓰이는 딥러닝 프레임워크
- 유연성, 효율성, 확장성

## Tensor
- Multidimensional Arrays(Data)
- 다차원 배열로 나타내는 데이터를 의미

## Flow
- 데이터의 흐름을 의미
- TensorFlow에서 계산은 데이터 플로우 그래프로 수행됨(그래프를 따라 데이터가 노드를 거쳐감)

## TF1 vs. TF2
- TF1에서는 그래프, 세션 등 비직관적인 개념이 있었음

## TensorFlow 기초 사용

### 자료형
```python
tf.float32	# 32-bit float
tf.float64	# 64-bit float
tf.int8		# 8-bit integer
tf.int16	# 16-bit integer
tf.int32	# 32-bit integer
tf.uint8	# 8-bit unsigned integer
tf.string	# String
tf.bool		# boolean
```

### Tansor의 종류
```python
#-------------------------------------------------------------
# Constant Tensor
#-------------------------------------------------------------

# 특정 값
tensor_a = tf.constant(value, dtype=None, shape=None, name=None)

# 모든 값이 0
tensor_b = tf.zeros(shape, dtype=tf.float32, name=None)

# 모든 값이 1
tensor_c = tf.ones(shape, dtype=tf.float32, name=None)

#-------------------------------------------------------------
# Sequence Tensor
#-------------------------------------------------------------

# start에서 stop까지 증가하는 num 개의 데이터
tensor_d = tf.linspace(start, stop, num, name=None)

# start에서 limit까지 delta씩 증가
tensor_e = tf.range(start, limit, delta, name=None)

#-------------------------------------------------------------
# Variable Tensor
#-------------------------------------------------------------

tensor_f = tf.Variable(initial_value=None, dtype=None, name=None)
```

### Tansor 사칙 연산
```python
tf.add(a, b)
tf.subtract(a, b)
tf.multiply(a, b)
tf.truediv(a, b)
```

## 딥러닝 모델 구현 

### 데이터 셋 준비
- Epoch: 전체 데이터 셋에 대해 1회 학습을 완료한 상태
- Batch(mini-batch): 나눠진 데이터 셋
- iteration: 전체 데이터 셋을 몇개의 Batch로 나눴는가

### Keras
- 모델 생성을 돕는 고수준 API

```python
# 모델 클래스 개체 생성
tf.keras.models.Sequential()

# 모델의 각 Layer 구성
tf.keras.layers.Dense(units, activation)
	# units: 레이어 안의 Node의 수
	# activation: 활성화 함수 설정

# Layer 추가
m.add()

# 최적화 방식 설정
model.compile(optimizer, loss)

# 학습
model.fit(X_train, y_train)

# 평가
model.evaluate(X_test, y_test)

# 예측
model.predict(X)
```

- Layer 구성 방법 예시

```python
# Ver.1
model = tf.keras.Sequential([
    tf.keras.layers.Dense(16, input_dim=2, activation='relu'),
    tf.keras.layers.Dense(100, activation='relu'),
    tf.keras.layers.Dense(1, activation='sigmoid'),
])

# Ver.2
model = tf.keras.Sequential()
model.add(tf.keras.layers.Dense(16, input_dim=2, activation='relu'))
model.add(tf.keras.layers.Dense(100, activation='relu'))
model.add(tf.keras.layers.Dense(1, activation='sigmoid'))  
```

# 딥러닝의 문제점(Second AI Winter)
- 학습 속도: 데이터가 많아지면서 학습 시간이 기하급수적으로 늘어남
- 기울기 소실: 출력값과 멀어질 수록 기울기가 0에 가까워짐 -> 출력값에서 먼 노드의 가중치가 잘 변하지 않음
- 초기값 설정: 초기값 설정에 따라 성능차이가 큼
- 과적합: 보통 모델이 복잡해질 수록 과적합 가능성이 높아짐

## 학습 속도 문제 해법
- SGD(Stochastic Gradient Descent) 등을 이용해서 전체 데이터가 아닌 부분 데이터(Mini-batch)만 활용해서 손실 함수를 계산함
- SGD의 파생 알고리즘
	- Momentum: 과거 기울기를 나중에 일정 부분 사용함
	- AdaGrad(Adaptive Gradient): 변수들의 변화 정도에 따라 Learning rate를 차등 적용함(많이 변화한 변수는 작게, 적게 변화한 변수는 크게 적용)
	- RMSProp: AdaGrad의 개선 버전으로 과거 기울기를 잊고 새 기울기 정보를 크게 반영
	- Adam(Momentum + RMSProp): 가장 발전된 최적화 알고리즘

### 다양한 최적화 함수

```python
tf.keras.optimizers.SGD(lr=0.01, momentum=0)

tf.keras.optimizers.Adagrad(lr=0.01, epsilon=0.00001, decay=0.4)
	# epsilon: 연산 시 devide by zero를 막음
	# decay: 업데이트마다 학습률을 비율만큼 줄여주는 파라미터

tf.keras.optimizers.RMSprop(lr=0.01)

tf.keras.optimizers.Adam(lr=0.01, beta_1=0.9, beta_2=0.999)
	# beta_1: 모멘텀
	# beta_2: step_size

```

### 손실 함수 binary crossentropy
- 두 확률 분포간의 차이를 측정하는 손실 함수
- 작을 수록 예측결과가 좋음을 의미

```python
# 손실 함수의 점수 출력 예시
model.compile(loss='binary_crossentropy', optimizer='sgd', metrics=['accuracy', 'binary_crossentropy'])
model.summary()
history = model.fit(train_data, train_labels, epochs = 20, batch_size = 50, validation_data = (test_data, test_labels), verbose = 0)
scores = history.history['val_binary_crossentropy'][-1]
print('scores: ', scores)
```

## 기울기 소실 문제 해법
- Layer가 깊을 수록 sigmoid 함수 말고 다른 함수를 활성화 함수로 사용하기

### 기울기 소실 문제의 주된 발생 원인
- 주로 사용되는 Sigmoid 함수가 입력의 절대값이 클 수록 기울기가 0에 가까워 짐
- Chain Rule에 의해 미분값이 계속 곱해지면서 점점 0이 됨

### 해법
- Hidden Layer에서 활성화 함수로 ReLU를 사용
- Output Layer에서 활성화 함수로 Tanh를 사용

## 초기값 설정 문제 해법
- 2022년 기준 He + ReLU가 가장 널리 쓰임

### 발달 과정
- 표준 정규 분포를 이용: 결국 추가 학습이 안 되는 시점이 발생
- 표준 편차를 줄임
- Xavier 초기화 방법(표준 정규 분포를 입력 개수의 제곱근으로 나눔) + Sigmoid를 사용
- He 초기화 방법(표준 정규 분포를 입력 개수 절반의 제곱근으로 나눔) + ReLU

## 과적합 방지

### 아이디어
- 정규화(모델이 복잡할 수록 가중치 합이 커지는 경향이 있음): 기존 손실 함수에 규제항을 더함

### L1 정규화(Lasso Regularization)
- 가중치의 절대값의 합을 규제 항으로 정의
- 작은 가중치들이 거의 0으로 수렴하여 몇개의 중요 가중치만 남김

### L2 정규화(Ridge Regularization)
- 가중치의 제곱의 합을 규제항으로 정의
- L1에 비해 0으로 수렴하는 가중치가 적으나 큰 값을 가진 가중치를 제약하는 효과가 있음

### 드롭아웃(DropOut)
- 각 Layer마다 일정 비율의 뉴런을 임의로 Drop시킴

### 배치 정규화(Batch Normalization)
- Normalization을 처음 input data 뿐만 아니라 신경망 내부 Hidden Layer의 input에도 적용
- 매 Layer마다 정규화를 하므로 가중치 초기값에 의존하지 않음

# Keras Model Template
```python
model = tf.keras.Sequential([
	tf.keras.layers.Flatten(input_shape=(28, 28)),

	# Actiation: Sigmoid
	tf.keras.layers.Dense(128, activation='sigmoid'),

	# Actiation: ReLU
	tf.keras.layers.Dense(128, activation='relu'),

	# Actiation: tanh
	tf.keras.layers.Dense(128, activation='tanh'),

	# L1
	tf.keras.layers.Dense(128, activation = 'relu', kernel_regularizer = tf.keras.regularizers.l1(0.001)),

	# L2
	tf.keras.layers.Dense(128, activation = 'relu', kernel_regularizer = tf.keras.regularizers.l2(0.001)),
	
	# Dropout
	tf.keras.layers.Dropout(0.1),

	# Batch Normalization: Dens와 Activation 사이에 존재함
	tf.keras.layers.Dense(512),
	tf.keras.layers.BatchNormalization(),
	tf.keras.layers.Activation('relu'),

	tf.keras.layers.Dense(10, activation='softmax')
])
```

# 다양한 분야에서의 딥러닝
- 이미지 처리(CNN)
- 자연어 처리
- 워드 임베딩
- 순환 신경망(RNN)

## 이미지 처리
- 얼굴 인식
- 화질 개선
- 이미지 자동 태깅

### 컴퓨터의 이미지 인식 방법
- 각 픽셀 값을 입력 데이터로 사용
- 기존 MLP에서는 많은 파라미터가 필요했고 이미지 변화(회전 등)에 대한 처리가 까다로웠음
- 딥러닝에서는 CNN을 이용해서 이미지의 패턴이 아닌 특징을 자동으로 학습하게 함

# CNN(Convolutional Nural Network)
- 시신경을 모방한 이미지 처리에 특화된 학습 모델

## CNN의 구성
- Convolution Layer
- Pooling Layer
- Fully Connected Layer

## Convolution Layer
- 이미지가 어떠한 특징이 있는 지를 구함
- 필터가 이미지를 이동하며 새로운 이미지(피쳐맵)을 생성

### 피쳐맵을 구하는 다양한 기법
- Padding: 경계 영역의 데이터를 분석하기 위해 원본 이미지에 1pixel 테두리를 추가
- Striding: 필터를 이동하는 간격을 조정

## Pooling Layer
- 이미지의 노이즈를 없애면서 축소시킴
	- Max Pooling: 큰 값만 남김
	- Average Pooling: 평균을 남김

## Fully Connected Layer
- 기존의 MLP에서의 Layer를 의미하며 Convolution, Pooling Layer를 거친 데이터에 적용됨
- 마지막 Layer에서는 분류를 위해 Softmax를 활성화함수로 사용함

### CNN Keras Example
```python
model = tf.keras.Sequential()
model.add(tf.keras.layers.Conv2D(filters=32, kernel_size=(3,3), activation='relu', padding='SAME', input_shape=(28,28,1)))
model.add(tf.keras.layers.MaxPool2D(padding='SAME'))
model.add(tf.keras.layers.Conv2D(filters=32, kernel_size=(3,3), activation='relu', padding='SAME'))
model.add(tf.keras.layers.MaxPool2D(padding='SAME'))
model.add(tf.keras.layers.Flatten())
model.add(tf.keras.layers.Dense(10, activation='softmax'))
```

```python
model = tf.keras.models.Sequential()
model.add(tf.keras.layers.Conv2D(filters=8, kernel_size=(3,3), strides=(1,1), padding='SAME', input_shape=(28,28,1)))
model.add(tf.keras.layers.BatchNormalization())
model.add(tf.keras.layers.Activation('relu'))
model.add(tf.keras.layers.Conv2D(filters=16, kernel_size=(5,5), strides=(1,1), padding='SAME'))
model.add(tf.keras.layers.BatchNormalization())
model.add(tf.keras.layers.Activation('relu'))
model.add(tf.keras.layers.MaxPool2D(pool_size=(2,2), padding='SAME'))
model.add(tf.keras.layers.Conv2D(filters=24, kernel_size=(3,3), strides=(1,1), padding='SAME'))
model.add(tf.keras.layers.BatchNormalization())
model.add(tf.keras.layers.Activation('relu'))
model.add(tf.keras.layers.MaxPool2D(pool_size=(2,2), padding='SAME'))
model.add(tf.keras.layers.Flatten())
model.add(tf.keras.layers.Dense(10, activation='softmax'))
```

# 자연어 처리(NLP: Natural Language Processing)
- 자연어의 의미를 분석해서 컴퓨터가 처리할 수 있도록 하는 것
- 예시: 기계 번역, 음성 인식

## NLP Process
- 자연어 전처리(Preprocessing)
- 단어 표현(Word Embedding)
- 모델 적용(Modeling)

### 자연어 전처리
- Noise Canceling: 오타, 띄어쓰기 오류 교정
- Tokenizing: 어절 또는 단어 등으로 구분시킴
- StopWord removal: StopWord(불용어: 불필요 단어) 제거

# 워드 임베딩(Word Embedding)
- 단어를 컴퓨터가 계산 가능한 숫자로 변환하는 작업

## Count-based Representations
- Bag of Words
- One-hot encoding
- Document term matrix

### 단점
- 벡터 크기가 너무 큼
- 단어간 관계 정보가 무시됨

### 코드 예시
- 형태소 및 품사 분할

```python
from konlpy.tag import Twitter

# 형태소 분할
analyzer = Twitter()
morphs = analyzer.morphs(sentence)

# 품사 분할
analyzer = Twitter()
analyzer.pos(sentence)
```

-  One-hot encoding & Document term matrix
```python
#  One-hot encoding
from tensorflow.python.keras.preprocessing.text import Tokenizer

tokenizer = Tokenizer()
tokenizer.fit_on_texts(sum_of_sentence)
word_dict = tokenizer.word_index

# term matrix 구현을 위한 전처리: value가 0부터 시작하게 바꿈
for k, v in word_dict.items():
	word_dict[k] = v - 1

sentense = tokenizer.texts_to_sequences(sentence)
sentense = [token[0] for token in sentence]

# Document term matrix
term_matrix = sum(tf.one_hot(sentense, len(word_dict)))
```

## Distributed Representations
- Word2vec: 의미상으로 유사한 단어끼리 가까이 있도록 벡터 공간에 Mapping

### 예시: CBOW 방식
- 주변 단어(Context Words)로 중심단어(Center word)를 예측하도록 학습함
- ex. 엄마-아빠(가까움) / 정치-바이올린(멈)

### Skip-Gram
- 특정 단어를 바탕으로 주변 단어들을 예측하는 모델을 말합니다.

```python
from gensim.models import word2vec

# Word2Vec 모델 생성(size: 벡터 차원 수, min_count: 최소 빈도, window: 앞뒤 단어 수, sg: 0(CBOW) / 1(Skip-gram))
model = word2vec.Word2Vec(sentences, size=300, min_count=1, window=10, sg=0)

idx2word_set = model.wv.index2word
```

# 순환신경망(RNN)
- 기존 MLP의 한계를 극복함
- 데이터의 순서에 의미를 부여함(자연어 처리에 적합)
- 사용예: Image captioning, Chat bot

## 아이디어
- 이전 데이터의 출력값을 다음 데이터와 함께 다시 입력으로 사용
- 이전 데이터의 출력값을 저장(신경망 입장에서는 기억)해 둠
- 입력 노드는 하나만 사용됨(주로 One-hot vector)

### RNN, LSTM, GRU 비교
```python
simpleRNN = tf.keras.models.Sequential([
	tf.keras.layers.Embedding(input_dim=1000, output_dim=embedding_vector_length, input_length=max_review_length)
	tf.keras.layers.SimpleRNN(units=5, activation='tanh')
	tf.keras.layers.Dense(1, activation='sigmoid')
])
    
lstm = tf.keras.models.Sequential([
	tf.keras.layers.Embedding(input_dim=1000, output_dim=embedding_vector_length, input_length=max_review_length)
	tf.keras.layers.LSTM(units=5)
	tf.keras.layers.Dense(1, activation='sigmoid')
])

gru = tf.keras.models.Sequential([
	tf.keras.layers.Embedding(input_dim=1000, output_dim=embedding_vector_length, input_length=max_review_length)
	tf.keras.layers.GRU(units=5)
	tf.keras.layers.Dense(1, activation='sigmoid')
])
```

# 기타 유용한 코드
-  One-hot Encoding

```python 
from tensorflow.keras.utils import to_categorical

to_categorical(labels, 10)
```

- 차원 추가
```python
arr = np.array([[1, 2], [3, 4]])
arr.shape
arr = np.expand_dims(arr, axis=1)
arr.shape
```

- 차원 변경
```python
# CNN이 RGB 3차원을 쓰기에 흑백이미지는 아래의 처리가 필요할 수 있음
x_train = x_train.reshape(-1, width, height, 1)
```
