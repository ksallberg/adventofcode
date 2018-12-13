#!/bin/escript

main(_) ->
    {ok, Fd} = file:open("input.txt", []),
    Coll = collect(Fd, []),
    All = lists:usort(lists:flatten([[X, Y]||{X, Y}<-Coll])),
    Res = lists:reverse(step([], All, lists:reverse(Coll))),
    io:format("Res: ~p\n", [Res]).

collect(Fd, Acc) ->
    case file:read_line(Fd) of
        {ok, Line} ->
            A = lists:nth(6, Line),
            B = lists:nth(37, Line),
            collect(Fd, [{A, B}|Acc]);
        eof ->
            Acc
    end.

step(Finished, [], _Rules) ->
    Finished;
step([], Left, [{First,_}|_]= Rules) ->
    step([First], Left--[First], Rules);
step(Finished, Left, Rules) ->
    %% Filt is the requirement for a step to be chosen
    Filt = fun(Step) ->
                   Reqs = [Req||{Req, Step0} <- Rules, Step0==Step],
                   Done = [lists:member(Req, Finished)||Req<-Reqs],
                   not lists:member(false, Done)
           end,
    %% If several, we must chose the lowest ranked
    [Next|_] = lists:sort(lists:filter(Filt, Left)),
    step([Next|Finished], Left -- [Next], Rules).
