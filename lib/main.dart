import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'theme/ds_web.dart';
import 'theme/ds_mobile.dart';
import 'screens/search_screen.dart';

enum DesignVersion { web, mobile }

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));
  runApp(const CookieDealApp());
}

class CookieDealApp extends StatefulWidget {
  const CookieDealApp({super.key});

  @override
  State<CookieDealApp> createState() => _CookieDealAppState();
}

class _CookieDealAppState extends State<CookieDealApp> {
  DesignVersion _version = DesignVersion.mobile;

  void _toggleVersion() {
    setState(() {
      _version = _version == DesignVersion.mobile
          ? DesignVersion.web
          : DesignVersion.mobile;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CookieDeal',
      debugShowCheckedModeBanner: false,
      theme: _version == DesignVersion.web ? DsWeb.theme : DsMobile.theme,
      home: MainShell(
        version: _version,
        onToggleVersion: _toggleVersion,
      ),
    );
  }
}

class MainShell extends StatefulWidget {
  final DesignVersion version;
  final VoidCallback onToggleVersion;

  const MainShell({super.key, required this.version, required this.onToggleVersion});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 3; // Default to 기업 탐색
  final _searchKey = GlobalKey<SearchScreenState>();

  Color get _brand => widget.version == DesignVersion.web ? DsWeb.brand : DsMobile.brand;
  Color get _muted => widget.version == DesignVersion.web ? DsWeb.gray500 : DsMobile.slate400;
  Color get _border => widget.version == DesignVersion.web ? DsWeb.gray200 : DsMobile.border;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          const _PlaceholderScreen(label: '홈'),
          const _PlaceholderScreen(label: '내 인맥'),
          const _PlaceholderScreen(label: '라운지'),
          SearchScreen(key: _searchKey),
          _SettingsScreen(
            version: widget.version,
            onToggle: widget.onToggleVersion,
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: _border)),
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 56,
            child: Row(
              children: [
                _NavItem(icon: Icons.home_outlined, label: '홈', isActive: _currentIndex == 0, brand: _brand, muted: _muted, onTap: () => setState(() => _currentIndex = 0)),
                _NavItem(icon: Icons.people_outline, label: '내 인맥', isActive: _currentIndex == 1, brand: _brand, muted: _muted, onTap: () => setState(() => _currentIndex = 1)),
                _NavItem(icon: Icons.monitor_outlined, label: '라운지', isActive: _currentIndex == 2, brand: _brand, muted: _muted, onTap: () => setState(() => _currentIndex = 2)),
                _NavItem(icon: Icons.search, label: '기업 탐색', isActive: _currentIndex == 3, brand: _brand, muted: _muted, onTap: () {
                  if (_currentIndex == 3) {
                    _searchKey.currentState?.toggleMode();
                  } else {
                    setState(() => _currentIndex = 3);
                  }
                }),
                _NavItem(icon: Icons.settings_outlined, label: '설정', isActive: _currentIndex == 4, brand: _brand, muted: _muted, onTap: () => setState(() => _currentIndex = 4)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final Color brand;
  final Color muted;
  final VoidCallback onTap;

  const _NavItem({required this.icon, required this.label, required this.isActive, required this.brand, required this.muted, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 22, color: isActive ? brand : muted),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: isActive ? brand : muted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlaceholderScreen extends StatelessWidget {
  final String label;
  const _PlaceholderScreen({required this.label});

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).textTheme.bodySmall?.color ?? Colors.grey;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('🚧', style: TextStyle(fontSize: 48)),
          const SizedBox(height: 12),
          Text(label, style: TextStyle(fontSize: 16, color: muted)),
          const SizedBox(height: 4),
          Text('준비 중', style: TextStyle(fontSize: 13, color: muted)),
        ],
      ),
    );
  }
}

class _SettingsScreen extends StatelessWidget {
  final DesignVersion version;
  final VoidCallback onToggle;

  const _SettingsScreen({required this.version, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Text('디자인 시스템 비교', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 8),
            Text(
              '두 버전을 전환하며 비교할 수 있습니다.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '현재: ${version == DesignVersion.web ? "Version A (웹 DS)" : "Version B (모바일 DS)"}',
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          version == DesignVersion.web
                              ? 'Neutral gray, 웹 시맨틱 토큰'
                              : 'Slate gray (blue tint), Tailwind 팔레트',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: onToggle,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('전환', style: TextStyle(fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text('차이점', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            _DiffRow(label: 'Gray Scale', a: 'Neutral (#f8f9fa~#212529)', b: 'Slate (#f7f8fa~#111827)'),
            _DiffRow(label: 'Error Red', a: '#DA4343 (muted)', b: '#EF4444 (vivid)'),
            _DiffRow(label: 'Success', a: '#4EC568 (warm green)', b: '#10B981 (emerald)'),
            _DiffRow(label: 'Warning', a: '#E8A43D (dark amber)', b: '#F59E0B (bright amber)'),
            _DiffRow(label: 'Chart Colors', a: 'Pink/Orange/Teal/Blue', b: 'Blue/Amber/Emerald/Purple/Red'),
            _DiffRow(label: 'Typography', a: 'Larger line-height (1.6)', b: 'Tighter, bolder (w800)'),
          ],
        ),
      ),
    );
  }
}

class _DiffRow extends StatelessWidget {
  final String label;
  final String a;
  final String b;
  const _DiffRow({required this.label, required this.a, required this.b});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text('A: $a', style: const TextStyle(fontSize: 11)),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text('B: $b', style: const TextStyle(fontSize: 11)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
