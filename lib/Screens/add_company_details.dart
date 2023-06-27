import 'package:auto_pilot/Screens/create_employee_screen.dart';
import 'package:auto_pilot/utils/app_colors.dart';
import 'package:country_data/country_data.dart';
import 'package:csc_picker/csc_picker.dart';

import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class AddCompanyDetailsScreen extends StatefulWidget {
  const AddCompanyDetailsScreen({super.key,required this.widgetIndex});
  final int widgetIndex;

  @override
  State<AddCompanyDetailsScreen> createState() => _AddCompanyDetailsScreenState();
}

class _AddCompanyDetailsScreenState extends State<AddCompanyDetailsScreen> {
    final countryPicker = const FlCountryCodePicker();
      CountryCode? selectedCountry;


       CountryData countryData = CountryData();
  List<Country> countries = [];
  List<String> states = [];
  Country? countrySelected;
    dynamic _currentSelectedValue;
      dynamic _currentSelectedStateValue;
       dynamic _currentSelectedTimezoneValue;
    Iterable<tz.Location> timeZones=[];  
  final busineesNameController=TextEditingController();
  final businessPhoneController=TextEditingController();
  final businessWebsiteController=TextEditingController();
  final addressController=TextEditingController();
  final cityController=TextEditingController();
  final zipController=TextEditingController();
  final labourRateController=TextEditingController();
  final taxRateController=TextEditingController();
  bool businessNameErrorStatus=false;
  bool businessPhoneErrorStatus=false;
  bool businessWebsiteErrorStatus=false;
  bool addressErrorStatus=false;
  bool cityErrorStatus=false;
  bool zipErrorStatus=false;
  bool labourRateErrorStatus=false;
  bool taxRateErrorStatus=false;
   String countryValue = "";
  String stateValue = "";
  late String selectedState;


  bool taxLabourSwitchValue=false;
  bool taxPartSwitchValue=false;
  bool taxMaterialSwitchValue=false;




  @override
  void initState() {
    initCountries();
     tz.initializeTimeZones();
  timeZones = tz.timeZoneDatabase.locations.values;
  print(timeZones);
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar:AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      bottomNavigationBar:Padding(
        padding: const EdgeInsets.only(bottom:24.0,left:24,right:24),
        child: GestureDetector(
          onTap: (){
            Navigator.pop(context);
          },
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
      ) ,
      body: SingleChildScrollView(child: widget.widgetIndex==0?basicDetailsWidget():widget.widgetIndex==1? operationDetailsWidget():addEmployeeWidget()),

    );
  }


