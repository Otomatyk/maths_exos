-module(call_cmd).
-export([callCmd/1]).

callCmd(Cmd) -> os:cmd(Cmd).