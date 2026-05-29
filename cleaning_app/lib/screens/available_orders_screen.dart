// // screens/available_orders_screen.dart
// import 'package:flutter/material.dart';
// import '../models/order_model.dart';
// import '../services/api_service.dart';

// class AvailableOrdersScreen extends StatefulWidget {
//   const AvailableOrdersScreen({super.key});

//   @override
//   State<AvailableOrdersScreen> createState() => _AvailableOrdersScreenState();
// }

// class _AvailableOrdersScreenState extends State<AvailableOrdersScreen> {
//   List<OrderModel> _orders = [];
//   bool _loading = true;

//   @override
//   void initState() {
//     super.initState();
//     _fetch();
//   }

//   Future<void> _fetch() async {
//     try {
//       final orders = await ApiService.getAvailableOrders();
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

//   Future<void> _accept(String orderId) async {
//     try {
//       await ApiService.acceptOrder(orderId);
//       _fetch();
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('Тапсырыс қабылданды'),
//             backgroundColor: Colors.green,
//           ),
//         );
//       }
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Қате: $e')),
//         );
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
//           ? Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(Icons.search_off, size: 64, color: Colors.grey[600]),
//                   const SizedBox(height: 16),
//                   Text(
//                     'Бос тапсырыстар жоқ',
//                     style: TextStyle(color: Colors.grey[400], fontSize: 18),
//                   ),
//                 ],
//               ),
//             )
//           : ListView.builder(
//               padding: const EdgeInsets.all(16),
//               itemCount: _orders.length,
//               itemBuilder: (_, i) {
//                 final o = _orders[i];
//                 return TweenAnimationBuilder<double>(
//                   tween: Tween(begin: 0.0, end: 1.0),
//                   duration: Duration(milliseconds: 300 + (i * 100)),
//                   builder: (context, value, child) {
//                     return Opacity(
//                       opacity: value,
//                       child: Transform.translate(
//                         offset: Offset(50 * (1 - value), 0),
//                         child: child,
//                       ),
//                     );
//                   },
//                   child: Card(
//                     margin: const EdgeInsets.only(bottom: 16),
//                     child: Padding(
//                       padding: const EdgeInsets.all(16),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             children: [
//                               Container(
//                                 padding: const EdgeInsets.all(12),
//                                 decoration: BoxDecoration(
//                                   color: const Color(0xFFFFD700).withOpacity(0.1),
//                                   borderRadius: BorderRadius.circular(12),
//                                 ),
//                                 child: const Icon(
//                                   Icons.cleaning_services,
//                                   color: Color(0xFFFFD700),
//                                 ),
//                               ),
//                               const SizedBox(width: 16),
//                               Expanded(
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       o.description,
//                                       style: const TextStyle(
//                                         fontWeight: FontWeight.w600,
//                                         fontSize: 16,
//                                       ),
//                                     ),
//                                     const SizedBox(height: 4),
//                                     Text(
//                                       o.address,
//                                       style: TextStyle(color: Colors.grey[400]),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               Column(
//                                 children: [
//                                   Text(
//                                     '${o.price} тг',
//                                     style: const TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                       color: Color(0xFFFFD700),
//                                       fontSize: 18,
//                                     ),
//                                   ),
//                                   const SizedBox(height: 8),
//                                   ElevatedButton(
//                                     onPressed: () => _accept(o.id),
//                                     style: ElevatedButton.styleFrom(
//                                       backgroundColor: const Color(0xFFFFD700),
//                                       foregroundColor: Colors.black,
//                                       padding: const EdgeInsets.symmetric(
//                                         horizontal: 24,
//                                         vertical: 12,
//                                       ),
//                                     ),
//                                     child: const Text('Алу'),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                           if (o.comment.isNotEmpty) ...[
//                             const SizedBox(height: 12),
//                             Container(
//                               padding: const EdgeInsets.all(12),
//                               decoration: BoxDecoration(
//                                 color: Colors.white.withOpacity(0.05),
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                               child: Row(
//                                 children: [
//                                   Icon(Icons.comment, size: 16, color: Colors.grey[400]),
//                                   const SizedBox(width: 8),
//                                   Expanded(
//                                     child: Text(
//                                       o.comment,
//                                       style: TextStyle(color: Colors.grey[400]),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ],
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//     );
//   }
// }

// screens/available_orders_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/order_model.dart';
import '../services/api_service.dart';

class AvailableOrdersScreen extends StatefulWidget {
  const AvailableOrdersScreen({super.key});

  @override
  State<AvailableOrdersScreen> createState() => _AvailableOrdersScreenState();
}

class _AvailableOrdersScreenState extends State<AvailableOrdersScreen> with SingleTickerProviderStateMixin {
  List<OrderModel> _orders = [];
  bool _loading = true;
  late AnimationController _animCtrl;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _animCtrl.forward();
    _fetch();
  }

  Future<void> _fetch() async {
    try {
      final orders = await ApiService.getAvailableOrders();
      setState(() {
        _orders = orders;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
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
                Expanded(child: Text(e.toString(), style: const TextStyle(fontWeight: FontWeight.w500))),
              ],
            ),
            backgroundColor: const Color(0xFFE57373),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
        );
      }
    }
  }

  Future<void> _accept(String orderId) async {
    try {
      await ApiService.acceptOrder(orderId);
      _fetch();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.check_circle_outline, color: Colors.white, size: 20),
                SizedBox(width: 12),
                Text('Тапсырыс қабылданды', style: TextStyle(fontWeight: FontWeight.w500)),
              ],
            ),
            backgroundColor: const Color(0xFF4CAF50),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white, size: 18),
                const SizedBox(width: 12),
                Expanded(child: Text('Қате: $e', style: const TextStyle(fontWeight: FontWeight.w500))),
              ],
            ),
            backgroundColor: const Color(0xFFE57373),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
        );
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
    
    return RefreshIndicator(
      onRefresh: _fetch,
      color: Colors.white,
      backgroundColor: const Color(0xFF3949AB),
      child: _orders.isEmpty
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
                      Icons.search_off_outlined,
                      size: 60,
                      color: const Color(0xFF3949AB).withAlpha(128),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Бос тапсырыстар жоқ',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1A237E).withAlpha(179),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Жаңа тапсырыстарды күтіңіз',
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
              itemCount: _orders.length,
              itemBuilder: (context, index) {
                final order = _orders[index];
                return TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: Duration(milliseconds: 400 + (index * 80)),
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
                        onTap: () {
                          _showOrderDetails(order);
                        },
                        borderRadius: BorderRadius.circular(24),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Иконка
                                  Container(
                                    padding: const EdgeInsets.all(14),
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [Color(0xFF3949AB), Color(0xFF5C6BC0)],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0xFF3949AB).withAlpha(40),
                                          blurRadius: 12,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: const Icon(
                                      Icons.cleaning_services,
                                      color: Colors.white,
                                      size: 28,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  
                                  // Ақпарат
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          order.description,
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w800,
                                            fontSize: 16,
                                            color: const Color(0xFF1A237E),
                                            letterSpacing: -0.5,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            Icon(Icons.location_on_outlined, size: 14, color: Colors.grey.withAlpha(128)),
                                            const SizedBox(width: 4),
                                            Expanded(
                                              child: Text(
                                                order.address,
                                                style: GoogleFonts.poppins(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.grey.withAlpha(128),
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              
                              const SizedBox(height: 16),
                              
                              // Бөлгіш сызық
                              Container(
                                height: 1,
                                color: Colors.grey.withAlpha(30),
                              ),
                              
                              const SizedBox(height: 16),
                              
                              // Төменгі бөлік: баға және батырма
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  // Баға
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [Color(0xFFFFD700), Color(0xFFFFC107)],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0xFFFFD700).withAlpha(40),
                                          blurRadius: 8,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(Icons.attach_money, color: Colors.white, size: 18),
                                        const SizedBox(width: 4),
                                        Text(
                                          '${order.price} ₸',
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w800,
                                            fontSize: 18,
                                            color: Colors.white,
                                            letterSpacing: -0.5,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  
                                  // Алу батырмасы
                                  Container(
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [Color(0xFF4CAF50), Color(0xFF66BB6A)],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      borderRadius: BorderRadius.circular(30),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0xFF4CAF50).withAlpha(40),
                                          blurRadius: 12,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        onTap: () => _accept(order.id),
                                        borderRadius: BorderRadius.circular(30),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Icon(Icons.check_circle_outline, color: Colors.white, size: 20),
                                              const SizedBox(width: 8),
                                              Text(
                                                'Алу',
                                                style: GoogleFonts.poppins(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.white,
                                                  letterSpacing: 0.5,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              
                              // Комментарий (егер бар болса)
                              if (order.comment.isNotEmpty) ...[
                                const SizedBox(height: 16),
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF8FAFE),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(color: Colors.grey.withAlpha(30), width: 1),
                                  ),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Icon(Icons.comment_outlined, size: 16, color: Colors.grey.withAlpha(128)),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          order.comment,
                                          style: GoogleFonts.poppins(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.grey.withAlpha(128),
                                            height: 1.3,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
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
            _buildDetailRow('Сипаттама', order.description),
            _buildDetailRow('Мекен-жай', order.address),
            if (order.entrance.isNotEmpty) _buildDetailRow('Подъезд', order.entrance),
            if (order.comment.isNotEmpty) _buildDetailRow('Түсінік', order.comment),
            _buildDetailRow('Телефон', order.phone),
            _buildDetailRow('Бағасы', '${order.price} ₸'),
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
}