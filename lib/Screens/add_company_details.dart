import 'dart:developer';

import 'package:auto_pilot/Models/employee_response_model.dart';
import 'package:auto_pilot/Models/province_model.dart';
import 'package:auto_pilot/Screens/add_company_screen.dart';
import 'package:auto_pilot/Screens/create_employee_screen.dart';
import 'package:auto_pilot/api_provider/api_repository.dart';
import 'package:auto_pilot/bloc/dashboard_bloc/dashboard_bloc.dart';
import 'package:auto_pilot/bloc/employee/employee_bloc.dart';
import 'package:auto_pilot/utils/app_colors.dart';
import 'package:auto_pilot/utils/app_utils.dart';
import 'package:country_data/country_data.dart';
import 'package:csc_picker/csc_picker.dart';

import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class AddCompanyDetailsScreen extends StatefulWidget {
  const AddCompanyDetailsScreen(
      {super.key,
      required this.widgetIndex,
      this.basicDetailsMap,
      this.operationDetailsMap});
  final int widgetIndex;
  final Map<String, dynamic>? basicDetailsMap;
  final Map<String, dynamic>? operationDetailsMap;

  @override
  State<AddCompanyDetailsScreen> createState() =>
      _AddCompanyDetailsScreenState();
}

class _AddCompanyDetailsScreenState extends State<AddCompanyDetailsScreen> {
  final countryPicker = const FlCountryCodePicker();
  CountryCode? selectedCountry;

  int? selectedEmployeeIndex;

  CountryData countryData = CountryData();
  List<Country> countries = [];
  List<String> states = [];
  Country? countrySelected;
  dynamic _currentSelectedValue;
  dynamic _currentSelectedStateValue;
  dynamic _currentSelectedTimezoneValue;
  String selectedCountryString = '';
  String selectedStateString = '';
  Iterable<tz.Location> timeZones = [];
  final busineesNameController = TextEditingController();
  final businessPhoneController = TextEditingController();
  final businessWebsiteController = TextEditingController();
  final addressController = TextEditingController();
  final cityController = TextEditingController();
  final zipController = TextEditingController();
  final labourRateController = TextEditingController();
  final taxRateController = TextEditingController();
  final numberOfEmployeeController = TextEditingController();
  bool businessNameErrorStatus = false;
  bool businessPhoneErrorStatus = false;
  bool businessWebsiteErrorStatus = false;
  bool addressErrorStatus = false;
  bool cityErrorStatus = false;
  bool zipErrorStatus = false;
  bool labourRateErrorStatus = false;
  bool taxRateErrorStatus = false;
  bool countryErrorStatus = false;
  bool stateErrorStatus = false;

  bool numberOfEmployeeErrorStatus = false;
  bool timeZoneErrorStatus = false;

  String countryValue = "";
  String stateValue = "";
  late String selectedState;

  String businessNameErrorMsg = '';
  String phoneErrorMsg = '';
  String addressErrorMsg = '';
  String countryErrorMsg = '';
  String cityErrorMsg = '';
  String stateErrorMsg = '';
  String zipErrorMsg = '';

  String numberOfEmployeeErrorMsg = '';
  String timeZoneErrorMsg = '';
  String taxRateErrorMsg = '';
  String laborRateErrorMsg = '';

  bool taxLabourSwitchValue = false;
  bool taxPartSwitchValue = false;
  bool taxMaterialSwitchValue = false;

  // Map<String, dynamic> basicDetailsmap = {};
  // Map<String, dynamic> operationDetailsMap = {};
  // Map<String, dynamic> employeeDetailsMap = {};
  List<ProvinceData> proviceList = [];
  ScrollController provinceScrollController = ScrollController();
  final provinceController = TextEditingController();
  int? provinceId;
  String numberOfEmployeeString = "";
  String timeZoneString = '';

  List<Employee> employeeList = [];
  late EmployeeBloc bloc;
  ScrollController employeeScrollController = ScrollController();
  final _debouncer = Debouncer();

