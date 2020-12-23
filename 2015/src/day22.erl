-module(day22).

-define(bosshits, 58).
-define(bossdmg, 9).

-define(debug, false).

-export([test/0, perm/0]).

-record(life, {hp :: integer(),
               mana :: integer()}).

-record(effect, {name :: atom(),
                 life :: integer()}).

-record(state, {boss :: #life{},
                player :: #life{},
                cmana :: integer(),
                effects :: [#effect{}]}).

test() ->
    Player = #life{hp=50, mana=500},
    Boss = #life{hp=?bosshits},
    St = #state{player=Player, boss=Boss, effects=[], cmana=0},
    %% SpellList = [poison, recharge, shield, poison, recharge, shield,
    %%              poison, magic_missile, magic_missile, magic_missile],
    SpellList = [poison, recharge, shield, poison, recharge, shield,
                 poison, magic_missile],
    eval(player, SpellList, St).

perm() ->
    Player = #life{hp=50, mana=500},
    Boss = #life{hp=?bosshits},
    St = #state{player=Player, boss=Boss, effects=[], cmana=0},
    Start = [[poison], [recharge], [shield], [magic_missile], [drain]],
    Perms = perm1(Start, 8),
    Answers = [eval(player, Perm, St) || Perm <- Perms],
    lists:sort([X || {win, X} <- Answers]).

perm1(Lss, 0) ->
    Lss;
perm1(Lss, Level) ->
    NewLss = [Ls ++ [X]
              || X <- [poison, recharge, shield, magic_missile, drain],
                 Ls <- Lss],
    perm1(NewLss, Level-1).

eval(_Turn, _SpellBacklog, #state{boss=#life{hp=BossHP}, cmana=CMana})
  when BossHP =< 0 ->
    {win, CMana};
eval(_Turn, _SpellBacklog, #state{player=#life{hp=HP, mana=Mana}, cmana=CMana})
  when Mana =< 0 orelse HP =< 0 ->
    {lose, CMana};
eval(player, SpellBacklog, St0) ->
    St = apply_effects(St0),
    St1 = case SpellBacklog of
              [] ->
                  Spell=no_spell,
                  Spells=[],
                  St;
              [Spell|Spells] ->
                  apply_onetime(Spell, St)
          end,
    case boss_is_dead(St) of
        true ->
            {win, St#state.cmana};
        false ->
            case St1 of
                #state{} ->
                    case boss_is_dead(St1) of
                        true ->
                            {win, St1#state.cmana};
                        false ->
                            debug("player spell on boss: ~p Boss: ~p ~n",
                                  [Spell, St1#state.boss]),
                            eval(boss, Spells, St1)
                    end;
                Fail ->
                    Fail
            end
    end;
eval(boss, SpellBacklog, #state{effects=Effects}=St0) ->
    PlayerHasArmor = lists:keyfind(shield, #effect.name, Effects),
    St = apply_effects(St0),
    case boss_is_dead(St) of
        true ->
            {win, St#state.cmana};
        false ->
            Player = St#state.player,
            NewHP = case PlayerHasArmor of
                        false -> Player#life.hp - ?bossdmg;
                        _     -> Player#life.hp - (?bossdmg - 7)
                    end,
            case NewHP > 0 of
                true ->
                    debug("player hit, hp: ~p ~p ~n", [NewHP, PlayerHasArmor]),
                    NewSt = St#state{player=Player#life{hp=NewHP}},
                    eval(player, SpellBacklog, NewSt);
                false ->
                    {lose, St#state.cmana}
            end
    end.

apply_onetime(Spell, #state{boss=#life{hp=BHP}=Boss,
                            player=#life{mana=Mana, hp=PHP}=Player,
                            effects=Effects,
                            cmana=CMana}=St) ->
    NewPHP = case Spell of
                 drain -> PHP + 2;
                 _     -> PHP
             end,
    NewBHP = case Spell of
                 magic_missile -> BHP - 4;
                 drain         -> BHP - 2;
                 _             -> BHP
             end,
    Cost = case Spell of
               magic_missile -> 53;
               drain         -> 73;
               shield        -> 113;
               poison        -> 173;
               recharge      -> 229
           end,
    NewMana = Mana - Cost,
    HasEffect = lists:keyfind(Spell, #effect.name, Effects),
    NewBoss = Boss#life{hp=NewBHP},
    NewPlayer = Player#life{mana=NewMana, hp=NewPHP},
    debug("Mana: ~p NewMana ~p\n", [Mana, NewMana]),
    if NewPHP =< 0 ->
            fail_player_hp_zero;
       NewMana =< 0 ->
            fail_player_mana_zero;
       HasEffect /= false ->
            fail_effect_already_on;
       true ->
            NewEffects =
                case Spell of
                    shield   -> [#effect{name=shield, life=6}|Effects];
                    poison   -> [#effect{name=poison, life=6}|Effects];
                    recharge -> [#effect{name=recharge, life=5}|Effects];
                    _ -> Effects
                end,
            St#state{boss=NewBoss, player=NewPlayer,
                     effects=NewEffects, cmana=CMana+Cost}
    end.

apply_effects(#state{effects=Effects}=St) ->
    debug("mana before apply: ~p~n", [(St#state.player)#life.mana]),
    Apply = fun(#effect{name=shield}, AccSt) ->
                    debug("shield is on!\n", []),
                    AccSt;
               (#effect{name=poison}, #state{boss=#life{hp=HP}=Boss}=AccSt) ->
                    debug("poison applied! ~n", []),
                    NewBoss = Boss#life{hp=HP-3},
                    AccSt#state{boss=NewBoss};
               (#effect{name=recharge},
                #state{player=#life{mana=Mana}=Player}=AccSt) ->
                    debug("recharge applied! new mana: ~p ~n", [Mana+101]),
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

debug(Str, Args) ->
    case ?debug of
        true ->
            io:format(Str, Args);
        false ->
            ok
    end.
