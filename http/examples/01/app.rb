class App
  def call(env)
    request = Rack::Request.new(env)

    case request.path_info
    when "/"
      [
        200, # status code
        { "Content-Type" => "text/plain" }, # header
        ["Hello, World\n"] # body
      ]
    else
      [
        404,
        { "Content-Type" => "text/plain" },
        ["This page does not exist\n"]
      ]
    end
  end
end
