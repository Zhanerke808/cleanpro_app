// // screens/chat_screen.dart
// import 'dart:async';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import '../config/app_theme.dart';
// import '../services/api_service.dart';

// class ChatScreen extends StatefulWidget {
//   final String orderId;
//   final String orderDescription;
//   final String chatPartner;

//   const ChatScreen({
//     super.key,
//     required this.orderId,
//     required this.orderDescription,
//     required this.chatPartner,
//   });

//   @override
//   State<ChatScreen> createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> {
//   final _msgCtrl = TextEditingController();
//   final _scrollCtrl = ScrollController();
//   final _focusNode = FocusNode();
//   List<Map<String, dynamic>> _messages = [];
//   bool _loading = true;
//   bool _sending = false;
//   Timer? _timer;
//   String _receiverId = '';

//   String get _baseUrl => 'http://192.168.1.67:3000/api';

//   @override
//   void initState() {
//     super.initState();
//     _loadReceiverAndFetch();
//     _timer = Timer.periodic(const Duration(seconds: 2), (_) => _fetchMessages());
//   }

//   Future<void> _loadReceiverAndFetch() async {
//     await _loadReceiverInfo();
//     await _fetchMessages();
//   }

//   Future<void> _loadReceiverInfo() async {
//     try {
//       final user = FirebaseAuth.instance.currentUser;
//       if (user == null) return;

//       // Алдымен клиент тапсырыстарынан іздеу
//       try {
//         final headers = await _authHeaders();
//         final res = await http.get(Uri.parse('$_baseUrl/orders/my'), headers: headers);
//         if (res.statusCode == 200) {
//           final List orders = jsonDecode(res.body);
//           final order = orders.firstWhere((o) => o['id'] == widget.orderId);
//           setState(() {
//             _receiverId = user.uid == order['clientId'] ? (order['cleanerId'] ?? '') : order['clientId'];
//           });
//           return;
//         }
//       } catch (_) {}

//       // Клинер тапсырыстарынан іздеу
//       try {
//         final headers = await _authHeaders();
//         final res = await http.get(Uri.parse('$_baseUrl/orders/accepted'), headers: headers);
//         if (res.statusCode == 200) {
//           final List orders = jsonDecode(res.body);
//           final order = orders.firstWhere((o) => o['id'] == widget.orderId);
//           setState(() {
//             _receiverId = user.uid == order['cleanerId'] ? order['clientId'] : (order['cleanerId'] ?? '');
//           });
//         }
//       } catch (_) {}
//     } catch (e) {
//       // ignore
//     }
//   }

//   Future<String> _getIdToken() async {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user == null) throw Exception('Кірмеген');
//     return await user.getIdToken() ?? '';
//   }

//   Future<Map<String, String>> _authHeaders() async {
//     final token = await _getIdToken();
//     return {
//       'Authorization': 'Bearer $token',
//       'Content-Type': 'application/json',
//     };
//   }

//   Future<void> _fetchMessages() async {
//     try {
//       final headers = await _authHeaders();
//       final res = await http.get(
//         Uri.parse('$_baseUrl/messages/${widget.orderId}'),
//         headers: headers,
//       );
//       if (res.statusCode == 200) {
//         final List data = jsonDecode(res.body);
//         if (mounted) {
//           setState(() {
//             _messages = data.map((e) => Map<String, dynamic>.from(e)).toList();
//             _loading = false;
//           });
//           _scrollToBottom();
//         }
//       }
//     } catch (e) {
//       if (mounted) setState(() => _loading = false);
//     }
//   }

//   Future<void> _sendMessage() async {
//     final text = _msgCtrl.text.trim();
//     if (text.isEmpty || _sending) return;

//     setState(() => _sending = true);
//     try {
//       final headers = await _authHeaders();
//       await http.post(
//         Uri.parse('$_baseUrl/messages'),
//         headers: headers,
//         body: jsonEncode({
//           'orderId': widget.orderId,
//           'receiverId': _receiverId,
//           'text': text,
//         }),
//       );
//       _msgCtrl.clear();
//       _focusNode.requestFocus();
//       await _fetchMessages();
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Қате: $e')),
//         );
//       }
//     } finally {
//       if (mounted) setState(() => _sending = false);
//     }
//   }

