#!/usr/bin/env escript
%% -*- erlang -*-
%% %%! -smp enable -sname factorial -mnesia debug verbose
main(Args)->
    DeleteFiles = fun(Files) ->
      lists:foreach(fun(File) -> file:delete(File) end, Files)
    end,

    DecodeData = fun(Data) ->
      case unicode:characters_to_list(Data) of
        {incomplete, _, _} -> {error, "Problem decoding"};
        {error, _, _} -> {error, "Problem decoding"};
        List -> {ok, List}
      end
    end,

    Readlines = fun(Filename) ->
      case file:read_file(Filename) of
        {ok, Data} -> DecodeData(Data);
        {error, _} -> {error, "Problem reading file"}
      end
    end,

    WriteBeamFile = fun(BeamFilename, BeamCode) ->
      escript:create(BeamFilename, [{beam, BeamCode}])
    end,

    WriteDissFile = fun(BeamFilename, DissFilename) ->
      {ok,F}=file:open(DissFilename, [write]),
      io:format(F,"~p.~n",[beam_disasm:file(BeamFilename)]),
      file:close(F)
    end,

    Diss = fun({ok, BeamFilename, DissFilename, BeamCode}) ->
        WriteBeamFile(BeamFilename, BeamCode),
        WriteDissFile(BeamFilename, DissFilename),
        case Readlines(DissFilename) of
          {ok, Data} -> {ok, Data};
          {error, Reason} -> {error, Reason}
        end
    end,

    Run = fun(Filename, Source) ->
      % create source file
      file:write_file(Filename, [Source]),
      BeamFilename = lists:concat([Filename, ".beam"]),
      DissFilename = lists:concat([BeamFilename, ".dmp"]),

      % compile erl
      Output = case compile:file(Filename, [binary, debug_info]) of
        % second arg is module name
        {ok, _, BeamCode} -> Diss({ok, BeamFilename, DissFilename, BeamCode});
        error -> {error, "Compilation error"}
      end,

      % cleanup
      DeleteFiles([Filename, BeamFilename, DissFilename]),

      % output
      case Output of
        {_, Result} -> io:format("~p~n", [Result])
      end
    end,
    Filename = lists:nth(1, Args),
    Source = lists:nth(2, Args),
    Run(Filename, Source).
