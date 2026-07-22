import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;
  String _selectedLanguage = 'en';
  int? _selectedBranchId;

  final List<Map<String, dynamic>> _branches = [
    {'id': 1, 'name': 'Main Branch', 'name_ar': 'الفرع الرئيسي'},
    {'id': 2, 'name': 'Branch 2', 'name_ar': 'الفرع الثاني'},
    {'id': 3, 'name': 'Branch 3', 'name_ar': 'الفرع الثالث'},
  ];

  @override
  void initState() {
    super.initState();
    _selectedBranchId = _branches[0]['id'];
    _selectedLanguage = Intl.getCurrentLocale().split('_')[0];
  }

  void _login() {
    // TODO: Implement login logic
  }

  void _loginWithFingerprint() {
    // TODO: Implement fingerprint login logic
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final isRTL = _selectedLanguage == 'ar';

    return Directionality(
      textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: isDarkMode ? Colors.grey[900] : Colors.blue[50],
        body: SingleChildScrollView(
          child: Column(
            children: [
              // Header
              Container(
                height: 200,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue[700]!, Colors.blue[500]!],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.shopping_cart,
                        size: 60,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _selectedLanguage == 'ar' ? 'نظام الكاشير' : 'Cashier System',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Login Form
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Language & Branch Selection
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButton<String>(
                            value: _selectedLanguage,
                            items: [
                              DropdownMenuItem(
                                value: 'en',
                                child: const Text('English'),
                              ),
                              DropdownMenuItem(
                                value: 'ar',
                                child: const Text('العربية'),
                              ),
                            ],
                            onChanged: (value) {
                              setState(() => _selectedLanguage = value ?? 'en');
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: DropdownButton<int>(
                            value: _selectedBranchId,
                            items: _branches
                                .map((branch) => DropdownMenuItem(
                                      value: branch['id'],
                                      child: Text(
                                        _selectedLanguage == 'ar'
                                            ? branch['name_ar']
                                            : branch['name'],
                                      ),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              setState(() => _selectedBranchId = value);
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    // Username
                    TextField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        labelText: _selectedLanguage == 'ar'
                            ? 'اسم المستخدم'
                            : 'Username',
                        prefixIcon: const Icon(Icons.person),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Password
                    TextField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        labelText: _selectedLanguage == 'ar'
                            ? 'كلمة المرور'
                            : 'Password',
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(
                              () => _obscurePassword = !_obscurePassword,
                            );
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Login Button
                    ElevatedButton(
                      onPressed: _isLoading ? null : _login,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.blue[700],
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : Text(
                              _selectedLanguage == 'ar' ? 'تسجيل الدخول' : 'Login',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                    ),
                    const SizedBox(height: 16),
                    // Divider
                    Row(
                      children: [
                        Expanded(child: Divider()),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            _selectedLanguage == 'ar' ? 'أو' : 'OR',
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ),
                        Expanded(child: Divider()),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Fingerprint Login Button
                    OutlinedButton.icon(
                      onPressed: _loginWithFingerprint,
                      icon: const Icon(Icons.fingerprint),
                      label: Text(
                        _selectedLanguage == 'ar'
                            ? 'تسجيل الدخول بالبصمة'
                            : 'Login with Fingerprint',
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Forgot Password
                    Center(
                      child: TextButton(
                        onPressed: () {
                          // TODO: Implement forgot password
                        },
                        child: Text(
                          _selectedLanguage == 'ar'
                              ? 'هل نسيت كلمة المرور؟'
                              : 'Forgot Password?',
                          style: TextStyle(color: Colors.blue[700]),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
