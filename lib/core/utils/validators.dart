class Validators {
  static String? jordanianPhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'الرجاء إدخال رقم الموبايل';
    }
    final cleaned = value.replaceAll(RegExp(r'[\s\-]'), '');
    if (!RegExp(r'^7[789]\d{7}$').hasMatch(cleaned)) {
      return 'رقم الموبايل غير صحيح';
    }
    return null;
  }

  static String? required(String? value, [String? fieldName]) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? 'هذا الحقل'} مطلوب';
    }
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.isEmpty) return null;
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'البريد الإلكتروني غير صحيح';
    }
    return null;
  }

  static String? minLength(String? value, int min, [String? fieldName]) {
    if (value == null || value.length < min) {
      return '${fieldName ?? 'هذا الحقل'} يجب أن يكون $min أحرف على الأقل';
    }
    return null;
  }
}
