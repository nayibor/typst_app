defmodule TypstAppWeb.PageController do
  use TypstAppWeb, :controller
  alias TypstApp.Blog
  
  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    render(conn, :home, layout: false)
  end

  def process_blog(conn,%{"id" => id,"type" => type}) do
    data = Blog.get_post!(id)
    jason_map = %{"id" => data.id,"title" => data.title, "body" => data.body}
    {:ok,blog_data} = Jason.encode(jason_map) 
    disposition = 
      case type do
	"view" -> :inline
	"download" -> :attachment
      end
    filename = "Blog #{id}"
    path_typst = Path.join([:code.priv_dir(:typst_app),"/typst/typst"] )    
    path_test_template = Path.join([:code.priv_dir(:typst_app),"/typst/main.typ"] )
    path_template = "blog.typ"
    command = "#{path_typst} compile  --input 'blogJson=#{blog_data}' --input 'templatePath=#{path_template}' -f pdf #{path_test_template} -"
    {result,code_result} = System.cmd("sh",["-c",command])
    case code_result do
      0 -> send_download(conn,{:binary,result},content_type: "application/pdf",disposition: disposition,filename: filename )
      _ -> text(conn,"error generating pdf")
    end
    
  end
end