  Widget basicDetailsWidget(){
    return Padding(
      padding: const EdgeInsets.only(left:24.0,right:24,bottom:24,top:8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           const Text("Basic Details",style: TextStyle(
                color: AppColors.primaryTitleColor,
                fontSize: 28,
                fontWeight: FontWeight.w600
              ),),
              Padding(
                padding: const EdgeInsets.only(top:25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Container(
                          height: 88,
                          width: 88,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(157),
                            color: const Color.fromARGB(255, 225, 225, 225)
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(32.0),
                            child: SvgPicture.asset("assets/images/upload_icon.svg"),
                          ),
                        ),

                       const  Padding(
                          padding:  EdgeInsets.only(top:8.0),
                          child:  Text("Upload Logo",style: TextStyle(
                                        color: AppColors.greyText,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600
                                      ),),
                        ),

                        
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top:30.0),
                child: textBox("Enter business name", busineesNameController, "Business Name", businessNameErrorStatus),
              ),
              textBox("Enter Business phone", businessPhoneController, "Business Phone", businessPhoneErrorStatus),
               textBox("Enter Business Website", businessWebsiteController, "Business Website", businessWebsiteErrorStatus),
                textBox("Enter Address", addressController, "Address", addressErrorStatus),
                countrydropDown(),
                textBox("Enter City", cityController, "City", cityErrorStatus),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    stateDropDown(),
                     textBox("Enter Zip", zipController, "Zip", zipErrorStatus),

                  ],
                )
               
             
              
    
    
    
        ],
      ),
    );
  }


  //Operation Details Widget

  Widget operationDetailsWidget(){
    return  Padding(
    padding:  const EdgeInsets.only(left:24.0,right:24,bottom:24,top:8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
                const Text("Operation Details",style: TextStyle(
                  color: AppColors.primaryTitleColor,
                  fontSize: 28,
                  fontWeight: FontWeight.w600
                ),),

                Padding(
                  padding: const EdgeInsets.only(top:28.0),
                  child: numberOfEmployeeWidget(),
                ),
                timeZoneDropdown(),
                textBox("Ex. \$45", labourRateController, "Shop Hourly Labor Rate", labourRateErrorStatus),
                 textBox("Enter percentage rate", taxRateController, "Tax Rate", taxRateErrorStatus),
                 taxSwitchWidget("Tax Labour",taxLabourSwitchValue),
                 taxSwitchWidget("Tax Parts",taxPartSwitchValue),
                 taxSwitchWidget("Tax Material",taxMaterialSwitchValue)
    
        ],
      ),
    );
  }


  Widget numberOfEmployeeWidget(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
                "Number of employees",
                style:  TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xff6A7187)),
              ),

              Padding(
                padding: const EdgeInsets.only(top:8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      height: 56,
                      width: MediaQuery.of(context).size.width/3.6,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Color(0xffF6F6F6)
                      ),
                      child: Text("1",
                      style: TextStyle(fontSize: 14,fontWeight: FontWeight.w600,color: Color(0xff6A7187)),),
                    ),
                     Container(
                      alignment: Alignment.center,
                      height: 56,
                      width: MediaQuery.of(context).size.width/3.6,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Color(0xffF6F6F6)
                      ),
                      child: const Text("2-5",
                      style: TextStyle(fontSize: 14,fontWeight: FontWeight.w600,color: Color(0xff6A7187)),),
                    ),
                     Container(
                      alignment: Alignment.center,
                      height: 56,
                      width: MediaQuery.of(context).size.width/3.6,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Color(0xffF6F6F6)
                      ),
                      child: Text("6+",
                      style: TextStyle(fontSize: 14,fontWeight: FontWeight.w600,color: Color(0xff6A7187)),),
                    )
              
                  ],
                ),
              )

      ],
    );
  }





  //Common Text field widget
  Widget textBox(String placeHolder, TextEditingController controller,
      String label, bool errorStatus) {
    return Padding(
      padding: const EdgeInsets.only(top:12.0),
      child: Column(
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
              width:label=='Zip'?MediaQuery.of(context).size.width/2.3: MediaQuery.of(context).size.width,
              child: TextField(
                controller: controller,
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
                       prefixIcon:
                        label == 'Business Phone' ? countryPickerWidget() : null,
                   
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
      ),
    );
  }


  //Phone number country code picker widget

  Widget countryPickerWidget() {
    return GestureDetector(
      onTap: () async {
        // Show the country code picker when tapped.
        final code = await countryPicker.showPicker(context: context);
        // Null check
        if (code != null) {
          setState(() {
            selectedCountry = code;
          });
        }
        ;
      },
      child: Container(
        width: 90,
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        decoration: const BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.all(Radius.circular(5.0))),
        child: Row(
          children: [
            // ClipRRect(
            //   borderRadius: BorderRadius.circular(10),
            //   child: CircleAvatar(
            //     radius: 9,
            //     backgroundColor: Colors.transparent,
            //     child: selectedCountry!=null?ClipOval(child: selectedCountry!.flagImage):const SizedBox() ,

            //   ),
            // ),

            Container(
              height: 20,
              width: 20,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey,
              ),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: selectedCountry != null
                      ? selectedCountry!.flagImage
                      : const SizedBox()),
            ),

            Padding(
              padding: const EdgeInsets.only(left: 6.0),
              child: Text(
                  selectedCountry != null ? selectedCountry!.dialCode : "+1"),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 5.0),
              child: Container(
                width: 0.7,
                color: AppColors.greyText,
              ),
            )
          ],
        ),
      ),
    );
  }


    void initCountries() {
    countries = countryData.getCountries();
    countrySelected = countries[0];
   // initCountryStates();
    
   
  }

   void initCountryStates(id) {
    // select state
    states = countryData.getStates(countryId: id);
  
    
    setState(() {
     // selectedState = states[0];
    // states = [selectedCountry!.name];
    print(states);
    });
  
  
  }

