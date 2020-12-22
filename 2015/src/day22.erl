-module(day22).

-define(bosshits, 58).
-define(bossdmg, 9).

-export([test/0]).

-record(life, {hp :: integer(),
               mana :: integer()}).

-record(effect, {name :: atom(),
                 life :: integer()}).

-record(state, {boss :: #life{},
                player :: #life{},
                effects :: [#effect{}]}).

test() ->
    Player = #life{hp=50, mana=500},
    Boss = #life{hp=?bosshits},
    St = #state{player=Player, boss=Boss, effects=[]},
    eval(player, [], St, 0).

eval(_Turn, _SpellBacklog, #state{boss=#life{hp=BossHP}}, CMana)
  when BossHP =< 0 ->
    {win, CMana};
eval(_Turn, _SpellBacklog, #state{player=#life{hp=HP, mana=Mana}}, CMana)
  when Mana =< 0 orelse HP =< 0 ->
    {lose, CMana};
eval(player, SpellBacklog, St0, CMana) ->
    St = apply_effects(St0),
    case boss_is_dead(St) of
        true ->
            {win, CMana};
        false ->
            eval(boss, SpellBacklog, St, CMana)
    end;
eval(boss, SpellBacklog, #state{player=#life{hp=HP}=Player}=St0, CMana) ->
    St = apply_effects(St0),
    case boss_is_dead(St) of
        true ->
            {win, CMana};
        false ->
            NewHP   = HP - ?bossdmg,
            io:format("HP ~p ~n", [NewHP]),
            NewSt = St#state{player=Player#life{hp=NewHP}},
            eval(player, SpellBacklog, NewSt, CMana)
    end.

apply_effects(#state{effects=Effects}=St) ->
    Apply = fun(#effect{name=shield}, AccSt) ->
                    AccSt;
               (#effect{name=poison}, #state{boss=#life{hp=HP}=Boss}=AccSt) ->
                    NewBoss = Boss#life{hp=HP-3},
                    AccSt#state{boss=NewBoss};
               (#effect{name=recharge},
                #state{player=#life{mana=Mana}=Player}=AccSt) ->
                    NewPlayer = Player#life{mana=Mana+101},
                    AccSt#state{player=NewPlayer}
            end,
    NewSt = lists:foldl(Apply, St, Effects),
    NewEffects = [Effect#effect{life=L-1}
                  || #effect{life=L}=Effect <- Effects, L-1 > 0],
    NewSt#state{effects=NewEffects}.

boss_is_dead(#state{boss=#life{hp=HP}}) when HP =< 0 ->
    true;
boss_is_dead(_) ->
    false.
