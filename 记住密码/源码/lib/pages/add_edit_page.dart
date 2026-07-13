import 'package:flutter/material.dart';
import '../models/account.dart';
import '../database/database_helper.dart';
import '../services/crypto_service.dart';

/// 添加 / 编辑页面
///
/// 包含四个输入框：网站名称、账号、密码、自定义字段（选填）。
/// 保存时自动对密码进行 AES-256-CBC 加密后存入数据库。
/// 编辑模式下自动解密当前密码供用户查看和修改。
class AddEditPage extends StatefulWidget {
  final Account? account; // null 时为添加模式，非 null 为编辑模式

  const AddEditPage({super.key, this.account});

  @override
  State<AddEditPage> createState() => _AddEditPageState();
}

class _AddEditPageState extends State<AddEditPage> {
  final DatabaseHelper _db = DatabaseHelper();
  final CryptoService _crypto = CryptoService();
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _siteNameController;
  late final TextEditingController _usernameController;
  late final TextEditingController _passwordController;
  late final TextEditingController _customFieldsController;

  bool _saving = false;

  bool get _isEditing => widget.account != null;

  @override
  void initState() {
    super.initState();
    _siteNameController = TextEditingController(
      text: widget.account?.siteName ?? '',
    );
    _usernameController = TextEditingController(
      text: widget.account?.username ?? '',
    );
    // 编辑模式下解密当前密码
    _passwordController = TextEditingController(
      text: widget.account != null
          ? _crypto.decrypt(widget.account!.password)
          : '',
    );
    _customFieldsController = TextEditingController(
      text: widget.account?.customFields ?? '',
    );
  }

  @override
  void dispose() {
    _siteNameController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _customFieldsController.dispose();
    super.dispose();
  }

  /// 保存操作（密码加密后存储）
  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _saving = true);

    try {
      final account = Account(
        id: widget.account?.id,
        siteName: _siteNameController.text.trim(),
        username: _usernameController.text.trim(),
        // 存储前加密密码
        password: _crypto.encrypt(_passwordController.text.trim()),
        customFields: _customFieldsController.text.trim().isEmpty
            ? null
            : _customFieldsController.text.trim(),
      );

      if (_isEditing) {
        await _db.update(account);
      } else {
        await _db.insert(account);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_isEditing ? '已更新' : '已添加'),
            duration: const Duration(seconds: 1),
          ),
        );
        Navigator.pop(context, true); // 返回 true 通知主页刷新
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('保存失败: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? '编辑密码' : '添加密码'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        actions: [
          TextButton(
            onPressed: _saving ? null : _save,
            child: _saving
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('保存', style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 网站名称
              TextFormField(
                controller: _siteNameController,
                decoration: InputDecoration(
                  labelText: '网站名称 *',
                  hintText: '例如：谷歌邮箱、GitHub',
                  prefixIcon: const Icon(Icons.language),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return '请输入网站名称';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // 账号
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: '账号 *',
                  hintText: '例如：example@gmail.com',
                  prefixIcon: const Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return '请输入账号';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // 密码
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: '密码 *',
                  hintText: '输入密码（保存时自动加密）',
                  prefixIcon: const Icon(Icons.key),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return '请输入密码';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // 自定义字段
              TextFormField(
                controller: _customFieldsController,
                decoration: InputDecoration(
                  labelText: '自定义字段（选填）',
                  hintText: '例如：密钥: sk-xxx、密保问题: xxx、手机号: 138xxx',
                  prefixIcon: const Icon(Icons.note_add),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                maxLines: 3,
                textInputAction: TextInputAction.done,
              ),
              const SizedBox(height: 24),

              // 保存按钮
              FilledButton.icon(
                onPressed: _saving ? null : _save,
                icon: _saving
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Icon(_isEditing ? Icons.save : Icons.add),
                label: Text(
                  _isEditing ? '保存修改' : '添加密码',
                  style: const TextStyle(fontSize: 16),
                ),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // 说明文字
              Text(
                '🔒 密码将使用 AES-256-CBC 加密后存储，仅在 App 内可查看明文。',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.green[700],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
