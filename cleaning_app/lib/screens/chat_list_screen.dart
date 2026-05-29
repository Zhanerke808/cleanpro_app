// // screens/chat_list_screen.dart
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import '../config/app_theme.dart';
// import '../models/order_model.dart';
// import '../services/api_service.dart';
// import 'chat_screen.dart';

// class ChatListScreen extends StatefulWidget {
//   final String userRole;
//   const ChatListScreen({super.key, required this.userRole});

//   @override
//   State<ChatListScreen> createState() => _ChatListScreenState();
// }

// class _ChatListScreenState extends State<ChatListScreen> {
//   List<OrderModel> _chats = [];
//   bool _loading = true;

//   @override
//   void initState() {
//     super.initState();
//     _fetch();
//   }

//   Future<void> _fetch() async {
//     try {
//       List<OrderModel> orders;
//       if (widget.userRole == 'cleaner') {
//         // Клинер тек өзі алған тапсырыстарды көреді
//         orders = await ApiService.getAcceptedOrders();
//       } else if (widget.userRole == 'client') {
//         // Клиент тек өз тапсырыстарын көреді
//         orders = await ApiService.getClientOrders();
//       } else {
//         orders = await ApiService.adminGetOrders();
//       }
//       // accepted немесе in_progress статустағы тапсырыстар
//       orders = orders.where((o) => o.status == 'accepted' || o.status == 'in_progress').toList();
//       if (mounted) setState(() { _chats = orders; _loading = false; });
//     } catch (e) {
//       if (mounted) setState(() => _loading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (_loading) return Center(child: CircularProgressIndicator(color: AppTheme.gold));
    
//     return RefreshIndicator(
//       onRefresh: _fetch,
//       child: _chats.isEmpty
//           ? Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(Icons.chat_bubble_outline, size: 80, color: Colors.white.withAlpha(30)),
//                   const SizedBox(height: 16),
//                   Text(
//                     'Хабарламалар жоқ',
//                     style: GoogleFonts.montserrat(fontSize: 16, color: Colors.white38),
//                   ),
//                   const SizedBox(height: 8),
//                   Text(
//                     'Тапсырыс қабылданғаннан кейін чат ашылады',
//                     style: GoogleFonts.montserrat(fontSize: 12, color: Colors.white24),
//                   ),
//                 ],
//               ),
//             )
//           : ListView.builder(
//               padding: const EdgeInsets.all(16),
//               itemCount: _chats.length,
//               itemBuilder: (_, i) => _buildChatItem(_chats[i]),
//             ),
//     );
//   }

//   Widget _buildChatItem(OrderModel order) {
//     final isCleaner = widget.userRole == 'cleaner';
//     final chatPartner = isCleaner ? 'Клиент' : 'Клинер';
    
