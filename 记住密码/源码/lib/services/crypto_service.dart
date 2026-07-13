import 'dart:convert';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart' as enc;

/// 加密服务 —— 对密码进行 AES-256-CBC 加密存储
///
/// 原理：
/// - 使用 AES-256-CBC 算法加密密码字段
/// - 密钥由固定的应用口令派生（SHA-256 → 32字节）
/// - 每次加密使用随机 IV，IV 拼在密文前面（base64:base64 格式）
/// - 数据库中存储的是加密后的密文，在 App 内显示时自动解密
///
/// ⚠️ 说明：由于无主密码设计，密钥派生自固定口令，安全性有限。
///   但已满足"数据库不存明文、App内可查看"的需求。
class CryptoService {
  static final CryptoService _instance = CryptoService._internal();
  factory CryptoService() => _instance;
  CryptoService._internal();

  // ⚠️ 安全提醒：请修改为只有你自己知道的密钥！
  // 建议使用大小写字母 + 数字 + 特殊符号，长度至少 16 位
  // 修改后重新构建 APK 即可生效
  static const String _passphrase = 'your-secret-passphrase-change-me-please';

  late final enc.Key _key;

  bool _initialized = false;

  /// 初始化加密服务（需在主函数中调用一次）
  void init() {
    if (_initialized) return;
    // SHA-256 派生 32 字节 AES-256 密钥
    final keyBytes = Uint8List.fromList(
      sha256.convert(utf8.encode(_passphrase)).bytes,
    );
    _key = enc.Key(keyBytes);
    _initialized = true;
  }

  /// 加密明文密码
  ///
  /// 返回格式：`iv_base64:ciphertext_base64`
  String encrypt(String plaintext) {
    _ensureInit();
    final iv = enc.IV.fromSecureRandom(16); // 每次随机 IV
    final encrypter = enc.Encrypter(enc.AES(_key));
    final encrypted = encrypter.encrypt(plaintext, iv: iv);
    return '${iv.base64}:${encrypted.base64}';
  }

  /// 解密密文密码
  ///
  /// 输入格式：`iv_base64:ciphertext_base64`
  /// 如果输入不包含冒号则原样返回（兼容旧明文数据）
  String decrypt(String ciphertext) {
    _ensureInit();
    final parts = ciphertext.split(':');
    if (parts.length != 2) {
      // 非加密格式，可能是旧明文数据，原样返回
      return ciphertext;
    }
    try {
      final iv = enc.IV.fromBase64(parts[0]);
      final encrypter = enc.Encrypter(enc.AES(_key));
      return encrypter.decrypt64(parts[1], iv: iv);
    } catch (_) {
      // 解密失败时返回原始字符串
      return ciphertext;
    }
  }

  void _ensureInit() {
    if (!_initialized) init();
  }
}
