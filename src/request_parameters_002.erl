%% -------------------------------------
%% This example based on official documentattion from http://yaws.hyber.org/
%% -------------------------------------

-module(request_parameters_002).

%% Yaws API
-include("/usr/local/lib/yaws/include/yaws_api.hrl").

%% API
-export([out/1]).

out(Yaws_arguments) ->
	Peer = Yaws_arguments#arg.client_ip_port,
	Req = Yaws_arguments#arg.req,
	H = yaws_api:reformat_header(Yaws_arguments#arg.headers),
	{ehtml,
		[
			{h5,[],"The headers passed to us were:"},
			{hr,[],[]},
			{ol,[],lists:map(fun(S) -> {li,[],{p,[],S}} end,H)},
			{h5,[], "The request"},
			{ul,[],
				[{li,[],yaws_api:f("method: ~s", [Req#http_request.method])},
					{li,[],yaws_api:f("path: ~p", [Req#http_request.path])},
					{li,[],yaws_api:f("version: ~p", [Req#http_request.version])}
				]},
			{hr,[],[]},
			{h5,[],"Other items"},
			{ul,[],
				[{li,[],yaws_api:f("Peer: ~p", [Peer])},
					{li,[],yaws_api:f("docroot: ~s", [Yaws_arguments#arg.docroot])},
					{li,[],yaws_api:f("fullpath: ~s", [Yaws_arguments#arg.fullpath])}]},
			{hr,[],[]},
			{h5,[],"Parsed query data"},
			{pre,[],yaws_api:f("~p",[yaws_api:parse_query(Yaws_arguments)])},
			{hr,[],[]},
			{h5,[],"Parsed POST data "},
			{pre,[],yaws_api:f("~p",[yaws_api:parse_post(Yaws_arguments)])}
		]
	}
.