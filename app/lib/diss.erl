#!/usr/bin/env escript
%% -*- erlang -*-
%% %%! -smp enable -sname factorial -mnesia debug verbose
main(Args)->
    DecodeData = fun(Data) ->
      case unicode:characters_to_list(Data) of
        {incomplete, _, _} -> error;
        {error, _, _} -> error;
        List -> List
      end
    end,

    Readlines = fun(Filename) ->
      case file:read_file(Filename) of
        {ok, Data} -> DecodeData(Data);
        {error, _} -> error
      end
    end,

    GenerateBeamFilename = fun(Filename) ->
      lists:concat([Filename, ".beam"])
    end,

    WriteBeamFile = fun(BeamFilename, BeamCode) ->
      escript:create(BeamFilename, [{beam, BeamCode}])
    end,

    WriteDissFile = fun(BeamFilename) ->
      DissFilename = lists:concat([BeamFilename, ".dmp"]),
      {ok,F}=file:open(DissFilename, [write]),
      io:format(F,"~p.~n",[beam_disasm:file(BeamFilename)]),
      file:close(F),
      DissFilename
    end,

    Diss = fun({ok, Filename, BeamCode}) ->
        BeamFilename = GenerateBeamFilename(Filename),
        WriteBeamFile(BeamFilename, BeamCode),
        DissFilename = WriteDissFile(BeamFilename),
        case Readlines(DissFilename) of
          {ok, Data} -> Data;
          error -> error
        end;
        (error) -> error
    end,

    Run = fun(Filename, Source) ->
      % create source file
      file:write_file(Filename, [Source]),

      % compile erl
      Output = case compile:file(Filename, [binary, debug_info]) of
        % second arg is module name
        {ok, _, BeamCode} -> Diss({ok, Filename, BeamCode});
        error -> Diss(error)
      end,
      io:format("~p~n", [Output])
    end,
    Filename = lists:nth(1, Args),
    Source = lists:nth(2, Args),
    Run(Filename, Source).
