defmodule Discuss.Plugs.SetUser do
	import Plug.Conn
	import Phoenix.Controller

	alias Discuss.Repo
	alias Discuss.User

	def init(_params) do
		
	end
	
	def call(conn, _params) do
		user_id = get_session(conn, :user_id)		# came from Phoenix.Controller

		cond do
			user = user_id && Repo.get(User, user_id) -> 

				assign(conn, :user, user)			# came from Plug.Conn
				#conn.assign.user => user.struct
			true -> 
				assign(conn, :user, nil)
		end
	end
end