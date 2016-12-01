instructions = [line.rstrip("\n") for line in open("input.txt", "r")]

instr_ls = instructions[0].split(", ")

cur_dir = "north";
dist = (0,0)

places = dict()

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
    dir_mod = instr[0]
    steps = int(instr[1:])
    cur_dir = new_dir(cur_dir, dir_mod)
    (new_x, new_y) = dist
    print dist
    if cur_dir == "north":
        new_y = new_y - steps
    elif cur_dir == "south":
        new_y = new_y + steps
    elif cur_dir == "west":
        new_x = new_x - steps
    elif cur_dir == "east":
        new_x = new_x + steps
    loc_dist = (new_x, new_y)

    if places.has_key(loc_dist):
        break
    else:
        places[loc_dist] = dist
        dist = loc_dist

(final_x, final_y) = dist

final = abs(final_x) + abs(final_y)

print "Final: ", dist, final
