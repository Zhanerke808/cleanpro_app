// // screens/admin_statistics_screen.dart
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import '../config/app_theme.dart';
// import '../models/order_model.dart';
// import '../models/user_model.dart';
// import '../services/api_service.dart';

// class AdminStatisticsScreen extends StatefulWidget {
//   const AdminStatisticsScreen({super.key});

//   @override
//   State<AdminStatisticsScreen> createState() => _AdminStatisticsScreenState();
// }

// class _AdminStatisticsScreenState extends State<AdminStatisticsScreen> {
//   List<OrderModel> _orders = [];
//   List<UserModel> _users = [];
//   bool _loading = true;

//   @override
//   void initState() {
//     super.initState();
//     _fetch();
//   }

//   Future<void> _fetch() async {
//     try {
//       final orders = await ApiService.adminGetOrders();
//       final users = await ApiService.adminGetUsers();
//       if (mounted) setState(() { _orders = orders; _users = users; _loading = false; });
//     } catch (e) {
//       if (mounted) setState(() => _loading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (_loading) return const Center(child: CircularProgressIndicator(color: AppTheme.primary));

//     final totalOrders = _orders.length;
//     final completed = _orders.where((o) => o.status == 'completed').length;
//     final pending = _orders.where((o) => o.status == 'pending').length;
//     final accepted = _orders.where((o) => o.status == 'accepted').length;
//     final cancelled = _orders.where((o) => o.status == 'cancelled').length;
//     final totalRevenue = _orders.where((o) => o.status == 'completed').fold<double>(0, (sum, o) => sum + o.price);
//     final totalUsers = _users.length;
//     final cleaners = _users.where((u) => u.role == 'cleaner').length;
//     final clients = _users.where((u) => u.role == 'client').length;

//     return RefreshIndicator(
//       onRefresh: _fetch,
//       child: SingleChildScrollView(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Expanded(child: _buildStatCard('Жалпы тапсырыс', totalOrders.toString(), Icons.receipt_long, AppTheme.info)),
//                 const SizedBox(width: 12),
//                 Expanded(child: _buildStatCard('Орындалды', completed.toString(), Icons.check_circle, AppTheme.success)),
//               ],
//             ),
//             const SizedBox(height: 12),
//             Row(
//               children: [
//                 Expanded(child: _buildStatCard('Күтілуде', pending.toString(), Icons.pending, AppTheme.warning)),
//                 const SizedBox(width: 12),
//                 Expanded(child: _buildStatCard('Жалпы табыс', '$totalRevenue ₸', Icons.monetization_on, AppTheme.accent, isRevenue: true)),
//               ],
//             ),
//             const SizedBox(height: 24),
//             Text('Тапсырыс статустары', style: GoogleFonts.montserrat(fontSize: 18, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
//             const SizedBox(height: 16),
//             _buildProgressBar('Орындалды', completed, totalOrders, AppTheme.success),
//             const SizedBox(height: 10),
//             _buildProgressBar('Қабылданды', accepted, totalOrders, AppTheme.info),
//             const SizedBox(height: 10),
//             _buildProgressBar('Күтілуде', pending, totalOrders, AppTheme.warning),
//             const SizedBox(height: 10),
//             _buildProgressBar('Бас тартылды', cancelled, totalOrders, AppTheme.error),
//             const SizedBox(height: 24),
//             Text('Пайдаланушылар', style: GoogleFonts.montserrat(fontSize: 18, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
//             const SizedBox(height: 16),
//             Row(
//               children: [
//                 Expanded(child: _buildUserCard('Барлығы', totalUsers, Colors.purple)),
//                 const SizedBox(width: 12),
//                 Expanded(child: _buildUserCard('Клиенттер', clients, Colors.blue)),
//                 const SizedBox(width: 12),
//                 Expanded(child: _buildUserCard('Клинерлер', cleaners, Colors.green)),
//               ],
//             ),
//             const SizedBox(height: 24),
//             Text('Соңғы тапсырыстар', style: GoogleFonts.montserrat(fontSize: 18, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
//             const SizedBox(height: 16),
//             ..._orders.take(5).map((order) => _buildRecentOrder(order)),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildStatCard(String title, String value, IconData icon, Color color, {bool isRevenue = false}) {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(color: color.withAlpha(40)),
//         boxShadow: [BoxShadow(color: color.withAlpha(15), blurRadius: 10)],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Icon(icon, color: color, size: 28),
//           const SizedBox(height: 12),
//           Text(value, style: GoogleFonts.montserrat(fontSize: isRevenue ? 20 : 28, fontWeight: FontWeight.w800, color: color)),
//           const SizedBox(height: 4),
//           Text(title, style: GoogleFonts.montserrat(fontSize: 12, color: AppTheme.textHint)),
//         ],
//       ),
//     );
//   }

