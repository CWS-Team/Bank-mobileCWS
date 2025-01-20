import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const BankingApp());
}

class BankingApp extends StatelessWidget {
  const BankingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bank',
      themeMode: ThemeMode.system,
      theme: ThemeData.light().copyWith(
        primaryColor: Colors.blue,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        primaryColor: Colors.black,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black87,
          foregroundColor: Colors.white,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey,
        ),
      ),
      home: const NavigationScreen(),
    );
  }
}

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const AccountInfoScreen(),
    const TransferFundsScreen(),
    const TransactionsScreen(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _screens[_currentIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance),
            label: 'Info Akun',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.send),
            label: 'Transfer',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt),
            label: 'Riwayat',
          ),
        ],
      ),
    );
  }
}

class AccountInfoScreen extends StatefulWidget {
  const AccountInfoScreen({super.key});

  @override
  State<AccountInfoScreen> createState() => _AccountInfoScreenState();
}

class _AccountInfoScreenState extends State<AccountInfoScreen> {
  late http.Client _client;
  List<dynamic> _accounts = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _client = http.Client();
    fetchAccountData();
  }

  @override
  void dispose() {
    _client.close();
    super.dispose();
  }

  Future<void> fetchAccountData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response =
          await _client.get(Uri.parse('https://baruna.web.id/API.php'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _accounts = data['data']; // Sesuaikan dengan struktur JSON
        });
      } else {
        setState(() {
          _accounts = [];
        });
      }
    } catch (e) {
      setState(() {
        _accounts = [];
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Info Akun'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _accounts.isEmpty
              ? const Center(child: Text('No accounts available'))
              : ListView.builder(
                  itemCount: _accounts.length,
                  itemBuilder: (context, index) {
                    final account = _accounts[index];
                    return AccountCard(account: account);
                  },
                ),
    );
  }
}

class AccountCard extends StatelessWidget {
  final Map<String, dynamic> account;

  const AccountCard({super.key, required this.account});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.blue],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Account Type: ${account['account_type']}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Account Number: ${account['account_number']}',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Currency: ${account['currency_code']}',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Balance: ${account['currency_code']} ${account['available_balance']}',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Created: ${account['created']}',
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  late http.Client _client;
  List<dynamic> _transactions = [];
  List<dynamic> _filteredTransactions = [];
  String _searchQuery = "";
  bool _isLoading = false;
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    _client = http.Client();
    fetchTransactionData();
  }

  @override
  void dispose() {
    _client.close();
    super.dispose();
  }

  Future<void> fetchTransactionData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _client
          .get(Uri.parse('https://baruna.web.id/api_histori_transaksi.php'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          List<dynamic> transactions = data['data'];
          setState(() {
            // Filter out transactions with null or invalid fields
            _transactions = transactions.where((transaction) {
              return transaction['description'] != null &&
                  transaction['transaction_amount'] != null;
            }).toList();
            _filteredTransactions = _transactions;
          });
        } else {
          setState(() {
            _transactions = [];
            _filteredTransactions = [];
          });
        }
      } else {
        setState(() {
          _transactions = [];
          _filteredTransactions = [];
        });
      }
    } catch (e) {
      setState(() {
        _transactions = [];
        _filteredTransactions = [];
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
      _filteredTransactions = _transactions
          .where((transaction) => transaction['description']
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()))
          .toList();
    });
  }

  void _onDateRangeSelected(DateTime start, DateTime end) {
    setState(() {
      _startDate = start;
      _endDate = end;
      _filteredTransactions = _transactions.where((transaction) {
        DateTime transactionDate =
            DateTime.parse(transaction['transaction_date']);
        return transactionDate.isAfter(start) && transactionDate.isBefore(end);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transactions'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    onChanged: _onSearchChanged,
                    decoration: const InputDecoration(
                      labelText: 'Search transactions',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                ),
                if (_filteredTransactions.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'Showing ${_filteredTransactions.length} results from ${_startDate != null ? _startDate!.toLocal().toString().split(' ')[0] : ''} to ${_endDate != null ? _endDate!.toLocal().toString().split(' ')[0] : ''}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _filteredTransactions.length,
                    itemBuilder: (context, index) {
                      final transaction = _filteredTransactions[index];
                      return TransactionCard(transaction: transaction);
                    },
                  ),
                ),
              ],
            ),
    );
  }
}

