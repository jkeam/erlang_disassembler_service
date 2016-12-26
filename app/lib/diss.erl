#!/usr/bin/env escript
%% -*- erlang -*-
%% %%! -smp enable -sname factorial -mnesia debug verbose
main(Args)->
    % Pretend source
    % Source = "%% Demo\nmain(_Args) ->\n    io:format(erlang:system_info(smp_support)).\n",

    Diss = fun(Filename, Source) ->
      % create source file
      file:write_file(Filename, ["%% ", Filename, "\n-module(jon).\n-export([main/1]).\n\n", Source]),

      % compile erl
      {ok, _, BeamCode} = compile:file(Filename, [binary, debug_info]),

      % create beam file
      BeamFile = lists:concat([Filename, ".beam"]),
      escript:create(BeamFile, [{beam, BeamCode}]),

      % create diss file
      {ok,F}=file:open(BeamFile++".dmp",[write]),
      io:format(F,"~p.~n",[beam_disasm:file(BeamFile)]),
      file:close(F)
    end,
    % lists:foreach(fun(Arg) -> io:format("~p~n", [Arg]) end, Args).
    Filename = lists:nth(1, Args),
    Source = lists:nth(2, Args),
    io:format("~p~n", [Filename]),
    io:format("~p~n", [Source]),
    Diss(Filename, Source).

%./diss doc.erl "%% Demo
% main(_Args) ->
  % io:format(erlang:system_info(smp_support))."
