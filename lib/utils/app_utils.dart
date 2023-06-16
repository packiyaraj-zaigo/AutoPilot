import 'dart:async';

import 'package:flutter/material.dart';
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

    var outputFormat = DateFormat('yyyy-MM-dd');
    var outputDate = outputFormat.format(inputDate);
    return outputDate;
  }

  static getFormatted(String date) {
    var inputFormat = DateFormat('dd/MM/yyyy HH:mm');
    var inputDate = inputFormat.parse(date);

    var outputFormat = DateFormat('yyyy-MM-dd');
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

    var outputFormat = DateFormat('MMMM-dd-yyyy');
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

  static getTimeFormatted(String time) {
    var inputFormat = DateFormat('HH:mm');
    var inputTime = inputFormat.parse(time);

    var outputFormat = DateFormat('h a');
    var outputTime = outputFormat.format(inputTime);
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

  static Future<String> getUserID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userID = prefs.getString(AppConstants.USER_ID);
    return userID ?? "";
  }
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
