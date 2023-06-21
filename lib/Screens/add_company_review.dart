import 'package:auto_pilot/utils/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddCompanyReviewScreen extends StatefulWidget {
  const AddCompanyReviewScreen({super.key});

  @override
  State<AddCompanyReviewScreen> createState() => _AddCompanyReviewScreenState();
}

class _AddCompanyReviewScreenState extends State<AddCompanyReviewScreen> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.primaryColors,
        elevation: 0,
      ),
      body: const Padding(
        padding:  EdgeInsets.only(top:8.0,left: 24,right: 24),
        child: Column(
          children: [
               Text("Review Details",style: TextStyle(
                    color: AppColors.primaryTitleColor,
                    fontSize: 28,
                    fontWeight: FontWeight.w600
                  ),),
          ],
        ),
      ),
    );
  }
}