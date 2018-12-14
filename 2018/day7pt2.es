#!/bin/escript

workers() ->
    5.

main(_) ->
    {ok, Fd} = file:open("input.txt", []),
    Coll = collect(Fd, []),
    All = lists:usort(lists:flatten([[X, Y]||{X, Y}<-Coll])),
    %% io:format("All: ~p\n", [All]),
    Res = step(-1, [], All, lists:reverse(Coll), []),
    io:format("Res: ~w\n", [Res]).

collect(Fd, Acc) ->
    case file:read_line(Fd) of
        {ok, Line} ->
            A = lists:nth(6, Line),
            B = lists:nth(37, Line),
            collect(Fd, [{A, B}|Acc]);
        eof ->
            Acc
    end.

step(Counter, _Finished, [], _Rules, []) ->
    Counter;
step(Counter, Finished, Left, Rules, Workers0) ->
    %% Filt is the requirement for a step to be chosen
    Workers = tick_workers(Workers0),
    WorkersLeft = workers_not_finished(Workers),
    NewFinished = Finished ++ workers_finished(Workers),
    Filt = fun(Step) ->
                   Reqs = [Req||{Req, Step0} <- Rules, Step0==Step],
                   Done = [lists:member(Req, NewFinished)||Req<-Reqs],
                   not lists:member(false, Done)
           end,
    Candidates = lists:sort(lists:filter(Filt, Left)),
    Grabbed = lists:sublist(Candidates, available_workers(WorkersLeft)),
    NewLeft = Left -- Grabbed,
    %% debug(Workers),
    NewWorkers = WorkersLeft ++ [{G, timeval(G)}||G<-Grabbed],
    step(Counter + 1, NewFinished, NewLeft, Rules, NewWorkers).

debug([]) ->
    io:format("\n");
debug([{C, I}|Rest]) ->
    io:format("(~c, ~B)|", [C, I]),
    debug(Rest).

available_workers(Workers) ->
    workers() - length(workers_not_finished(Workers)).

workers_finished(Workers) ->
    [X||{X, 0}<-Workers].

workers_not_finished(Workers) ->
    [{X, Y}||{X, Y}<-Workers, Y > 0].

tick_workers(Workers) ->
    [{Val, Now-1} || {Val, Now} <- Workers].

timeval(Char) ->
    %% Char - 4.
    Char - 4.
