// screens/client/create_order_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../config/app_theme.dart';
import '../../config/app_constants.dart';
import '../../services/api_service.dart';

class CreateOrderScreen extends StatefulWidget {
  const CreateOrderScreen({super.key});

  @override
  State<CreateOrderScreen> createState() => _CreateOrderScreenState();
}

class _CreateOrderScreenState extends State<CreateOrderScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _addressCtrl = TextEditingController();
  final _entranceCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _commentCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  String? _selectedType, _selectedRooms;
  int _currentStep = 0;
  bool _loading = false;
  late AnimationController _animCtrl;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _fadeAnim = CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut);
    _animCtrl.forward();
  }

  Future<void> _createOrder() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      await ApiService.createOrder(
        description: '${AppConstants.cleaningTypes.firstWhere((e) => e['id'] == _selectedType)['name']} - ${_selectedRooms ?? 'Бөлме'}',
        address: _addressCtrl.text.trim(),
        entrance: _entranceCtrl.text.trim(),
        comment: _commentCtrl.text.trim(),
        phone: _phoneCtrl.text.trim(),
        price: double.parse(_priceCtrl.text.trim()),
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: const Color(0xFF4CAF50),
          content: Row(
            children: const [
              Icon(Icons.check_circle_outline, color: Colors.white, size: 22),
              SizedBox(width: 12),
              Text('Тапсырыс сәтті жіберілді!', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
            ],
          ),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          duration: const Duration(seconds: 2),
        ),
      );
      _clearForm();
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(
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
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _clearForm() {
    _addressCtrl.clear(); _entranceCtrl.clear(); _phoneCtrl.clear(); _commentCtrl.clear(); _priceCtrl.clear();
    setState(() { _selectedType = null; _selectedRooms = null; _currentStep = 0; });
  }

  void _selectType(String id) {
    final type = AppConstants.cleaningTypes.firstWhere((e) => e['id'] == id);
    setState(() { _selectedType = id; _priceCtrl.text = type['basePrice'].toString(); _currentStep = 1; });
  }

  @override
  void dispose() {
    _addressCtrl.dispose(); _entranceCtrl.dispose(); _phoneCtrl.dispose(); _commentCtrl.dispose(); _priceCtrl.dispose(); _animCtrl.dispose();
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
      child: FadeTransition(
        opacity: _fadeAnim,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStepIndicator(),
                const SizedBox(height: 24),
                if (_currentStep == 0) _buildTypeSelection(),
                if (_currentStep == 1) _buildDetailsForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStepIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          _stepDot(0, 'Тазалау түрі'),
          Expanded(
            child: Container(
              height: 2,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: _currentStep >= 1 
                      ? [const Color(0xFF3949AB), const Color(0xFF5C6BC0)]
                      : [const Color(0xFFE8ECF1), const Color(0xFFE8ECF1)],
                ),
              ),
            ),
          ),
          _stepDot(1, 'Мәліметтер'),
        ],
      ),
    );
  }

  Widget _stepDot(int step, String label) {
    final active = _currentStep >= step;
    final isCurrent = _currentStep == step;
    return Column(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            gradient: active
                ? const LinearGradient(
                    colors: [Color(0xFF3949AB), Color(0xFF5C6BC0)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            color: active ? null : const Color(0xFFF8FAFE),
            shape: BoxShape.circle,
            border: Border.all(
              color: active ? Colors.transparent : Colors.grey.withAlpha(51),
              width: 1.5,
            ),
            boxShadow: active && isCurrent
                ? [BoxShadow(color: const Color(0xFF3949AB).withAlpha(40), blurRadius: 12, spreadRadius: 2)]
                : null,
          ),
          child: Center(
            child: Text(
              '${step + 1}',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: active ? Colors.white : Colors.grey.withAlpha(128),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: active ? const Color(0xFF3949AB) : Colors.grey.withAlpha(128),
          ),
        ),
      ],
    );
  }

  Widget _buildTypeSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Тазалау түрін таңдаңыз',
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF1A237E),
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Әр түрдің базалық бағасы көрсетілген',
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey.withAlpha(153),
          ),
        ),
        const SizedBox(height: 24),
        ...AppConstants.cleaningTypes.map((type) => _buildTypeCard(type)),
      ],
    );
  }

  Widget _buildTypeCard(Map<String, dynamic> type) {
    final selected = _selectedType == type['id'];
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 300),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.scale(
            scale: 0.95 + (value * 0.05),
            child: child,
          ),
        );
      },
      child: GestureDetector(
        onTap: () => _selectType(type['id']),
        child: Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: selected ? const Color(0xFF3949AB).withAlpha(10) : Colors.white,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: selected ? const Color(0xFF3949AB) : Colors.grey.withAlpha(30),
              width: selected ? 2 : 1,
            ),
            boxShadow: selected
                ? [BoxShadow(color: const Color(0xFF3949AB).withAlpha(30), blurRadius: 20, spreadRadius: 2)]
                : [BoxShadow(color: Colors.black.withAlpha(8), blurRadius: 15, offset: const Offset(0, 4))],
          ),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: selected
                        ? [const Color(0xFF3949AB), const Color(0xFF5C6BC0)]
                        : [const Color(0xFF3949AB).withAlpha(20), const Color(0xFF5C6BC0).withAlpha(20)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    type['icon']!,
                    style: const TextStyle(fontSize: 32),
                  ),
                ),
              ),
              const SizedBox(width:  20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      type['name']!,
                      style: GoogleFonts.poppins(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF1A237E),
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '~${type['duration']}',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.withAlpha(128),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${type['basePrice']} ₸',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFFFFD700),
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'бастап',
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.withAlpha(128),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailsForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF3949AB), Color(0xFF5C6BC0)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(30),
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18),
                onPressed: () => setState(() => _currentStep = 0),
                padding: const EdgeInsets.all(10),
              ),
            ),
            Text(
              'Мәліметтерді толтырыңыз',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF1A237E),
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 28),
        _buildDropdown('Бөлме саны', AppConstants.roomTypes, _selectedRooms, (v) => setState(() => _selectedRooms = v)),
        const SizedBox(height: 20),
        _buildTextField(_addressCtrl, 'Мекен-жай', Icons.location_on_outlined, validator: true),
        const SizedBox(height: 20),
        _buildTextField(_entranceCtrl, 'Подъезд / Қабат', Icons.apartment_outlined),
        const SizedBox(height: 20),
        _buildTextField(_phoneCtrl, 'Байланыс телефоны', Icons.phone_outlined, keyboardType: TextInputType.phone, validator: true),
        const SizedBox(height: 20),
        _buildTextField(_commentCtrl, 'Қосымша түсініктеме', Icons.comment_outlined, maxLines: 3),
        const SizedBox(height: 20),
        _buildTextField(_priceCtrl, 'Бағасы (теңге)', Icons.monetization_on_outlined, keyboardType: TextInputType.number, validator: true),
        const SizedBox(height: 36),
        _loading
            ? Center(
                child: Container(
                  height: 56,
                  child: const CircularProgressIndicator(
                    color: Color(0xFF3949AB),
                    strokeWidth: 3,
                  ),
                ),
              )
            : SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _createOrder,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: const Color(0xFF3949AB),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                    textStyle: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                    ),
                    shadowColor: const Color(0xFF3949AB).withAlpha(100),
                  ),
                  child: const Text('ЖАРИЯЛАУ'),
                ),
              ),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon, {
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    bool validator = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(10),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        style: GoogleFonts.poppins(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: const Color(0xFF1A237E),
        ),
        decoration: InputDecoration(
          hintText: label,
          hintStyle: GoogleFonts.poppins(
            color: Colors.grey.withAlpha(128),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          prefixIcon: Container(
            margin: const EdgeInsets.only(right: 8),
            child: Icon(icon, color: const Color(0xFF3949AB), size: 22),
          ),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24),
            borderSide: BorderSide(color: Colors.grey.withAlpha(50), width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24),
            borderSide: const BorderSide(color: Color(0xFF3949AB), width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
        ),
        validator: validator ? (v) => v!.isEmpty ? 'Міндетті' : null : null,
      ),
    );
  }

  Widget _buildDropdown(String label, List<String> items, String? value, Function(String?) onChanged) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(10),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.grey.withAlpha(50), width: 1),
        ),
        child: DropdownButtonFormField<String>(
          value: value,
          dropdownColor: Colors.white,
          icon: Icon(Icons.keyboard_arrow_down_rounded, color: const Color(0xFF3949AB), size: 28),
          style: GoogleFonts.poppins(
            color: const Color(0xFF1A237E),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            labelText: label,
            labelStyle: GoogleFonts.poppins(
              color: Colors.grey.withAlpha(128),
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            prefixIcon: Container(
              margin: const EdgeInsets.only(right: 8),
              child: Icon(Icons.house_outlined, color: const Color(0xFF3949AB), size: 22),
            ),
          ),
          items: items.map((e) => DropdownMenuItem(value: e, child: Text(e, style: GoogleFonts.poppins(fontSize: 14)))).toList(),
          onChanged: onChanged,
          validator: (v) => v == null ? 'Таңдаңыз' : null,
        ),
      ),
    );
  }
}