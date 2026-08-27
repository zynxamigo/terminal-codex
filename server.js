const express = require('express');
const http = require('http');
const path = require('path');
const os = require('os');
const { WebSocketServer } = require('ws');
const pty = require('node-pty');

const app = express();
const server = http.createServer(app);
const wss = new WebSocketServer({ server });

const PORT = process.env.PORT || 3000;

// Serve frontend
app.use(express.static(path.join(__dirname, 'public')));

// System info endpoint (para o monitor da direita)
app.get('/api/system', (req, res) => {
  const cpus = os.cpus();
  const totalMem = os.totalmem();
  const freeMem = os.freemem();
  const usedMem = totalMem - freeMem;

  res.json({
    hostname: os.hostname(),
    platform: os.platform(),
    arch: os.arch(),
    release: os.release(),
    uptime: os.uptime(),
    cpus: cpus.length,
    cpuModel: cpus[0]?.model || 'unknown',
    totalMem,
    freeMem,
    usedMem,
    loadavg: os.loadavg()
  });
});

// WebSocket para o terminal real
wss.on('connection', (ws) => {
  console.log('[+] Nova conexão de terminal');

  // Shell real
  const shell = process.env.SHELL || (process.platform === 'win32' ? 'powershell.exe' : 'bash');
  const ptyProcess = pty.spawn(shell, [], {
    name: 'xterm-color',
    cols: 80,
    rows: 24,
    cwd: process.env.HOME || process.cwd(),
    env: process.env
  });

  // Saída do shell → cliente
  ptyProcess.onData((data) => {
    if (ws.readyState === ws.OPEN) {
      ws.send(JSON.stringify({ type: 'output', data }));
    }
  });

  // Entrada do cliente → shell
  ws.on('message', (msg) => {
    try {
      const parsed = JSON.parse(msg);
      if (parsed.type === 'input') {
        ptyProcess.write(parsed.data);
      } else if (parsed.type === 'resize') {
        ptyProcess.resize(parsed.cols, parsed.rows);
      }
    } catch (e) {
      // fallback texto puro
      ptyProcess.write(msg.toString());
    }
  });

  ws.on('close', () => {
    console.log('[-] Conexão fechada');
    ptyProcess.kill();
  });

  ptyProcess.onExit(() => {
    if (ws.readyState === ws.OPEN) {
      ws.close();
    }
  });
});

server.listen(PORT, () => {
  console.log(`\n╔══════════════════════════════════════════╗`);
  console.log(`║     TERMINAL CODEX  —  RODANDO           ║`);
  console.log(`║     http://localhost:${PORT}                ║`);
  console.log(`╚══════════════════════════════════════════╝\n`);
});
