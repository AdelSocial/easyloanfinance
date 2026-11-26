import 'package:easy_loan_finance/app/controller/business_application_controller.dart';
import 'package:easy_loan_finance/app/controller/home_application_controller.dart';
import 'package:easy_loan_finance/app/controller/home_controller.dart';
import 'package:easy_loan_finance/app/controller/personal_application_controller.dart';
import 'package:easy_loan_finance/app/controller/register_controller.dart';
import 'package:get/get.dart';
import '../controller/apply_loan_controller.dart';
import '../controller/business_address_details_controller.dart';
import '../controller/business_application_success_controller.dart';
import '../controller/business_document_controller.dart';
import '../controller/business_employment_income_controller.dart';
import '../controller/business_review_controller.dart';
import '../controller/cibil_controller.dart';
import '../controller/home_details_controller.dart';
import '../controller/home_loan_document_controller.dart';
import '../controller/home_loan_review_controller.dart';
import '../controller/instant_loan_address_controller.dart';
import '../controller/instant_loan_application_controller.dart';
import '../controller/loan_controller.dart';
import '../controller/login_controller.dart';
import '../controller/mobile_verification_controller.dart';
import '../controller/new_car_address_controller.dart';
import '../controller/new_car_application_controller.dart';
import '../controller/new_car_document_controller.dart';
import '../controller/old_car_address_controller.dart';
import '../controller/old_car_application_controller.dart';
import '../controller/old_car_application_submitted_controller.dart';
import '../controller/old_car_document_controller.dart';
import '../controller/pay_controller.dart';
import '../controller/personal_address_controller.dart';
import '../controller/personal_application_success_controller.dart';
import '../controller/personal_document_controller.dart';
import '../controller/personal_employment_controller.dart';
import '../controller/personal_review_controller.dart';
import '../controller/profile_controller.dart';
import '../controller/register_three_controller.dart';
import '../controller/register_two_controller.dart';
import '../controller/support_controller.dart';
import '../controller/top_up_controller.dart';
import '../controller/transfer_controller.dart';
import '../controller/car_option_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LoginController());
  }
}

class RegisterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => RegistrationController());
  }
}

class RegisterTwoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => RegisterTwoController());
  }
}
class RegisterThreeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => RegisterThreeController());
  }
}

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeController());
  }
}

class PersonalApplicationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PersonalApplicationController());
  }
}

class BusinessApplicationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => BusinessApplicationController());
  }
}

class PersonalAddressDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PersonalAddressController());
  }
}
class PersonalEmploymentIncomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PersonalEmploymentController());
  }
}

class PersonalDocumentUploadBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PersonalDocumentController());
  }
}

class PersonalReviewSubmitBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PersonalReviewController());
  }
}

class MobileVerificationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MobileVerificationController());
  }
}

class CibilBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CibilController());
  }
}

class HomeApplicationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeApplicationController());
  }
}


class PersonalApplicationSuccessBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PersonalApplicationSuccessController());
  }
}

class BusinessAddressDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => BusinessAddressDetailsController());
  }
}


class BusinessEmploymentIncomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => BusinessEmploymentController());
  }
}

class BusinessDocumentUploadBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => BusinessDocumentController());
  }
}

class BusinessReviewSubmitBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => BusinessReviewController());
  }
}

class BusinessApplicationSuccessBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => BusinessApplicationSuccessController());
  }
}

class HomeLoanDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeLoanDetailsController());
  }
}


class HomeLoanDocumentUploadBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeLoanDocumentController());
  }
}

class HomeLoanSubmitBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeLoanReviewController());
  }
}

class SupportBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SupportController());
  }
}

class LoansBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LoansController());
  }
}

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ProfileController());
  }
}

class TransferBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TransferController());
  }
}


class PayBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PayController());
  }
}

class TopUpBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TopUpController());
  }
}

class ApplyLoanBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ApplyLoanController());
  }
}

class CarOptionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CarOptionController());
  }
}

class NewCarApplicationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => NewCarApplicationController());
  }
}


class OldCarApplicationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => OldCarApplicationController());
  }
}

class NewCarAddressDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => NewCarAddressController());
  }
}

class NewCarDocumentUploadBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => NewCarDocumentController());
  }
}


class NewCarApplicationSubmittedBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => NewCarApplicationController());
  }
}


class OldCarAddressDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => OldCarAddressController());
  }
}

class OldCarDocumentUploadBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => OldCarDocumentController());
  }
}

class OldCarApplicationSubmittedBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => OldCarApplicationSubmittedController());
  }
}

class InstantLoanApplicationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => InstantLoanApplicationController());
  }
}

class InstantLoanAddressDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => InstantLoanAddressController());
  }
}