class TransactionCard extends StatelessWidget {
  final Map<String, dynamic> transaction;

  const TransactionCard({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    bool isCredit = transaction['transaction_type'] == 'CR' ||
        transaction['transaction_type'] == '01';
    Color amountColor = isCredit ? Colors.green : Colors.red;
    String amountSymbol = isCredit ? '+' : '-';

    // Check if the required fields are not null
    String description = transaction['description'] ?? 'No Description';
    String amount = transaction['transaction_amount'] ?? '0';
    String date = transaction['transaction_date'] != null
        ? DateTime.parse(transaction['transaction_date'])
            .toLocal()
            .toString()
            .split(' ')[0]
        : 'Unknown Date';

    return Card(
      elevation: 8,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Logo
            const CircleAvatar(
              radius: 24,
              backgroundColor: Colors.blue,
              child: Icon(Icons.account_balance_wallet, color: Colors.white),
            ),
            const SizedBox(width: 16),
            // Description and Amount
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    description,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'From account: ${transaction['from_account_number'] ?? 'Unknown'}',
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$amountSymbol Rp $amount',
                    style: TextStyle(
                        fontSize: 16,
                        color: amountColor,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            // Date
            Text(
              date,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

class TransferFundsScreen extends StatefulWidget {
  const TransferFundsScreen({super.key});

  @override
  State<TransferFundsScreen> createState() => _TransferFundsScreenState();
}

class _TransferFundsScreenState extends State<TransferFundsScreen> {
  final TextEditingController _sourceAccountController =
      TextEditingController();
  final TextEditingController _destinationAccountController =
      TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  bool _isLoading = false;

  Future<void> _makeTransfer() async {
    final sourceAccountNumber = _sourceAccountController.text;
    final destinationAccountNumber = _destinationAccountController.text;
    final amount = _amountController.text;

    // Validate input
    if (sourceAccountNumber.isEmpty ||
        destinationAccountNumber.isEmpty ||
        amount.isEmpty) {
      _showErrorDialog('Please fill in all fields');
      return;
    }

    final Map<String, dynamic> transferData = {
      'source_account': sourceAccountNumber,
      'destination_account': destinationAccountNumber,
      'transfer_amount': int.tryParse(amount) ?? 0,
      'transaction_type': 'MB',
      'description':
          'Transfer dari rekening $sourceAccountNumber ke $destinationAccountNumber',
      'created_by': 'API',
      'updated_by': 'API',
    };

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('https://baruna.web.id/api_transfer.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(transferData),
      );

      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        if (responseData['status'] == 'SUCCESS') {
          _showSuccessDialog(responseData['message']);
        } else {
          _showErrorDialog(responseData['message']);
        }
      } else {
        _showErrorDialog('Transaction failed. Please try again later.');
      }
    } catch (e) {
      _showErrorDialog('Something went wrong. Please check your connection.');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Success'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                _navigateToSuccessPage();
              },
            ),
          ],
        );
      },
    );
  }

  void _navigateToSuccessPage() {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const TransferSuccessScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;

          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);

          return SlideTransition(position: offsetAnimation, child: child);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transfer'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _sourceAccountController,
              decoration:
                  const InputDecoration(labelText: 'Source Account Number'),
            ),
            TextField(
              controller: _destinationAccountController,
              decoration: const InputDecoration(
                  labelText: 'Destination Account Number'),
            ),
            TextField(
              controller: _amountController,
              decoration: const InputDecoration(labelText: 'Amount'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                bool? confirm = await _showConfirmationDialog();
                if (confirm == true) {
                  _makeTransfer();
                }
              },
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Transfer'),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool?> _showConfirmationDialog() {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Transaction'),
          content: const Text('Are you sure you want to make this transfer?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }
}

class TransferSuccessScreen extends StatelessWidget {
  const TransferSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction Successful'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.check_circle_outline,
              color: Colors.green,
              size: 100,
            ),
            const SizedBox(height: 20),
            const Text(
              'Transfer Successful!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Back to Home'),
            ),
          ],
        ),
      ),
    );
  }
}
