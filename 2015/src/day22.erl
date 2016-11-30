-module(day22).
-compile(export_all).
-author("kristian").

-define(bosshits, 58).
-define(bossdmg, 9).

%% Magic Missile costs 53 mana. It instantly does 4 damage.

%% Drain costs 73 mana. It instantly does 2 damage and heals
%% you for 2 hit points.

%% Shield costs 113 mana. It starts an effect that lasts for
%% 6 turns. While it is active, your armor is increased by 7.

%% Poison costs 173 mana. It starts an effect that lasts for
%% 6 turns. At the start of each turn while it is active,
%% it deals the boss 3 damage.

%% Recharge costs 229 mana. It starts an effect that lasts
%% for 5 turns. At the start of each turn while it is active,
%% it gives you 101 new mana.

test() ->
    eval([], 500, 50, ?bosshits, 0).

eval(ActiveSpells, Mana, HitPoints, BossHitPoints, CMana)
  when BossHitPoints =< 0 ->
    {win, CMana};
eval(ActiveSpells, Mana, HitPoints, BossHitPoints, CMana)
  when Mana =< 0 orelse HitPoints =< 0 ->
    {lose, CMana};
eval(ActiveSpells, Mana, HitPoints, BossHitPoints, CMana) ->
    io:format("BossHitPoints ~p~n", [BossHitPoints]),
    BossNewHP = BossHitPoints - 4,
    MyNewHP   = HitPoints - ?bossdmg,
    eval([], Mana - 53, MyNewHP, BossNewHP, CMana + 53).
