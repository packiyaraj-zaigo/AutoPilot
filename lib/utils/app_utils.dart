import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_colors.dart';
import 'app_constants.dart';

class AppUtils {
  static buildErrorSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: Text(message),
      ),
    );
  }

  static validateEmail(String email) {
    if (!RegExp(r"^([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5})$")
        .hasMatch(email.trim())) {
      return false;
    } else {
      return true;
    }
  }

  static sizedBox() {
    return SizedBox(
      height: 10,
    );
  }

  static boldStyle() {
    return const TextStyle(
      color: AppColors.primaryBlackColors,
      fontWeight: FontWeight.w600,
      fontSize: 17,
      fontFamily: '.SF Pro Text',
    );
  }

  static cardStyle() {
    return const TextStyle(
      color: AppColors.primaryColors,
      fontWeight: FontWeight.w600,
      fontSize: 17,
      fontFamily: '.SF Pro Text',
    );
  }

  static subTitleStyle() {
    return const TextStyle(
      color: AppColors.primaryTextColors,
      fontWeight: FontWeight.w400,
      fontSize: 12,
      fontFamily: '.SF Pro Text',
    );
  }

  static verticalDivider() {
    return const Divider(
      color: Color(0xffEBEAEA),
      thickness: 1,
      indent: 3,
      endIndent: 2,
    );
  }

  static verticalTextDivider() {
    return const Divider(
      color: Color(0xffEBEAEA),
      thickness: 1,
      indent: 2,
      endIndent: 2,
    );
  }

  static textStyle() {
    return const TextStyle(
      color: AppColors.primaryBlackColors,
      fontWeight: FontWeight.w400,
      fontSize: 14,
      fontFamily: '.SF Pro Text',
    );
  }

  static requiredStyle() {
    return const TextStyle(
      color: AppColors.primaryTextColors,
      fontWeight: FontWeight.w400,
      fontSize: 14,
      fontFamily: '.SF Pro Text',
    );
  }

  static drawerStyle() {
    return const TextStyle(
      color: AppColors.primaryBlackColors,
      fontWeight: FontWeight.w500,
      fontSize: 16,
      fontFamily: '.SF Pro Text',
    );
  }

  static summaryStyle() {
    return const TextStyle(
      color: AppColors.greyText,
      fontWeight: FontWeight.w500,
      fontSize: 16,
      fontFamily: '.SF Pro Text',
    );
  }

  static Future<void> setToken(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(AppConstants.USER_TOKEN, value);
  }

  static Future<String> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? isToken = prefs.getString(AppConstants.USER_TOKEN);
    return isToken ?? "";
  }

  static Future<void> setOnBoarding(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(AppConstants.ONBOARDING_VALUE, value);
  }

  static Future<bool> getOnBoarding() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? obBoarding = prefs.getBool(AppConstants.ONBOARDING_VALUE);
    return obBoarding ?? false;
  }

  static Future<void> setUserName(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(AppConstants.USER_Name, value);
  }

  static Future<String> getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? isToken = prefs.getString(AppConstants.USER_Name);
    return isToken ?? "";
  }

  static Future<void> setProfilePic(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(AppConstants.USER_PROFILE_PIC, value);
  }

  static Future<String> getProfilePic() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? isToken = prefs.getString(AppConstants.USER_PROFILE_PIC);
    return isToken ?? "";
  }

  static Future<void> setOTP(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(AppConstants.OTP, value);
  }

  static Future<String> getOTP() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? isToken = prefs.getString(AppConstants.OTP);
    return isToken ?? "";
  }

  static getDateFormatted(String date) {
    var inputFormat = DateFormat('yyyy-MM-dd');
    var inputDate = inputFormat.parse(date);

    var outputFormat = DateFormat('MM/dd/yy');
    var outputDate = outputFormat.format(inputDate);
    return outputDate;
  }

  static getFormatted(String date) {
    var inputFormat = DateFormat('yyyy-MM-dd HH:mm');
    var inputDate = inputFormat.parse(date);

    var outputFormat = DateFormat('MM/dd/yy hh:mm a');
    var outputDate = outputFormat.format(inputDate);
    return outputDate;
  }

  static getFormattedForApi(String date) {
    var inputFormat = DateFormat('yyyy-MM-dd HH:mm');
    var inputDate = inputFormat.parse(date);

    var outputFormat = DateFormat('yyyy-MM-dd');
    var outputDate = outputFormat.format(inputDate);
    return outputDate;
  }

  static getDateStringFormatted(String date) {
    var inputFormat = DateFormat('yyyy-MM-dd');
    var inputDate = inputFormat.parse(date);

    var outputFormat = DateFormat.yMMMMEEEEd();
    var outputDate = outputFormat.format(inputDate);
    return outputDate;
  }

  static getDateFormatterUI(String date) {
    var inputFormat = DateFormat('yyyy-MM-dd');
    var inputDate = inputFormat.parse(date);

    var outputFormat = DateFormat('MM-dd-yyyy');
    var outputDate = outputFormat.format(inputDate);
    return outputDate;
  }

  static getDateFormatterAPI(String date) {
    var inputFormat = DateFormat('MMMM-dd-yyyy');
    var inputDate = inputFormat.parse(date);

    var outputFormat = DateFormat('yyyy-MM-dd');
    var outputDate = outputFormat.format(inputDate);
    return outputDate;
  }

  static getTimeFormatted(DateTime date) {
    var outputFormat = DateFormat('M/d h:mm a');
    var outputTime = outputFormat.format(date);
    return outputTime;
  }

  static getTimeMinFormatted(String time) {
    var inputFormat = DateFormat('HH:mm');
    var inputTime = inputFormat.parse(time);

    var outputFormat = DateFormat('h:mm a');
    var outputTime = outputFormat.format(inputTime);
    return outputTime;
  }

  static Future<void> setUserID(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(AppConstants.USER_ID, value);
  }

  static Future<void> setTokenValidity(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token_expiry', value);
  }

  static Future<String> getUserID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userID = prefs.getString(AppConstants.USER_ID);
    return userID ?? "";
  }

  //temp for showing the add company screen.
  ///////////////////////////////////////////////////////////////
  static calendarStyle() {
    return const TextStyle(
      color: AppColors.primaryBlackColors,
      fontWeight: FontWeight.w600,
      fontSize: 24,
      fontFamily: '.SF Pro Text',
    );
  }

  static Future<void> setTempVar(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(AppConstants.TEMP_VAR, value);
  }

  static Future<String> getTempVar() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userID = prefs.getString(AppConstants.TEMP_VAR);
    return userID ?? "";
  }

  static Future<bool> getConnectivity() async {
    final connectivity = await Connectivity().checkConnectivity();
    if (connectivity == ConnectivityResult.other ||
        connectivity == ConnectivityResult.bluetooth ||
        connectivity == ConnectivityResult.none) {
      return false;
    } else {
      return true;
    }
  }

  ////////////////////////////////////////////////////////////////
}

