instructions = [line.rstrip("\n") for line in open("input", "r")]

pos = (0, 2)
keypad = [[0,0,1,0,0],
          [0,2,3,4,0],
          [5,6,7,8,9],
          [0,"A","B","C",0],
          [0,0,"D",0,0]]

code = []

def new_pos((x, y), char):
    try:
        if char == "L":
            if x-1 >= 0 and keypad[y][x-1] != 0:
                return (x-1, y)
            else:
                return (x, y)
        if char == "R":
            if x+1 <= 4 and keypad[y][x+1] != 0:
                return (x+1, y)
            else:
                return (x, y)
        if char == "U":
            if y-1 >= 0 and keypad[y-1][x] != 0:
                return (x, y-1)
            else:
                return (x, y)
        if char == "D":
            if y+1 <= 4 and keypad[y+1][x] != 0:
                return (x, y+1)
            else:
                return (x, y)
    except IndexError:
        return (x, y)

for instr in instructions:
    for char in instr:
        pos = new_pos(pos, char)
    (x, y) = pos
    code.append(keypad[y][x])

print "Code is: ", code
