///|
fn parse_path(url : String) -> String {
  let mut path = ""
  for i = 0; i < url.length(); i = i + 1 {
    if url[i] == '?' {
      break
    }
    path = path + url[i].to_string()
  }
  path
}

///|
fn parse_query(url : String) -> Map[String, String] {
  let params : Map[String, String] = {}
  let mut query_start = -1
  for i = 0; i < url.length(); i = i + 1 {
    if url[i] == '?' {
      query_start = i + 1
      break
    }
  }
  if query_start == -1 {
    return params
  }
  let mut query = ""
  for i = query_start; i < url.length(); i = i + 1 {
    query = query + url[i].to_string()
  }
  let pairs = query.split("&")
  for pair in pairs {
    let kv = pair.split("=")
    let arr = kv.collect()
    if arr.length() == 2 {
      params[arr[0].to_string()] = arr[1].to_string()
    }
  }
  params
}

///|
fn build_json_object(entries : Array[(String, String)]) -> String {
  let mut result = "{"
  for i, entry in entries {
    let key = entry.0
    let value = entry.1
    if i > 0 {
      result = result + ","
    }
    result = result + "\"\{key}\":\"\{value}\""
  }
  result = result + "}"
  result
}

///|
fn handle_request(
  req : @http.IncomingMessage,
  res : @http.ServerResponse
) -> Unit {
  let url = req.url.unwrap_or("/")
  let path = parse_path(url)
  let req_method = req.method_().unwrap_or("GET")
  println("\{req_method} \{url}")
  match path {
    "/health" => {
      let _ = res.writeHead(
        200,
        headers=@core.from_entries(
          [("Content-Type", @core.any("application/json"))],
        ),
      )
      res.end(data="{\"status\":\"ok\"}")
    }
    "/echo" => {
      let params = parse_query(url)
      let message = params.get("message").or("").to_string()
      let _ = res.writeHead(
        200,
        headers=@core.from_entries(
          [("Content-Type", @core.any("text/plain"))],
        ),
      )
      res.end(data=message)
    }
    "/info" => {
      let json = build_json_object(
        [("server", "MoonBit"), ("version", "0.1.0"), ("runtime", "node")],
      )
      let _ = res.writeHead(
        200,
        headers=@core.from_entries(
          [("Content-Type", @core.any("application/json"))],
        ),
      )
      res.end(data=json)
    }
    "/greet" => {
      let params = parse_query(url)
      let name = params.get("name").or("world").to_string()
      let greeting = "Hello, " + name + "!"
      let _ = res.writeHead(
        200,
        headers=@core.from_entries(
          [("Content-Type", @core.any("text/plain; charset=utf-8"))],
        ),
      )
      res.end(data=greeting)
    }
    "/" => {
      let _ = res.writeHead(
        200,
        headers=@core.from_entries(
          [("Content-Type", @core.any("text/plain"))],
        ),
      )
      res.end(data="Hello from MoonBit on Node.js!")
    }
    _ => {
      let _ = res.writeHead(
        404,
        headers=@core.from_entries(
          [("Content-Type", @core.any("text/plain"))],
        ),
      )
      res.end(data="Not Found")
    }
  }
}

///|
fn main {
  let server = @http.createServer(requestListener=handle_request)
  let port = 3000
  let _ = server.listen(port, callback=fn() {
    println("Server is running at http://localhost:\{port}/")
  })
}
