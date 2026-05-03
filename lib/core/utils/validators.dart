/// Common form / input validators.
class Validators {
  Validators._();

  static String? required(String? value, {String label = 'This field'}) {
    if (value == null || value.trim().isEmpty) return '$label is required';
    return null;
  }

  static String? minLength(String? value, int min,
      {String label = 'This field'}) {
    if (value == null || value.length < min) {
      return '$label must be at least $min characters';
    }
    return null;
  }

  static String? maxLength(String? value, int max,
      {String label = 'This field'}) {
    if (value != null && value.length > max) {
      return '$label must be at most $max characters';
    }
    return null;
  }

  static String? port(String? value) {
    final n = int.tryParse(value ?? '');
    if (n == null || n < 1 || n > 65535) return 'Invalid port';
    return null;
  }

  static String? ipv4(String? value) {
    if (value == null || value.isEmpty) return 'Address required';
    final parts = value.split('.');
    if (parts.length != 4) return 'Invalid IPv4 address';
    for (final p in parts) {
      final n = int.tryParse(p);
      if (n == null || n < 0 || n > 255) return 'Invalid IPv4 address';
    }
    return null;
  }
}
