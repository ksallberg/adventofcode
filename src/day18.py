import numpy
import re

instructions = [line.rstrip("\n") for line in open("input.txt", "r")]
theSize      = 100
lights       = numpy.zeros((theSize, theSize))

def parse(x):
    if x == ".":
        return 0
    elif x == "#":
        return 1

# Initial grid:
y = 0
for row in instructions:
    for x in range(0,100):
        lights[x][y] = parse(row[x])
    y += 1

def safeget(x, y):
    if x < 0 or x > 99:
        return 0
    if y < 0 or y > 99:
        return 0
    return lights[x, y]

# abc
# def
# ghi
#      When evaluating e
def eval(x, y):
    a = safeget(x-1, y-1)
    b = safeget(x, y-1)
    c = safeget(x+1, y-1)
    d = safeget(x-1, y)
    f = safeget(x+1, y)
    g = safeget(x-1, y+1)
    h = safeget(x, y+1)
    i = safeget(x+1, y+1)
    return a+b+c+d+f+g+h+i

def run():
    setOn = []
    setOff = []

    for y in range(0,100):
        for x in range(0,100):
            cur = lights[x][y]
            ev = eval(x, y)
            if cur == 1 and (ev == 2 or ev == 3):
                continue
            elif cur == 1:
                setOff.append((x, y))
            elif cur == 0 and ev == 3:
                setOn.append((x, y))
            else:
                continue

    for (x, y) in setOn:
        lights[x, y] = 1

    for (x, y) in setOff:
        lights[x, y] = 0

for i in range(0, 100):
    lights[0][0]   = 1
    lights[0][99]  = 1
    lights[99][0]  = 1
    lights[99][99] = 1
    run()
    lights[0][0]   = 1
    lights[0][99]  = 1
    lights[99][0]  = 1
    lights[99][99] = 1

print "Nonzero:", numpy.count_nonzero(lights)
