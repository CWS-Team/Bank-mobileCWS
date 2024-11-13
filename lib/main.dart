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
      home: const AccountInputPage(),
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

  void _goToHomePage() {
    if (_accountController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              HomePage(accountNumber: _accountController.text),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Silakan masukkan nomor rekening dan sandi.')),
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

class HomePage extends StatefulWidget {
  final String accountNumber;
  const HomePage({super.key, required this.accountNumber});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      BalanceInfoPage(accountNumber: widget.accountNumber),
      const HistoryPage(),
      AccountDetailPage(accountNumber: widget.accountNumber),
    ];

    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Riwayat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Akun',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

class BalanceInfoPage extends StatelessWidget {
  final String accountNumber;

  const BalanceInfoPage({super.key, required this.accountNumber});

  @override
  Widget build(BuildContext context) {
    double balance = 5000000.0;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.asset(
                  'asset/logobca.png',
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
              'Rp ${balance.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Implementasikan logika transfer
                  },
                  child: const Text('Transfer'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Implementasikan logika top up
                  },
                  child: const Text('Top Up'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> transactions = [];

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: transactions.isEmpty
            ? const Center(
                child: Text(
                  'Belum ada aktivitas transfer atau top up',
                  style: TextStyle(fontSize: 16),
                ),
              )
            : ListView.builder(
                itemCount: transactions.length,
                itemBuilder: (context, index) {
                  var transaction = transactions[index];
                  return ListTile(
                    title: Text(transaction['type'] ?? ''),
                    subtitle: Text(transaction['date'] ?? ''),
                    trailing: Text(transaction['amount'] ?? ''),
                  );
                },
              ),
      ),
    );
  }
}

class AccountDetailPage extends StatelessWidget {
  final String accountNumber;

  const AccountDetailPage({super.key, required this.accountNumber});

  @override
  Widget build(BuildContext context) {
    String currency = 'IDR';
    String accountType = 'Tabungan';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[800],
        title: const Text("Detail Akun"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Informasi Akun',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            DataTable(
              columns: const [
                DataColumn(label: Text('Informasi')),
                DataColumn(label: Text('Detail')),
              ],
              rows: [
                DataRow(cells: [
                  const DataCell(Text('Nomor Rekening')),
                  DataCell(Text(accountNumber)),
                ]),
                DataRow(cells: [
                  const DataCell(Text('Mata Uang')),
                  DataCell(Text(currency)),
                ]),
                DataRow(cells: [
                  const DataCell(Text('Tipe Akun')),
                  DataCell(Text(accountType)),
                ]),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
