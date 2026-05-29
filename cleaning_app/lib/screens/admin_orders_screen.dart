// // screens/admin_orders_screen.dart
// import 'package:flutter/material.dart';
// import '../models/order_model.dart';
// import '../services/api_service.dart';

// class AdminOrdersScreen extends StatefulWidget {
//   const AdminOrdersScreen({super.key});

//   @override
//   State<AdminOrdersScreen> createState() => _AdminOrdersScreenState();
// }

// class _AdminOrdersScreenState extends State<AdminOrdersScreen> {
//   List<OrderModel> _orders = [];
//   bool _loading = true;

//   @override
//   void initState() {
//     super.initState();
//     _fetch();
//   }

//   Future<void> _fetch() async {
//     try {
//       final orders = await ApiService.adminGetOrders();
//       setState(() {
//         _orders = orders;
//         _loading = false;
//       });
//     } catch (e) {
//       setState(() => _loading = false);
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text(e.toString())),
//         );
//       }
//     }
//   }

//   Future<void> _updateStatus(String id, String status) async {
//     try {
//       await ApiService.adminUpdateOrderStatus(id, status);
//       _fetch();
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('$e')),
//         );
//       }
//     }
//   }

//   Future<void> _delete(String id) async {
//     final confirm = await showDialog<bool>(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Жою'),
//         content: const Text('Бұл тапсырысты жоюға сенімдісіз бе?'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context, false),
//             child: const Text('Жоқ'),
//           ),
//           TextButton(
//             onPressed: () => Navigator.pop(context, true),
//             child: const Text('Иә', style: TextStyle(color: Colors.red)),
//           ),
//         ],
//       ),
//     );
//     if (confirm == true) {
//       try {
//         await ApiService.adminDeleteOrder(id);
//         _fetch();
//       } catch (e) {
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('$e')),
//           );
//         }
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (_loading) {
//       return const Center(
//         child: CircularProgressIndicator(color: Color(0xFFFFD700)),
//       );
//     }
//     return RefreshIndicator(
//       onRefresh: _fetch,
//       child: _orders.isEmpty
//           ? const Center(child: Text('Тапсырыстар жоқ'))
//           : ListView.builder(
//               padding: const EdgeInsets.all(16),
//               itemCount: _orders.length,
//               itemBuilder: (_, i) {
//                 final o = _orders[i];
//                 return Card(
//                   margin: const EdgeInsets.only(bottom: 16),
//                   child: Padding(
//                     padding: const EdgeInsets.all(16),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           o.description,
//                           style: const TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 16,
//                           ),
//                         ),
//                         const SizedBox(height: 8),
//                         Text('Мекен-жай: ${o.address}'),
//                         if (o.entrance.isNotEmpty) Text('Подъезд: ${o.entrance}'),
//                         if (o.comment.isNotEmpty) Text('Түсінік: ${o.comment}'),
//                         Text('Телефон: ${o.phone}'),
//                         Text(
//                           'Бағасы: ${o.price} тг',
//                           style: const TextStyle(
//                             color: Color(0xFFFFD700),
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         const SizedBox(height: 12),
//                         Row(
//                           children: [
//                             Container(
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: 12,
//                                 vertical: 4,
//                               ),
//                               decoration: BoxDecoration(
//                                 color: _getStatusColor(o.status).withOpacity(0.1),
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                               child: Text(
//                                 o.status,
//                                 style: TextStyle(
//                                   color: _getStatusColor(o.status),
//                                 ),
//                               ),
//                             ),
//                             const Spacer(),
//                             PopupMenuButton<String>(
//                               onSelected: (v) => _updateStatus(o.id, v),
//                               itemBuilder: (_) => [
//                                 const PopupMenuItem(
//                                   value: 'pending',
//                                   child: Text('pending'),
//                                 ),
//                                 const PopupMenuItem(
//                                   value: 'accepted',
//                                   child: Text('accepted'),
//                                 ),
//                                 const PopupMenuItem(
//                                   value: 'completed',
//                                   child: Text('completed'),
//                                 ),
//                                 const PopupMenuItem(
//                                   value: 'cancelled',
//                                   child: Text('cancelled'),
//                                 ),
//                               ],
//                               child: Container(
//                                 padding: const EdgeInsets.all(8),
//                                 decoration: BoxDecoration(
//                                   color: Colors.white.withOpacity(0.1),
//                                   borderRadius: BorderRadius.circular(8),
//                                 ),
//                                 child: const Icon(Icons.edit),
//                               ),
//                             ),
//                             const SizedBox(width: 8),
//                             InkWell(
//                               onTap: () => _delete(o.id),
//                               child: Container(
//                                 padding: const EdgeInsets.all(8),
//                                 decoration: BoxDecoration(
//                                   color: Colors.red.withOpacity(0.1),
//                                   borderRadius: BorderRadius.circular(8),
//                                 ),
//                                 child: const Icon(
//                                   Icons.delete,
//                                   color: Colors.red,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//     );
//   }

//   Color _getStatusColor(String status) {
//     switch (status) {
//       case 'pending':
//         return Colors.orange;
//       case 'accepted':
//         return Colors.blue;
//       case 'completed':
//         return Colors.green;
//       case 'cancelled':
//         return Colors.red;
//       default:
//         return Colors.grey;
//     }
//   }
// }

// screens/admin/admin_orders_screen.dart
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/order_model.dart';
import '../services/api_service.dart';

class AdminOrdersScreen extends StatefulWidget {
  const AdminOrdersScreen({super.key});

  @override
  State<AdminOrdersScreen> createState() => _AdminOrdersScreenState();
}

class _AdminOrdersScreenState extends State<AdminOrdersScreen> with SingleTickerProviderStateMixin {
  List<OrderModel> _orders = [];
  bool _loading = true;
  late AnimationController _animCtrl;
  String _filterStatus = 'all';
  
  List<String> get _statuses => ['all', 'pending', 'accepted', 'completed', 'cancelled'];
  
  List<OrderModel> get _filteredOrders {
    if (_filterStatus == 'all') return _orders;
    return _orders.where((o) => o.status == _filterStatus).toList();
  }

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
      setState(() {
        _orders = orders;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(_buildErrorSnackBar(e.toString()));
      }
    }
  }

  Future<void> _updateStatus(String id, String status) async {
    try {
      await ApiService.adminUpdateOrderStatus(id, status);
      _fetch();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(_buildSuccessSnackBar(
          'Тапсырыс статусы жаңартылды',
          Icons.check_circle_outline,
        ));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(_buildErrorSnackBar(e.toString()));
      }
    }
  }

  Future<void> _delete(String id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => _buildDeleteDialog(),
    );
    if (confirm == true) {
      try {
        await ApiService.adminDeleteOrder(id);
        _fetch();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(_buildSuccessSnackBar(
            'Тапсырыс жойылды',
            Icons.delete_outline,
          ));
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(_buildErrorSnackBar(e.toString()));
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
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFF5F7FA), Color(0xFFE8ECF1)],
        ),
      ),
      child: Column(
        children: [
          // Фильтр чиптері
          if (!_loading && _orders.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _statuses.map((status) {
                    final isSelected = _filterStatus == status;
                    final statusName = _getStatusName(status);
                    final statusColor = _getStatusColorFromStatus(status);
                    return Container(
                      margin: const EdgeInsets.only(right: 12),
                      child: FilterChip(
                        label: Text(
                          statusName,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            color: isSelected ? Colors.white : statusColor,
                          ),
                        ),
                        selected: isSelected,
                        onSelected: (_) => setState(() => _filterStatus = status),
                        backgroundColor: Colors.white,
                        selectedColor: statusColor,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                          side: BorderSide(color: statusColor.withAlpha(51), width: 1),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          
          // Контент
          Expanded(
            child: _loading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF3949AB),
                      strokeWidth: 3,
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: _fetch,
                    color: Colors.white,
                    backgroundColor: const Color(0xFF3949AB),
                    child: _filteredOrders.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 120,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [const Color(0xFF3949AB).withAlpha(30), const Color(0xFF3949AB).withAlpha(10)],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(40),
                                  ),
                                  child: Icon(
                                    Icons.receipt_long_outlined,
                                    size: 60,
                                    color: const Color(0xFF3949AB).withAlpha(128),
                                  ),
                                ),
                                const SizedBox(height: 24),
                                Text(
                                  'Тапсырыстар жоқ',
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF1A237E).withAlpha(179),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Әзірге ешқандай тапсырыс жоқ',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey.withAlpha(153),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: _filteredOrders.length,
                            itemBuilder: (context, index) {
                              final order = _filteredOrders[index];
                              return _buildOrderCard(order, index);
                            },
                          ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderCard(OrderModel order, int index) {
    final statusColor = _getStatusColor(order.status);
    final statusName = _getStatusName(order.status);
    
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 400 + (index * 60)),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(30 * (1 - value), 0),
            child: child,
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(12),
              blurRadius: 20,
              spreadRadius: 2,
              offset: const Offset(0, 8),
            ),
          ],
          border: Border.all(
            color: Colors.white.withAlpha(102),
            width: 1,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => _showOrderDetails(order),
            borderRadius: BorderRadius.circular(24),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Жоғарғы бөлік: ID және статус
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: statusColor.withAlpha(20),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _getStatusIcon(order.status),
                              size: 16,
                              color: statusColor,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              statusName,
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: statusColor,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '#${order.id.substring(0, 8)}',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.withAlpha(128),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Сипаттама
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF3949AB).withAlpha(15),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          Icons.description_outlined,
                          color: Color(0xFF3949AB),
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          order.description,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF1A237E),
                            height: 1.3,
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 14),
                  
                  // Мекен-жай
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF4CAF50).withAlpha(15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.location_on_outlined,
                          color: Color(0xFF4CAF50),
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          order.address,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.withAlpha(179),
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Қосымша ақпарат (подъезд, комментарий, телефон)
                  Wrap(
                    spacing: 12,
                    runSpacing: 8,
                    children: [
                      if (order.entrance.isNotEmpty)
                        _buildInfoChip(
                          Icons.door_front_door_outlined,
                          'Подъезд: ${order.entrance}',
                          const Color(0xFF2196F3),
                        ),
                      if (order.comment.isNotEmpty)
                        _buildInfoChip(
                          Icons.comment_outlined,
                          'Түсінік: ${order.comment}',
                          const Color(0xFFFF9800),
                        ),
                      _buildInfoChip(
                        Icons.phone_outlined,
                        order.phone,
                        const Color(0xFF9C27B0),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Баға
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFFD700), Color(0xFFFFC107)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.attach_money, color: Colors.white, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          '${order.price} ₸',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const Spacer(),
                        // Әрекет батырмалары
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha(30),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: PopupMenuButton<String>(
                            onSelected: (v) => _updateStatus(order.id, v),
                            icon: const Icon(Icons.edit_outlined, color: Colors.white, size: 20),
                            padding: EdgeInsets.zero,
                            itemBuilder: (_) => [
                              const PopupMenuItem(value: 'all', child: Text('Барлығы')),
                              const PopupMenuItem(value: 'pending', child: Text('Күтуде')),
                              const PopupMenuItem(value: 'accepted', child: Text('Қабылданды')),
                              const PopupMenuItem(value: 'completed', child: Text('Аяқталды')),
                              const PopupMenuItem(value: 'cancelled', child: Text('Бас тартылды')),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha(30),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.delete_outline, color: Colors.white, size: 20),
                            onPressed: () => _delete(order.id),
                            padding: const EdgeInsets.all(8),
                            constraints: const BoxConstraints(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withAlpha(15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeleteDialog() {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.withAlpha(20),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.warning_amber_rounded, color: Colors.red, size: 48),
            ),
            const SizedBox(height: 20),
            Text(
              'Тапсырысты жою',
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF1A237E),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Бұл тапсырысты жоюға сенімдісіз бе?',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey.withAlpha(153),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                      'Жоқ',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context, true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      textStyle: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    child: const Text('Иә, жою'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showOrderDetails(OrderModel order) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 60,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.withAlpha(51),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Тапсырыс туралы ақпарат',
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF1A237E),
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 20),
            _buildDetailRow('Тапсырыс ID', order.id.substring(0, 12)),
            _buildDetailRow('Сипаттама', order.description),
            _buildDetailRow('Мекен-жай', order.address),
            if (order.entrance.isNotEmpty) _buildDetailRow('Подъезд', order.entrance),
            if (order.comment.isNotEmpty) _buildDetailRow('Түсінік', order.comment),
            _buildDetailRow('Телефон', order.phone),
            _buildDetailRow('Бағасы', '${order.price} ₸'),
            _buildDetailRow('Статус', _getStatusName(order.status)),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3949AB),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                  textStyle: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                child: const Text('ЖАБУ'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey.withAlpha(153),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF1A237E),
              ),
            ),
          ),
        ],
      ),
    );
  }

  SnackBar _buildSuccessSnackBar(String message, IconData icon) {
    return SnackBar(
      content: Row(
        children: [
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(width: 12),
          Expanded(child: Text(message, style: const TextStyle(fontWeight: FontWeight.w500))),
        ],
      ),
      backgroundColor: const Color(0xFF4CAF50),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      duration: const Duration(seconds: 2),
    );
  }

  SnackBar _buildErrorSnackBar(String message) {
    return SnackBar(
      content: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withAlpha(30),
            ),
            child: const Icon(Icons.error_outline, color: Colors.white, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(message, style: const TextStyle(fontWeight: FontWeight.w500))),
        ],
      ),
      backgroundColor: const Color(0xFFE57373),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    );
  }

  String _getStatusName(String status) {
    switch (status) {
      case 'all': return 'Барлығы';
      case 'pending': return 'Күтуде';
      case 'accepted': return 'Қабылданды';
      case 'completed': return 'Аяқталды';
      case 'cancelled': return 'Бас тартылды';
      default: return status;
    }
  }

  String _getStatusNameFromStatus(String status) {
    if (status == 'all') return 'Барлығы';
    return _getStatusName(status);
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending': return const Color(0xFFFF9800);
      case 'accepted': return const Color(0xFF2196F3);
      case 'completed': return const Color(0xFF4CAF50);
      case 'cancelled': return const Color(0xFFF44336);
      default: return Colors.grey;
    }
  }

  Color _getStatusColorFromStatus(String status) {
    if (status == 'all') return const Color(0xFF3949AB);
    return _getStatusColor(status);
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'pending': return Icons.pending_outlined;
      case 'accepted': return Icons.check_circle_outline;
      case 'completed': return Icons.done_all_outlined;
      case 'cancelled': return Icons.cancel_outlined;
      default: return Icons.help_outline;
    }
  }
}