class Debouncer {
  int? milliseconds;
  VoidCallback? action;
  Timer? timer;

  run(VoidCallback action) {
    if (null != timer) {
      timer!.cancel();
    }
    timer = Timer(
      const Duration(milliseconds: Duration.millisecondsPerSecond),
      action,
    );
  }
}

class PhoneInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Remove any non-digit characters from the input
    String sanitizedText = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    // Apply the desired format: (555) 555-5555
    final formattedText = StringBuffer();

    if (sanitizedText.length >= 1) {
      formattedText.write(
          '(${sanitizedText.substring(0, sanitizedText.length >= 3 ? 3 : sanitizedText.length)})');

      if (sanitizedText.length > 3) {
        formattedText.write(
            ' ${sanitizedText.substring(3, sanitizedText.length >= 6 ? 6 : sanitizedText.length)}');
      }

      if (sanitizedText.length > 6) {
        formattedText
            .write('-${sanitizedText.substring(6, sanitizedText.length)}');
      }
    }

    // Determine the selection offset after formatting
    int selectionOffset = newValue.selection.baseOffset +
        formattedText.length -
        newValue.text.length;
    selectionOffset = selectionOffset.clamp(
        0, formattedText.length); // Clamp the selection offset to a valid range

    // Handle backspace key
    if (newValue.text.length < oldValue.text.length &&
        newValue.selection.baseOffset == newValue.selection.extentOffset) {
      if (newValue.selection.baseOffset >= 4 &&
          newValue.selection.baseOffset <= 5) {
        formattedText.clear();
        formattedText.write(
            '(${sanitizedText.substring(0, sanitizedText.length >= 3 ? 3 : sanitizedText.length)})');
        selectionOffset--;
      } else if (newValue.selection.baseOffset >= 7 &&
          newValue.selection.baseOffset <= 9) {
        formattedText.clear();
        formattedText.write(
            '(${sanitizedText.substring(0, sanitizedText.length >= 3 ? 3 : sanitizedText.length)}) ');
        formattedText.write(sanitizedText.substring(
            3, sanitizedText.length >= 6 ? 6 : sanitizedText.length));
      } else if (newValue.selection.baseOffset >= 11 &&
          newValue.selection.baseOffset <= 15) {
        formattedText.clear();
        formattedText.write(
            '(${sanitizedText.substring(0, sanitizedText.length >= 3 ? 3 : sanitizedText.length)}) ');
        formattedText.write(sanitizedText.substring(
            3, sanitizedText.length >= 6 ? 6 : sanitizedText.length));
        formattedText
            .write('-${sanitizedText.substring(6, sanitizedText.length)}');
        // selectionOffset--;
      }
      if (newValue.selection.baseOffset == 6) {
        selectionOffset--;
      }
    }

    // Return the updated text value with proper formatting
    return TextEditingValue(
      text: formattedText.toString(),
      selection: TextSelection.collapsed(offset: selectionOffset),
    );
  }
}

class CardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String rawText = newValue.text.replaceAll(RegExp(r'\D'), '');
    String lastFourDigits =
        rawText.length >= 4 ? rawText.substring(rawText.length - 4) : rawText;
    if (newValue.text.length > 19) {
      return oldValue;
    }
    if (oldValue.text.endsWith('XXXX ')) {
      if (lastFourDigits.isNotEmpty) {
        String formattedValue = 'XXXX XXXX XXXX ' + lastFourDigits;
        return TextEditingValue(
          text: formattedValue,
          selection: TextSelection.collapsed(offset: formattedValue.length),
        );
      } else {
        return oldValue;
      }
    }
    String formattedValue = '';
    int index = 0;
    for (int i = 0; i < lastFourDigits.length; i++) {
      if (i % 4 == 0 && i != 0) {
        formattedValue += ' ';
      }
      formattedValue += lastFourDigits[i];
      index++;
    }

    formattedValue = 'XXXX XXXX XXXX ' + formattedValue;

    return TextEditingValue(
      text: formattedValue,
      selection: TextSelection.collapsed(offset: formattedValue.length),
    );
  }
}