//     return GestureDetector(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (_) => ChatScreen(
//               orderId: order.id,
//               orderDescription: order.description,
//               chatPartner: chatPartner,
//             ),
//           ),
//         );
//       },
//       child: Container(
//         margin: const EdgeInsets.only(bottom: 10),
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: AppTheme.surface,
//           borderRadius: BorderRadius.circular(16),
//           border: Border.all(color: Colors.white.withAlpha(8)),
//           boxShadow: [
//             BoxShadow(
//               color: AppTheme.gold.withAlpha(10),
//               blurRadius: 10,
//               offset: const Offset(0, 4),
//             ),
//           ],
//         ),
//         child: Row(
//           children: [
//             Container(
//               width: 55,
//               height: 55,
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [AppTheme.gold, const Color(0xFFFF8C00)],
//                 ),
//                 borderRadius: BorderRadius.circular(18),
//                 boxShadow: [
//                   BoxShadow(
//                     color: AppTheme.gold.withAlpha(40),
//                     blurRadius: 15,
//                     spreadRadius: 2,
//                   ),
//                 ],
//               ),
//               child: const Icon(Icons.chat_rounded, color: Colors.white, size: 28),
//             ),
//             const SizedBox(width: 16),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     order.description,
//                     style: GoogleFonts.montserrat(
//                       fontWeight: FontWeight.w600,
//                       color: Colors.white,
//                       fontSize: 15,
//                     ),
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   const SizedBox(height: 6),
//                   Row(
//                     children: [
//                       Icon(Icons.location_on, size: 14, color: Colors.white38),
//                       const SizedBox(width: 4),
//                       Expanded(
//                         child: Text(
//                           order.address,
//                           style: GoogleFonts.montserrat(
//                             fontSize: 12,
//                             color: Colors.white38,
//                           ),
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 4),
//                   Container(
//                     padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
//                     decoration: BoxDecoration(
//                       color: AppTheme.gold.withAlpha(20),
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: Text(
//                       chatPartner,
//                       style: GoogleFonts.montserrat(
//                         fontSize: 10,
//                         color: AppTheme.gold,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(width: 8),
//             Column(
//               children: [
//                 Text(
//                   '${order.price} ₸',
//                   style: GoogleFonts.montserrat(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w800,
//                     color: AppTheme.gold,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Icon(Icons.chevron_right, color: Colors.white24, size: 20),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }// screens/chat_list_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/app_theme.dart';
import '../models/order_model.dart';
import '../services/api_service.dart';
import 'chat_screen.dart';

class ChatListScreen extends StatefulWidget {
  final String userRole;
  const ChatListScreen({super.key, required this.userRole});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> with SingleTickerProviderStateMixin {
  List<OrderModel> _chats = [];
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
      List<OrderModel> orders;
      if (widget.userRole == 'cleaner') {
        orders = await ApiService.getAcceptedOrders();
      } else if (widget.userRole == 'client') {
        orders = await ApiService.getClientOrders();
      } else {
        orders = await ApiService.adminGetOrders();
      }
      orders = orders.where((o) => o.status == 'accepted' || o.status == 'in_progress').toList();
      if (mounted) setState(() { _chats = orders; _loading = false; });
    } catch (e) {
      if (mounted) setState(() => _loading = false);
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
      child: _chats.isEmpty
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
                      Icons.chat_bubble_outline,
                      size: 60,
                      color: const Color(0xFF3949AB).withAlpha(128),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Хабарламалар жоқ',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1A237E).withAlpha(179),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Тапсырыс қабылданғаннан кейін чат ашылады',
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
              itemCount: _chats.length,
              itemBuilder: (context, index) {
                final order = _chats[index];
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
                  child: _buildChatItem(order),
                );
              },
            ),
    );
  }

  Widget _buildChatItem(OrderModel order) {
    final isCleaner = widget.userRole == 'cleaner';
    final chatPartner = isCleaner ? 'Клиент' : 'Клинер';
    final partnerColor = isCleaner ? const Color(0xFF2196F3) : const Color(0xFF4CAF50);
    
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ChatScreen(
              orderId: order.id,
              orderDescription: order.description,
              chatPartner: chatPartner,
            ),
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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ChatScreen(
                    orderId: order.id,
                    orderDescription: order.description,
                    chatPartner: chatPartner,
                  ),
                ),
              );
            },
            borderRadius: BorderRadius.circular(24),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Аватар / Иконка
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [partnerColor, partnerColor.withAlpha(179)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: partnerColor.withAlpha(40),
                          blurRadius: 15,
                          spreadRadius: 2,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.chat_rounded,
                      color: Colors.white,
                      size: 30,
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
                            fontSize: 15,
                            color: const Color(0xFF1A237E),
                            letterSpacing: -0.3,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              size: 14,
                              color: Colors.grey.withAlpha(128),
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                order.address,
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey.withAlpha(128),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        // Чат партнер чипі
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: partnerColor.withAlpha(20),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: partnerColor.withAlpha(40),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                isCleaner ? Icons.person_outline : Icons.cleaning_services_outlined,
                                size: 12,
                                color: partnerColor,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                chatPartner,
                                style: GoogleFonts.poppins(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: partnerColor,
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(width: 12),
                  
                  // Баға және көрсеткі
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFFFD700), Color(0xFFFFC107)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFFFD700).withAlpha(40),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          '${order.price} ₸',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF3949AB).withAlpha(15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.chevron_right,
                          color: Color(0xFF3949AB),
                          size: 18,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}