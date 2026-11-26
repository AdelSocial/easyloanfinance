import 'package:get/get.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';

class BusinessAddressDetailsController extends GetxController {
  /// 🔹 Business Address Fields
  var businessAddress = ''.obs;
  var city = ''.obs;
  var pincode = ''.obs;
  var selectedState = ''.obs;
  var premisesType = ''.obs;
  var kycDocumentNumber = ''.obs;
  var selectedKYCDocument = ''.obs;
  var isKYCDocumentUploaded = false.obs;

  void uploadKYCDocument() {
    // Implement document upload logic
    isKYCDocumentUploaded.value = true;
  }
  /// 🔹 Ownership Section
  var premisesOwnership = ''.obs;
  var monthlyRent = ''.obs;

  /// 🔹 Address Proof Section
  var selectedAddressProof = ''.obs;
  var isAddressProofUploaded = false.obs;
  File? uploadedFile;

  /// 🔹 KYC Section
  var kycMethods = [
    'Aadhaar OTP eKYC',
    'CKYC',
    'DigiLocker',
    'Video KYC',
  ].obs;

  var selectedKYCMethod = ''.obs;

  /// 🔹 State List
  var states = [
    'Andhra Pradesh',
    'Arunachal Pradesh',
    'Assam',
    'Bihar',
    'Chhattisgarh',
    'Goa',
    'Gujarat',
    'Haryana',
    'Himachal Pradesh',
    'Jharkhand',
    'Karnataka',
    'Kerala',
    'Madhya Pradesh',
    'Maharashtra',
    'Manipur',
    'Meghalaya',
    'Mizoram',
    'Nagaland',
    'Odisha',
    'Punjab',
    'Rajasthan',
    'Sikkim',
    'Tamil Nadu',
    'Telangana',
    'Tripura',
    'Uttar Pradesh',
    'Uttarakhand',
    'West Bengal',
    'Delhi',
    'Jammu & Kashmir',
    'Ladakh'
  ].obs;

  /// 🔹 File Upload Functionality
  Future<void> uploadAddressProof() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
        withData: true,
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        // Check file size (max 5MB)
        if ((file.size / 1024 / 1024) > 5) {
          Get.snackbar('Error', 'File size should not exceed 5MB');
          return;
        }

        uploadedFile = File(file.path!);
        isAddressProofUploaded.value = true;
        Get.snackbar('Success', 'Address Proof uploaded successfully');
      } else {
        isAddressProofUploaded.value = false;
      }
    } catch (e) {
      Get.snackbar('Error', 'File upload failed: $e');
    }
  }

  /// 🔹 Validate if the form is complete
  bool get isFormValid {
    return businessAddress.value.isNotEmpty &&
        city.value.isNotEmpty &&
        pincode.value.isNotEmpty &&
        selectedState.value.isNotEmpty &&
        premisesType.value.isNotEmpty &&
        premisesOwnership.value.isNotEmpty &&
        (premisesOwnership.value != 'Rented' && premisesOwnership.value != 'Leased'
            ? true
            : monthlyRent.value.isNotEmpty) &&
        selectedAddressProof.value.isNotEmpty &&
        isAddressProofUploaded.value &&
        selectedKYCMethod.value.isNotEmpty;
  }

  /// 🔹 For Debugging or API submission
  Map<String, dynamic> get formData => {
    "businessAddress": businessAddress.value,
    "city": city.value,
    "pincode": pincode.value,
    "state": selectedState.value,
    "premisesType": premisesType.value,
    "premisesOwnership": premisesOwnership.value,
    "monthlyRent": monthlyRent.value,
    "addressProofType": selectedAddressProof.value,
    "kycMethod": selectedKYCMethod.value,
  };
}
