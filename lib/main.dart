import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bank BCA Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const AccountInputPage(),
    const BalanceInfoPage(accountNumber: '123456789'), // Contoh nomor akun
    const TransferPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: 'Saldo',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.swap_horiz),
            label: 'Transfer',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

class AccountInputPage extends StatefulWidget {
  const AccountInputPage({super.key});

  @override
  State<AccountInputPage> createState() => _AccountInputPageState();
}

class _AccountInputPageState extends State<AccountInputPage> {
  final TextEditingController _accountController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _goToBalancePage() {
    if (_accountController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              BalanceInfoPage(accountNumber: _accountController.text),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please enter your account number and password.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[800],
        title: Row(
          children: [
            Image.asset(
              'asset/logo-klikbca.jpg',
              height: 40,
            ),
            const SizedBox(width: 10),
            const Text("Bank BCA"),
          ],
        ),
      ),
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
              onPressed: _goToBalancePage,
              child: const Text('Masuk'),
            ),
          ],
        ),
      ),
    );
  }
}

class BalanceInfoPage extends StatelessWidget {
  final String accountNumber;

  const BalanceInfoPage({super.key, required this.accountNumber});

  void _goToBalanceDetailPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BalanceDetailPage(accountNumber: accountNumber),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double balance = 5000000.0;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[800],
        title: const Text("Informasi Saldo"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nomor Rekening: $accountNumber',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              'Saldo Anda:',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            Text(
              'Rp ${balance.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _goToBalanceDetailPage(context),
              child: const Text('Lihat Detail Saldo'),
            ),
          ],
        ),
      ),
    );
  }
}

class BalanceDetailPage extends StatelessWidget {
  final String accountNumber;

  const BalanceDetailPage({super.key, required this.accountNumber});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[800],
        title: const Text("Detail Informasi Saldo"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DataTable(
              columns: const [
                DataColumn(label: Text('Informasi')),
                DataColumn(label: Text('Detail')),
              ],
              rows: const [
                DataRow(cells: [
                  DataCell(Text('Saldo Utama')),
                  DataCell(Text('Rp 5,000,000')),
                ]),
                DataRow(cells: [
                  DataCell(Text('Penarikan Terakhir')),
                  DataCell(Text('Rp 1,000,000')),
                ]),
                DataRow(cells: [
                  DataCell(Text('Transaksi Terbaru')),
                  DataCell(Text('Rp 500,000')),
                ]),
                DataRow(cells: [
                  DataCell(Text('Bunga Bulanan')),
                  DataCell(Text('Rp 50,000')),
                ]),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class TransferPage extends StatefulWidget {
  const TransferPage({super.key});

  @override
  State<TransferPage> createState() => _TransferPageState();
}

class _TransferPageState extends State<TransferPage> {
  final TextEditingController _recipientController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  String _selectedBank = 'BCA';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 87, 155, 234),
        title: const Text('Transfer'),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Bank Tujuan',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: _selectedBank,
              items: ['BCA', 'Mandiri', 'BNI', 'BRI']
                  .map((bank) => DropdownMenuItem<String>(
                        value: bank,
                        child: Text(bank),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedBank = value!;
                });
              },
              decoration: InputDecoration(
                hintText: 'Pilih bank tujuan',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Nomor Rekening Tujuan',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _recipientController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Masukkan nomor rekening',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Jumlah Transfer',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Masukkan jumlah',
                prefixText: 'Rp ',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                // Implementasikan logika transfer di sini
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[800],
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Transfer Sekarang',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
