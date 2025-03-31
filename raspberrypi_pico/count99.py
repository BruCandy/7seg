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
    1: Pin(13, Pin.OUT), # 千の位
    2: Pin(12, Pin.OUT), # 百の位
    3: Pin(11, Pin.OUT), # 十の位
    4: Pin(10, Pin.OUT), # 一の位
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

# 2桁の数字を表示（ダイナミック点灯）
def show_number(val):
    #10の位
    set_seg(int(val / 10) % 10) 
    set_dig(3)
    time.sleep(0.005) # 5ms間隔
    #1の位
    set_seg(val % 10) 
    set_dig(4)
    time.sleep(0.005) # 5ms間隔


# RESETボタン
button = Pin(0, Pin.IN, Pin.PULL_UP)


cnt = 0
last_update = time.ticks_ms() # time.time()だと1s単位でしか出ない
while True:
    if button.value() == 0:
        cnt = 0
    show_number(cnt)
    if time.ticks_ms() - last_update >= 1000: # 1sごとにカウント
        cnt = (cnt + 1) % 100
        last_update = time.ticks_ms()
