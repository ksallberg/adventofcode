print("hej hej!")

f = open("inputy.txt", "r")

lines = list(filter(None, f.read().split("\n")))
for line in lines:
    line = [x for x in line]

# debug
for y in range(0,len(lines)):
    myline = ""
    for x in range(0, len(lines[0])):
        myline += lines[y][x]
    print(myline)
