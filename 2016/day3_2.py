instructions = [line.rstrip("\n") for line in open("input", "r")]
ins2 = []
ins3 = []
valids = []

def valid(inp):
    [a, b, c] = inp
    if a + b <= c:
        return False
    elif b + c <= a:
        return False
    elif a + c <= b:
        return False
    return True

for instr in instructions:
    x = instr.split(" ")
    y = [int(z) for z in x if z != '']
    ins2.append(y)

for i in xrange(0, len(ins2), 3):
    ins3.append([ins2[i][0], ins2[i+1][0], ins2[i+2][0]])
    ins3.append([ins2[i][1], ins2[i+1][1], ins2[i+2][1]])
    ins3.append([ins2[i][2], ins2[i+1][2], ins2[i+2][2]])

for instr in ins3:
    if valid(instr) == True:
        valids.append(y)

print "Valid triangles: ", len(valids)
