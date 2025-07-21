# -*- coding: utf-8 -*-

import os

myDic = {}
printDic = {}

def getTitle(path):
    f = open(path, encoding='utf-8')

    lines = f.readlines()

    for l in lines:
        key = 'title: '
        if l.find(key) == 0:
            return l[len(key):-1]
    
    return 'N/A'

def func(path):
    if os.path.isdir(path):        
        myDic[path] = []
    else:
        f = os.path.basename(path)
        d = os.path.dirname(path)
        myDic[d].append(f)        
        return     

    l = os.listdir(path)
    
    if l != []:
        for e in l:
            func(f'{path}/{e}')

func('res')
#print(myDic)

for f in os.listdir('link'):
    os.remove(f'link/{f}')

for k, v in myDic.items():    
    if v == []:
        continue
    
    depth = len(k.split('/'))
    category = k.split('/')[1]    

    target = f'link/{category}.md'
    print(target)

    if target not in printDic:
        printDic[target] = []
    
    prefix = ''
    for i in range(depth - 1):
        prefix += '#'
    
    printDic[target].append(f'{prefix} {os.path.basename(k)}')
    
    prefix = '../'    
    
    for md in v:
        path = f'{k}/{md}'
        title = getTitle(path)        
        printDic[target].append(f'- [{title}]({prefix}{path})') 

for k, v in printDic.items():    
    for line in v:
        print(line)

    with open(k, 'a', encoding='utf8') as f:
        for line in v:
            f.write(f'{line}\n')

print('-------------------------------------')

for k in printDic:    
    print(f'- [title]({k})')