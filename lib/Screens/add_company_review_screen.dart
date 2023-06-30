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
        elevation: 0,
        foregroundColor: AppColors.primaryColors,
        

      ),
      body:  Padding(
        padding:  const EdgeInsets.all(24.0),
        child:  Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           const  Text("Review Details",style: TextStyle(
              color: AppColors.primaryTitleColor,
              fontSize: 28,
              fontWeight: FontWeight.w600
            ),),
          const   Padding(
              padding: EdgeInsets.only(top:8.0),
              child: Text("Something wrong? Tap on the row to edit it.\nOtherwise tap confirm and continue.",style: TextStyle(
                color: AppColors.greyText,
                fontSize: 14,
                height: 1.5,
                fontWeight: FontWeight.w400
              ),),
            ),

            Padding(
              padding: const EdgeInsets.only(top:40.0),
              child: detailsWidget("Name","sanjay"),
            ),
            dividerLine()
          ],
        ),
      ),
    );
  }


  Widget dividerLine(){
    return Padding(
      padding: const EdgeInsets.only(top:12.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 0.5,
        color: const Color(0xff6A7187),
      ),
    );
  }

  Widget detailsWidget(String label,String value){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
        style: const TextStyle(
          color: Color(0xff6A7187,
        
          ),
          fontSize: 16,
          fontWeight: FontWeight.w400
        ),),

        Text(value,
        style: const TextStyle(
          color: AppColors.primaryTitleColor,
          fontSize: 16,
          fontWeight: FontWeight.w400
        ),)

      ],
    );
  }
}