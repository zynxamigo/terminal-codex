# Terminal Codex

**Painel Linux terminal full-screen**  
50% VSCode + 50% Termux = **MIL VEZES melhor** que o Termux original.  
100% focado no terminal. Zero distração.

## O que é

Um terminal web dark as fuck, com:
- Tema VSCode (cores, status bar, tabs de sessão)
- Vibe Termux (comandos rápidos, layout limpo pra digitar)
- xterm.js de verdade
- Histórico de comandos (setas ↑↓)
- Barra de comandos rápidos (botão ⚡)
- Status bar minimalista
- Responsivo pra desktop e mobile

## Como usar

1. Abre o `index.html` no browser (ou sobe em qualquer static host)
2. Digita comandos
3. Clica no ⚡ pra ver os botões rápidos estilo Termux

## Demo local

```bash
# só abre o arquivo
open index.html
# ou
python -m http.server 8080
```

## Próximos passos (se quiser evoluir)

- Plugar WebSocket + backend real (node-pty / xterm.js server)
- Múltiplas sessões de verdade
- Temas custom
- Atalhos configuráveis

---

Feito sem enrolação. Usa e para de reclamar.
