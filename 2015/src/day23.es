#!/home/krisallb/Documents/stash/annan/otp/installed/bin/escript

main(_) ->
    {ok, Fd} = file:open("input.txt", []),
    Collected = lists:reverse(collect(Fd, [])),
    VMResult = vm(1, 0, 1, Collected),
    io:format("vm result: ~p~n", [VMResult]).

collect(Fd, Acc) ->
    case file:read_line(Fd) of
        {ok, Line} ->
            Parsed = parse(string:trim(Line)),
            collect(Fd, [Parsed|Acc]);
        eof ->
            Acc
    end.

parse([$t,$p,$l,_Space,Register]) ->
    {tpl, parse_register(Register)};
parse([$i,$n,$c,_Space,Register]) ->
    {inc, parse_register(Register)};
parse([$j,$m,$p,_Space|Value]) ->
    {jmp, parse_val(Value)};
parse([$h,$l,$f,_Space,Register]) ->
    {hlf, parse_register(Register)};
parse([$j,$i,$e,_Space,Register,$,,_Space2|Val]) ->
    {jie, parse_register(Register), parse_val(Val)};
parse([$j,$i,$o,_Space,Register,$,,_Space2|Val]) ->
    {jio, parse_register(Register), parse_val(Val)}.

parse_register($a) ->
    a;
parse_register($b) ->
    b.

parse_val([$+|Val]) ->
    list_to_integer(Val);
parse_val(Val) ->
    list_to_integer(Val).

%% IP = instruction pointer
vm(A, B, IP, Program) when IP > length(Program)->
    {A, B};
vm(A, B, IP, Program) ->
    CurInstruction = lists:nth(IP, Program),
    case CurInstruction of
        {inc, a} ->
            vm(A+1, B, IP+1, Program);
        {inc, b} ->
            vm(A, B+1, IP+1, Program);
        {hlf, a} ->
            vm(A div 2, B, IP+1, Program);
        {hlf, b} ->
            vm(A, B div 2, IP+1, Program);
        {tpl, a} ->
            vm(A*3, B, IP+1, Program);
        {tpl, b} ->
            vm(A, B*3, IP+1, Program);
        {jmp, Offset} ->
            vm(A, B, IP+Offset, Program);
        {jie, a, Offset} when A rem 2 == 0 ->
            vm(A, B, IP+Offset, Program);
        {jie, b, Offset} when B rem 2 == 0 ->
            vm(A, B, IP+Offset, Program);
        {jio, a, Offset} when A == 1 ->
            vm(A, B, IP+Offset, Program);
        {jio, b, Offset} when B == 1 ->
            vm(A, B, IP+Offset, Program);
        _ ->
            vm(A, B, IP+1, Program)
    end.