  @override
  void initState() {
    initCountries();
    tz.initializeTimeZones();
    timeZones = tz.timeZoneDatabase.locations.values.where((element) {
      return element.name.contains("America/");
    });
    print(timeZones);
    bloc = BlocProvider.of<EmployeeBloc>(context);
    bloc.currentPage = 1;
    bloc.add(GetAllEmployees());
    // TODO: implement initState

    if (widget.widgetIndex == 0) {
      if (basicDetailsMap != null && basicDetailsMap != {}) {
        populateBasicDetails();
      }
    } else if (widget.widgetIndex == 1) {
      if (operationDetailsMap != null && operationDetailsMap != {}) {
        populateOperationDetails();
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
        leading: GestureDetector(
            onTap: () {
              if (widget.widgetIndex == 0) {
                if (busineesNameController.text.isNotEmpty ||
                    businessPhoneController.text.isNotEmpty ||
                    businessWebsiteController.text.isNotEmpty ||
                    addressController.text.isNotEmpty ||
                    cityController.text.isNotEmpty ||
                    zipController.text.isNotEmpty) {
                  showBackDialog(context,
                      "The entered data will be lost until you confirm it.");
                } else {
                  Navigator.pop(context);
                }
              } else if (widget.widgetIndex == 1) {
                if (labourRateController.text.isNotEmpty ||
                    taxRateController.text.isNotEmpty ||
                    numberOfEmployeeString.isNotEmpty) {
                  showBackDialog(context,
                      "The enterd data will be lost until you confim it.");
                } else {
                  Navigator.pop(context);
                }
              } else {
                Navigator.pop(context);
              }
            },
            child: const Icon(
              Icons.arrow_back,
              color: AppColors.primaryColors,
            )),
      ),
      bottomNavigationBar: Padding(
        padding:
            const EdgeInsets.only(bottom: 24.0, left: 24, right: 24, top: 0),
        child: GestureDetector(
          onTap: () {
            if (widget.widgetIndex == 0) {
              validateBasicDetails();
              print("hellooo");
            } else if (widget.widgetIndex == 1) {
              validateOperationDetails();
            } else if (widget.widgetIndex == 2) {
              employeeList.forEach((element) {
                employeeDetailsMap!.addAll({
                  element.id.toString():
                      "${element.firstName} ${element.lastName}"
                });
              });

              print(employeeDetailsMap);

              Navigator.pop(context, employeeDetailsMap);
            }
          },
          child: Container(
            height: 56,
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: AppColors.primaryColors,
            ),
            child: const Text(
              "Confirm",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white),
            ),
          ),
        ),
      ),
      body: widget.widgetIndex == 0
          ? basicDetailsWidget()
          : widget.widgetIndex == 1
              ? operationDetailsWidget()
              : addEmployeeWidget(),
    );
  }

  Widget basicDetailsWidget() {
    return SingleChildScrollView(
      // physics: CustomScrollPhysics(),
      child: Padding(
        padding:
            const EdgeInsets.only(left: 24.0, right: 24, bottom: 24, top: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Basic Details",
              style: TextStyle(
                  color: AppColors.primaryTitleColor,
                  fontSize: 28,
                  fontWeight: FontWeight.w600),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 25.0),
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
                            color: const Color.fromARGB(255, 225, 225, 225)),
                        child: Padding(
                          padding: const EdgeInsets.all(32.0),
                          child:
                              SvgPicture.asset("assets/images/upload_icon.svg"),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 8.0),
                        child: Text(
                          "Upload Logo",
                          style: TextStyle(
                              color: AppColors.greyText,
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: textBox("Enter Business Name", busineesNameController,
                  "Business Name", businessNameErrorStatus),
            ),
            errorMessageWidget(businessNameErrorMsg, businessNameErrorStatus),
            textBox("Enter business phone", businessPhoneController,
                "Business Phone", businessPhoneErrorStatus),
            errorMessageWidget(phoneErrorMsg, businessPhoneErrorStatus),
            textBox("Enter business Website", businessWebsiteController,
                "Business Website", businessWebsiteErrorStatus),
            textBox("Enter address", addressController, "Address",
                addressErrorStatus),
            errorMessageWidget(addressErrorMsg, addressErrorStatus),
            // countrydropDown(),
            // errorMessageWidget(countryErrorMsg, countryErrorStatus),
            textBox("Enter city", cityController, "City", cityErrorStatus),
            errorMessageWidget(cityErrorMsg, cityErrorStatus),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                stateDropDown(),
                textBox("Enter zipcode", zipController, "Zip", zipErrorStatus),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                errorMessageWidget(stateErrorMsg, stateErrorStatus),
                errorMessageWidget(zipErrorMsg, zipErrorStatus)
              ],
            )
          ],
        ),
      ),
    );
  }

  //Operation Details Widget

  Widget operationDetailsWidget() {
    return SingleChildScrollView(
      child: Padding(
        padding:
            const EdgeInsets.only(left: 24.0, right: 24, bottom: 24, top: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Operating Details",
              style: TextStyle(
                  color: AppColors.primaryTitleColor,
                  fontSize: 28,
                  fontWeight: FontWeight.w600),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 28.0),
              child: numberOfEmployeeWidget(),
            ),
            errorMessageWidget(
                numberOfEmployeeErrorMsg, numberOfEmployeeErrorStatus),
            timeZoneDropdown(),
            errorMessageWidget(timeZoneErrorMsg, timeZoneErrorStatus),
            textBox("Ex. \$45", labourRateController, "Shop Hourly Labor Rate",
                labourRateErrorStatus),
            errorMessageWidget(laborRateErrorMsg, labourRateErrorStatus),
            textBox("Enter Percentage Rate", taxRateController, "Tax Rate",
                taxRateErrorStatus),
            errorMessageWidget(taxRateErrorMsg, taxRateErrorStatus),
            taxSwitchWidget("Tax Labor", taxLabourSwitchValue),
            taxSwitchWidget("Tax Parts", taxPartSwitchValue),
            taxSwitchWidget("Tax Material", taxMaterialSwitchValue)
          ],
        ),
      ),
    );
  }

  Widget numberOfEmployeeWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // const Text(
        //   "Number of employees",
        //   style: TextStyle(
        //       fontSize: 14,
        //       fontWeight: FontWeight.w500,
        //       color: Color(0xff6A7187)),
        // ),
        textBox("Enter Number of Employees", numberOfEmployeeController,
            "Number of Employees", numberOfEmployeeErrorStatus)
      ],
    );
  }

  //Common Text field widget
  Widget textBox(String placeHolder, TextEditingController controller,
      String label, bool errorStatus) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
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
              width: label == 'Zip'
                  ? MediaQuery.of(context).size.width / 2.3
                  : MediaQuery.of(context).size.width,
              child: TextField(
                controller: controller,
                inputFormatters: label == "Business Phone"
                    ? [PhoneInputFormatter()]
                    : label == "Number of Employees" || label == 'Zip'
                        ? [FilteringTextInputFormatter.digitsOnly]
                        : [],
                keyboardType: label == 'Business Phone' ||
                        label == "Number of Employees" ||
                        label == "Shop Hourly Labor Rate" ||
                        label == "Tax Rate" ||
                        label == 'Zip'
                    ? TextInputType.number
                    : null,
                maxLength: label == 'Business Phone'
                    ? 19
                    : label == 'Password'
                        ? 12
                        : label == 'Zip'
                            ? 5
                            : 50,
                decoration: InputDecoration(
                    prefixText: label == 'Shop Hourly Labor Rate' ? '\$' : null,
                    hintText: placeHolder,
                    counterText: "",
                    suffixIcon: label == "Shop Hourly Labor Rate"
                        ? const Padding(
                            padding: EdgeInsets.only(right: 10.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "per hour",
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: AppColors.primaryTitleColor),
                                ),
                              ],
                            ),
                          )
                        : label == "Tax Rate"
                            ? const Padding(
                                padding: EdgeInsets.only(right: 10.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "%",
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: AppColors.primaryColors),
                                    ),
                                  ],
                                ),
                              )
                            : const SizedBox(),

                    // prefixIcon: label == 'Business Phone'
                    //     ? countryPickerWidget()
                    //     : null,
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
      padding: const EdgeInsets.only(top: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Country",
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xff6A7187)),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 56,
              // margin: const EdgeInsets.only(left: 15, top: 10, right: 15),
              // padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                  border: Border.all(
                      color: countryErrorStatus
                          ? const Color(0xFFD80027)
                          : const Color(0xffC1C4CD)),
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
                    items: countries
                        .map<DropdownMenuItem<Country>>((Country value) {
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
                        selectedCountryString = value!.name;
                        initCountryStates(value.id);
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
      padding: const EdgeInsets.only(top: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "State",
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xff6A7187)),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width / 2.6,
                height: 56,
                // margin: const EdgeInsets.only(left: 15, top: 10, right: 15),
                // padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xffC1C4CD)),
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: TextField(
                    readOnly: true,
                    controller: provinceController,
                    onTap: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return provinceBottomSheet();
                          },
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent);
                    },
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Select State",
                        suffixIcon: Icon(Icons.arrow_drop_down)),
                  ),
                )),
          ),
        ],
      ),
    );
  }

  //Timezone dropdown

  Widget timeZoneDropdown() {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Time Zone",
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xff6A7187)),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 56,
              // margin: const EdgeInsets.only(left: 15, top: 10, right: 15),
              // padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                  border: Border.all(
                      color: timeZoneErrorStatus
                          ? const Color(0xffD80027)
                          : const Color(0xffC1C4CD)),
                  borderRadius: BorderRadius.circular(12)),
              child: DropdownButtonHideUnderline(
                child: ButtonTheme(
                  alignedDropdown: true,
                  child: DropdownButtonFormField<tz.Location>(
                    icon: const Icon(
                      Icons.keyboard_arrow_down_sharp,
                      color: AppColors.primaryColors,
                    ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                    ),
                    menuMaxHeight: 380,
                    value: _currentSelectedTimezoneValue,
                    style: const TextStyle(color: Color(0xff6A7187)),
                    items: timeZones.map<DropdownMenuItem<tz.Location>>(
                        (tz.Location value) {
                      return DropdownMenuItem<tz.Location>(
                        alignment: AlignmentDirectional.centerStart,
                        value: value,
                        child: Text(value.name),
                      );
                    }).toList(),
                    hint: const Text(
                      "Select timezone",
                      style: TextStyle(
                          color: Color(0xff6A7187),
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                    ),
                    onChanged: (tz.Location? value) {
                      setState(() {
                        _currentSelectedTimezoneValue = value;
                        timeZoneString = value!.name.toString();
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

  Widget taxSwitchWidget(String label, bool switchValue) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
                color: Color(0xff6A7187),
                fontSize: 14,
                fontWeight: FontWeight.w600),
          ),
          Transform.scale(
              scale: 0.8,
              child: CupertinoSwitch(
                  value: label == "Tax Labor"
                      ? taxLabourSwitchValue
                      : label == "Tax Parts"
                          ? taxPartSwitchValue
                          : taxMaterialSwitchValue,
                  onChanged: (value) {
                    if (label == "Tax Labor") {
                      setState(() {
                        taxLabourSwitchValue = value;
                      });
                    } else if (label == "Tax Parts") {
                      setState(() {
                        taxPartSwitchValue = value;
                      });
                    } else if (label == "Tax Material") {
                      setState(() {
                        taxMaterialSwitchValue = value;
                      });
                    }
                  }))
        ],
      ),
    );
  }

  // add employee widget

  addEmployeeWidget() {
    return Padding(
      padding: const EdgeInsets.only(left: 24.0, right: 24, bottom: 24, top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Employees",
            style: TextStyle(
                color: AppColors.primaryTitleColor,
                fontSize: 28,
                fontWeight: FontWeight.w600),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Text(
              "Get started by adding an employee to your company account.",
              style: TextStyle(
                  color: AppColors.greyText,
                  fontSize: 14,
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.w400),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 52.0),
            child: GestureDetector(
              onTap: () async {
                await Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) {
                    return const CreateEmployeeScreen(
                        navigation: "add_company");
                  },
                )).then((value) {
                  if (value != null && value) {
                    bloc.currentPage = 1;
                    bloc.add(GetAllEmployees());
                  }
                });
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
                    Icon(
                      Icons.add_circle_outline,
                      color: AppColors.primaryColors,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Text(
                        "Add New Employee",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: AppColors.primaryColors),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Employee list
          employeeListWidget()
        ],
      ),
    );
  }

  void validateBasicDetails() {
    if (busineesNameController.text.isEmpty) {
      setState(() {
        businessNameErrorStatus = true;
        businessNameErrorMsg = "Business name can't be empty";
      });
    } else {
      setState(() {
        businessNameErrorStatus = false;
      });
    }
    if (businessPhoneController.text.isEmpty) {
      setState(() {
        businessPhoneErrorStatus = true;
        phoneErrorMsg = "Business phone can't be empty";
      });
    } else {
      if (businessPhoneController.text.length < 6) {
        setState(() {
          businessPhoneErrorStatus = true;
          phoneErrorMsg = "Please enter a valid business phone";
        });
      } else {
        setState(() {
          businessPhoneErrorStatus = false;
        });
      }
    }
    if (addressController.text.isEmpty) {
      setState(() {
        addressErrorStatus = true;
        addressErrorMsg = "Address can't be empty";
      });
    } else {
      setState(() {
        addressErrorStatus = false;
      });
    }
    // if(selectedCountryString.isEmpty){
    //   setState(() {
    //     countryErrorStatus=true;
    //     countryErrorMsg='Please select a county';

    //   });

    // }else{
    //   setState(() {
    //      countryErrorStatus=false;
    //   });

    // }
    if (cityController.text.isEmpty) {
      setState(() {
        cityErrorStatus = true;
        cityErrorMsg = "City cant't be empty";
      });
    } else {
      setState(() {
        cityErrorStatus = false;
      });
    }
    if (provinceId == null || provinceId == 0) {
      setState(() {
        stateErrorStatus = true;
        stateErrorMsg = "Please select a state";
      });
    } else {
      setState(() {
        stateErrorStatus = false;
      });
    }
    if (zipController.text.isEmpty) {
      setState(() {
        zipErrorStatus = true;
        zipErrorMsg = "Zip can't be empty";
      });
    } else {
      if (zipController.text.length < 2) {
        setState(() {
          zipErrorStatus = true;
          zipErrorMsg = "Please enter a valid zip code";
        });
      } else {
        setState(() {
          zipErrorStatus = false;
        });
      }
    }

    if (!businessNameErrorStatus &&
        !businessPhoneErrorStatus &&
        !addressErrorStatus &&
        !countryErrorStatus &&
        !cityErrorStatus &&
        !stateErrorStatus &&
        !zipErrorStatus) {
      basicDetailsMap!.addAll({
        "company_name": busineesNameController.text,
        "phone": businessPhoneController.text,
        "address_1": addressController.text,
        "town_city": cityController.text,
        "zipcode": zipController.text,
        "province_id": provinceId,
        "province_name": provinceController.text,
        "website": businessWebsiteController.text
      });

      Navigator.pop(context, basicDetailsMap);
    }
  }

  Widget errorMessageWidget(String errorMsg, bool isVisible) {
    return Padding(
      padding: const EdgeInsets.only(top: 6.0),
      child: Visibility(
        visible: isVisible,
        child: Text(
          errorMsg,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFFD80027),
          ),
        ),
      ),
    );
  }

  Widget provinceBottomSheet() {
    return BlocProvider(
      create: (context) => DashboardBloc(apiRepository: ApiRepository())
        ..add(GetProvinceEvent()),
      child: BlocListener<DashboardBloc, DashboardState>(
        listener: (context, state) {
          if (state is GetProvinceState) {
            proviceList.addAll(state.provinceList.data.data);

            print(proviceList);
          }
          // TODO: implement listener
        },
        child: BlocBuilder<DashboardBloc, DashboardState>(
          builder: (context, state) {
            return Container(
              height: MediaQuery.of(context).size.height / 2,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12), color: Colors.white),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "State",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primaryTitleColor),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: LimitedBox(
                        maxHeight: MediaQuery.of(context).size.height / 2 - 90,
                        child: ListView.builder(
                          itemBuilder: (context, index) {
                            if (index == proviceList.length) {
                              return BlocProvider.of<DashboardBloc>(context)
                                              .currentPage <=
                                          BlocProvider.of<DashboardBloc>(
                                                  context)
                                              .totalPages &&
                                      BlocProvider.of<DashboardBloc>(context)
                                              .currentPage !=
                                          0
                                  ? const SizedBox(
                                      height: 40,
                                      child: CupertinoActivityIndicator(
                                        color: AppColors.primaryColors,
                                      ))
                                  : Container();
                            }

                            return Padding(
                              padding: const EdgeInsets.only(top: 12.0),
                              child: GestureDetector(
                                onTap: () {
                                  print("heyy");

                                  provinceController.text =
                                      proviceList[index].provinceName;
                                  provinceId = proviceList[index].id;

                                  Navigator.pop(context);
                                },
                                child: Container(
                                  height: 50,
                                  decoration: BoxDecoration(
                                      color: Colors.grey[100],
                                      borderRadius: BorderRadius.circular(8)),
                                  width: MediaQuery.of(context).size.width,
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Text(
                                      proviceList[index].provinceName,
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                          itemCount: proviceList.length + 1,
                          controller: provinceScrollController
                            ..addListener(() {
                              if ((BlocProvider.of<DashboardBloc>(context)
                                          .currentPage <=
                                      BlocProvider.of<DashboardBloc>(context)
                                          .totalPages) &&
                                  provinceScrollController.offset ==
                                      provinceScrollController
                                          .position.maxScrollExtent &&
                                  BlocProvider.of<DashboardBloc>(context)
                                          .currentPage !=
                                      0 &&
                                  !BlocProvider.of<DashboardBloc>(context)
                                      .isFetching) {
                                context.read<DashboardBloc>()
                                  ..isFetching = true
                                  ..add(GetProvinceEvent());
                              }
                            }),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  validateOperationDetails() {
    if (numberOfEmployeeController.text.isEmpty) {
      setState(() {
        numberOfEmployeeErrorStatus = true;
        numberOfEmployeeErrorMsg = "Please select number of employees";
      });
    } else {
      setState(() {
        numberOfEmployeeErrorStatus = false;
      });
    }
    if (timeZoneString.isEmpty) {
      setState(() {
        timeZoneErrorStatus = true;
        timeZoneErrorMsg = "Please select a time zone";
      });
    } else {
      setState(() {
        timeZoneErrorStatus = false;
      });
    }
    if (labourRateController.text.isEmpty) {
      setState(() {
        labourRateErrorStatus = true;
        laborRateErrorMsg = "Labor rate can't be empty";
      });
    } else {
      setState(() {
        labourRateErrorStatus = false;
      });
    }
    if (taxRateController.text.isEmpty) {
      setState(() {
        taxRateErrorStatus = true;
        taxRateErrorMsg = "Tax rate can't be empty";
      });
    } else {
      setState(() {
        taxRateErrorStatus = false;
      });
    }

    if (!numberOfEmployeeErrorStatus &&
        !timeZoneErrorStatus &&
        !labourRateErrorStatus &&
        !taxRateErrorStatus) {
      operationDetailsMap!.addAll({
        "employee_count": numberOfEmployeeController.text,
        "time_zone": timeZoneString,
        "base_labor_cost": labourRateController.text.replaceAll('\$', ''),
        "sales_tax_rate": taxRateController.text
      });

      Navigator.pop(context, operationDetailsMap);
    }
  }

  Widget employeeListWidget() {
    return Padding(
      padding: const EdgeInsets.only(top: 24.0),
      child: Container(
        height: MediaQuery.of(context).size.width - 49,
        child: SingleChildScrollView(
          controller: employeeScrollController
            ..addListener(() {
              if (employeeScrollController.offset ==
                      employeeScrollController.position.maxScrollExtent &&
                  !bloc.isPagenationLoading &&
                  bloc.currentPage <= bloc.totalPages) {
                _debouncer.run(() {
                  bloc.isPagenationLoading = true;
                  bloc.add(GetAllEmployees());
                });
              }
            }),
          child: BlocListener<EmployeeBloc, EmployeeState>(
            listener: (context, state) {
              if (state is EmployeeDetailsSuccessState) {
                log('Adding');
                employeeList.clear();
                employeeList.addAll(state.employees.employeeList ?? []);

                // if (employeeList.isNotEmpty) {
                //   employeeList.forEach((element) {
                //     employeeDetailsMap.addAll({
                //       element.id.toString():
                //           "${element.firstName} ${element.lastName}"
                //     });
                //   });

                //   print(employeeDetailsMap);
                // }
              }
            },
            child: BlocBuilder<EmployeeBloc, EmployeeState>(
              builder: (context, state) {
                if (state is EmployeeDetailsLoadingState &&
                    !bloc.isPagenationLoading) {
                  return const Center(child: CupertinoActivityIndicator());
                } else {
                  return employeeList.isEmpty
                      ? const Center(
                          child: Text(
                          '',
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryTextColors),
                        ))
                      : ScrollConfiguration(
                          behavior: const ScrollBehavior(),
                          child: ListView.separated(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                final item = employeeList[index];
                                return Column(
                                  children: [
                                    GestureDetector(
                                      behavior: HitTestBehavior.opaque,
                                      onTap: () {
                                        // Navigator.of(context).push(
                                        //   MaterialPageRoute(
                                        //     builder: (context) =>
                                        //         EmployeeDetailsScreen(
                                        //       employee: item,
                                        //     ),
                                        //   ),
                                        // );
                                      },
                                      child: Container(
                                        height: 77,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black
                                                  .withOpacity(0.07),
                                              offset: const Offset(0, 4),
                                              blurRadius: 10,
                                            ),
                                          ],
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16.0),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '${item.firstName ?? ""} ${item.lastName ?? ""} ',
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                style: const TextStyle(
                                                  color: Color(0xFF061237),
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              const SizedBox(height: 3),
                                              Text(
                                                item.roles?[0].name!
                                                        .toUpperCase() ??
                                                    '',
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                style: const TextStyle(
                                                  color: Color(0xFF6A7187),
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    bloc.currentPage <= bloc.totalPages &&
                                            index == employeeList.length - 1
                                        ? const Column(
                                            children: [
                                              SizedBox(height: 24),
                                              Center(
                                                child:
                                                    CupertinoActivityIndicator(),
                                              ),
                                              SizedBox(height: 24),
                                            ],
                                          )
                                        : const SizedBox(),
                                    index == employeeList.length - 1
                                        ? const SizedBox(height: 24)
                                        : const SizedBox(),
                                  ],
                                );
                              },
                              separatorBuilder: (context, index) =>
                                  const SizedBox(height: 24),
                              itemCount: employeeList.length),
                        );
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  populateBasicDetails() {
    busineesNameController.text = basicDetailsMap?['company_name'] ?? "";
    businessPhoneController.text = basicDetailsMap?['phone'] ?? "";
    addressController.text = basicDetailsMap?['address_1'] ?? "";
    cityController.text = basicDetailsMap?['town_city'] ?? "";
    provinceController.text = basicDetailsMap?['province_name'] ?? "";
    zipController.text = basicDetailsMap?['zipcode'] ?? "";
    provinceId = basicDetailsMap?['province_id'] ?? 0;
    businessWebsiteController.text = basicDetailsMap?['website'] ?? "";

    print(basicDetailsMap);
  }

  populateOperationDetails() {
    labourRateController.text = operationDetailsMap?['base_labor_cost'] ?? "";
    taxRateController.text = operationDetailsMap?['sales_tax_rate'] ?? "";
    numberOfEmployeeController.text =
        operationDetailsMap?['employee_count'] ?? "";

    timeZones.forEach((element) {
      print(element.name);
      if (element.name == operationDetailsMap?['time_zone']) {
        print("in condition");
        setState(() {
          _currentSelectedTimezoneValue = element;
          timeZoneString = element.name;
          print(timeZoneString + "tiiimme zoneee");
        });
      }
    });
  }

  Future showBackDialog(BuildContext context, message) {
    return showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text("Do you really want to go back?"),
        content: Text(message),
        actions: <Widget>[
          CupertinoDialogAction(
            child: const Text("Yes"),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
              if (widget.widgetIndex == 1) {
                operationDetailsMap.clear();
              } else if (widget.widgetIndex == 0) {
                basicDetailsMap.clear();
              }
            },
          ),
          CupertinoDialogAction(
            child: const Text("No"),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  validateEmployeeDetails() {
    employeeList.forEach((element) {
      employeeDetailsMap!.addAll(
          {element.id.toString(): "${element.firstName} ${element.lastName}"});
    });

    print(employeeDetailsMap);

    Navigator.pop(context, employeeDetailsMap);
  }
}

// class CustomScrollPhysics extends ScrollPhysics {
//   const CustomScrollPhysics({ScrollPhysics? parent}) : super(parent: parent);

//   @override
//   CustomScrollPhysics applyTo(ScrollPhysics? ancestor) {
//     return CustomScrollPhysics(parent: buildParent(ancestor));
//   }

//   @override
//   bool shouldAcceptUserOffset(ScrollMetrics position) {
//     return true;
//   }

//   @override
//   double applyPhysicsToUserOffset(ScrollMetrics position, double offset) {
//     return offset;
//   }
// }
