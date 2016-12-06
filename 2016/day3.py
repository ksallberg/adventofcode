instructions = [line.rstrip("\n") for line in open("input", "r")]

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

    if valid(y) == True and y not in valids:
        valids.append(y)

print "Valid triangles: ", len(valids)