//   Widget _buildProgressBar(String label, int value, int total, Color color) {
//     final percent = total > 0 ? (value / total * 100).toStringAsFixed(1) : '0';
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
//           Text(label, style: GoogleFonts.montserrat(fontSize: 13, color: AppTheme.textSecondary)),
//           Text('$value ($percent%)', style: GoogleFonts.montserrat(fontSize: 13, color: color, fontWeight: FontWeight.w700)),
//         ]),
//         const SizedBox(height: 6),
//         ClipRRect(
//           borderRadius: BorderRadius.circular(10),
//           child: LinearProgressIndicator(value: total > 0 ? value / total : 0, backgroundColor: AppTheme.divider, color: color, minHeight: 10),
//         ),
//       ],
//     );
//   }

//   Widget _buildUserCard(String label, int count, Color color) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: color.withAlpha(40))),
//       child: Column(children: [
//         Text(count.toString(), style: GoogleFonts.montserrat(fontSize: 24, fontWeight: FontWeight.w800, color: color)),
//         const SizedBox(height: 4),
//         Text(label, style: GoogleFonts.montserrat(fontSize: 11, color: AppTheme.textHint)),
//       ]),
//     );
//   }

//   Widget _buildRecentOrder(OrderModel order) {
//     final statusColors = {'pending': AppTheme.warning, 'accepted': AppTheme.info, 'completed': AppTheme.success, 'cancelled': AppTheme.error};
//     final color = statusColors[order.status] ?? AppTheme.textHint;
//     return Container(
//       margin: const EdgeInsets.only(bottom: 8),
//       padding: const EdgeInsets.all(14),
//       decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppTheme.divider)),
//       child: Row(children: [
//         Container(width: 8, height: 8, decoration: BoxDecoration(shape: BoxShape.circle, color: color)),
//         const SizedBox(width: 12),
//         Expanded(child: Text(order.description, style: GoogleFonts.montserrat(fontSize: 13, color: AppTheme.textPrimary), maxLines: 1, overflow: TextOverflow.ellipsis)),
//         Text('${order.price} ₸', style: GoogleFonts.montserrat(fontSize: 14, fontWeight: FontWeight.w700, color: AppTheme.accent)),
//       ]),
//     );
//   }
// }

// screens/admin/admin_statistics_screen.dart
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import '../config/app_theme.dart';
import '../models/order_model.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';

class AdminStatisticsScreen extends StatefulWidget {
  const AdminStatisticsScreen({super.key});

  @override
  State<AdminStatisticsScreen> createState() => _AdminStatisticsScreenState();
}

class _AdminStatisticsScreenState extends State<AdminStatisticsScreen> with SingleTickerProviderStateMixin {
  List<OrderModel> _orders = [];
  List<UserModel> _users = [];
  bool _loading = true;
  late AnimationController _animCtrl;
  
