instructions = [line.rstrip("\n") for line in open("input.txt", "r")]

instr_ls = instructions[0].split(", ")

cur_dir = "north";
dist = (0,0)

places = []

def new_dir(current, dir_mod):
    if current == "north" and dir_mod == "L":
        return "west"
    elif current == "west" and dir_mod == "L":
        return "south"
    elif current == "south" and dir_mod == "L":
        return "east"
    elif current == "east" and dir_mod == "L":
        return "north"
    elif current == "north" and dir_mod == "R":
        return "east"
    elif current == "east" and dir_mod == "R":
        return "south"
    elif current == "south" and dir_mod == "R":
        return "west"
    elif current == "west" and dir_mod == "R":
        return "north"

for instr in instr_ls:
    kill_me = 0
    dir_mod = instr[0]
    steps = int(instr[1:])
    cur_dir = new_dir(cur_dir, dir_mod)
    (new_x, new_y) = dist
    print cur_dir, steps
    new_range = []
    if cur_dir == "north":
        new_range = range(new_y - 1, new_y - steps - 1, -1)
        new_y = new_y - steps
        for r in new_range:
            fill_in = (new_x, r)
            if fill_in in places:
                dist = fill_in
                kill_me = 1
                break
            else:
                places.append(fill_in)
    elif cur_dir == "south":
        new_range = range(new_y + 1, new_y + steps + 1)
        new_y = new_y + steps
        for r in new_range:
            fill_in = (new_x, r)
            if fill_in in places:
                dist = fill_in
                kill_me = 1
                break
            else:
                places.append(fill_in)
    elif cur_dir == "west":
        new_range = range(new_x - 1, new_x - steps - 1, -1)
        new_x = new_x - steps
        for r in new_range:
            fill_in = (r, new_y)
            if fill_in in places:
                dist = fill_in
                kill_me = 1
                break
            else:
                places.append(fill_in)
    elif cur_dir == "east":
        new_range = range(new_x + 1, new_x + steps + 1)
        new_x = new_x + steps
        for r in new_range:
            fill_in = (r, new_y)
            if fill_in in places:
                dist = fill_in
                kill_me = 1
                break
            else:
                places.append(fill_in)
    if kill_me == 1:
        break
    dist = (new_x, new_y)

print places
(final_x, final_y) = dist

final = abs(final_x) + abs(final_y)

print "Final: ", dist, final
