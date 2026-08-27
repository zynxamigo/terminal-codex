# Terminal Codex

**Painel Linux real**  
50% VSCode + 50% Termux = **MIL VEZES melhor**.  
Agora com **shell de verdade** (node-pty + WebSocket).

Não é HTML de mentira. É terminal real.

## Requisitos

- Node.js 18+
- Linux / macOS (Windows funciona mas node-pty é chato)

## Como rodar (PC)

```bash
git clone https://github.com/zynxamigo/terminal-codex.git
cd terminal-codex
npm install
npm start
```

Abre no browser: **http://localhost:3000**

Pronto. Shell real rodando.

## O que tem

- Terminal real (bash/zsh via node-pty)
- Layout estilo da imagem (sidebar + system monitor)
- Teclas virtuais embaixo (ESC, CTRL, setas...)
- Monitor de CPU/RAM ao vivo
- Tema dark VSCode

## Mobile

Por enquanto o layout se adapta (some as sidebars).  
Versão mobile dedicada com teclado grande vem depois.

## Aviso

Isso roda **local**. Não exponha na internet sem autenticação, senão qualquer um toma teu shell.

---

Agora é terminal de verdade, caralho.
