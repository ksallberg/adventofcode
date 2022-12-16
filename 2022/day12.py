from collections import deque as queue

############
# credits: #
############

# Learn bfs on array, and initial structure of program:
# https://www.geeksforgeeks.org/breadth-first-traversal-bfs-on-a-2d-array/

# Understand you need to explicitly remember dist:
# https://github.com/ygge/adventofcode2022/blob/main/src/main/java/Day12.java

#####################
# helper functions: #
#####################

# debug
def debugit(row1, col1):
    for row in range(0,len(lines)):
        myline = ""
        for col in range(0, len(lines[0])):
            if(col == col1 and row == row1):
                myline += '©'
            else:
                myline += lines[row][col]
        print(myline)
    print("____")

# Parse the input file into type [[Char]],
# where rows are the inner arrays, so like:
# [
#  ['t','h','i','s',' ','i','s',' ','a',' ','r','o','w,]
# ]
f = open("input.txt", "r")

lines = list(filter(None, f.read().split("\n")))
for line in lines:
    line = [x for x in line]

# Then find the position to start the BFS search from.
# It is denoted by 'S'
start = (0,0)
all_starts = []
for row in range(0, len(lines)):
    for col in range(0, len(lines[0])):
        if(lines[row][col] == 'a'):
            all_starts.append((row, col))
        if(lines[row][col] == 'S'):
            start = (row, col)

def is_valid(row, col, currently_at_elevation):
    # out of bounds check
    if (row < 0 or col < 0 or row >= len(lines) or col >= len(lines[0])):
        return False

    prospect_elevation = lines[row][col]

    if (prospect_elevation == 'E'):
        prospect_elevation = 'z'

    if (prospect_elevation == 'S'):
        prospect_elevation = 'a'

    # allow step if max altitude increase is 1, but also if
    # there is an altitude decrease
    if(ord(prospect_elevation) <= ord(currently_at_elevation) + 1):
        return True
    else:
        return False

# BFS implementation
def bfs(initial_position):
    # BFS requires a queue, that you can insert in the end of,
    # and that you can pick from the beginning of,
    #
    # Additionally, I found that you need to store the distance
    # for each position reached, since the overall list of
    # visited nodes might be a lot larger than this
    # global queue
    bfs_queue = queue()
    bfs_queue.append((initial_position, 0))

    # Keep track of what has been visited so that we don't walk
    # around forever
    visited = []

    while len(bfs_queue) > 0:

        # Take first item in queue
        (new_place, dist) = bfs_queue.popleft()
        row = new_place[0]
        col = new_place[1]
        currently_at_elevation = lines[row][col]

        # if we reached destination
        if(currently_at_elevation == 'E'):
            return dist

        # if we already visited a position, discard current pos and get
        # next from queue
        if((row,col) in visited):
            continue
        # if not, mark as visited
        else:
            visited.append((row,col))

        currently_at_elevation = lines[row][col]
        if(currently_at_elevation == 'S'):
            currently_at_elevation = 'a'

        # debugit(row, col)

        # Now, this is the interesting part,
        # we need to add all adjacent tiles if they are valid.
        # We also need to increase the distance needed to get to them.
        up = (-1, 0)
        left = (0, -1)
        right = (0, 1)
        down = (1, 0)
        directions = [up, left, right, down]
        for dir in directions:
            adjrow = row + dir[0]
            adjcol = col + dir[1]
            if(is_valid(adjrow, adjcol, currently_at_elevation)):
                bfs_queue.append(((adjrow, adjcol), dist+1))

print("pt 1 solution", bfs(start))

# pt2:

all = [bfs(x) for x in all_starts]
all2 = list(filter(lambda x: x != None, all))

print("all: ", all2)
all2.sort()

print("pt 2 solution", all2[0])
