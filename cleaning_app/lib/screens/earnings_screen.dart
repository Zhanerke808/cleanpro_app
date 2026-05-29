// screens/cleaner/earnings_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../config/app_theme.dart';
import '../../models/order_model.dart';
import '../../services/api_service.dart';

class EarningsScreen extends StatefulWidget {
  const EarningsScreen({super.key});

  @override
  State<EarningsScreen> createState() => _EarningsScreenState();
}

class _EarningsScreenState extends State<EarningsScreen> with SingleTickerProviderStateMixin {
  List<OrderModel> _orders = [];
  bool _loading = true;
  late AnimationController _animCtrl;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _fadeAnim = CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut);
    _animCtrl.forward();
    _fetch();
  }

  Future<void> _fetch() async {
    try {
      final orders = await ApiService.getAcceptedOrders();
      if (mounted) setState(() { _orders = orders; _loading = false; });
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

    final completed = _orders.where((o) => o.status == 'completed').toList();
    final totalEarnings = completed.fold<double>(0, (sum, o) => sum + o.price);
    final thisMonth = completed.where((o) {
      if (o.createdAt == null) return false;
      return o.createdAt!.month == DateTime.now().month && o.createdAt!.year == DateTime.now().year;
    }).fold<double>(0, (sum, o) => sum + o.price);
    
    final inProgress = _orders.where((o) => o.status == 'in_progress').length;
    final accepted = _orders.where((o) => o.status == 'accepted').length;

    return RefreshIndicator(
      onRefresh: _fetch,
      color: Colors.white,
      backgroundColor: const Color(0xFF3949AB),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Негізгі табыс карточкасы
            FadeTransition(
              opacity: _fadeAnim,
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeOutCubic,
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: 0.9 + (value * 0.1),
                    child: child,
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF1A237E), Color(0xFF3949AB)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(32),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF3949AB).withAlpha(40),
                        blurRadius: 30,
                        spreadRadius: 5,
                        offset: const Offset(0, 15),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(30),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(
                          Icons.monetization_on_outlined,
                          color: Color(0xFFFFD700),
                          size: 32,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Жалпы табыс',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white.withAlpha(204),
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '$totalEarnings ₸',
                        style: GoogleFonts.poppins(
                          fontSize: 44,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFFFFD700),
                          letterSpacing: -1,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFD700).withAlpha(30),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Осы айда: $thisMonth ₸',
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFFFFD700),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Статистика карточкалары
            Row(
              children: [
                Expanded(child: _buildMiniStat('Аяқталды', '${completed.length}', const Color(0xFF4CAF50), Icons.done_all_outlined)),
                const SizedBox(width: 12),
                Expanded(child: _buildMiniStat('Орындалуда', '$inProgress', const Color(0xFFFF9800), Icons.pending_outlined)),
                const SizedBox(width: 12),
                Expanded(child: _buildMiniStat('Күтілуде', '$accepted', const Color(0xFF2196F3), Icons.schedule_outlined)),
              ],
            ),
            
            const SizedBox(height: 32),
            
            // Соңғы төлемдер
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Соңғы төлемдер',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF1A237E),
                    letterSpacing: -0.5,
                  ),
                ),
                if (completed.length > 10)
                  TextButton(
                    onPressed: () {},
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
            
            if (completed.isEmpty)
              Container(
                padding: const EdgeInsets.all(40),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.grey.withAlpha(30), width: 1),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.attach_money_outlined,
                      size: 64,
                      color: Colors.grey.withAlpha(102),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Әзірше төлемдер жоқ',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.withAlpha(128),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Тапсырыстар орындағаннан кейін төлемдер көрсетіледі',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.withAlpha(128),
                      ),
                    ),
                  ],
                ),
              )
            else
              ...completed.take(10).map((order) => _buildPaymentItem(order)),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniStat(String title, String value, Color color, IconData icon) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutCubic,
      builder: (context, opacity, child) {
        return Opacity(
          opacity: opacity,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - opacity)),
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
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
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
                fontSize: 26,
                fontWeight: FontWeight.w800,
                color: color,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Colors.grey.withAlpha(128),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentItem(OrderModel order) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 300),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(20 * (1 - value), 0),
            child: child,
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(8),
              blurRadius: 15,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: const Color(0xFF4CAF50).withAlpha(30),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF4CAF50), Color(0xFF66BB6A)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF4CAF50).withAlpha(40),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.check_circle_outline,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    order.description,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1A237E),
                      letterSpacing: -0.3,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatDate(order.createdAt),
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.withAlpha(128),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFFD700), Color(0xFFFFC107)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                '${order.price} ₸',
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: -0.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Күн белгісіз';
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays == 0) {
      return 'Бүгін';
    } else if (difference.inDays == 1) {
      return 'Кеше';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} күн бұрын';
    } else {
      return '${date.day}.${date.month}.${date.year}';
    }
  }
}