-module(send_file_stream).

%% Yaws API
-include("/usr/local/lib/yaws/include/yaws_api.hrl").

%% Define file name
-define(FILE_NAME,"file.name").
-define(FILE_PATH,"/path/to/"++?FILE_NAME).

%% API
-export([out/1,open_file/1,stream_data/1,stream_from_file/2]).

out(Yaws_arguments) ->
	spawn(yaws_stream_file, stream_data, [self()]),
	[
		{header, {"Content-Disposition", "attachment; filename="++?FILE_NAME}},
		{header, {"Content-Length",filelib:file_size(?FILE_PATH)}},
		{streamcontent, "application/octet-stream", <<>>}
	]
.
stream_data(Pid) ->
	FileHDL = open_file(?FILE_PATH),
	stream_from_file(Pid,FileHDL)
.
open_file(File) ->
	{ok,IoDevice} = file:open(File,[read,binary]),
	IoDevice
.
stream_from_file(Pid,File) ->
	Result = file:read(File,4096),
	case Result of
		{ok,Data} ->
			yaws_api:stream_chunk_deliver_blocking(Pid,Data),
			stream_from_file(Pid,File);
		eof ->
			yaws_api:stream_chunk_end(Pid);
		{error,Reason} ->
			error_logger:error_msg("~p:~p Error ~p ~n",[?MODULE,?LINE,Reason])
	end
.