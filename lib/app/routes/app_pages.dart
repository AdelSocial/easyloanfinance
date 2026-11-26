import 'package:get/get.dart';
import '../binding/bindings.dart';
import '../quick_action/apply_loan_screen.dart';
import '../quick_action/pay_screen.dart';
import '../quick_action/top_up_screen.dart';
import '../quick_action/transfer_screen.dart';
import '../view/auth/cibil_screen.dart';
import '../view/auth/mobile_verification_screen.dart';
import '../view/auth/register_screen.dart';
import '../view/auth/register_three_screen.dart';
import '../view/auth/register_two_screen.dart';
import '../view/auth/splash_screen.dart';
import '../view/auth/login_screen.dart';
import '../view/business_loan/business_address_details_screen.dart';
import '../view/business_loan/business_application_screen.dart';
import '../view/business_loan/business_application_success_screen.dart';
import '../view/business_loan/business_document_upload_screen.dart';
import '../view/business_loan/business_employment_income_screen.dart';
import '../view/business_loan/business_review_submit_screen.dart';
import '../view/car_loan/car_option_screen.dart';
import '../view/car_loan/new_car/new_car_address_details_screen.dart';
import '../view/car_loan/new_car/new_car_application_submitted_screen.dart';
import '../view/car_loan/new_car/new_car_applicationc_screen.dart';
import '../view/car_loan/new_car/new_car_document_upload_screen.dart';
import '../view/car_loan/old_car/old_car_address_details_screen.dart';
import '../view/car_loan/old_car/old_car_application_screen.dart';
import '../view/car_loan/old_car/old_car_application_submitted_screen.dart';
import '../view/car_loan/old_car/old_car_document_upload_screen.dart';
import '../view/home_loan/home_application_screen.dart';
import '../view/home_loan/home_details_screen.dart';
import '../view/home_loan/home_document_upload_screen.dart';
import '../view/home_loan/home_loan_submit_screen.dart';
import '../view/home_screen.dart';
import '../view/instance_loan/instant_loan_address_details_screen.dart';
import '../view/instance_loan/instant_loan_application_screen.dart';
import '../view/loan_screen.dart';
import '../view/personal_loan/personal_address_details_screen.dart';
import '../view/personal_loan/personal_application_screen.dart';
import '../view/personal_loan/personal_application_success_screen.dart';
import '../view/personal_loan/personal_document_upload_screen.dart';
import '../view/personal_loan/personal_employment_income_screen.dart';
import '../view/personal_loan/personal_review_submit_screen.dart';
import '../view/profile/profile_screen.dart';
import '../view/support_screen.dart';
import '../view/loan_details_screen.dart';
part 'app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: Routes.splash,
      page: () => const SplashScreen(),
    ),
    GetPage(
      name: Routes.login,
      page: () =>  LoginScreen(),
        binding: LoginBinding(),
    ),
    GetPage(
      name: Routes.registrationScreen,
      page: () =>  RegistrationScreen(),
        binding: RegisterBinding(),
    ),

    GetPage(
      name: Routes.registerTwoScreen,
      page: () =>  RegisterTwoScreen(),
        binding: RegisterTwoBinding(),
    ),

    GetPage(
      name: Routes.registerThreeScreen,
      page: () =>  RegisterThreeScreen(),
        binding: RegisterThreeBinding(),
    ),

    GetPage(
      name: Routes.homeScreen,
      page: () =>  HomeScreen(),
        binding: HomeBinding(),
    ),

    GetPage(
      name: Routes.personalApplicationScreen,
      page: () =>  PersonalApplicationScreen(),
        binding: PersonalApplicationBinding(),
    ),

    GetPage(
      name: Routes.businessApplicationScreen,
      page: () =>  BusinessApplicationScreen(),
        binding: BusinessApplicationBinding(),
    ),

    GetPage(
      name: Routes.personalAddressDetailsScreen,
      page: () =>  PersonalAddressDetailsScreen(),
        binding: PersonalAddressDetailsBinding(),
    ),

    GetPage(
      name: Routes.personalEmploymentIncomeScreen,
      page: () =>  PersonalEmploymentIncomeScreen(),
        binding: PersonalEmploymentIncomeBinding(),
    ),

    GetPage(
      name: Routes.personalDocumentUploadScreen,
      page: () =>  PersonalDocumentUploadScreen(),
        binding: PersonalDocumentUploadBinding(),
    ),

    GetPage(
      name: Routes.personalReviewSubmitScreen,
      page: () =>  PersonalReviewSubmitScreen(),
        binding: PersonalReviewSubmitBinding(),
    ),

    GetPage(
      name: Routes.mobileVerificationScreen,
      page: () =>  MobileVerificationScreen(),
        binding: PersonalReviewSubmitBinding(),
    ),

    GetPage(
      name: Routes.cibilScreen,
      page: () =>  CibilScreen(),
        binding: CibilBinding(),
    ),

    GetPage(
      name: Routes.homeApplicationScreen,
      page: () =>  HomeApplicationScreen(),
        binding: HomeApplicationBinding(),
    ),

    GetPage(
      name: Routes.personalApplicationSuccessScreen,
      page: () =>  PersonalApplicationSuccessScreen(),
        binding: PersonalApplicationSuccessBinding(),
    ),


    GetPage(
      name: Routes.businessAddressDetailsScreen,
      page: () =>  BusinessAddressDetailsScreen(),
        binding: BusinessAddressDetailsBinding(),
    ),

    GetPage(
      name: Routes.businessEmploymentIncomeScreen,
      page: () =>  BusinessEmploymentIncomeScreen(),
        binding: BusinessEmploymentIncomeBinding(),
    ),

    GetPage(
      name: Routes.businessDocumentUploadScreen,
      page: () =>  BusinessDocumentUploadScreen(),
        binding: BusinessDocumentUploadBinding(),
    ),

    GetPage(
      name: Routes.businessReviewSubmitScreen,
      page: () =>  BusinessReviewSubmitScreen(),
        binding: BusinessReviewSubmitBinding(),
    ),


    GetPage(
      name: Routes.businessApplicationSuccessScreen,
      page: () =>  BusinessApplicationSuccessScreen(),
        binding: BusinessApplicationSuccessBinding(),
    ),

    GetPage(
      name: Routes.homeLoanDetailsScreen,
      page: () =>  HomeLoanDetailsScreen(),
        binding: HomeLoanDetailBinding(),
    ),

    GetPage(
      name: Routes.homeLoanDocumentUploadScreen,
      page: () =>  HomeLoanDocumentUploadScreen(),
        binding: HomeLoanDocumentUploadBinding(),
    ),

    GetPage(
      name: Routes.homeLoanSubmitScreen,
      page: () =>  HomeLoanSubmitScreen(),
        binding: HomeLoanSubmitBinding(),
    ),

    GetPage(
      name: Routes.supportScreen,
      page: () =>  SupportScreen(),
        binding: SupportBinding(),
    ),

    GetPage(
      name: Routes.loansScreen,
      page: () =>  LoansScreen(),
        binding: LoansBinding(),
    ),

    GetPage(
      name: Routes.profileScreen,
      page: () =>  ProfileScreen(),
        binding: ProfileBinding(),
    ),

    GetPage(
      name: Routes.transferScreen,
      page: () =>  TransferScreen(),
        binding: TransferBinding(),
    ),

    GetPage(
      name: Routes.payScreen,
      page: () =>  PayScreen(),
        binding: PayBinding(),
    ),

    GetPage(
      name: Routes.topUpScreen,
      page: () =>  TopUpScreen(),
        binding: PayBinding(),
    ),

    GetPage(
      name: Routes.applyLoanScreen,
      page: () =>  ApplyLoanScreen(),
        binding: PayBinding(),
    ),

    GetPage(
      name: Routes.carOptionScreen,
      page: () =>  CarOptionScreen(),
        binding: CarOptionBinding(),
    ),

    GetPage(
      name: Routes.carOptionScreen,
      page: () =>  CarOptionScreen(),
        binding: CarOptionBinding(),
    ),

    GetPage(
      name: Routes.newCarApplicationScreen,
      page: () =>  NewCarApplicationScreen(),
        binding: NewCarApplicationBinding(),
    ),

    GetPage(
      name: Routes.oldCarApplicationScreen,
      page: () =>  OldCarApplicationScreen(),
        binding: OldCarApplicationBinding(),
    ),

    GetPage(
      name: Routes.newCarAddressDetailsScreen,
      page: () =>  NewCarAddressDetailsScreen(),
        binding: NewCarAddressDetailsBinding(),
    ),

    GetPage(
      name: Routes.newCarDocumentUploadScreen,
      page: () =>  NewCarDocumentUploadScreen(),
        binding: NewCarDocumentUploadBinding(),
    ),

    GetPage(
      name: Routes.newCarApplicationSubmittedScreen,
      page: () =>  NewCarApplicationSubmittedScreen(),
        binding: NewCarApplicationSubmittedBinding(),
    ),

    GetPage(
      name: Routes.oldCarAddressDetailsScreen,
      page: () =>  OldCarAddressDetailsScreen(),
        binding: OldCarAddressDetailsBinding(),
    ),


    GetPage(
      name: Routes.oldCarDocumentUploadScreen,
      page: () =>  OldCarDocumentUploadScreen(),
        binding: OldCarDocumentUploadBinding(),
    ),

    GetPage(
      name: Routes.oldCarApplicationSubmittedScreen,
      page: () =>  OldCarApplicationSubmittedScreen(),
        binding: OldCarApplicationSubmittedBinding(),
    ),

    GetPage(
      name: Routes.instantLoanApplicationScreen,
      page: () =>  InstantLoanApplicationScreen(),
        binding: InstantLoanApplicationBinding(),
    ),

    GetPage(
      name: Routes.instantLoanAddressDetailsScreen,
      page: () =>  InstantLoanAddressDetailsScreen(),
      binding: InstantLoanAddressDetailsBinding(),
    ),

    GetPage(
      name: Routes.loanDetailsScreen,
      page: () =>  LoanDetailsScreen(),
    ),

  ];
}