// Country dropdown

  Widget countrydropDown() {
    return Padding(
      padding: const EdgeInsets.only(top:12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,


        children: [
           const Text(
                "Country",
                style:  TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xff6A7187)),
              ),
          Padding(
            padding: const EdgeInsets.only(top:8.0),
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
                  child: DropdownButtonFormField<Country>(
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                    ),
                    menuMaxHeight: 380,
                    value: _currentSelectedValue,
                    style: const TextStyle(color: Color(0xff6A7187)),
                    items: countries.map<DropdownMenuItem<Country>>((Country value) {
                      return DropdownMenuItem<Country>(
                        alignment: AlignmentDirectional.centerStart,
                        value: value,
                        child: Text(value.name),
                      );
                    }).toList(),
                    hint: const Text(
                      "Select Country",
                      style: TextStyle(
                          color: Color(0xff6A7187),
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                    ),
                    onChanged: (Country? value) {
                      setState(() {
                      
                        _currentSelectedValue = value;
                        initCountryStates(value!.id);
                    
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


//State dropdown

Widget stateDropDown() {
    return Padding(
      padding: const EdgeInsets.only(top:12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,


        children: [
           const Text(
                "State",
                style:  TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xff6A7187)),
              ),
          Padding(
            padding: const EdgeInsets.only(top:8.0),
            child: Container(
              width: MediaQuery.of(context).size.width/2.6,
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
                    
                    value: _currentSelectedStateValue,
                    style: const TextStyle(color: Color(0xff6A7187),overflow: TextOverflow.ellipsis),
                    items: states.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        alignment: AlignmentDirectional.centerStart,
                        value: value,
                        child: Text(value,style: TextStyle(
                          overflow: TextOverflow.ellipsis
                        ),),
                      );
                    }).toList(),
                    hint: const Text(
                      "Select State",
                      style: TextStyle(
                          color: Color(0xff6A7187),
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                    ),
                    onChanged: (String? value) {
                      setState(() {
                      
                        _currentSelectedStateValue = value;
                    
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


  //Timezone dropdown

  Widget timeZoneDropdown() {
    return Padding(
      padding: const EdgeInsets.only(top:12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,


        children: [
           const Text(
                "Timezone",
                style:  TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xff6A7187)),
              ),
          Padding(
            padding: const EdgeInsets.only(top:8.0),
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
                  child: DropdownButtonFormField<tz.Location>(
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                    ),
                    menuMaxHeight: 380,
                    value: _currentSelectedValue,
                    style: const TextStyle(color: Color(0xff6A7187)),
                    items: timeZones.map<DropdownMenuItem<tz.Location>>((tz.Location value) {
                      return DropdownMenuItem<tz.Location>(
                        alignment: AlignmentDirectional.centerStart,
                        value: value,
                        child: Text(value.name),
                      );
                    }).toList(),
                    hint: const Text(
                      "Select Timezone",
                      style: TextStyle(
                          color: Color(0xff6A7187),
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                    ),
                    onChanged: (tz.Location? value) {
                      setState(() {
                      
                        _currentSelectedTimezoneValue = value;

                        
                    
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

  Widget taxSwitchWidget(String label,bool switchValue){
    return Padding(
      padding: const EdgeInsets.only(top:12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,style: const TextStyle(
            color: Color(0xff6A7187),
            fontSize: 14,
            fontWeight: FontWeight.w600
          ),),
          Transform.scale(
            scale: 0.8,
            child: CupertinoSwitch(value: switchValue, onChanged: (value){}))
        ],
      ),
    );
  }


  // add employee widget

  addEmployeeWidget(){
    return Padding(
      padding: const EdgeInsets.only(left:24.0,right:24,bottom:24,top:8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
            const Text("Employees",style: TextStyle(
                    color: AppColors.primaryTitleColor,
                    fontSize: 28,
                    fontWeight: FontWeight.w600
                  ),),

                      const Padding(
                        padding:  EdgeInsets.only(top:8.0),
                        child:  Text("Get started by adding an employee to your company account.",style: TextStyle(
                                          color: AppColors.greyText,
                                          fontSize: 14,
                                          letterSpacing: 1.2,
                                          fontWeight: FontWeight.w400
                                        ),),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(top:52.0),
                        child: GestureDetector(
                          onTap: (){
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                              return CreateEmployeeScreen();
                            },));
                          },
                          child: Container(
                          height: 56,
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Color(0xffF6F6F6),
                            
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add_circle_outline,
                              color: AppColors.primaryColors,),
                               Padding(
                                 padding: EdgeInsets.only(left:8.0),
                                 child: Text("Add New Employee",
                                                           style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.primaryColors
                                                           ),),
                               ),
                            ],
                          ),
                                            ),
                        ),
                      ),
        ],
      ),
    );
  }





 



  
}