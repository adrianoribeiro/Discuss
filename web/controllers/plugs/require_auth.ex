defmodule Discuss.Plugs.RequireAuth do
	import Plug.Conn
	import Phoenix.Controller

	alias Discuss.Router.Helpers 	#Need to use topic_path
	
	def init(_params) do
	end

	def call(conn, _params) do
		if conn.assigns[:user] do
			conn
		else
			conn
			|> put_flash(:error, "You must be logged in.")		#Phoenix.Controller
			|> redirect(to: Helpers.topic_path(conn, :index))	#Phoenix.Controller
			|> halt()											#Plug.conn
		end
	end

end