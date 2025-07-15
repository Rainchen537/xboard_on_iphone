import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // 模拟设置数据
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;
  String _language = '中文';
  String _apiEndpoint = 'https://api.xboard.example.com';
  String _apiKey = 'sk_live_***********************';
  
  // 模拟用户数据
  final Map<String, dynamic> _userData = {
    'name': '管理员',
    'email': 'admin@example.com',
    'role': '超级管理员',
    'lastLogin': '2024-07-15 10:30',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 头部
              _buildHeader(context),
              const SizedBox(height: 32),

              // 用户信息卡片
              _buildUserProfileCard(),
              const SizedBox(height: 32),

              // 应用设置
              _buildSectionHeader('应用设置'),
              _buildSettingsGroup([
                _buildSettingCard(
                  title: '通知',
                  subtitle: '接收应用内通知和邮件提醒',
                  icon: Icons.notifications_outlined,
                  trailing: Switch(
                    value: _notificationsEnabled,
                    activeColor: const Color(0xFF5E6AD2),
                    onChanged: (value) {
                      setState(() {
                        _notificationsEnabled = value;
                      });
                    },
                  ),
                ),
                _buildSettingCard(
                  title: '深色模式',
                  subtitle: '切换应用的显示主题',
                  icon: Icons.dark_mode_outlined,
                  trailing: Switch(
                    value: _darkModeEnabled,
                    activeColor: const Color(0xFF5E6AD2),
                    onChanged: (value) {
                      setState(() {
                        _darkModeEnabled = value;
                      });
                      // TODO: 实现深色模式切换
                    },
                  ),
                ),
                _buildSettingCard(
                  title: '语言',
                  subtitle: '选择应用显示语言',
                  icon: Icons.language_outlined,
                  trailing: DropdownButton<String>(
                    value: _language,
                    underline: Container(),
                    style: const TextStyle(
                      color: Color(0xFF374151),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    items: const [
                      DropdownMenuItem(value: '中文', child: Text('中文')),
                      DropdownMenuItem(value: 'English', child: Text('English')),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _language = value;
                        });
                      }
                    },
                  ),
                ),
              ]),

              const SizedBox(height: 32),

              // API设置
              _buildSectionHeader('API设置'),
              _buildSettingsGroup([
                _buildSettingCard(
                  title: 'API端点',
                  subtitle: _apiEndpoint,
                  icon: Icons.api_outlined,
                  trailing: IconButton(
                    icon: const Icon(Icons.edit_outlined, color: Color(0xFF6B7280)),
                    onPressed: () {
                      _showEditApiEndpointDialog();
                    },
                  ),
                ),
                _buildSettingCard(
                  title: 'API密钥',
                  subtitle: _apiKey,
                  icon: Icons.key_outlined,
                  trailing: IconButton(
                    icon: const Icon(Icons.edit_outlined, color: Color(0xFF6B7280)),
                    onPressed: () {
                      _showEditApiKeyDialog();
                    },
                  ),
                ),
              ]),

              const SizedBox(height: 32),

              // 系统设置
              _buildSectionHeader('系统设置'),
              _buildSettingsGroup([
                _buildSettingCard(
                  title: '清除缓存',
                  subtitle: '清除应用缓存数据',
                  icon: Icons.cleaning_services_outlined,
                  trailing: IconButton(
                    icon: const Icon(Icons.chevron_right, color: Color(0xFF6B7280)),
                    onPressed: () {
                      _showClearCacheDialog();
                    },
                  ),
                ),
                _buildSettingCard(
                  title: '备份数据',
                  subtitle: '备份应用数据到云端',
                  icon: Icons.backup_outlined,
                  trailing: IconButton(
                    icon: const Icon(Icons.chevron_right, color: Color(0xFF6B7280)),
                    onPressed: () {
                      _showBackupDialog();
                    },
                  ),
                ),
                _buildSettingCard(
                  title: '恢复数据',
                  subtitle: '从云端恢复应用数据',
                  icon: Icons.restore_outlined,
                  trailing: IconButton(
                    icon: const Icon(Icons.chevron_right, color: Color(0xFF6B7280)),
                    onPressed: () {
                      _showRestoreDialog();
                    },
                  ),
                ),
              ]),

              const SizedBox(height: 32),

              // 关于
              _buildSectionHeader('关于'),
              _buildSettingsGroup([
                _buildSettingCard(
                  title: '应用版本',
                  subtitle: 'v1.0.0',
                  icon: Icons.info_outlined,
                  trailing: IconButton(
                    icon: const Icon(Icons.chevron_right, color: Color(0xFF6B7280)),
                    onPressed: () {
                      _showAboutDialog();
                    },
                  ),
                ),
                _buildSettingCard(
                  title: '检查更新',
                  subtitle: '检查应用是否有新版本',
                  icon: Icons.update_outlined,
                  trailing: IconButton(
                    icon: const Icon(Icons.chevron_right, color: Color(0xFF6B7280)),
                    onPressed: () {
                      _checkForUpdates();
                    },
                  ),
                ),
              ]),

              const SizedBox(height: 32),

              // 退出登录按钮
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFFEF4444),
                    width: 1,
                  ),
                ),
                child: TextButton.icon(
                  icon: const Icon(Icons.logout_outlined, color: Color(0xFFEF4444)),
                  label: const Text(
                    '退出登录',
                    style: TextStyle(
                      color: Color(0xFFEF4444),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: () {
                    _showLogoutDialog();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '设置',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        const SizedBox(height: 4),
        Text(
          '管理应用偏好和账户设置',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: const Color(0xFF6B7280),
          ),
        ),
      ],
    );
  }

  Widget _buildUserProfileCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE5E7EB),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFF5E6AD2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(
                _userData['name'][0],
                style: const TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _userData['name'],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1F2937),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _userData['email'],
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF6B7280),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF5E6AD2).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        _userData['role'],
                        style: const TextStyle(
                          color: Color(0xFF5E6AD2),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '上次登录: ${_userData['lastLogin']}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF9CA3AF),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: Color(0xFF6B7280)),
            onPressed: () {
              _showEditProfileDialog();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Color(0xFF1F2937),
        ),
      ),
    );
  }

  Widget _buildSettingsGroup(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE5E7EB),
          width: 1,
        ),
      ),
      child: Column(
        children: children.asMap().entries.map((entry) {
          final index = entry.key;
          final child = entry.value;
          return Column(
            children: [
              child,
              if (index < children.length - 1)
                const Divider(
                  height: 1,
                  color: Color(0xFFE5E7EB),
                  indent: 16,
                  endIndent: 16,
                ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSettingCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Widget trailing,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF5E6AD2).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF5E6AD2),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF1F2937),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
          trailing,
        ],
      ),
    );
  }

  void _showEditProfileDialog() {
    // TODO: 实现编辑个人资料对话框
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('编辑个人资料功能待实现')),
    );
  }

  void _showEditApiEndpointDialog() {
    // TODO: 实现编辑API端点对话框
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('编辑API端点功能待实现')),
    );
  }

  void _showEditApiKeyDialog() {
    // TODO: 实现编辑API密钥对话框
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('编辑API密钥功能待实现')),
    );
  }

  void _showClearCacheDialog() {
    // TODO: 实现清除缓存对话框
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('清除缓存功能待实现')),
    );
  }

  void _showBackupDialog() {
    // TODO: 实现备份数据对话框
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('备份数据功能待实现')),
    );
  }

  void _showRestoreDialog() {
    // TODO: 实现恢复数据对话框
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('恢复数据功能待实现')),
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('关于应用'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Xboard管理器'),
            Text('版本: v1.0.0'),
            SizedBox(height: 8),
            Text('这是一个用于管理Xboard面板的移动应用。'),
            SizedBox(height: 8),
            Text('© 2024 雨晨. 保留所有权利。'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('关闭'),
          ),
        ],
      ),
    );
  }

  void _checkForUpdates() {
    // TODO: 实现检查更新功能
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('当前已是最新版本')),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('退出登录'),
        content: const Text('确定要退出登录吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: 实现退出登录功能
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('退出登录功能待实现')),
              );
            },
            child: const Text('确定'),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}
