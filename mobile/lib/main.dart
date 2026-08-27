import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:xterm/xterm.dart';
import 'package:flutter_pty/flutter_pty.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  runApp(const TerminalCodexApp());
}

class TerminalCodexApp extends StatelessWidget {
  const TerminalCodexApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Terminal Codex',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0D1117),
        primaryColor: const Color(0xFF58A6FF),
        fontFamily: 'monospace',
      ),
      home: const TerminalScreen(),
    );
  }
}

class TerminalScreen extends StatefulWidget {
  const TerminalScreen({super.key});

  @override
  State<TerminalScreen> createState() => _TerminalScreenState();
}

class _TerminalScreenState extends State<TerminalScreen> {
  late final Terminal terminal;
  Pty? pty;
  bool showQuickBar = false;
  bool showSidebar = false;

  @override
  void initState() {
    super.initState();
    terminal = Terminal(maxLines: 10000);

    // Tenta abrir shell real
    try {
      pty = Pty.start(
        'sh', // no Android/Termux costuma ser sh ou bash
        arguments: [],
        environment: {'TERM': 'xterm-256color'},
      );

      pty!.output.cast<List<int>>().listen((data) {
        terminal.write(String.fromCharCodes(data));
      });

      terminal.onOutput = (data) {
        pty?.write(data);
      };

      terminal.onResize = (width, height, pixelWidth, pixelHeight) {
        pty?.resize(height, width);
      };
    } catch (e) {
      terminal.write('\x1b[31mErro ao abrir shell: $e\x1b[0m\r\n');
      terminal.write('No Android puro o PTY é limitado. Rode via Termux ou adicione permissões.\r\n');
    }
  }

  @override
  void dispose() {
    pty?.kill();
    super.dispose();
  }

  void _sendKey(String key) {
    // Mapeamento simples de teclas especiais
    final map = {
      'ESC': '\x1b',
      'CTRL': '', // precisa de estado
      'ALT': '',
      'TAB': '\t',
      'HOME': '\x1b[H',
      'END': '\x1b[F',
      'UP': '\x1b[A',
      'DOWN': '\x1b[B',
      'LEFT': '\x1b[D',
      'RIGHT': '\x1b[C',
    };
    if (map.containsKey(key)) {
      terminal.write(map[key]!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Top bar minimalista
            Container(
              height: 40,
              color: const Color(0xFF161B22),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.menu, size: 20, color: Color(0xFF8B949E)),
                    onPressed: () => setState(() => showSidebar = !showSidebar),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'TERMINAL CODEX',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.flash_on, size: 20, color: Color(0xFF8B949E)),
                    onPressed: () => setState(() => showQuickBar = !showQuickBar),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),

            // Área principal
            Expanded(
              child: Row(
                children: [
                  // Sidebar (abre/fecha)
                  if (showSidebar)
                    Container(
                      width: 200,
                      color: const Color(0xFF161B22),
                      child: ListView(
                        padding: const EdgeInsets.all(12),
                        children: const [
                          Text('SESSIONS', style: TextStyle(fontSize: 11, color: Color(0xFF8B949E))),
                          SizedBox(height: 8),
                          Text('● Local', style: TextStyle(color: Color(0xFF3FB950))),
                          SizedBox(height: 4),
                          Text('○ Kali', style: TextStyle(color: Color(0xFF8B949E))),
                          SizedBox(height: 16),
                          Text('FAVORITES', style: TextStyle(fontSize: 11, color: Color(0xFF8B949E))),
                          SizedBox(height: 8),
                          Text('⭐ .bashrc'),
                          Text('⭐ install.sh'),
                        ],
                      ),
                    ),

                  // Terminal
                  Expanded(
                    child: TerminalView(
                      terminal,
                      textStyle: const TerminalStyle(
                        fontSize: 13,
                        fontFamily: 'monospace',
                      ),
                      theme: TerminalThemes.defaultTheme.copyWith(
                        background: const Color(0xFF0D1117),
                        cursor: const Color(0xFF58A6FF),
                      ),
                      autofocus: true,
                    ),
                  ),
                ],
              ),
            ),

            // Quick bar (comandos rápidos)
            if (showQuickBar)
              Container(
                height: 48,
                color: const Color(0xFF161B22),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  children: [
                    _quickBtn('ls -la'),
                    _quickBtn('cd ~'),
                    _quickBtn('pwd'),
                    _quickBtn('clear'),
                    _quickBtn('uname -a'),
                    _quickBtn('df -h'),
                  ],
                ),
              ),

            // Teclado virtual grande (estilo Termux)
            Container(
              color: const Color(0xFF161B22),
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _keyBtn('ESC'),
                      _keyBtn('CTRL'),
                      _keyBtn('ALT'),
                      _keyBtn('TAB'),
                      _keyBtn('HOME'),
                      _keyBtn('END'),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _keyBtn('UP'),
                      _keyBtn('DOWN'),
                      _keyBtn('LEFT'),
                      _keyBtn('RIGHT'),
                      _keyBtn('-'),
                      _keyBtn('/'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _keyBtn(String label) {
    return GestureDetector(
      onTap: () => _sendKey(label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFF21262D),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: const Color(0xFF30363D)),
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 12, color: Color(0xFFC9D1D9)),
        ),
      ),
    );
  }

  Widget _quickBtn(String cmd) {
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: GestureDetector(
        onTap: () {
          terminal.write('$cmd\n');
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFF21262D),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: const Color(0xFF30363D)),
          ),
          child: Text(cmd, style: const TextStyle(fontSize: 12)),
        ),
      ),
    );
  }
}
