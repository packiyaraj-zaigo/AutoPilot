import 'dart:async';

import 'package:auto_pilot/utils/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CreateEstimateScreen extends StatefulWidget {
  const CreateEstimateScreen({super.key});

  @override
  State<CreateEstimateScreen> createState() => _CreateEstimateScreenState();
}

class _CreateEstimateScreenState extends State<CreateEstimateScreen> {
  final List<String>tempItems=["temp1","temp2","temp3"];
  final notesController=TextEditingController();
  final startTimeController=TextEditingController();
  final endTimeController=TextEditingController();
  final dateController=TextEditingController();
  final appointmentController=TextEditingController();

  bool noteErrorStatus=false;
  bool startTimeErrorStatus=false;
  bool endTimeErrorStatus=false;
  bool dateErrorStatus=false;
  bool appointmentErrorStatus=false;

  String noteErrorMsg='';
  String dateErrorMsg='';
  String appointmentErrorMsg='';
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.primaryColors,
        leading: const SizedBox(),
        actions: [
          IconButton(onPressed: (){
            Navigator.pop(context);
          }, icon: const Icon(Icons.close))
        ],

      ),
      body:  SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top:8.0,left: 24,right:24,bottom: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                   const Text("Estimate Details",style: TextStyle(
                    color: AppColors.primaryTitleColor,
                    fontSize: 28,
                    fontWeight: FontWeight.w600
                  ),),
                    const Padding(
                      padding: EdgeInsets.only(top:8.0),
                      child: Text("Follow the steps to create an estimate.",style: TextStyle(
                      color: AppColors.greyText,
                      fontSize: 14,
                      fontWeight: FontWeight.w400
                                      ),),
                    ),
                    subTitleWidget("Customer Details"),
                    const Padding(
                      padding:  EdgeInsets.only(top:24.0),
                      child:  Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Customer",style: TextStyle(
                            color: AppColors.greyText,
                            fontSize: 14,
                            fontWeight: FontWeight.w500
                          ),),
                          Row(
                            children: [
                              Icon(Icons.add,color: AppColors.primaryColors,),
                                Text("Add new",style: TextStyle(
                            color: AppColors.primaryColors,
                            fontSize: 14,
                            fontWeight: FontWeight.w600
                          ),)

                            ],
                          )
                        ],
                      ),
                    ),
                    customerDropdown(),


                    const Padding(
                      padding:  EdgeInsets.only(top:24.0),
                      child:  Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Vehicle",style: TextStyle(
                            color: AppColors.greyText,
                            fontSize: 14,
                            fontWeight: FontWeight.w500
                          ),),
                          Row(
                            children: [
                              Icon(Icons.add,color: AppColors.primaryColors,),
                                Text("Add new",style: TextStyle(
                            color: AppColors.primaryColors,
                            fontSize: 14,
                            fontWeight: FontWeight.w600
                          ),)

                            ],
                          )
                        ],
                      ),
                    ),
                    customerDropdown(),

                    subTitleWidget("Estimate Notes"),
                    Padding(
                      padding: const EdgeInsets.only(top:16.0),
                      child: textBox("Enter note",notesController,"Note",noteErrorStatus),
                    ),
                    subTitleWidget("Appointment"),
                    Padding(
                      padding: const EdgeInsets.only(top:24.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          halfTextBox("Select time", startTimeController, "Start time", startTimeErrorStatus),
                          halfTextBox("Select time", endTimeController, "End time", endTimeErrorStatus)
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top:16.0),
                      child: textBox("Select date", dateController, "Date", dateErrorStatus),
                    ),
                      Padding(
                      padding: const EdgeInsets.only(top:16.0),
                      child: textBox("Enter appointment note", appointmentController, "Appointment note", appointmentErrorStatus),
                    ),

                    subTitleWidget("Inspection Photos"),
                      const Padding(
                        padding:  EdgeInsets.only(top:16.0),
                        child:  Text(
                                    "Upload photo",
                                    style:  TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xff6A7187)),
                                  ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top:8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                          inspectionPhotoWidget(),
                          inspectionPhotoWidget(),
                          inspectionPhotoWidget(),
                          inspectionPhotoWidget()
                        ],),
                      ),
                      subTitleWidget("Services"),
                      const Padding(
                      padding:  EdgeInsets.only(top:24.0),
                      child:  Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Select Services",style: TextStyle(
                            color: AppColors.greyText,
                            fontSize: 14,
                            fontWeight: FontWeight.w500
                          ),),
                          Row(
                            children: [
                              Icon(Icons.add,color: AppColors.primaryColors,),
                                Text("Add new",style: TextStyle(
                            color: AppColors.primaryColors,
                            fontSize: 14,
                            fontWeight: FontWeight.w600
                          ),)

                            ],
                          )
                        ],
                      ),
                    ),
                    customerDropdown(),
                    Padding(
                      padding: const EdgeInsets.only(top:12.0),
                      child: taxDetailsWidget("Total Material","0.00"),
                    ),
                    taxDetailsWidget("Total Labor","0.00"),
                    taxDetailsWidget("Tax","0.00"),
                    taxDetailsWidget("Discount","0.00"),
                     taxDetailsWidget("Total","0.00"),
                     taxDetailsWidget("Balance Due","0.00"),
                     Padding(
                       padding: const EdgeInsets.only(top:32.0),
                       child: Container(
                        height: 56,
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: AppColors.primaryColors,
                          
                        ),
                        child: const Text("Confirm",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white
                        ),),
                                         ),
                     ),






        
        
            ],
          ),
        ),
      ),
    );
  }


  Widget subTitleWidget(String subTitle){
    return Padding(
      padding: const EdgeInsets.only(top:18.0),
      child: Text(subTitle,style: const TextStyle(
        fontSize: 18,fontWeight: FontWeight.w600,
        color: AppColors.primaryTitleColor
    
      ),),
    );
  }



  //Customer dropdown
  Widget customerDropdown() {
    return Padding(
      padding: const EdgeInsets.only(top:0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,


        children: [
          //  const Text(
          //       "State",
          //       style:  TextStyle(
          //           fontSize: 14,
          //           fontWeight: FontWeight.w500,
          //           color: Color(0xff6A7187)),
          //     ),
          Padding(
            padding: const EdgeInsets.only(top:0.0),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 56,
              // margin: const EdgeInsets.only(left: 15, top: 10, right: 15),
              // padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(border: Border.all(color:const Color(0xffC1C4CD)),
              borderRadius: BorderRadius.circular(12)),
              child: DropdownButtonHideUnderline(
                child: ButtonTheme(
                  alignedDropdown: true,
               
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      
                    ),
                    menuMaxHeight: 380,
                    isExpanded: true,
                    
                    value: tempItems[0],
                    style: const TextStyle(color: Color(0xff6A7187),overflow: TextOverflow.ellipsis),
                    items: tempItems.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        alignment: AlignmentDirectional.centerStart,
                        value: value,
                        child: Text(value,style: TextStyle(
                          overflow: TextOverflow.ellipsis
                        ),),
                      );
                    }).toList(),
                    hint: const Text(
                      "Select Customer",
                      style: TextStyle(
                          color: Color(0xff6A7187),
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                    ),
                    onChanged: (String? value) {
                      setState(() {
                      
                     //   _currentSelectedStateValue = value;
                    
                      });
                    },
                    //isExpanded: true,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


  //Common text box widget

  Widget textBox(String placeHolder, TextEditingController controller,
      String label, bool errorStatus) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff6A7187)),
            ),
          
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 6.0),
          child: SizedBox(
            height: 56,
            width: MediaQuery.of(context).size.width,
            child: TextField(
              controller: controller,
              readOnly: label=='Date'?true:false,
              onTap: (){
                if(label=='Date'){
                  showCupertinoModalPopup(
                                    context: context,
                                    builder: (context) {
                                      return datePicker("");
                                    },
                                  );
                }
              },
              keyboardType:
                  label == 'Phone Number' ? TextInputType.number : null,
              maxLength: label == 'Phone Number'
                  ? 16
                  : label == 'Password'
                      ? 12
                      : 50,
            
              decoration: InputDecoration(
                  hintText: placeHolder,
                  counterText: "",
                 
                 
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                          color: errorStatus == true
                              ? Color(0xffD80027)
                              : Color(0xffC1C4CD))),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                          color: errorStatus == true
                              ? Color(0xffD80027)
                              : Color(0xffC1C4CD))),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                          color: errorStatus == true
                              ? Color(0xffD80027)
                              : Color(0xffC1C4CD)))),
            ),
          ),
        ),
      ],
    );
  }



  Widget halfTextBox(String placeHolder, TextEditingController controller,
      String label, bool errorStatus) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff6A7187)),
            ),
          
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 6.0),
          child: SizedBox(
            height: 56,
            width: MediaQuery.of(context).size.width / 2.4,
            child: TextField(
              controller: controller,
              maxLength: 50,
              readOnly: true,
              onTap: (){
                 showCupertinoModalPopup(
                                    context: context,
                                    builder: (context) {
                                      return timerPicker("time_from");
                                    },
                                  );

              },
            
              decoration: InputDecoration(
                  hintText: placeHolder,
                  counterText: "",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                          color: errorStatus == true
                              ? Color(0xffD80027)
                              : Color(0xffC1C4CD))),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                          color: errorStatus == true
                              ? Color(0xffD80027)
                              : Color(0xffC1C4CD))),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                          color: errorStatus == true
                              ? Color(0xffD80027)
                              : Color(0xffC1C4CD)))),
            ),
          ),
        ),
      ],
    );
  }



   Widget timerPicker(String timeType) {
    return CupertinoPopupSurface(
      child: Container(
        color: CupertinoColors.white,
        height: MediaQuery.of(context).size.height * 0.3,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CupertinoButton(
                    child: const Text("Done"),
                    onPressed: () {
                      Navigator.pop(context);
                    })
              ],
            ),
            Flexible(
              child: CupertinoTimerPicker(
                mode: CupertinoTimerPickerMode.hm,
                minuteInterval: 1,
                secondInterval: 1,
                initialTimerDuration: const Duration(),
                onTimerDurationChanged: (Duration changeTimer) {
                  setState(() {
                    // initialTimer = changeTimer;
                  

                    print(
                        '${changeTimer.inHours} hrs ${changeTimer.inMinutes % 60} mins ${changeTimer.inSeconds % 60} secs');
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }



  Widget datePicker(String dateType) {
    return CupertinoPopupSurface(
      child: Container(
          width: MediaQuery.of(context).size.width,
          color: CupertinoColors.white,
          height: MediaQuery.of(context).size.height * 0.3,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CupertinoButton(
                      child: const Text("Done"),
                      onPressed: () {
                        Navigator.pop(context);
                      })
                ],
              ),
           //   CommonWidgets().commonDividerLine(context),
              Flexible(
                child: CupertinoDatePicker(
                  initialDateTime: DateTime.now(),
                  onDateTimeChanged: (DateTime newdate) {
                  
                  },
                  use24hFormat: true,
                  maximumDate: new DateTime(2030, 12, 30),
                  minimumYear: 2009,
                  maximumYear: 2030,
                  minuteInterval: 1,
                  mode: CupertinoDatePickerMode.date,
                ),
              ),
            ],
          )),
    );
  }


  Widget inspectionPhotoWidget(){
    return Container(
      width: MediaQuery.of(context).size.width/4.8,
      height: 75,
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0xffE8EAED)
        ),
        borderRadius: BorderRadius.circular(8)
        
      ),
      child: const Icon(Icons.add,color: AppColors.primaryColors,),
    );
  }

  Widget taxDetailsWidget(String title,String price){
    return Padding(
      padding: const EdgeInsets.only(top:12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,style: const TextStyle(
            color: AppColors.primaryTitleColor,
            fontSize: 16,
            fontWeight: FontWeight.w500
          ),),
             Text("\$ $price",style: const TextStyle(
            color: AppColors.primaryTitleColor,
            fontSize: 16,
            fontWeight: FontWeight.w500
          ),)
        ],
      ),
    );
  }

}