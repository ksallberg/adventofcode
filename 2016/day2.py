instructions = [line.rstrip("\n") for line in open("input", "r")]

pos = (1, 1)
keypad = [[1, 2, 3],
          [4, 5, 6],
          [7, 8, 9]]

code = []

def new_pos((x, y), char):
    if char == "L":
        if x > 0:
            return (x-1, y)
        else:
            return (x, y)
    if char == "R":
        if x < 2:
            return (x+1, y)
        else:
            return (x, y)
    if char == "U":
        if y > 0:
            return (x, y-1)
        else:
            return (x, y)
    if char == "D":
        if y < 2:
            return (x, y+1)
        else:
            return (x, y)

for instr in instructions:
    for char in instr:
        pos = new_pos(pos, char)
    (x, y) = pos
    code.append(keypad[y][x])

print "Code is: ", code
