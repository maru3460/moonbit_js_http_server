const http = require('http');

// 1. サーバーを作成
const server = http.createServer((req, res) => {
  // リクエストURLをコンソールに表示
  console.log(`Request received: ${req.url}`);

  // 2. レスポンスヘッダー（ステータス200, コンテンツタイプ）を設定
  res.writeHead(200, { 'Content-Type': 'text/plain; charset=utf-8' });

  // 3. レスポンスボディを送信して終了
  res.end('Hello from Node.js! 🚀');
});

// 4. ポート3000でサーバーを起動
const PORT = 3000;
server.listen(PORT, () => {
  console.log(`Server is running at http://localhost:${PORT}/`);
});
