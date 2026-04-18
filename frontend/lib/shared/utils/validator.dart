class Validator {
  static String? validateNumber(String value,
      {bool required = true, int? max, int? min}) {
    if (required && value.isEmpty) return 'Обязательное поле';
    final number = double.tryParse(value);
    if (number == null) return 'Только цифры';
    if (min != null && number < min) return 'Минимум $min';
    if (max != null && number > max) return 'Максимум $max';

    return null;
  }

  static String? validateString(String value,
      {bool required = true,
      int? maxLength,
      int? minLength,
      RegExp? pattern,
      String? patternError}) {
    if (required && value.isEmpty) return 'Обязательное поле';

    if (minLength != null && value.length < minLength) {
      return 'Минимум $minLength символов';
    }

    if (maxLength != null && value.length > maxLength) {
      return 'Максимум $maxLength символов';
    }

    if (pattern != null && !pattern.hasMatch(value)) {
      return patternError ?? 'Неверный формат';
    }

    return null;
  }
}