  // Айлық статистика үшін
  Map<String, int> _monthlyOrders = {};
  Map<String, double> _monthlyRevenue = {};

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _animCtrl.forward();
    _fetch();
  }

  Future<void> _fetch() async {
    try {
      final orders = await ApiService.adminGetOrders();
      final users = await ApiService.adminGetUsers();
      _calculateMonthlyStats(orders);
      if (mounted) setState(() { 
        _orders = orders; 
        _users = users; 
        _loading = false; 
      });
    } catch (e) {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _calculateMonthlyStats(List<OrderModel> orders) {
    _monthlyOrders.clear();
    _monthlyRevenue.clear();
    
    // Соңғы 6 айдың атаулары
    final months = List.generate(6, (i) {
      final date = DateTime.now().subtract(Duration(days: (5 - i) * 30));
      return '${date.month}.${date.year}';
    });
    
    for (var month in months) {
      _monthlyOrders[month] = 0;
      _monthlyRevenue[month] = 0;
    }
    
    // Нақты деректермен толтыру (егер тапсырыста күн болса)
    for (var order in orders) {
      // Егер order.date бар болса, оны қолдану керек
      // Қазір уақытша шешім - барлық тапсырыстарды ағымдағы айға қосу
      final currentMonth = '${DateTime.now().month}.${DateTime.now().year}';
      if (_monthlyOrders.containsKey(currentMonth)) {
        _monthlyOrders[currentMonth] = (_monthlyOrders[currentMonth] ?? 0) + 1;
        if (order.status == 'completed') {
          _monthlyRevenue[currentMonth] = (_monthlyRevenue[currentMonth] ?? 0) + order.price;
        }
      }
    }
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(
        child: CircularProgressIndicator(
          color: Color(0xFF3949AB),
          strokeWidth: 3,
        ),
      );
    }

    final totalOrders = _orders.length;
    final completed = _orders.where((o) => o.status == 'completed').length;
    final pending = _orders.where((o) => o.status == 'pending').length;
    final accepted = _orders.where((o) => o.status == 'accepted').length;
    final cancelled = _orders.where((o) => o.status == 'cancelled').length;
    final totalRevenue = _orders.where((o) => o.status == 'completed').fold<double>(0, (sum, o) => sum + o.price);
    final completionRate = totalOrders > 0 ? (completed / totalOrders * 100).toStringAsFixed(1) : '0';
    
    final totalUsers = _users.length;
    final cleaners = _users.where((u) => u.role == 'cleaner').length;
    final clients = _users.where((u) => u.role == 'client').length;
    final activeUsers = totalUsers;

    return RefreshIndicator(
      onRefresh: _fetch,
      color: Colors.white,
      backgroundColor: const Color(0xFF3949AB),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Қош келу блогы
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1A237E), Color(0xFF3949AB)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF3949AB).withAlpha(40),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Қош келдіңіз, Админ!',
                          style: GoogleFonts.poppins(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Бүгінгі статистикалық көрсеткіштер',
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Colors.white.withAlpha(204),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(30),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.insights_outlined,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Статистика карточкалары
            Row(
              children: [
                Expanded(child: _buildStatCard('Жалпы тапсырыс', totalOrders.toString(), Icons.receipt_long_outlined, const Color(0xFF3949AB))),
                const SizedBox(width: 12),
                Expanded(child: _buildStatCard('Орындалды', completed.toString(), Icons.check_circle_outline, const Color(0xFF4CAF50))),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _buildStatCard('Күтілуде', pending.toString(), Icons.pending_outlined, const Color(0xFFFF9800))),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    'Жалпы табыс', 
                    '$totalRevenue ₸', 
                    Icons.monetization_on_outlined, 
                    const Color(0xFFFFD700),
                    isRevenue: true,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Орындалу пайызы
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(8),
                    blurRadius: 20,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Орындалу пайызы',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1A237E),
                        ),
                      ),
                      Text(
                        '$completionRate%',
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF4CAF50),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: LinearProgressIndicator(
                      value: totalOrders > 0 ? completed / totalOrders : 0,
                      backgroundColor: const Color(0xFFE8ECF1),
                      color: const Color(0xFF4CAF50),
                      minHeight: 12,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Диаграмма (айлық тапсырыстар)
            if (_monthlyOrders.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(8),
                      blurRadius: 20,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Айлық тапсырыстар',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1A237E),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 200,
                      child: BarChart(
                        BarChartData(
                          alignment: BarChartAlignment.spaceAround,
                          maxY: _monthlyOrders.values.reduce((a, b) => a > b ? a : b).toDouble() + 2,
                          barGroups: _monthlyOrders.entries.map((entry) {
                            return BarChartGroupData(
                              x: _monthlyOrders.keys.toList().indexOf(entry.key),
                              barRods: [
                                BarChartRodData(
                                  toY: entry.value.toDouble(),
                                  color: const Color(0xFF3949AB),
                                  width: 20,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ],
                            );
                          }).toList(),
                          titlesData: FlTitlesData(
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  final keys = _monthlyOrders.keys.toList();
                                  if (value.toInt() >= 0 && value.toInt() < keys.length) {
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 8),
                                      child: Text(
                                        keys[value.toInt()],
                                        style: GoogleFonts.poppins(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey.withAlpha(128),
                                        ),
                                      ),
                                    );
                                  }
                                  return const Text('');
                                },
                              ),
                            ),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            topTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            rightTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                          ),
                          gridData: FlGridData(show: false),
                          borderData: FlBorderData(show: false),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            
            const SizedBox(height: 24),
            
            // Тапсырыс статустары
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(8),
                    blurRadius: 20,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Тапсырыс статустары',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1A237E),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildProgressBar('Орындалды', completed, totalOrders, const Color(0xFF4CAF50), Icons.done_all_outlined),
                  const SizedBox(height: 14),
                  _buildProgressBar('Қабылданды', accepted, totalOrders, const Color(0xFF2196F3), Icons.check_circle_outline),
                  const SizedBox(height: 14),
                  _buildProgressBar('Күтілуде', pending, totalOrders, const Color(0xFFFF9800), Icons.pending_outlined),
                  const SizedBox(height: 14),
                  _buildProgressBar('Бас тартылды', cancelled, totalOrders, const Color(0xFFF44336), Icons.cancel_outlined),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Пайдаланушылар статистикасы
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(8),
                    blurRadius: 20,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Пайдаланушылар статистикасы',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1A237E),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(child: _buildUserCard('Барлығы', totalUsers, const Color(0xFF9C27B0), Icons.people_alt_outlined)),
                      const SizedBox(width: 12),
                      Expanded(child: _buildUserCard('Клиенттер', clients, const Color(0xFF2196F3), Icons.person_outline)),
                      const SizedBox(width: 12),
                      Expanded(child: _buildUserCard('Клинерлер', cleaners, const Color(0xFF4CAF50), Icons.cleaning_services_outlined)),
                    ],
                  ),
                  if (activeUsers > 0) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4CAF50).withAlpha(20),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.favorite_outlined, color: Color(0xFF4CAF50), size: 20),
                          const SizedBox(width: 12),
                          Text(
                            'Белсенді пайдаланушылар: $activeUsers',
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF4CAF50),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Соңғы тапсырыстар
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(8),
                    blurRadius: 20,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Соңғы тапсырыстар',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1A237E),
                        ),
                      ),
                      if (_orders.length > 5)
                        TextButton(
                          onPressed: () {
                            // Барлық тапсырыстар бетіне өту
                          },
                          child: Text(
                            'Барлығы',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF3949AB),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (_orders.isEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(40),
                        child: Text(
                          'Тапсырыстар жоқ',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.withAlpha(128),
                          ),
                        ),
                      ),
                    )
                  else
                    ..._orders.take(5).map((order) => _buildRecentOrder(order)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color, {bool isRevenue = false}) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutCubic,
      builder: (context, opacity, child) {
        return Opacity(
          opacity: opacity,
          child: Transform.scale(
            scale: 0.9 + (opacity * 0.1),
            child: child,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: color.withAlpha(40), width: 1),
          boxShadow: [
            BoxShadow(
              color: color.withAlpha(15),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withAlpha(20),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: isRevenue ? 18 : 26,
                fontWeight: FontWeight.w800,
                color: color,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.grey.withAlpha(128),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar(String label, int value, int total, Color color, IconData icon) {
    final percent = total > 0 ? (value / total * 100).toStringAsFixed(1) : '0';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, size: 16, color: color),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1A237E),
                  ),
                ),
              ],
            ),
            Text(
              '$value ($percent%)',
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: total > 0 ? value / total : 0,
            backgroundColor: const Color(0xFFE8ECF1),
            color: color,
            minHeight: 8,
          ),
        ),
      ],
    );
  }

  Widget _buildUserCard(String label, int count, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withAlpha(40), width: 1),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withAlpha(20),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 10),
          Text(
            count.toString(),
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: color,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: Colors.grey.withAlpha(128),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentOrder(OrderModel order) {
    final statusColors = {
      'pending': const Color(0xFFFF9800),
      'accepted': const Color(0xFF2196F3),
      'completed': const Color(0xFF4CAF50),
      'cancelled': const Color(0xFFF44336),
    };
    final statusNames = {
      'pending': 'Күтуде',
      'accepted': 'Қабылданды',
      'completed': 'Аяқталды',
      'cancelled': 'Бас тартылды',
    };
    final color = statusColors[order.status] ?? Colors.grey;
    final statusName = statusNames[order.status] ?? order.status;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFE),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.withAlpha(30), width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  order.description,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1A237E),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  statusName,
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${order.price} ₸',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: const Color(0xFFFFD700),
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
    );
  }
}