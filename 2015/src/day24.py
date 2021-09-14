import itertools

packs = [1,3,5,11,13,17,19,23,29,31,37,41,
         43,47,53,59,67,71,73,79,83,89,97,101,103,107,109,113]

print sum(packs)/4

m = 999999999999
for i in itertools.combinations(packs, 6):
    if sum(i) == 508:
        m = min(m, reduce(lambda x,y:x*y,i))

print m

m = 9999999999999999999999999999999999999999999999999999999999999
for i in itertools.combinations(packs, 5):
    if sum(i) == 381:
        m = min(m, reduce(lambda x,y:x*y,i))

print m
