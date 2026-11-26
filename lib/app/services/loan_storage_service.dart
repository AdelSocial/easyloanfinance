import 'package:shared_preferences/shared_preferences.dart';

class LoanStorageService {
  static const String _loanIdPrefix = 'current_loan_id_';
  static const String _loanTypePrefix = 'current_loan_type_';

  // Store current loan ID and type
  static Future<void> storeCurrentLoan({
    required String loanType,
    required int loanId,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('${_loanIdPrefix}$loanType', loanId.toString());
    await prefs.setString('${_loanTypePrefix}$loanType', loanType);
  }

  // Get current loan ID
  static Future<int?> getCurrentLoanId(String loanType) async {
    final prefs = await SharedPreferences.getInstance();
    final loanIdString = prefs.getString('${_loanIdPrefix}$loanType');
    if (loanIdString != null) {
      return int.tryParse(loanIdString);
    }
    return null;
  }

  // Clear stored loan ID
  static Future<void> clearCurrentLoan(String loanType) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('${_loanIdPrefix}$loanType');
    await prefs.remove('${_loanTypePrefix}$loanType');
  }

  // Store loan ID from API response
  static Future<void> storeLoanFromResponse(
    String loanType,
    Map<String, dynamic> response,
  ) async {
    if (response['success'] == true && response['data'] != null) {
      final loanData = response['data'];
      if (loanData['id'] != null) {
        await storeCurrentLoan(
          loanType: loanType,
          loanId: loanData['id'],
        );
      }
    }
  }
}

