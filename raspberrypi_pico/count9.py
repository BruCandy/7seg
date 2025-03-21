from machine import Pin
import time


segs = {
    'a': Pin(18, Pin.OUT),
    'b': Pin(20, Pin.OUT),
    'c': Pin(2, Pin.OUT),
    'd': Pin(4, Pin.OUT),
    'e': Pin(5, Pin.OUT),
    'f': Pin(19, Pin.OUT),
    'g': Pin(21, Pin.OUT),
    'dp': Pin(3, Pin.OUT),
}

digs = {
    1: Pin(13, Pin.OUT),
    2: Pin(12, Pin.OUT),
    3: Pin(11, Pin.OUT),
    4: Pin(10, Pin.OUT),
}

# dp(小数点)は使用しない
num = {
    0: [1, 1, 1, 1, 1, 1, 0, 0],
    1: [0, 1, 1, 0, 0, 0, 0, 0],
    2: [1, 1, 0, 1, 1, 0, 1, 0],
    3: [1, 1, 1, 1, 0, 0, 1, 0], 
    4: [0, 1, 1, 0, 0, 1, 1, 0], 
    5: [1, 0, 1, 1, 0, 1, 1, 0],
    6: [1, 0, 1, 1, 1, 1, 1, 0],
    7: [1, 1, 1, 0, 0, 0, 0, 0],
    8: [1, 1, 1, 1, 1, 1, 1, 0],
    9: [1, 1, 1, 1, 0, 1, 1, 0],
}


# 表示数字の指定
def set_seg(val):
    data = num.get(val)
    for i, s in enumerate(['a', 'b', 'c', 'd', 'e', 'f', 'g']):
        segs[s].value(data[i])

# 表示する桁の指定
def set_dig(dig):
    for d in digs:
        active = 0 if d == dig else 1
        digs[d].value(active)

# RESETボタン
button = Pin(0, Pin.IN, Pin.PULL_UP)


cnt = 0
set_dig(4) # 1桁目に表示
while True:
    if button.value() == 0:
        cnt = 0
    set_seg(cnt)
    cnt = (cnt + 1) % 10
    time.sleep(1) # 1秒ごとにカウント


'''
# プログラムを終えるときにエラーを出さないようしたい場合
try:
    while True:
        if button.value() == 0:
            cnt = 0 
        set_seg(cnt) 
        cnt = (cnt + 1) % 10
        time.sleep(1)
except KeyboardInterrupt:
    print("\nプログラムを終了します") 
'''
