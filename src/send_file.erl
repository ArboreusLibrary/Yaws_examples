-module(send_file).

%% Yaws API
%% Set the correct path to yaws_api.hrl
-include("/usr/local/lib/yaws/include/yaws_api.hrl").

%% API
-export([out/1]).

%% Define path to file and the file MIME type for example
-define(FILE_PATH,"/path/to/file").
-define(MIME_TYPE,"mime/type").

out(Yaws_argument) ->
	{ok,Output}=file:read_file(?FILE_PATH),
	[
		{'allheaders',[
			{'header', {'content_type', ?MIME_TYPE}}
		]},
		{'ehtml',[
			Output
		]}
	]
.