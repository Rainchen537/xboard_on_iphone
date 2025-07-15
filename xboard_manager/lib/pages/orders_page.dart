import 'package:flutter/material.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // 模拟订单数据
  final List<Map<String, dynamic>> _orders = [
    {
      'id': '#12345',
      'user': 'user1@example.com',
      'plan': 'VIP套餐',
      'amount': 99.00,
      'status': 'completed',
      'date': '2024-07-15 14:30',
      'paymentMethod': '支付宝',
    },
    {
      'id': '#12346',
      'user': 'user2@example.com',
      'plan': '专业版',
      'amount': 59.00,
      'status': 'pending',
      'date': '2024-07-15 13:45',
      'paymentMethod': '微信支付',
    },
    {
      'id': '#12347',
      'user': 'user3@example.com',
      'plan': '基础版',
      'amount': 29.00,
      'status': 'failed',
      'date': '2024-07-15 12:20',
      'paymentMethod': '银行卡',
    },
    {
      'id': '#12348',
      'user': 'user4@example.com',
      'plan': 'VIP套餐',
      'amount': 99.00,
      'status': 'completed',
      'date': '2024-07-15 11:15',
      'paymentMethod': '支付宝',
    },

  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    if (mounted) {
      _tabController.dispose();
      _searchController.dispose();
    }
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 确保TabController在widget树重建时保持正确状态
    if (mounted && _tabController.length != 4) {
      _tabController.dispose();
      _tabController = TabController(length: 4, vsync: this);
    }
  }

  List<Map<String, dynamic>> get _filteredOrders {
    List<Map<String, dynamic>> filtered = _orders;
    
    // 根据搜索查询过滤
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((order) {
        return order['id'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
            order['user'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
            order['plan'].toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
    }
    
    // 根据选中的标签页过滤
    switch (_tabController.index) {
      case 1: // 待支付
        return filtered.where((order) => order['status'] == 'pending').toList();
      case 2: // 已完成
        return filtered.where((order) => order['status'] == 'completed').toList();
      case 3: // 已失败
        return filtered.where((order) => order['status'] == 'failed').toList();
      default: // 全部
        return filtered;
    }
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

            // 标签页
            _buildTabBar(context),

            // 搜索栏和统计
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Container(
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
                        hintText: '搜索订单号、用户或套餐...',
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
                  const SizedBox(height: 16),
                  _buildOrderStats(),
                ],
              ),
            ),

            // 订单列表
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: List.generate(4, (index) => _buildOrderList()),
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
                  '订单管理',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const SizedBox(height: 4),
                Text(
                  '管理所有订单和支付',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: const Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar(BuildContext context) {
    final tabs = ['全部', '待支付', '已完成', '已失败'];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE5E7EB),
          width: 1,
        ),
      ),
      child: Row(
        children: tabs.asMap().entries.map((entry) {
          final index = entry.key;
          final title = entry.value;
          final isSelected = _tabController.index == index;

          return Expanded(
            child: GestureDetector(
              onTap: () {
                _tabController.animateTo(index);
                setState(() {});
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF5E6AD2) : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isSelected ? Colors.white : const Color(0xFF6B7280),
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildOrderStats() {
    final totalOrders = _orders.length;
    final completedOrders = _orders.where((o) => o['status'] == 'completed').length;
    final pendingOrders = _orders.where((o) => o['status'] == 'pending').length;
    final totalRevenue = _orders
        .where((o) => o['status'] == 'completed')
        .fold(0.0, (sum, order) => sum + order['amount']);

    return Row(
      children: [
        Expanded(
          child: _buildStatCard('总订单', '$totalOrders', Colors.blue),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildStatCard('已完成', '$completedOrders', Colors.green),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildStatCard('待支付', '$pendingOrders', Colors.orange),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildStatCard('总收入', '¥${totalRevenue.toStringAsFixed(0)}', Colors.purple),
        ),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, Color color) {
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
              fontSize: 18,
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

  Widget _buildOrderList() {
    final filteredOrders = _filteredOrders;
    
    if (filteredOrders.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: 64,
              color: Color(0xFF9CA3AF),
            ),
            SizedBox(height: 16),
            Text(
              '暂无订单数据',
              style: TextStyle(
                color: Color(0xFF6B7280),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      itemCount: filteredOrders.length,
      itemBuilder: (context, index) {
        final order = filteredOrders[index];
        return _buildOrderCard(order);
      },
    );
  }

  Widget _buildOrderCard(Map<String, dynamic> order) {
    Color statusColor;
    String statusText;
    IconData statusIcon;

    switch (order['status']) {
      case 'completed':
        statusColor = const Color(0xFF10B981);
        statusText = '已完成';
        statusIcon = Icons.check_circle_outline;
        break;
      case 'pending':
        statusColor = const Color(0xFFF59E0B);
        statusText = '待支付';
        statusIcon = Icons.schedule_outlined;
        break;
      case 'failed':
        statusColor = const Color(0xFFEF4444);
        statusText = '支付失败';
        statusIcon = Icons.error_outline;
        break;
      default:
        statusColor = const Color(0xFF6B7280);
        statusText = '未知';
        statusIcon = Icons.help_outline;
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
          _showOrderDetails(order);
        },
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    statusIcon,
                    color: statusColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            order['id'],
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1F2937),
                            ),
                          ),
                          const Spacer(),
                          Text(
                            '¥${order['amount'].toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1F2937),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        order['user'],
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF6B7280),
                        ),
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
                      value: 'view',
                      child: Row(
                        children: [
                          Icon(Icons.visibility_outlined, size: 18, color: Color(0xFF6B7280)),
                          SizedBox(width: 8),
                          Text('查看详情'),
                        ],
                      ),
                    ),
                    if (order['status'] == 'pending')
                      const PopupMenuItem(
                        value: 'cancel',
                        child: Row(
                          children: [
                            Icon(Icons.cancel_outlined, size: 18, color: Color(0xFF6B7280)),
                            SizedBox(width: 8),
                            Text('取消订单'),
                          ],
                        ),
                      ),
                  ],
                  onSelected: (value) {
                    _handleOrderAction(value.toString(), order);
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              order['plan'],
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF374151),
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
                    color: const Color(0xFF8B5CF6).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    order['paymentMethod'],
                    style: const TextStyle(
                      color: Color(0xFF8B5CF6),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  order['date'],
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF9CA3AF),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _handleOrderAction(String action, Map<String, dynamic> order) {
    switch (action) {
      case 'view':
        _showOrderDetails(order);
        break;
      case 'cancel':
        _showCancelOrderDialog(order);
        break;
    }
  }

  void _showOrderDetails(Map<String, dynamic> order) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('订单详情 - ${order['id']}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('用户: ${order['user']}'),
            Text('套餐: ${order['plan']}'),
            Text('金额: ¥${order['amount'].toStringAsFixed(2)}'),
            Text('支付方式: ${order['paymentMethod']}'),
            Text('状态: ${order['status']}'),
            Text('时间: ${order['date']}'),
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

  void _showCancelOrderDialog(Map<String, dynamic> order) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('取消订单 ${order['id']} 功能待实现')),
    );
  }


}
