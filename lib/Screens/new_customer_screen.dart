import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../api_provider/api_repository.dart';
import '../bloc/customer_bloc/customer_bloc.dart';
import '../utils/app_colors.dart';
import '../utils/app_strings.dart';

class NewCustomerScreen extends StatefulWidget {
  const NewCustomerScreen({Key? key}) : super(key: key);

  @override
  State<NewCustomerScreen> createState() => _NewCustomerScreenState();
}

class _NewCustomerScreenState extends State<NewCustomerScreen> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController customerNotesController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController zipCodeController = TextEditingController();

  final countryPicker = const FlCountryCodePicker();
  CountryCode? selectedCountry;

  bool firstNameErrorStatus = false;
  bool lastNameErrorStatus = false;
  bool emailErrorStatus = false;
  bool phoneNumberErrorStatus = false;
  bool customerErrorStatus = false;
  bool addressErrorStatus = false;
  bool cityErrorStatus = false;
  bool zipCodeErrorStatus = false;
  bool nameErrorStaus = false;
  bool stateErrorStatus = false;

  bool check = false;

  String firstNameErrorMsg = '';
  String lastNameErrorMsg = '';
  String emailErrorMsg = '';
  String phoneErrorMsg = '';
  String passwordErrorMsg = '';
  String customerNotesErrorMsg = '';
  String addressErrorMsg = '';
  String cityErrorMsg = '';
  String stateErrorMsg = '';
  String zipCodeErrorMsg = '';

  String? _dropDownValues;
  String? selectedValue;

  List? dropdownList;
  final _dropdownFormKey = GlobalKey<FormState>();
  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(child: Text("USA"), value: "USA"),
      DropdownMenuItem(child: Text("Canada"), value: "Canada"),
      DropdownMenuItem(child: Text("Brazil"), value: "Brazil"),
      DropdownMenuItem(child: Text("England"), value: "England"),
    ];
    return menuItems;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: Text(
          'New Customer',
          style: TextStyle(
              color: AppColors.primaryBlackColors,
              fontSize: AppStrings.fontSize16,
              fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.close_rounded,
                size: AppStrings.fontSize20,
                color: AppColors.primaryBlackColors,
              )),
          SizedBox(
            width: 20,
          )
        ],
      ),
      body: BlocProvider(
        create: (context) => CustomerBloc(apiRepository: ApiRepository()),
        child: BlocListener<CustomerBloc, CustomerState>(
          listener: (context, state) {
            if (state is AddCustomerError) {
              '==========================errrrrrrrrorrrrrrrrr';
            } else if (state is AddCustomerLoading) {
              Center(
                child: CupertinoActivityIndicator(),
              );
              // Navigator.pop(context, true);
            }
          },
          child: BlocBuilder<CustomerBloc, CustomerState>(
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.only(left: 24, right: 24, top: 5),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      textBox("Enter Name...", firstNameController,
                          "First Name", firstNameErrorStatus),
                      Visibility(
                          visible: firstNameErrorStatus,
                          child: Text(
                            firstNameErrorMsg,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Color(
                                0xffD80027,
                              ),
                            ),
                          )),
                      textBox("Enter Name...", lastNameController, "Last Name",
                          lastNameErrorStatus),
                      Visibility(
                          visible: lastNameErrorStatus,
                          child: Text(
                            lastNameErrorMsg,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Color(
                                0xffD80027,
                              ),
                            ),
                          )),
                      textBox("Enter email...", emailController, "Email",
                          emailErrorStatus),
                      Visibility(
                          visible: emailErrorStatus,
                          child: Text(
                            emailErrorMsg,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Color(
                                0xffD80027,
                              ),
                            ),
                          )),
                      textBox("ex. 555-555-5555", phoneNumberController,
                          "Phone", phoneNumberErrorStatus),
                      Visibility(
                          visible: phoneNumberErrorStatus,
                          child: Text(
                            phoneErrorMsg,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Color(
                                0xffD80027,
                              ),
                            ),
                          )),
                      textBox("Enter notes...", customerNotesController,
                          "Customer Notes", customerErrorStatus),
                      Visibility(
                          visible: customerErrorStatus,
                          child: Text(
                            customerNotesErrorMsg,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Color(
                                0xffD80027,
                              ),
                            ),
                          )),
                      textBox("Enter address...", addressController, "Address",
                          addressErrorStatus),
                      Visibility(
                          visible: addressErrorStatus,
                          child: Text(
                            addressErrorMsg,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Color(
                                0xffD80027,
                              ),
                            ),
                          )),
                      textBox("Enter city...", cityController, "City",
                          cityErrorStatus),
                      Visibility(
                          visible: cityErrorStatus,
                          child: Text(
                            cityErrorMsg,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Color(
                                0xffD80027,
                              ),
                            ),
                          )),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'State',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xff6A7187)),
                                ),
                                SizedBox(
                                  height: 6,
                                ),
                                SizedBox(
                                  height: 56,
                                  child: Form(
                                    key: _dropdownFormKey,
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButtonFormField(
                                          padding: EdgeInsets.zero,
                                          elevation: 4,
                                          isExpanded: true,
                                          isDense: true,
                                          hint: Text(
                                            'Select',
                                            style: TextStyle(
                                              color:
                                                  AppColors.primaryBlackColors,
                                            ),
                                          ),
                                          icon: Icon(
                                              Icons.keyboard_arrow_down_sharp),
                                          decoration: InputDecoration(
                                              disabledBorder:
                                                  OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: AppColors
                                                        .primaryGrayColors),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: stateErrorStatus ==
                                                            true
                                                        ? Color(0xffD80027)
                                                        : Color(0xffC1C4CD)),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              border: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: AppColors
                                                        .primaryGrayColors),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: AppColors
                                                        .primaryGrayColors),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              focusColor:
                                                  AppColors.primaryGrayColors
                                              // filled: true,
                                              // fillColor: AppColors.greyText,
                                              ),
                                          autovalidateMode:
                                              AutovalidateMode.always,
                                          // validator: (value) =>
                                          //     value == selectedValue?.isEmpty
                                          //         ? "States Cant be empty"
                                          //         : null,
                                          // dropdownColor: Colors.blueAccent,
                                          value: selectedValue,
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              selectedValue = newValue!;
                                              stateErrorStatus = false;
                                            });
                                            print('ihihi${selectedValue}');
                                          },
                                          items: dropdownItems),
                                    ),
                                  ),
                                ),
                                // SizedBox(
                                //   width: 10,
                                // ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Visibility(
                                      visible: stateErrorStatus,
                                      child: Text(
                                        stateErrorMsg,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: Color(
                                            0xffD80027,
                                          ),
                                        ),
                                      )),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          halfTextBox("Zipcode", zipCodeController, "Zip",
                              zipCodeErrorStatus),
                        ],
                      ),
                      CheckboxListTile(
                        fillColor: MaterialStatePropertyAll(
                            AppColors.primaryGrayColors),
                        controlAffinity: ListTileControlAffinity.leading,
                        title: Text("Create new estimate using this customer"),
                        value: check,
                        onChanged: (bool? value) {
                          setState(() {
                            check = value!;
                          });
                        },
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            validateConfirm(
                                firstNameController.text,
                                lastNameController.text,
                                emailController.text,
                                phoneNumberController.text,
                                // customerNotesController.text,
                                // cityController.text,
                                // addressController.text,
                                // zipCodeController.text,
                                context);
                          });
                        },
                        child: Container(
                          height: 56,
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: AppColors.primaryBlackColors,
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
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          height: 56,
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.transparent,
                          ),
                          child: const Text(
                            "Cancel",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: AppColors.primaryBlackColors),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

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
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff6A7187)),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 6.0, bottom: 15),
          child: SizedBox(
            height: 56,
            width: MediaQuery.of(context).size.width,
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                  hintText: placeHolder,
                  counterText: "",
                  prefixIcon: label == 'Phone' ? countryPickerWidget() : null,
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
              style: TextStyle(
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
              inputFormatters: [
                FilteringTextInputFormatter.deny(RegExp(r'\s')),
              ],
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
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Visibility(
              visible: zipCodeErrorStatus,
              child: Text(
                zipCodeErrorMsg,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(
                    0xffD80027,
                  ),
                ),
              )),
        ),
      ],
    );
  }

  Widget countryPickerWidget() {
    return GestureDetector(
      onTap: () async {
        // Show the country code picker when tapped.
        final code = await countryPicker.showPicker(context: context);
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

  validateConfirm(
      String firstName,
      String lastName,
      String email,
      String phoneNumber,
      // String customerNotes,
      // String city,
      // String address,
      // String state,
      // String zipCode,
      BuildContext context) {
    if (firstName.isEmpty) {
      setState(() {
        firstNameErrorMsg = 'First name cant be empty';
        firstNameErrorStatus = true;
      });
    } else {
      firstNameErrorStatus = false;
    }
    if (lastName.isEmpty) {
      lastNameErrorMsg = 'Last name cant be empty';
      lastNameErrorStatus = true;
    } else {
      lastNameErrorStatus = false;
    }
    if (email.isEmpty) {
      setState(() {
        emailErrorMsg = 'Email cant be empty';
        emailErrorStatus = true;
      });
    } else {
      emailErrorStatus = false;
    }
    if (phoneNumber.isEmpty) {
      setState(() {
        phoneErrorMsg = 'PhoneNumber cant be empty';
        phoneNumberErrorStatus = true;
      });
    } else {
      phoneNumberErrorStatus = false;
    }
    if (!firstNameErrorStatus &&
        !lastNameErrorStatus &&
        !emailErrorStatus &&
        !phoneNumberErrorStatus) {
      context.read<CustomerBloc>().add(AddCustomerDetails(
          context: context,
          firstName: firstNameController.text,
          lastName: lastNameController.text,
          email: emailController.text,
          mobileNo: phoneNumberController.text,
          customerNotes: customerNotesController.text,
          address: addressController.text,
          city: cityController.text,
          state: selectedValue ?? '',
          pinCode: zipCodeController.text));
      print('hiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii');
    } else {
      print('eeeeeeeeeeeeeeeeeeeeeeeeeeeeeee');
    }
  }
}
