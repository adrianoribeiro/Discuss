defmodule Discuss.TopicController do
	use Discuss.Web, :controller

	alias Discuss.Topic

	plug Discuss.Plugs.RequireAuth when action in [:new, :create, :edit, :update, :delete]
	plug :check_topic_owner when action in [:edit, :update, :delete]

	def index(conn, _params) do
		IO.puts("=============================")
		IO.inspect(conn.assigns)
		IO.puts("=============================")

		topics = Repo.all(Topic)
		render conn, "index.html", topics: topics
	end

	def new(conn, _params) do
		changeset = Topic.changeset(%Topic{}, %{})

		render conn, "new.html", changeset: changeset
	end

	# def create(conn, %{"topic" => topic}) do
	def create(conn, params) do
		
		%{"topic" => topic} = params

		# changeset = Topic.changeset(%Topic{}, topic)
		# changeset = conn.assigns.user
		# 	|> build_assoc(:topics)
		# 	|> Topic.changeset(Topic)

		IO.puts("=========== conn.assigns.user ===============")
		IO.inspect(conn.assigns.user)
		IO.puts("=========== build_assoc(:topics) ===============")
		conn.assigns.user |> build_assoc(:topics) |> IO.inspect
		IO.puts("=========== changeset ===============")

		changeset = conn.assigns.user
			|> build_assoc(:topics)
			|> Topic.changeset(topic)
		IO.inspect(changeset)

		case Repo.insert(changeset) do
			{:ok, _topic} -> 
				conn
				|> put_flash(:info, "Topic created")
				|> redirect(to: topic_path(conn, :index) )

			{:error, changeset} -> render conn, "new.html", changeset: changeset
		end
	end

	#%{"id" => "2"}
	def edit(conn, %{"id" => topic_id}) do
		topic = Repo.get(Topic, topic_id)
		changeset = Topic.changeset(topic)

		render conn, "edit.html", changeset: changeset, topic: topic
	end

	def update(conn, %{"id" => topic_id, "topic" => topic}) do

		old_topic = Repo.get(Topic, topic_id) 
		changeset = Topic.changeset(old_topic, topic)

		case Repo.update(changeset) do
			{:ok, _topic} -> 
				conn 
				|>  put_flash(:info, "Topic updated")
				|> redirect(to: topic_path(conn, :index))
			{:error, changeset} ->
				render conn, "edit.html", changeset: changeset, topic: old_topic
		end
	end

	def show(conn, %{"id" => topic_id}) do
		topic = Repo.get!(Topic, topic_id)
		render conn, "show.html", topic: topic
	end

	def delete(conn, %{"id" => topic_id}) do
		Repo.get!(Topic, topic_id) |> Repo.delete!

		conn
		|> put_flash(:info, "Topic deleted")
		|> redirect(to: topic_path(conn, :index))
	end

	def check_topic_owner(conn, _params) do
		%{params: %{"id" => topic_id}} = conn

		if Repo.get(Topic, topic_id).user_id == conn.assigns.user.id do
			conn
		else
			conn
			|> put_flash(:error, "You cannot edit that")
			|> redirect(to: topic_path(conn, :index))
			|> halt()
		end
	end
end 
