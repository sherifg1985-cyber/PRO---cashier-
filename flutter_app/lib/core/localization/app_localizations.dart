import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppLocalizations {
  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  // English Translations
  static const Map<String, String> _englishTranslations = {
    'appTitle': 'Cashier System',
    'home': 'Home',
    'sales': 'Sales',
    'inventory': 'Inventory',
    'reports': 'Reports',
    'settings': 'Settings',
    'logout': 'Logout',
    'login': 'Login',
    'username': 'Username',
    'password': 'Password',
    'addProduct': 'Add Product',
    'editProduct': 'Edit Product',
    'deleteProduct': 'Delete Product',
    'productName': 'Product Name',
    'price': 'Price',
    'quantity': 'Quantity',
    'total': 'Total',
    'checkout': 'Checkout',
    'receipt': 'Receipt',
    'printReceipt': 'Print Receipt',
    'noInternet': 'No Internet Connection',
    'loading': 'Loading...',
    'error': 'Error',
    'success': 'Success',
    'warning': 'Warning',
  };

  // Arabic Translations
  static const Map<String, String> _arabicTranslations = {
    'appTitle': 'نظام الكاشير',
    'home': 'الرئيسية',
    'sales': 'المبيعات',
    'inventory': 'المخزون',
    'reports': 'التقارير',
    'settings': 'الإعدادات',
    'logout': 'تسجيل الخروج',
    'login': 'تسجيل الدخول',
    'username': 'اسم المستخدم',
    'password': 'كلمة المرور',
    'addProduct': 'إضافة منتج',
    'editProduct': 'تعديل منتج',
    'deleteProduct': 'حذف منتج',
    'productName': 'اسم المنتج',
    'price': 'السعر',
    'quantity': 'الكمية',
    'total': 'الإجمالي',
    'checkout': 'الدفع',
    'receipt': 'إيصال',
    'printReceipt': 'طباعة الإيصال',
    'noInternet': 'لا توجد اتصال إنترنت',
    'loading': 'جاري التحميل...',
    'error': 'خطأ',
    'success': 'نجح',
    'warning': 'تحذير',
  };

  String translate(String key) {
    if (locale.languageCode == 'ar') {
      return _arabicTranslations[key] ?? key;
    }
    return _englishTranslations[key] ?? key;
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      ['en', 'ar'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
