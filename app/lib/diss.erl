#!/usr/bin/env escript
%% -*- erlang -*-
%% %%! -smp enable -sname factorial -mnesia debug verbose
main(Args)->
    GenerateBeamFilename = fun(Filename) ->
      lists:concat([Filename, ".beam"])
    end,

    WriteBeamFile = fun(BeamFilename, BeamCode) ->
      escript:create(BeamFilename, [{beam, BeamCode}])
    end,

    WriteDissFile = fun(BeamFilename) ->
      {ok,F}=file:open(BeamFilename++".dmp",[write]),
      io:format(F,"~p.~n",[beam_disasm:file(BeamFilename)]),
      file:close(F)
    end,

    Diss = fun({ok, Filename, BeamCode}) ->
        BeamFilename = GenerateBeamFilename(Filename),
        WriteBeamFile(BeamFilename, BeamCode),
        WriteDissFile(BeamFilename);
        (error) -> io:format("~p~n", ["Error"])
    end,

    Run = fun(Filename, Source) ->
      % create source file
      file:write_file(Filename, [Source]),

      % compile erl
      case compile:file(Filename, [binary, debug_info]) of
        % second arg is module name
        {ok, _, BeamCode} -> Diss({ok, Filename, BeamCode});
        error -> Diss(error)
      end
    end,
    Filename = lists:nth(1, Args),
    Source = lists:nth(2, Args),
    Run(Filename, Source).