//   void _scrollToBottom() {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (_scrollCtrl.hasClients) {
//         _scrollCtrl.animateTo(
//           _scrollCtrl.position.maxScrollExtent,
//           duration: const Duration(milliseconds: 300),
//           curve: Curves.easeOut,
//         );
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _msgCtrl.dispose();
//     _scrollCtrl.dispose();
//     _focusNode.dispose();
//     _timer?.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final currentUser = FirebaseAuth.instance.currentUser;

//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back_ios, color: AppTheme.gold),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: Column(
//           children: [
//             Text(
//               widget.chatPartner,
//               style: GoogleFonts.montserrat(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white),
//             ),
//             Text(
//               widget.orderDescription,
//               style: GoogleFonts.montserrat(fontSize: 11, color: Colors.white38),
//               maxLines: 1,
//               overflow: TextOverflow.ellipsis,
//             ),
//           ],
//         ),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: _loading
//                 ? Center(child: CircularProgressIndicator(color: AppTheme.gold))
//                 : _messages.isEmpty
//                     ? Center(
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Icon(Icons.chat_outlined, size: 64, color: Colors.white.withAlpha(20)),
//                             const SizedBox(height: 16),
//                             Text('Хабарламалар жоқ', style: GoogleFonts.montserrat(fontSize: 14, color: Colors.white38)),
//                             const SizedBox(height: 8),
//                             Text('Бірінші хабарламаны жазыңыз', style: GoogleFonts.montserrat(fontSize: 12, color: Colors.white24)),
//                           ],
//                         ),
//                       )
//                     : ListView.builder(
//                         controller: _scrollCtrl,
//                         padding: const EdgeInsets.all(16),
//                         itemCount: _messages.length,
//                         itemBuilder: (_, i) {
//                           final msg = _messages[i];
//                           final isMe = msg['senderId'] == currentUser?.uid;
//                           return _buildMessageBubble(msg, isMe);
//                         },
//                       ),
//           ),
//           Container(
//             padding: const EdgeInsets.all(12),
//             decoration: BoxDecoration(
//               color: AppTheme.surface,
//               border: Border(top: BorderSide(color: Colors.white.withAlpha(10))),
//             ),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: _msgCtrl,
//                     focusNode: _focusNode,
//                     style: GoogleFonts.montserrat(color: Colors.white),
//                     decoration: InputDecoration(
//                       hintText: 'Хабарлама жазыңыз...',
//                       hintStyle: GoogleFonts.montserrat(color: Colors.white38),
//                       filled: true,
//                       fillColor: Colors.white.withAlpha(8),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(25),
//                         borderSide: BorderSide.none,
//                       ),
//                       contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 GestureDetector(
//                   onTap: _sending ? null : _sendMessage,
//                   child: Container(
//                     width: 48,
//                     height: 48,
//                     decoration: BoxDecoration(
//                       color: _sending ? AppTheme.gold.withAlpha(100) : AppTheme.gold,
//                       shape: BoxShape.circle,
//                     ),
//                     child: _sending
//                         ? const SizedBox(
//                             width: 22,
//                             height: 22,
//                             child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black),
//                           )
//                         : const Icon(Icons.send_rounded, color: Colors.black, size: 22),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildMessageBubble(Map<String, dynamic> msg, bool isMe) {
//     String timeStr = '';
//     if (msg['createdAt'] != null) {
//       try {
//         final dt = DateTime.parse(msg['createdAt'].toString());
//         timeStr = '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
//       } catch (_) {}
//     }

