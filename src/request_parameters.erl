-module(request_parameters).

%% Yaws API
-include("/usr/local/lib/yaws/include/yaws_api.hrl").

%% API
-export([out/1]).


out(Yaws_arguments) ->
	Url = yaws_api:request_url(Yaws_arguments),
	%% Get URL
	Schema = Url#url.scheme,
	Host = Url#url.host,
	Path = Url#url.path,
	Port = Url#url.port,
	Method = (Yaws_arguments#arg.req)#http_request.method,
	Output_params = fun() ->
		case Method of
			'GET' ->
				Params = yaws_api:parse_query(Yaws_arguments),
				[{'div',[],lists:concat(["Key: ",Key," Value: ",Value])}||{Key,Value}<-Params];
			'POST' ->
				Params = yaws_api:parse_post(Yaws_arguments),
				[{'div',[],lists:concat(["Key: ",Key," Value: ",Value])}||{Key,Value}<-Params];
			_ ->
				[{'div',[],"Unrecognisable method"}]
		end
	end,
	[
		{'ehtml',[
			["<!DOCTYPE html> "],
			{'html',[],[
				{'head',[],[
					{'title',[],"Test page"},
					["\n"]
				]},
				{'body',[],[
					{'div',[],lists:concat(["Method: ",Method," Type: atom = ",is_atom(Method)])},
					{'div',[],lists:concat(["Schema: ",Schema," Type: list = ",is_list(Schema)])},
					{'div',[],lists:concat(["Host: ",Host," Type: list = ",is_list(Host)])},
					{'div',[],lists:concat(["Path: ",Path," Type: list = ",is_list(Path)])},
					{'div',[],lists:concat(["Port: ",Port,"Need to define"])},
					Output_params,
					["\n"]
				]}
			]}
		]}
	]
.