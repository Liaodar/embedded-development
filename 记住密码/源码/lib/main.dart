import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'services/crypto_service.dart';

/// 「奶龙的密码」应用入口
///
/// 启动后直接进入主页面，无需任何验证、无主密码、无登录界面。
/// 完全离线运行，密码以 AES-256-CBC 加密存储在本地 SQLite 数据库中。
/// 在 App 内可随时查看已解密的密码。
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // 初始化加密服务
  CryptoService().init();
  runApp(const NailongPasswordApp());
}

class NailongPasswordApp extends StatelessWidget {
  const NailongPasswordApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '奶龙的密码',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.indigo,
        useMaterial3: true,
        brightness: Brightness.light,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 1,
        ),
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      // 直接进入主页面，无任何验证
      home: const HomePage(),
    );
  }
}
