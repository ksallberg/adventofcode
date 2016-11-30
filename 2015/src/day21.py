import itertools

daggers = [("Dagger",     8,  4, 0),
           ("Shortsword", 10, 5, 0),
           ("Warhammer",  25, 6, 0),
           ("Longsword",  40, 7, 0),
           ("Greataxe",   74, 8, 0)]

armor = [("Leather",     13,  0, 1),
         ("Chainmail",   31,  0, 2),
         ("Splintmail",  53,  0, 3),
         ("Bandedmail",  75,  0, 4),
         ("Platemail",   102, 0, 5)]

rings = [("dmg+1", 25, 1, 0),
         ("dmg+2", 50, 2, 0),
         ("dmg+3", 100, 3, 0),
         ("def+1", 20, 0, 1),
         ("def+2", 40, 0, 2),
         ("def+3", 80, 0, 3)]

class Mob:
    def __init__(self, e):
        self.hp    = 100
        self.dmg   = 8
        self.arm   = 2
        self.equip = e

    def fight(self, other):
        inflicteddmg = self.calcdmg() - other.calcarm()
        other.hp = other.hp - max(1, inflicteddmg)

    def calcarm(self):
        sum_ = 0
        for (_, _, _, arm) in self.equip:
            sum_ = sum_ + arm
        return sum_ + self.arm

    def calcdmg(self):
        sum_ = 0
        for (_, _, dmg, _) in self.equip:
            sum_ = sum_ + dmg
        return sum_ + self.dmg

    def calccost(self):
        sum_ = 0
        for (_, cost, _, _) in self.equip:
            sum_ = sum_ + cost
        return sum_

prices = []
losingprices = []

class Fight:
    def __init__(self, e):
        self.me   = Mob(e)
        self.me.dmg = 0
        self.me.arm = 0
        self.boss = Mob([])
        self.winner = ""

        while self.me.hp > 0 and self.boss.hp > 0:
            self.me.fight(self.boss)
            if self.boss.hp <= 0:
                self.winner = "me"
            self.boss.fight(self.me)

        if self.winner == "me":
            prices.append(self.me.calccost())
        else:
            self.winner = "boss"
            losingprices.append(self.me.calccost())

al = [[d, y] for d in daggers for y in armor]
ds = [[d] for d in daggers]
fs = al + ds

sn  = list(itertools.permutations(rings, 2))

snx = [[x, y] for (x, y) in sn]
sny = [[x] for x in rings]

fin = fs + [x + y for x in fs for y in (snx+sny)]

for e in fin:
    print e
    f = Fight(e)

losingprices.sort()

print "sorted prices", losingprices[-1]
