import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/api_service.dart';
import '../routes/app_pages.dart';

class LoansController extends GetxController {
  // Selected tab index
  var selectedTabIndex = 0.obs;

  // Loan lists by status
  var pendingLoans = <LoanItem>[].obs;
  var approvedLoans = <LoanItem>[].obs;
  var rejectedLoans = <LoanItem>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadLoansData();
  }

  Future<void> loadLoansData() async {
    isLoading.value = true;
    try {
      // Fetch all loan types
      final personalLoans = await ApiService.getPersonalLoans();
      final businessLoans = await ApiService.getBusinessLoans();
      final homeLoans = await ApiService.getHomeLoans();
      final carLoans = await ApiService.getCarLoans();
      final instantLoans = await ApiService.getInstantLoans();

      // Combine all loans
      List<LoanItem> allLoans = [];
      
      if (personalLoans['success'] == true && personalLoans['data'] != null) {
        allLoans.addAll(_parseLoans(personalLoans['data'], 'Personal Loan'));
      }
      
      if (businessLoans['success'] == true && businessLoans['data'] != null) {
        allLoans.addAll(_parseLoans(businessLoans['data'], 'Business Loan'));
      }
      
      if (homeLoans['success'] == true && homeLoans['data'] != null) {
        allLoans.addAll(_parseLoans(homeLoans['data'], 'Home Loan'));
      }
      
      if (carLoans['success'] == true && carLoans['data'] != null) {
        allLoans.addAll(_parseLoans(carLoans['data'], 'Car Loan'));
      }
      
      if (instantLoans['success'] == true && instantLoans['data'] != null) {
        allLoans.addAll(_parseLoans(instantLoans['data'], 'Instant Loan'));
      }

      // Categorize loans by status according to MySQL schema (pending, approved, rejected)
      pendingLoans.assignAll(allLoans.where((loan) => loan.status == LoanStatus.pending).toList());
      approvedLoans.assignAll(allLoans.where((loan) => loan.status == LoanStatus.approved).toList());
      rejectedLoans.assignAll(allLoans.where((loan) => loan.status == LoanStatus.rejected).toList());

    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load loans: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Helper function to safely convert to double (handles string, int, double, null)
  double _toDouble(dynamic value, double defaultValue) {
    if (value == null) return defaultValue;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) {
      // Remove any commas or spaces and try to parse
      final cleaned = value.replaceAll(RegExp(r'[,\s]'), '');
      return double.tryParse(cleaned) ?? defaultValue;
    }
    return defaultValue;
  }
  
  // Helper function to safely convert to int (handles string, int, double, null)
  int _toInt(dynamic value, int defaultValue) {
    if (value == null) return defaultValue;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) {
      // Remove any commas or spaces and try to parse
      final cleaned = value.replaceAll(RegExp(r'[,\s]'), '');
      return int.tryParse(cleaned) ?? defaultValue;
    }
    return defaultValue;
  }

  List<LoanItem> _parseLoans(List<dynamic> loansData, String defaultLoanType) {
    return loansData.map((loan) {
      // Map status from API to LoanStatus enum according to MySQL schema
      // MySQL status values: 'pending', 'approved', 'rejected'
      LoanStatus status = LoanStatus.pending;
      if (loan['status'] != null) {
        final statusStr = loan['status'].toString().toLowerCase().trim();
        if (statusStr == 'approved') {
          status = LoanStatus.approved;
        } else if (statusStr == 'rejected' || statusStr == 'reject') {
          status = LoanStatus.rejected;
        } else if (statusStr == 'pending') {
          status = LoanStatus.pending;
        }
        // Keep default as pending if status doesn't match
      }

      // Get loan type from database field, fallback to default
      final loanType = loan['loan_type']?.toString() ?? defaultLoanType;
      
      // Parse dates
      DateTime? disbursedDate;
      DateTime? nextDueDate;
      DateTime? createdAt;
      
      if (loan['disbursed_date'] != null) {
        try {
          disbursedDate = DateTime.parse(loan['disbursed_date'].toString());
        } catch (e) {
          disbursedDate = null;
        }
      }

      if (loan['next_due_date'] != null) {
        try {
          nextDueDate = DateTime.parse(loan['next_due_date'].toString());
        } catch (e) {
          nextDueDate = null;
        }
      }

      if (loan['created_at'] != null) {
        try {
          createdAt = DateTime.parse(loan['created_at'].toString());
        } catch (e) {
          createdAt = null;
        }
      }
      
      // Get loan amount from database (handle string values)
      final loanAmount = _toDouble(loan['loan_amount'] ?? loan['amount'], 0.0);
      
      // Get loan tenure from database (in months)
      final loanTenure = _toInt(loan['loan_tenure'] ?? loan['tenure'] ?? loan['tenure_months'], 0);
      
      // Calculate or get interest rate (default to 10.5% if not provided)
      final interestRate = _toDouble(loan['interest_rate'] ?? loan['rate'], 10.5);
      
      // Calculate EMI if not provided (Simple EMI calculation: P * r * (1+r)^n / ((1+r)^n - 1))
      double calculatedEMI = 0.0;
      if (loan['emi'] != null || loan['monthly_emi'] != null) {
        calculatedEMI = _toDouble(loan['emi'] ?? loan['monthly_emi'], 0.0);
      } else if (loanAmount > 0 && loanTenure > 0 && interestRate > 0) {
        // Calculate EMI: P * r * (1+r)^n / ((1+r)^n - 1)
        final monthlyRate = interestRate / 100 / 12;
        final powerN = pow(1 + monthlyRate, loanTenure);
        if (powerN > 1) {
          calculatedEMI = loanAmount * monthlyRate * powerN / (powerN - 1);
        }
      }
      
      // Get paid months (default to 0 for new loans)
      final paidMonths = _toInt(loan['paid_months'] ?? loan['months_paid'], 0);
      
      // Calculate outstanding balance (for approved loans)
      double outstandingBalance = loanAmount;
      if (loan['outstanding_balance'] != null || loan['balance'] != null) {
        outstandingBalance = _toDouble(loan['outstanding_balance'] ?? loan['balance'], loanAmount);
      } else if (status == LoanStatus.approved && calculatedEMI > 0 && paidMonths > 0) {
        // Approximate outstanding: original amount - (EMI * paid months)
        outstandingBalance = (loanAmount - (calculatedEMI * paidMonths)).clamp(0.0, loanAmount);
      }

      return LoanItem(
        id: loan['id']?.toString() ?? loan['loan_id']?.toString() ?? 'N/A',
        type: loanType,
        amount: loanAmount,
        disbursedAmount: _toDouble(loan['disbursed_amount'], loanAmount),
        interestRate: interestRate,
        tenure: loanTenure,
        emi: calculatedEMI,
        nextDueDate: nextDueDate,
        disbursedDate: disbursedDate,
        status: status,
        paidMonths: paidMonths,
        totalMonths: loanTenure > 0 ? loanTenure : 1, // Avoid division by zero
        outstandingBalance: outstandingBalance,
        createdAt: createdAt,
        fullName: loan['full_name']?.toString(),
        email: loan['email']?.toString(),
        mobile: loan['mobile']?.toString(),
      );
    }).toList();
  }

  void changeTab(int index) {
    selectedTabIndex.value = index;
  }

  Future<void> refreshLoans() async {
    await loadLoansData();
  }

  double getTotalOutstanding() {
    return approvedLoans.fold(0, (sum, loan) => sum + loan.outstandingBalance);
  }

  double getTotalEMI() {
    return approvedLoans.fold(0, (sum, loan) => sum + loan.emi);
  }

  void viewLoanDetails(LoanItem loan) {
    Get.toNamed(Routes.loanDetailsScreen, arguments: loan);
  }

  void payEMI(LoanItem loan) {
    // TODO: Implement pay EMI functionality
    Get.snackbar(
      'Pay EMI',
      'EMI payment feature coming soon',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.orange,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }

  void downloadStatement(LoanItem loan) {
    Get.snackbar(
      'Statement Downloaded',
      'Loan statement for ${loan.id} has been downloaded',
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }
}

class LoanItem {
  final String id;
  final String type;
  final double amount;
  final double disbursedAmount;
  final double interestRate;
  final int tenure; // in months
  final double emi;
  final DateTime? nextDueDate;
  final DateTime? disbursedDate;
  final LoanStatus status;
  final int paidMonths;
  final int totalMonths;
  final double outstandingBalance;
  final DateTime? createdAt;
  final String? fullName;
  final String? email;
  final String? mobile;

  LoanItem({
    required this.id,
    required this.type,
    required this.amount,
    required this.disbursedAmount,
    required this.interestRate,
    required this.tenure,
    required this.emi,
    required this.nextDueDate,
    required this.disbursedDate,
    required this.status,
    required this.paidMonths,
    required this.totalMonths,
    required this.outstandingBalance,
    this.createdAt,
    this.fullName,
    this.email,
    this.mobile,
  });

  String get formattedAmount {
    if (amount >= 100000) {
      return '₹${(amount / 100000).toStringAsFixed(1)}L';
    } else if (amount >= 1000) {
      return '₹${(amount / 1000).toStringAsFixed(1)}K';
    }
    return '₹${amount.toStringAsFixed(0)}';
  }
  
  String get formattedEMI {
    if (emi <= 0) return 'N/A';
    if (emi >= 1000) {
      return '₹${(emi / 1000).toStringAsFixed(1)}K';
    }
    return '₹${emi.toInt()}';
  }
  
  String get formattedOutstanding {
    if (outstandingBalance >= 100000) {
      return '₹${(outstandingBalance / 100000).toStringAsFixed(1)}L';
    } else if (outstandingBalance >= 1000) {
      return '₹${(outstandingBalance / 1000).toStringAsFixed(1)}K';
    }
    return '₹${outstandingBalance.toStringAsFixed(0)}';
  }
  
  String get progressText => '$paidMonths/$totalMonths months';
  
  double get progress {
    if (totalMonths <= 0) return 0.0;
    return (paidMonths / totalMonths).clamp(0.0, 1.0);
  }

  String get statusText {
    switch (status) {
      case LoanStatus.pending:
        return 'Pending';
      case LoanStatus.approved:
        return 'Approved';
      case LoanStatus.rejected:
        return 'Rejected';
      case LoanStatus.active:
        return 'Active';
      case LoanStatus.closed:
        return 'Closed';
      case LoanStatus.overdue:
        return 'Overdue';
    }
  }

  Color get statusColor {
    switch (status) {
      case LoanStatus.pending:
        return Colors.orange;
      case LoanStatus.approved:
        return Colors.green;
      case LoanStatus.rejected:
        return Colors.red;
      case LoanStatus.active:
        return Colors.green;
      case LoanStatus.closed:
        return Colors.blue;
      case LoanStatus.overdue:
        return Colors.red;
    }
  }

  String get nextDueText {
    if (nextDueDate == null) return 'N/A';
    final now = DateTime.now();
    final difference = nextDueDate!.difference(now);
    if (difference.inDays == 0) return 'Today';
    if (difference.inDays == 1) return 'Tomorrow';
    if (difference.inDays < 0) return 'Overdue by ${difference.inDays.abs()} days';
    return 'In ${difference.inDays} days';
  }

  Color get dueTextColor {
    if (nextDueDate == null) return Colors.white54;
    final now = DateTime.now();
    final difference = nextDueDate!.difference(now);
    if (difference.inDays <= 0) return Colors.red;
    if (difference.inDays <= 3) return Colors.orange;
    return Colors.green;
  }
}

enum LoanStatus {
  pending,    // Default status from MySQL
  approved,  // Approved status from MySQL
  rejected,  // Rejected status from MySQL
  active,    // Legacy support
  closed,    // Legacy support
  overdue,   // Legacy support
}