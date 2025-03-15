defmodule TypstAppWeb.PostLive.Index do
  use TypstAppWeb, :live_view

  alias TypstApp.Blog
  alias TypstApp.Blog.Post
  alias TypstApp.Utils

  @impl true
  def mount(_params, _session, socket) do
    posts = Blog.list_posts()
    {:ok,
     socket
    |> assign(:page_data,Utils.paginate(1,length(posts)))
    |> stream(:posts, posts)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Post")
    |> assign(:post, Blog.get_post!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Post")
    |> assign(:post, %Post{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Posts")
    |> assign(:form, %{})
    |> assign(:post, nil)
  end

  defp apply_action(socket, :preview, %{"id" => id}) do
    socket
    |> assign(:page_title, "Preview Post Pdf")
    |> assign(:post, Blog.get_post!(id))
  end

  
  @impl true
  def handle_info({TypstAppWeb.PostLive.FormComponent, {:saved, _post}}, socket) do
    posts = Blog.list_posts()
    {:noreply,
     socket
     |> assign(:page_data,Utils.paginate(1,length(posts)))
     |> stream(:posts, posts,reset: true)     
    }
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    post = Blog.get_post!(id)
    {:ok, _} = Blog.delete_post(post)
    posts = Blog.list_posts()    
    {:noreply,
     socket
     |> assign(:page_data,Utils.paginate(1,length(posts)))
     |> stream(:posts, posts,reset: true)     
    }
  end

  @impl true
  def handle_event("paginate", %{"page" => page} = _params, socket) do
    offset = Utils.get_offset(page)
    posts = Blog.list_posts(%{offset: offset,limit: Utils.get_page_size()})
    {:noreply,
     socket
    |> assign(:page_data,Utils.paginate(page,length(posts)))     
    |> stream(:posts,posts,reset: true)}
  end

  @impl true
  def handle_event("search", params, socket) do
    IO.inspect(params)
    {:noreply,socket}
  end
  
end
