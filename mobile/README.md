# Terminal Codex — Versão Celular (Flutter)

App Android focado em terminal, estilo Termux + VSCode.

## O que tem

- Terminal com xterm + flutter_pty
- Teclado virtual grande (ESC, CTRL, setas...)
- Quick bar de comandos
- Sidebar de sessões (abre pelo menu)
- Tema dark estilo GitHub/VSCode
- Tela imersiva

## Como gerar o APK

1. Instala o Flutter: https://docs.flutter.dev/get-started/install
2. Clona o repo e entra na pasta mobile:

```bash
cd terminal-codex/mobile
flutter pub get
flutter build apk --release
```

O APK sai em: `build/app/outputs/flutter-apk/app-release.apk`

## Aviso importante sobre shell real no Android

No Android puro o PTY é bem limitado por permissões de segurança.  
Para ter shell **de verdade** (como o Termux), o ideal é:

- Rodar o app com permissões especiais, ou
- Integrar com Termux, ou
- Usar um backend local (mais complexo).

Por enquanto o app abre o shell que o sistema permitir. Em emulador ou com Termux por baixo funciona melhor.

---

Próximos passos: melhorar o teclado, adicionar múltiplas sessões e system monitor.
