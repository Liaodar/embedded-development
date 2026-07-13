import 'package:flutter/material.dart';
import '../models/account.dart';
import '../database/database_helper.dart';
import '../services/crypto_service.dart';
import 'add_edit_page.dart';
import 'detail_page.dart';

/// 主页面 —— 卡片列表仅显示网站名称
///
/// 功能：
/// - 顶部搜索栏
/// - 卡片列表：每张卡片只显示网站名称（账号密码隐藏在详情页）
/// - 点击卡片进入详情页（只读查看）
/// - 每张卡片末尾有编辑和删除图标
/// - 底部「添加」按钮
/// - 下拉刷新
/// - 无需任何验证，启动即显示
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DatabaseHelper _db = DatabaseHelper();
  final CryptoService _crypto = CryptoService();
  List<Account> _accounts = [];
  bool _loading = true;
  String _searchKeyword = '';

  @override
  void initState() {
    super.initState();
    _loadAccounts();
  }

  /// 加载账号列表（自动解密密码）
  Future<void> _loadAccounts() async {
    setState(() => _loading = true);
    try {
      List<Account> accounts;
      if (_searchKeyword.isEmpty) {
        accounts = await _db.getAll();
      } else {
        accounts = await _db.search(_searchKeyword);
      }
      // 解密密码字段，以便在 App 内显示
      accounts = accounts.map((a) {
        return a.copyWith(password: _crypto.decrypt(a.password));
      }).toList();
      setState(() {
        _accounts = accounts;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('加载失败: $e')),
        );
      }
    }
  }

  /// 跳转详情页（只读查看）
  Future<void> _navigateToDetail(Account account) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => DetailPage(account: account)),
    );
  }

  /// 跳转添加页面
  Future<void> _navigateToAdd() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddEditPage()),
    );
    if (result == true) _loadAccounts();
  }

  /// 跳转编辑页面
  Future<void> _navigateToEdit(Account account) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AddEditPage(account: account)),
    );
    if (result == true) _loadAccounts();
  }

  /// 删除确认弹窗
  Future<void> _confirmDelete(Account account) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('确认删除'),
        content: Text('确定要删除「${account.siteName}」吗？\n此操作不可撤销。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('删除'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _db.delete(account.id!);
      _loadAccounts();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('已删除「${account.siteName}」')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('奶龙的密码'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: Column(
        children: [
          // 搜索栏
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: '搜索网站名称...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchKeyword.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() => _searchKeyword = '');
                          _loadAccounts();
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              onChanged: (value) {
                setState(() => _searchKeyword = value);
                _loadAccounts();
              },
            ),
          ),

          // 列表内容
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _accounts.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.lock_outline,
                                size: 64, color: Colors.grey[400]),
                            const SizedBox(height: 16),
                            Text(
                              _searchKeyword.isEmpty
                                  ? '还没有保存任何密码\n点击下方按钮添加'
                                  : '没有找到匹配的记录',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: _loadAccounts,
                        child: ListView.builder(
                          padding: const EdgeInsets.only(
                            left: 12,
                            right: 12,
                            bottom: 80,
                          ),
                          itemCount: _accounts.length,
                          itemBuilder: (context, index) {
                            return _buildAccountCard(_accounts[index]);
                          },
                        ),
                      ),
          ),
        ],
      ),
      // 底部添加按钮
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _navigateToAdd,
        icon: const Icon(Icons.add),
        label: const Text('添加'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  /// 构建单张卡片 —— 仅显示网站名称
  Widget _buildAccountCard(Account account) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        // 点击卡片进入详情页（只读）
        onTap: () => _navigateToDetail(account),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              // 左侧图标
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.language,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(width: 14),

              // 中间：网站名称（仅此一项）
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      account.siteName,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '点击查看详情',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),

              // 右侧操作图标
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 编辑按钮
                  IconButton(
                    icon: const Icon(Icons.edit, size: 20, color: Colors.orange),
                    tooltip: '编辑',
                    onPressed: () => _navigateToEdit(account),
                  ),
                  // 删除按钮
                  IconButton(
                    icon: const Icon(Icons.delete, size: 20, color: Colors.red),
                    tooltip: '删除',
                    onPressed: () => _confirmDelete(account),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
