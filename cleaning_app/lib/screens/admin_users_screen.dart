// // screens/admin_users_screen.dart
// import 'package:flutter/material.dart';
// import '../models/user_model.dart';
// import '../services/api_service.dart';

// class AdminUsersScreen extends StatefulWidget {
//   const AdminUsersScreen({super.key});

//   @override
//   State<AdminUsersScreen> createState() => _AdminUsersScreenState();
// }

// class _AdminUsersScreenState extends State<AdminUsersScreen> {
//   List<UserModel> _users = [];
//   bool _loading = true;

//   @override
//   void initState() {
//     super.initState();
//     _fetch();
//   }

//   Future<void> _fetch() async {
//     try {
//       final users = await ApiService.adminGetUsers();
//       setState(() {
//         _users = users;
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

//   @override
//   Widget build(BuildContext context) {
//     if (_loading) {
//       return const Center(
//         child: CircularProgressIndicator(color: Color(0xFFFFD700)),
//       );
//     }
//     return RefreshIndicator(
//       onRefresh: _fetch,
//       child: _users.isEmpty
//           ? const Center(child: Text('Қолданушылар жоқ'))
//           : ListView.builder(
//               padding: const EdgeInsets.all(16),
//               itemCount: _users.length,
//               itemBuilder: (_, i) {
//                 final u = _users[i];
//                 return Card(
//                   margin: const EdgeInsets.only(bottom: 12),
//                   child: ListTile(
//                     contentPadding: const EdgeInsets.all(16),
//                     leading: CircleAvatar(
//                       radius: 25,
//                       backgroundColor: _getRoleColor(u.role),
//                       child: Text(
//                         u.name[0].toUpperCase(),
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontWeight: FontWeight.bold,
//                           fontSize: 20,
//                         ),
//                       ),
//                     ),
//                     title: Text(
//                       u.name,
//                       style: const TextStyle(fontWeight: FontWeight.w600),
//                     ),
//                     subtitle: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const SizedBox(height: 4),
//                         Text(u.email),
//                         const SizedBox(height: 2),
//                         Text(u.phone),
//                       ],
//                     ),
//                     trailing: Container(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 12,
//                         vertical: 4,
//                       ),
//                       decoration: BoxDecoration(
//                         color: _getRoleColor(u.role).withOpacity(0.1),
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Icon(
//                             _getRoleIcon(u.role),
//                             size: 16,
//                             color: _getRoleColor(u.role),
//                           ),
//                           const SizedBox(width: 4),
//                           Text(
//                             u.role,
//                             style: TextStyle(
//                               color: _getRoleColor(u.role),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//     );
//   }

//   Color _getRoleColor(String role) {
//     switch (role) {
//       case 'admin':
//         return Colors.red;
//       case 'cleaner':
//         return Colors.green;
//       case 'client':
//         return Colors.blue;
//       default:
//         return Colors.grey;
//     }
//   }

//   IconData _getRoleIcon(String role) {
//     switch (role) {
//       case 'admin':
//         return Icons.admin_panel_settings;
//       case 'cleaner':
//         return Icons.cleaning_services;
//       case 'client':
//         return Icons.person;
//       default:
//         return Icons.person;
//     }
//   }
// }


// screens/admin/admin_users_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';

class AdminUsersScreen extends StatefulWidget {
  const AdminUsersScreen({super.key});

  @override
  State<AdminUsersScreen> createState() => _AdminUsersScreenState();
}

class _AdminUsersScreenState extends State<AdminUsersScreen> with SingleTickerProviderStateMixin {
  List<UserModel> _users = [];
  bool _loading = true;
  late AnimationController _animCtrl;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _fadeAnim = CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut);
    _animCtrl.forward();
    _fetch();
  }

  Future<void> _fetch() async {
    try {
      final users = await ApiService.adminGetUsers();
      setState(() {
        _users = users;
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
      child: _users.isEmpty
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
                      Icons.people_outline,
                      size: 60,
                      color: const Color(0xFF3949AB).withAlpha(128),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Қолданушылар жоқ',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1A237E).withAlpha(179),
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _users.length,
              itemBuilder: (context, index) {
                final user = _users[index];
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
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      leading: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [_getRoleColor(user.role), _getRoleColor(user.role).withAlpha(179)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: _getRoleColor(user.role).withAlpha(40),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 28,
                          backgroundColor: Colors.transparent,
                          child: Text(
                            user.name[0].toUpperCase(),
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 24,
                            ),
                          ),
                        ),
                      ),
                      title: Text(
                        user.name,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF1A237E),
                          letterSpacing: -0.5,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Icon(Icons.email_outlined, size: 14, color: Colors.grey.withAlpha(128)),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  user.email,
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey.withAlpha(128),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.phone_outlined, size: 14, color: Colors.grey.withAlpha(128)),
                              const SizedBox(width: 6),
                              Text(
                                user.phone,
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey.withAlpha(128),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: _getRoleColor(user.role).withAlpha(20),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: _getRoleColor(user.role).withAlpha(40), width: 1),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _getRoleIcon(user.role),
                              size: 16,
                              color: _getRoleColor(user.role),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              _getRoleName(user.role),
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: _getRoleColor(user.role),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }

  String _getRoleName(String role) {
    switch (role) {
      case 'admin': return 'Админ';
      case 'cleaner': return 'Клинер';
      case 'client': return 'Клиент';
      default: return role;
    }
  }

  Color _getRoleColor(String role) {
    switch (role) {
      case 'admin':
        return const Color(0xFFF44336);
      case 'cleaner':
        return const Color(0xFF4CAF50);
      case 'client':
        return const Color(0xFF2196F3);
      default:
        return Colors.grey;
    }
  }

  IconData _getRoleIcon(String role) {
    switch (role) {
      case 'admin':
        return Icons.admin_panel_settings;
      case 'cleaner':
        return Icons.cleaning_services;
      case 'client':
        return Icons.person;
      default:
        return Icons.person;
    }
  }
}