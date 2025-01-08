import 'package:flutter/material.dart';
import 'dart:convert'; // untuk json
import 'package:http/http.dart' as http; // untuk http

// URL API server untuk login dan saldo
const String baseUrl = 'http://website-mini-bank.test/Api-bank.php';

// Fungsi untuk login dan mengambil saldo
Future<Map<String, dynamic>> loginAndGetSaldo(String rekening, String password) async {
  try {
    // Mengirimkan data login ke API
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'rekening': rekening,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      // Login berhasil, mengambil saldo berdasarkan rekening
      final saldoResponse = await http.get(Uri.parse('$baseUrl/saldo/$rekening'));
      if (saldoResponse.statusCode == 200) {
        final saldoData = json.decode(saldoResponse.body);
        return {
          'status': 'success',
          'saldo': double.parse(saldoData['saldo'].toString()),
        };
      } else {
        return {'status': 'error', 'message': 'Gagal mengambil saldo'};
      }
    } else {
      final errorData = json.decode(response.body);
      return {'status': 'error', 'message': errorData['message'] ?? 'Login gagal'};
    }
  } catch (e) {
    return {'status': 'error', 'message': 'Terjadi kesalahan: $e'};
  }
}

class AccountInputPage extends StatefulWidget {
  @override
  _AccountInputPageState createState() => _AccountInputPageState();
}

class _AccountInputPageState extends State<AccountInputPage> {
  final TextEditingController _accountController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _goToHomePage() async {
    if (_accountController.text.isNotEmpty && _passwordController.text.isNotEmpty) {
      final result = await loginAndGetSaldo(_accountController.text, _passwordController.text);

      if (result['status'] == 'success') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(
              accountNumber: _accountController.text,
              saldo: result['saldo'],
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result['message'])));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Silakan masukkan nomor rekening dan sandi.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Masukkan Nomor Rekening',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _accountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Nomor Rekening',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.account_balance),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 110, 168, 235),
              ),
              onPressed: _goToHomePage,
              child: const Text('Masuk'),
            ),
          ],
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  final String accountNumber;
  final double saldo;

  const HomePage({super.key, required this.accountNumber, required this.saldo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BalanceInfoPage(accountNumber: accountNumber, saldo: saldo),
    );
  }
}

class BalanceInfoPage extends StatelessWidget {
  final String accountNumber;
  final double saldo;

  const BalanceInfoPage({super.key, required this.accountNumber, required this.saldo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.asset(
                  'assets/logobca.png',
                  height: 40,
                ),
                const SizedBox(width: 10),
                const Text(
                  'Bank BCA',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              'Selamat datang, $accountNumber',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Saldo Anda:',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            Text(
              'Rp ${saldo.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: AccountInputPage(),
  ));
}
