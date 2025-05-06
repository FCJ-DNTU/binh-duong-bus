import 'package:flutter/material.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({Key? key}) : super(key: key);

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _name, _surname, _cardNumber, _securityCode, _expiryDate;
  String _selectedPaymentMethod = 'Card';

  @override
  Widget build(BuildContext context) {
    final Map<String, String> args =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>? ??
            {};
    final String routeName = args['routeName'] ?? 'Unknown Route';
    final String routeNumber = args['routeNumber'] ?? 'Unknown Number';
    final String dateTime = args['dateTime'] ?? 'Unknown Date';
    final String price = args['price'] ?? '0 VND';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leadingWidth: 40,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black, size: 24),
            padding: EdgeInsets.zero,
            onPressed: () => Navigator.pop(context),
          ),
        ),
        title: const Text(
          'Thanh toán',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE3F2FD),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Icon(
                        Icons.directions_bus,
                        color: Color(0xFF0D7FE3),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            routeName,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              color: Color(0xFF212529),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Tuyến $routeNumber',
                            style: const TextStyle(
                              color: Color(0xFF6C757D),
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.access_time,
                                    size: 14,
                                    color: Color(0xFF6C757D),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    dateTime,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Color(0xFF495057),
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                '$price VND',
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF495057),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const Text(
                  'Thông tin thanh toán',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF212529),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildPaymentMethodButton('Pass', Icons.confirmation_number,
                        _selectedPaymentMethod == 'Pass', () {
                      setState(() {
                        _selectedPaymentMethod = 'Pass';
                      });
                    }),
                    _buildPaymentMethodButton('Card', Icons.credit_card,
                        _selectedPaymentMethod == 'Card', () {
                      setState(() {
                        _selectedPaymentMethod = 'Card';
                      });
                    }),
                    _buildPaymentMethodButton('G Pay', Icons.payment,
                        _selectedPaymentMethod == 'G Pay', () {
                      setState(() {
                        _selectedPaymentMethod = 'G Pay';
                      });
                    }),
                    _buildPaymentMethodButton('Apple Pay', Icons.apple,
                        _selectedPaymentMethod == 'Apple Pay', () {
                      setState(() {
                        _selectedPaymentMethod = 'Apple Pay';
                      });
                    }),
                  ],
                ),
                const SizedBox(height: 24),
                if (_selectedPaymentMethod == 'Card') ...[
                  const Text(
                    'Tên:',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF6C757D),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    decoration: const InputDecoration(
                      hintText: 'Nam',
                      hintStyle: TextStyle(color: Color(0xFF6C757D)),
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    validator: (value) =>
                        value!.isEmpty ? 'Vui lòng nhập tên' : null,
                    onSaved: (value) => _name = value,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Họ:',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF6C757D),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    decoration: const InputDecoration(
                      hintText: 'Nguyễn',
                      hintStyle: TextStyle(color: Color(0xFF6C757D)),
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    validator: (value) =>
                        value!.isEmpty ? 'Vui lòng nhập họ' : null,
                    onSaved: (value) => _surname = value,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Số thẻ tín dụng:',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF6C757D),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: '1234 1234 1234 1234',
                      hintStyle: const TextStyle(color: Color(0xFF6C757D)),
                      border: const OutlineInputBorder(),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      suffixIcon: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.credit_card,
                                color: Colors.orange, size: 24),
                            const SizedBox(width: 4),
                            Icon(Icons.circle, color: Colors.red, size: 12),
                            Icon(Icons.circle, color: Colors.orange, size: 12),
                          ],
                        ),
                      ),
                    ),
                    validator: (value) =>
                        value!.isEmpty ? 'Vui lòng nhập số thẻ' : null,
                    onSaved: (value) => _cardNumber = value,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Mã bảo mật',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF6C757D),
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              decoration: const InputDecoration(
                                hintText: 'CVC',
                                hintStyle: TextStyle(color: Color(0xFF6C757D)),
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                                suffixIcon: Icon(Icons.help_outline,
                                    color: Color(0xFF6C757D), size: 20),
                              ),
                              validator: (value) => value!.isEmpty
                                  ? 'Vui lòng nhập mã bảo mật'
                                  : null,
                              onSaved: (value) => _securityCode = value,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Ngày hết hạn của thẻ',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF6C757D),
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              decoration: const InputDecoration(
                                hintText: 'MM / YY',
                                hintStyle: TextStyle(color: Color(0xFF6C757D)),
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                                suffixIcon: Icon(Icons.help_outline,
                                    color: Color(0xFF6C757D), size: 20),
                              ),
                              validator: (value) => value!.isEmpty
                                  ? 'Vui lòng nhập ngày hết hạn'
                                  : null,
                              onSaved: (value) => _expiryDate = value,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                ],
                ElevatedButton(
                  onPressed: () {
                    if (_selectedPaymentMethod == 'Card') {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Thanh toán thành công!')),
                        );
                        Navigator.pop(context);
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(
                                'Thanh toán bằng $_selectedPaymentMethod thành công!')),
                      );
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text(
                    'Thanh toán',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentMethodButton(
      String label, IconData icon, bool isSelected, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? Colors.blue.shade50 : Colors.grey.shade100,
            border: Border.all(
              color: isSelected ? Colors.blue : Colors.grey.shade300,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: isSelected ? Colors.blue : Colors.grey,
                size: 24,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: isSelected ? Colors.blue : Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
