///|
fn main {
  let server = @http.createServer(requestListener=fn(req, res) {
    // リクエストURLの取得  
    let url = req.url
    println("Request received: \{url}")

    // レスポンスヘッダーの設定  
    let _ = res.writeHead(
      200,
      headers=@core.from_entries([("Content-Type", @core.any("text/plain"))]),
    )

    // レスポンスボディの送信  
    res.end(data="Hello from MoonBit on Node.js!")
  })

  // 2. ポート 3000 で待機  
  let port = 3000
  let _ = server.listen(port, callback=fn() {
    println("Server is running at http://localhost:\{port}/")
  })
}
