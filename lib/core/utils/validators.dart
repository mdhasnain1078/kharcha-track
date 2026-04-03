class Validators {
  Validators._();

  static String? validateAmount(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter an amount';
    }
    final amount = double.tryParse(value.trim());
    if (amount == null) {
      return 'Please enter a valid number';
    }
    if (amount <= 0) {
      return 'Amount must be greater than 0';
    }
    if (amount > 99999999) {
      return 'Amount is too large';
    }
    return null;
  }

  static String? validateTitle(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter a title';
    }
    if (value.trim().length < 2) {
      return 'Title must be at least 2 characters';
    }
    if (value.trim().length > 100) {
      return 'Title must be less than 100 characters';
    }
    return null;
  }

  static String? validateNote(String? value) {
    if (value != null && value.length > 500) {
      return 'Note must be less than 500 characters';
    }
    return null;
  }

  static String? validateCategory(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please select a category';
    }
    return null;
  }

  static String? validateDate(DateTime? date) {
    if (date == null) {
      return 'Please select a date';
    }
    return null;
  }

  static String? validateGoalAmount(String? value, {double? currentSaved}) {
    final baseValidation = validateAmount(value);
    if (baseValidation != null) return baseValidation;

    final amount = double.parse(value!.trim());
    if (currentSaved != null && amount <= currentSaved) {
      return 'Target must be greater than saved amount';
    }
    return null;
  }
}