//     return Align(
//       alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
//       child: Container(
//         margin: const EdgeInsets.only(bottom: 12),
//         constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//         decoration: BoxDecoration(
//           color: isMe ? AppTheme.gold.withAlpha(25) : AppTheme.surface,
//           borderRadius: BorderRadius.only(
//             topLeft: const Radius.circular(18),
//             topRight: const Radius.circular(18),
//             bottomLeft: isMe ? const Radius.circular(18) : const Radius.circular(4),
//             bottomRight: isMe ? const Radius.circular(4) : const Radius.circular(18),
//           ),
//           border: Border.all(color: isMe ? AppTheme.gold.withAlpha(50) : Colors.white.withAlpha(10)),
//         ),
//         child: Column(
//           crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
//           children: [
//             Text(msg['text'] ?? '', style: GoogleFonts.montserrat(fontSize: 14, color: Colors.white)),
//             if (timeStr.isNotEmpty) ...[
//               const SizedBox(height: 4),
//               Text(timeStr, style: GoogleFonts.montserrat(fontSize: 10, color: Colors.white38)),
//             ],
//           ],
//         ),
//       ),
//     );
//   }
// }// screens/chat_screen.dart
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config/app_theme.dart';
import '../services/api_service.dart';

class ChatScreen extends StatefulWidget {
  final String orderId;
  final String orderDescription;
  final String chatPartner;

  const ChatScreen({
    super.key,
    required this.orderId,
    required this.orderDescription,
    required this.chatPartner,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _msgCtrl = TextEditingController();
  final _scrollCtrl = ScrollController();
  final _focusNode = FocusNode();
  List<Map<String, dynamic>> _messages = [];
  bool _loading = true;
  bool _sending = false;
  Timer? _timer;
  String _receiverId = '';

  String get _baseUrl => 'http://localhost:3000/api';

  @override
  void initState() {
    super.initState();
    _loadReceiverAndFetch();
    _timer = Timer.periodic(const Duration(seconds: 2), (_) => _fetchMessages());
  }

  Future<void> _loadReceiverAndFetch() async {
    await _loadReceiverInfo();
    await _fetchMessages();
  }

  Future<void> _loadReceiverInfo() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;
      try {
        final headers = await _authHeaders();
        final res = await http.get(Uri.parse('$_baseUrl/orders/my'), headers: headers);
        if (res.statusCode == 200) {
          final List orders = jsonDecode(res.body);
          final order = orders.firstWhere((o) => o['id'] == widget.orderId);
          setState(() { _receiverId = user.uid == order['clientId'] ? (order['cleanerId'] ?? '') : order['clientId']; });
          return;
        }
      } catch (_) {}
      try {
        final headers = await _authHeaders();
        final res = await http.get(Uri.parse('$_baseUrl/orders/accepted'), headers: headers);
        if (res.statusCode == 200) {
          final List orders = jsonDecode(res.body);
          final order = orders.firstWhere((o) => o['id'] == widget.orderId);
          setState(() { _receiverId = user.uid == order['cleanerId'] ? order['clientId'] : (order['cleanerId'] ?? ''); });
        }
      } catch (_) {}
    } catch (e) {}
  }

