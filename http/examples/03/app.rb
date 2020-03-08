class App
  def call(env)
    request = Rack::Request.new(env)

    case request.path_info
    when "/"
      case request.request_method
      when "GET"
        case request.get_header("HTTP_ACCEPT")
        when "*/*", "text/plain"
          [
            200,
            { "Content-Type" => "text/plain" },
            ["Hello, World\n"]
          ]
        when "text/html"
          [
            200,
            { "Content-Type" => "text/html" },
            ["<html><body>Hello, World</body></html>\n"]
          ]
        else
          [
            406,
            { "Content-Type" => "text/plain" }, # 本来はAcceptヘッダで指定されてる形式でエラーを返すべき
            ["Not acceptable\n"]
          ]
        end
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
