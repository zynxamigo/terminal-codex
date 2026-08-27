# Terminal Codex

**Painel Linux terminal**  
50% VSCode + 50% Termux = **MIL VEZES melhor**.

## Versões

### 1. Mobile (APP Android) — **foco principal agora**
Pasta: `mobile/`  
Projeto Flutter com:
- Terminal real (xterm + flutter_pty)
- Teclado virtual grande estilo Termux
- Quick bar de comandos
- Sidebar de sessões
- Tema dark

**Como gerar o APK:**
```bash
cd mobile
flutter pub get
flutter build apk --release
```

Veja o README dentro de `mobile/` para mais detalhes.

### 2. PC (Node.js)
Versão web com shell real via node-pty + WebSocket.  
Roda com `npm install && npm start` e abre `http://localhost:3000`.

---

O foco atual é o **APP de celular**.  
Ainda tem limitações de PTY no Android puro (o sistema bloqueia bastante). Em emulador ou integrado com Termux funciona melhor.

Qualquer dúvida ou erro na compilação, manda o log.