  Future<String> _getIdToken() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('Кірмеген');
    return await user.getIdToken() ?? '';
  }

  Future<Map<String, String>> _authHeaders() async {
    return {'Authorization': 'Bearer ${await _getIdToken()}', 'Content-Type': 'application/json'};
  }

  Future<void> _fetchMessages() async {
    try {
      final headers = await _authHeaders();
      final res = await http.get(Uri.parse('$_baseUrl/messages/${widget.orderId}'), headers: headers);
      if (res.statusCode == 200) {
        final List data = jsonDecode(res.body);
        if (mounted) { setState(() { _messages = data.map((e) => Map<String, dynamic>.from(e)).toList(); _loading = false; }); _scrollToBottom(); }
      }
    } catch (e) {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _sendMessage() async {
    final text = _msgCtrl.text.trim();
    if (text.isEmpty || _sending) return;
    setState(() => _sending = true);
    try {
      final headers = await _authHeaders();
      await http.post(Uri.parse('$_baseUrl/messages'), headers: headers, body: jsonEncode({'orderId': widget.orderId, 'receiverId': _receiverId, 'text': text}));
      _msgCtrl.clear(); _focusNode.requestFocus(); await _fetchMessages();
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(_buildErrorSnackBar('Қате: $e'));
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollCtrl.hasClients) _scrollCtrl.animateTo(_scrollCtrl.position.maxScrollExtent, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
    });
  }

  @override
  void dispose() {
    _msgCtrl.dispose(); _scrollCtrl.dispose(); _focusNode.dispose(); _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1A237E),
        leading: Container(
          margin: const EdgeInsets.only(left: 8),
          decoration: BoxDecoration(
            color: const Color(0xFF3949AB).withAlpha(20),
            borderRadius: BorderRadius.circular(30),
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF3949AB), size: 20),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        title: Column(
          children: [
            Text(
              widget.chatPartner,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF1A237E),
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              widget.orderDescription,
              style: GoogleFonts.poppins(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: Colors.grey.withAlpha(128),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            color: Colors.grey.withAlpha(30),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: _loading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF3949AB),
                      strokeWidth: 3,
                    ),
                  )
                : _messages.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [const Color(0xFF3949AB).withAlpha(30), const Color(0xFF3949AB).withAlpha(10)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Icon(
                                Icons.chat_outlined,
                                size: 50,
                                color: const Color(0xFF3949AB).withAlpha(128),
                              ),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              'Хабарламалар жоқ',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF1A237E).withAlpha(179),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Бірінші хабарламаны жазыңыз',
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey.withAlpha(128),
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        controller: _scrollCtrl,
                        padding: const EdgeInsets.all(16),
                        itemCount: _messages.length,
                        itemBuilder: (context, index) {
                          final msg = _messages[index];
                          final isMe = msg['senderId'] == currentUser?.uid;
                          return _buildMessageBubble(msg, isMe);
                        },
                      ),
          ),
          // Төменгі панель
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(15),
                  blurRadius: 20,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFE),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.grey.withAlpha(30), width: 1),
                    ),
                    child: TextField(
                      controller: _msgCtrl,
                      focusNode: _focusNode,
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        color: const Color(0xFF1A237E),
                      ),
                      decoration: InputDecoration(
                        hintText: 'Хабарлама жазыңыз...',
                        hintStyle: GoogleFonts.poppins(
                          color: Colors.grey.withAlpha(128),
                          fontSize: 13,
                        ),
                        filled: true,
                        fillColor: const Color(0xFFF8FAFE),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: _sending ? null : _sendMessage,
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      gradient: _sending
                          ? LinearGradient(
                              colors: [Colors.grey.withAlpha(102), Colors.grey.withAlpha(153)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            )
                          : const LinearGradient(
                              colors: [Color(0xFF3949AB), Color(0xFF5C6BC0)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        if (!_sending)
                          BoxShadow(
                            color: const Color(0xFF3949AB).withAlpha(40),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                      ],
                    ),
                    child: _sending
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.send_rounded, color: Colors.white, size: 22),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(Map<String, dynamic> msg, bool isMe) {
    String timeStr = '';
    if (msg['createdAt'] != null) {
      try {
        final dt = DateTime.parse(msg['createdAt'].toString());
        timeStr = '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
      } catch (_) {}
    }

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(isMe ? 20 * (1 - value) : -20 * (1 - value), 0),
            child: child,
          ),
        );
      },
      child: Align(
        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          decoration: BoxDecoration(
            gradient: isMe
                ? const LinearGradient(
                    colors: [Color(0xFF3949AB), Color(0xFF5C6BC0)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : const LinearGradient(
                    colors: [Colors.white, Color(0xFFF8FAFE)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(20),
              topRight: const Radius.circular(20),
              bottomLeft: isMe ? const Radius.circular(20) : const Radius.circular(6),
              bottomRight: isMe ? const Radius.circular(6) : const Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(8),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Text(
                msg['text'] ?? '',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isMe ? Colors.white : const Color(0xFF1A237E),
                ),
              ),
              if (timeStr.isNotEmpty) ...[
                const SizedBox(height: 6),
                Text(
                  timeStr,
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: isMe ? Colors.white.withAlpha(179) : Colors.grey.withAlpha(128),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
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
}