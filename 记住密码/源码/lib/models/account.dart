/// Account 数据模型
///
/// 表示一条密码记录，包含基本信息与可选的自定义字段。
/// 所有数据以明文形式存储（无加密）。
class Account {
  final int? id;
  final String siteName;   // 网站名称
  final String username;   // 账号
  final String password;   // 密码（明文存储）
  final String? customFields; // 自定义额外字段（JSON字符串），如密钥、备注等

  Account({
    this.id,
    required this.siteName,
    required this.username,
    required this.password,
    this.customFields,
  });

  /// 从数据库 Map 创建 Account
  factory Account.fromMap(Map<String, dynamic> map) {
    return Account(
      id: map['id'] as int?,
      siteName: map['siteName'] as String,
      username: map['username'] as String,
      password: map['password'] as String,
      customFields: map['customFields'] as String?,
    );
  }

  /// 转换为数据库 Map
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'siteName': siteName,
      'username': username,
      'password': password,
      'customFields': customFields,
    };
  }

  /// 复制并修改部分字段
  Account copyWith({
    int? id,
    String? siteName,
    String? username,
    String? password,
    String? customFields,
  }) {
    return Account(
      id: id ?? this.id,
      siteName: siteName ?? this.siteName,
      username: username ?? this.username,
      password: password ?? this.password,
      customFields: customFields ?? this.customFields,
    );
  }

  @override
  String toString() {
    return 'Account(id: $id, siteName: $siteName, username: $username, password: $password, customFields: $customFields)';
  }
}
