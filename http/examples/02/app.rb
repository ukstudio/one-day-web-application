class App
  def call(env)
    request = Rack::Request.new(env)

    case request.path_info
    when "/"
      case request.request_method
      when "GET"
        [
          200,
          { "Content-Type" => "text/plain" },
          ["Hello, World\n"]
        ]
      when "POST"
        [
          201,
          { "Content-Type" => "text/plain" },
          ["Resource was successfully created.\n"]
        ]
      else
        [
          405,
          { "Content-Type" => "text/plain" },
          ["Method not allowed.\n"]
        ]
      end
    else
      [
        404,
        { "Content-Type" => "text/plain" },
        ["This page does not exist\n"]
      ]
    end
  end
end
