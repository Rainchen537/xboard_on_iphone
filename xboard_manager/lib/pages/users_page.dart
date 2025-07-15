import 'package:flutter/material.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // 模拟用户数据
  final List<Map<String, dynamic>> _users = [
    {
      'id': 1,
      'email': 'user1@example.com',
      'username': '用户001',
      'status': 'active',
      'plan': 'VIP',
      'expiry': '2024-12-31',
      'traffic': '50GB/100GB',
    },
    {
      'id': 2,
      'email': 'user2@example.com',
      'username': '用户002',
      'status': 'inactive',
      'plan': '基础版',
      'expiry': '2024-08-15',
      'traffic': '10GB/20GB',
    },
    {
      'id': 3,
      'email': 'user3@example.com',
      'username': '用户003',
      'status': 'active',
      'plan': '专业版',
      'expiry': '2024-11-20',
      'traffic': '80GB/200GB',
    },
    {
      'id': 4,
      'email': 'user4@example.com',
      'username': '用户004',
      'status': 'suspended',
      'plan': 'VIP',
      'expiry': '2024-09-10',
      'traffic': '0GB/100GB',
    },
  ];

  List<Map<String, dynamic>> get _filteredUsers {
    if (_searchQuery.isEmpty) {
      return _users;
    }
    return _users.where((user) {
      return user['email'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
          user['username'].toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: Column(
          children: [
            // 头部
            _buildHeader(context),

            // 搜索栏
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFFE5E7EB),
                    width: 1,
                  ),
                ),
                child: TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: '搜索用户...',
                    prefixIcon: Icon(Icons.search, color: Color(0xFF6B7280)),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(16),
                    hintStyle: TextStyle(color: Color(0xFF9CA3AF)),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
              ),
            ),

            // 统计信息
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                children: [
                  Expanded(
                    child: _buildStatChip('总用户', '${_users.length}', const Color(0xFF5E6AD2)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatChip(
                      '活跃用户',
                      '${_users.where((u) => u['status'] == 'active').length}',
                      const Color(0xFF10B981),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatChip(
                      '暂停用户',
                      '${_users.where((u) => u['status'] == 'suspended').length}',
                      const Color(0xFFF59E0B),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 用户列表
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                itemCount: _filteredUsers.length,
                itemBuilder: (context, index) {
                  final user = _filteredUsers[index];
                  return _buildUserCard(user);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '用户管理',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const SizedBox(height: 4),
                Text(
                  '管理所有用户账户',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: const Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF5E6AD2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Icons.add, color: Colors.white),
              onPressed: () {
                _showAddUserDialog();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatChip(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE5E7EB),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserCard(Map<String, dynamic> user) {
    Color statusColor;
    String statusText;

    switch (user['status']) {
      case 'active':
        statusColor = const Color(0xFF10B981);
        statusText = '活跃';
        break;
      case 'inactive':
        statusColor = const Color(0xFF6B7280);
        statusText = '未激活';
        break;
      case 'suspended':
        statusColor = const Color(0xFFEF4444);
        statusText = '暂停';
        break;
      default:
        statusColor = const Color(0xFF6B7280);
        statusText = '未知';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE5E7EB),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: () {
          _showUserDetails(user);
        },
        borderRadius: BorderRadius.circular(12),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  user['username'][0].toUpperCase(),
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user['username'],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    user['email'],
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
                          color: statusColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          statusText,
                          style: TextStyle(
                            color: statusColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF5E6AD2).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          user['plan'],
                          style: const TextStyle(
                            color: Color(0xFF5E6AD2),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            PopupMenuButton(
              icon: const Icon(
                Icons.more_vert,
                color: Color(0xFF6B7280),
              ),
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit_outlined, size: 18, color: Color(0xFF6B7280)),
                      SizedBox(width: 8),
                      Text('编辑'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'suspend',
                  child: Row(
                    children: [
                      Icon(Icons.block_outlined, size: 18, color: Color(0xFF6B7280)),
                      SizedBox(width: 8),
                      Text('暂停'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete_outline, size: 18, color: Color(0xFFEF4444)),
                      SizedBox(width: 8),
                      Text('删除', style: TextStyle(color: Color(0xFFEF4444))),
                    ],
                  ),
                ),
              ],
              onSelected: (value) {
                _handleUserAction(value.toString(), user);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _handleUserAction(String action, Map<String, dynamic> user) {
    switch (action) {
      case 'edit':
        _showEditUserDialog(user);
        break;
      case 'suspend':
        _showSuspendUserDialog(user);
        break;
      case 'delete':
        _showDeleteUserDialog(user);
        break;
    }
  }

  void _showUserDetails(Map<String, dynamic> user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('用户详情 - ${user['username']}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('邮箱: ${user['email']}'),
            Text('套餐: ${user['plan']}'),
            Text('到期时间: ${user['expiry']}'),
            Text('流量使用: ${user['traffic']}'),
            Text('状态: ${user['status']}'),
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

  void _showAddUserDialog() {
    // TODO: 实现添加用户对话框
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('添加用户功能待实现')),
    );
  }

  void _showEditUserDialog(Map<String, dynamic> user) {
    // TODO: 实现编辑用户对话框
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('编辑用户 ${user['username']} 功能待实现')),
    );
  }

  void _showSuspendUserDialog(Map<String, dynamic> user) {
    // TODO: 实现暂停用户对话框
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('暂停用户 ${user['username']} 功能待实现')),
    );
  }

  void _showDeleteUserDialog(Map<String, dynamic> user) {
    // TODO: 实现删除用户对话框
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('删除用户 ${user['username']} 功能待实现')),
    );
  }
}
