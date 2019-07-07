class Home::Index < ApiAction
  get "/" do
    head 200
  end
end

class User::Show < ApiAction
  get "/user/:id" do
    raise Lucky::RouteNotFoundError.new(context) unless /\d+/.match(id)
    render_text id
  end
end

class User::Create < ApiAction
  post "/user" do
    head 200
  end
end
