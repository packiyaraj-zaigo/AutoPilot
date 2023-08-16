import 'dart:developer';

import 'package:auto_pilot/Models/customer_model.dart';
import 'package:auto_pilot/Screens/customers_screen.dart';
import 'package:auto_pilot/Screens/dummy_customer_screen.dart';
import 'package:auto_pilot/utils/app_utils.dart';
import 'package:auto_pilot/utils/common_widgets.dart';
import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../Models/province_model.dart';
import '../bloc/customer_bloc/customer_bloc.dart';
import '../utils/app_colors.dart';
import '../utils/app_strings.dart';

class NewCustomerScreen extends StatefulWidget {
  final Datum? customerEdit;
  final String? navigation;
  final String? orderId;
  const NewCustomerScreen(
      {Key? key, this.customerEdit, this.navigation, this.orderId})
      : super(key: key);

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
  List<ProvinceData> proviceList = [];
  ScrollController provinceScrollController = ScrollController();
  final TextEditingController provinceController = TextEditingController();
  int? provinceId;
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
  String? selectedValue;
  List? dropdownList;
  @override
  void initState() {
    if (widget.customerEdit != null) {
      firstNameController.text = widget.customerEdit?.firstName ?? "";
      lastNameController.text = widget.customerEdit?.lastName ?? '';
      emailController.text = widget.customerEdit?.email ?? '';
      phoneNumberController.text =
          '(${widget.customerEdit!.phone.substring(0, 3)}) ${widget.customerEdit!.phone.substring(3, 6)}-${widget.customerEdit!.phone.substring(6)}';
      customerNotesController.text = widget.customerEdit?.notes ?? '';
      addressController.text = widget.customerEdit?.addressLine1 ?? '';
      cityController.text = widget.customerEdit?.townCity ?? '';
      zipCodeController.text = widget.customerEdit?.zipcode ?? '';
      provinceController.text = widget.customerEdit?.provinceName == null
          ? ''
          : widget.customerEdit?.provinceName['province_name'] ?? '';
    }
    super.initState();
  }

  Future<bool> networkCheck() async {
    final value = await AppUtils.getConnectivity().then((value) {
      return value;
    });
    return value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: Text(
          widget.customerEdit != null ? 'Edit Customer' : 'New Customer',
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
              icon: const Icon(
                Icons.close_rounded,
                color: AppColors.primaryColors,
              )),
        ],
      ),
      body: BlocProvider(
        create: (context) => CustomerBloc(),
        child: BlocListener<CustomerBloc, CustomerState>(
          listener: (context, state) {
            if (state is AddCustomerError) {
              CommonWidgets().showDialog(context, state.message);

              '==========================errrrrrrrrorrrrrrrrr';
            } else if (state is CreateCustomerState) {
              if (widget.navigation != null) {
                //  Navigator.pop(context);
                Navigator.pushReplacement(context, MaterialPageRoute(
                  builder: (context) {
                    return DummyCustomerScreen(
                      customerId: state.id,
                      navigation: widget.navigation,
                      orderId: widget.orderId,
                    );
                  },
                ));
              } else {
                if (check) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) =>
                          DummyCustomerScreen(customerId: state.id),
                    ),
                    (route) => false,
                  );
                } else {
                  CommonWidgets().showSuccessDialog(
                      context, "Customer Created Successfully");
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => const CustomersScreen(),
                    ),
                    (route) => false,
                  );
                }
              }
            } else if (state is AddCustomerLoading) {
              const Center(
                child: CupertinoActivityIndicator(),
              );
              // Navigator.pop(context, true);
            } else if (state is EditCustomerLoading) {
              const Center(
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
                      textBox("Enter First Name", firstNameController,
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
                      const SizedBox(height: 15),
                      textBox("Enter Last Name", lastNameController,
                          "Last Name", lastNameErrorStatus),
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
                      const SizedBox(height: 15),
                      textBox("Enter Email", emailController, "Email",
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
                      const SizedBox(height: 15),
                      textBox("Ex. (555) 555-5555", phoneNumberController,
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
                      const SizedBox(height: 15),
                      textBox("Enter Notes", customerNotesController,
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
                      const SizedBox(height: 15),
                      textBox("Enter Address", addressController, "Address",
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
                      const SizedBox(height: 15),
                      textBox("Enter City", cityController, "City",
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
                      // textBox("Enter Zipcode...", zipCodeController, "Zip",
                      //     zipCodeErrorStatus),
                      const SizedBox(height: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  stateDropDown(),
                                  Visibility(
                                      visible: stateErrorStatus,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        child: Text(
                                          stateErrorMsg,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Color(
                                              0xffD80027,
                                            ),
                                          ),
                                        ),
                                      )),
                                ],
                              ),
                              // const SizedBox(
                              //   width: 10,
                              // ),
                              Column(
                                children: [
                                  halfTextBox(
                                      "Enter Zipcode",
                                      zipCodeController,
                                      "Zip",
                                      zipCodeErrorStatus),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Visibility(
                                      visible: zipCodeErrorStatus,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        child: Text(
                                          zipCodeErrorMsg,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Color(
                                              0xffD80027,
                                            ),
                                          ),
                                        ),
                                      ))
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                      widget.navigation == "estimate_screen" ||
                              widget.navigation == "partial_estimate" ||
                              widget.customerEdit != null
                          ? const SizedBox()
                          : CheckboxListTile(
                              fillColor: const MaterialStatePropertyAll(
                                  AppColors.primaryGrayColors),
                              controlAffinity: ListTileControlAffinity.leading,
                              title: const Text(
                                  "Create new estimate using this customer"),
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
                                customerNotesController.text,
                                addressController.text,
                                cityController.text,
                                provinceController.text,
                                zipCodeController.text,
                                context);
                          });
                        },
                        child: Container(
                          height: 56,
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: AppColors.primaryColors,
                          ),
                          child: state is EditCustomerLoading ||
                                  state is AddCustomerLoading
                              ? const Center(
                                  child: CupertinoActivityIndicator(),
                                )
                              : Text(
                                  widget.customerEdit != null
                                      ? "Update"
                                      : "Confirm",
                                  style: const TextStyle(
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
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff6A7187)),
            ),
            label == 'First Name' ||
                    label == 'Last Name' ||
                    label == 'Email' ||
                    label == 'Phone' ||
                    label == 'Address' ||
                    label == 'City'
                ? const Text(
                    " *",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color(
                        0xffD80027,
                      ),
                    ),
                  )
                : const Text(''),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 6.0, bottom: 2),
          child: SizedBox(
            height: 56,
            width: MediaQuery.of(context).size.width,
            child: TextFormField(
              textCapitalization: TextCapitalization.sentences,
              controller: controller,
              maxLength: label == "Phone"
                  ? 14
                  : label == "Customer Notes" ||
                          label == "Address" ||
                          label == "Email"
                      ? 50
                      : 25,
              keyboardType: label == "Phone"
                  ? TextInputType.phone
                  : label == "Email"
                      ? TextInputType.emailAddress
                      : TextInputType.text,
              inputFormatters: label == "Phone" ? [PhoneInputFormatter()] : [],
              decoration: InputDecoration(
                  hintText: placeHolder,
                  counterText: "",
                  // prefixIcon: label == 'Phone' ? countryPickerWidget() : null,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                          color: errorStatus == true
                              ? const Color(0xffD80027)
                              : const Color(0xffC1C4CD))),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                          color: errorStatus == true
                              ? const Color(0xffD80027)
                              : const Color(0xffC1C4CD))),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                          color: errorStatus == true
                              ? const Color(0xffD80027)
                              : const Color(0xffC1C4CD)))),
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
            const Text(
              "*",
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xffD80027)),
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
              maxLength: 5,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              decoration: InputDecoration(
                  hintText: placeHolder,
                  counterText: "",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                          color: errorStatus == true
                              ? const Color(0xffD80027)
                              : const Color(0xffC1C4CD))),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                          color: errorStatus == true
                              ? const Color(0xffD80027)
                              : const Color(0xffC1C4CD))),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                          color: errorStatus == true
                              ? const Color(0xffD80027)
                              : const Color(0xffC1C4CD)))),
            ),
          ),
        ),
        // Padding(
        //   padding: const EdgeInsets.all(8.0),
        //   child: Visibility(
        //       visible: zipCodeErrorStatus,
        //       child: Text(
        //         zipCodeErrorMsg,
        //         style: const TextStyle(
        //           fontSize: 14,
        //           fontWeight: FontWeight.w500,
        //           color: Color(
        //             0xffD80027,
        //           ),
        //         ),
        //       )),
        // ),
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

  Widget provinceBottomSheet() {
    return BlocProvider(
      create: (context) => CustomerBloc()..add(GetProvinceEvent()),
      child: BlocListener<CustomerBloc, CustomerState>(
        listener: (context, state) {
          if (state is GetProvinceState) {
            proviceList.addAll(state.provinceList.data.data);

            log(proviceList.toString());
          }
        },
        child: BlocBuilder<CustomerBloc, CustomerState>(
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
                              return BlocProvider.of<CustomerBloc>(context)
                                              .currentPage <=
                                          BlocProvider.of<CustomerBloc>(context)
                                              .totalPages &&
                                      BlocProvider.of<CustomerBloc>(context)
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
                              if ((BlocProvider.of<CustomerBloc>(context)
                                          .currentPage <=
                                      BlocProvider.of<CustomerBloc>(context)
                                          .totalPages) &&
                                  provinceScrollController.offset ==
                                      provinceScrollController
                                          .position.maxScrollExtent &&
                                  BlocProvider.of<CustomerBloc>(context)
                                          .currentPage !=
                                      0 &&
                                  !BlocProvider.of<CustomerBloc>(context)
                                      .isFetching) {
                                context.read<CustomerBloc>()
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

  Widget stateDropDown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Text(
              "State",
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff6A7187)),
            ),
            Text(
              "*",
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xffD80027)),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 6.0),
          child: Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width / 2.6,
              height: 56,
              // margin: const EdgeInsets.only(left: 15, top: 10, right: 15),
              // padding: const EdgeInsets.all(5),
              // decoration: BoxDecoration(
              //     border: Border.all(color: const Color(0xffC1C4CD)),
              //     borderRadius: BorderRadius.circular(12)),
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
                decoration: InputDecoration(
                    hintText: "Select State",
                    suffixIcon: const Icon(Icons.arrow_drop_down),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                            color: stateErrorStatus == true
                                ? const Color(0xffD80027)
                                : const Color(0xffC1C4CD))),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                            color: stateErrorStatus == true
                                ? const Color(0xffD80027)
                                : const Color(0xffC1C4CD))),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                            color: stateErrorStatus == true
                                ? const Color(0xffD80027)
                                : const Color(0xffC1C4CD)))),
              )),
        ),
      ],
    );
  }

  validateConfirm(
      String firstName,
      String lastName,
      String email,
      String phoneNumber,
      String customerNotes,
      String address,
      String city,
      String state,
      String zipCode,
      BuildContext context) {
    if (firstName.trim().isEmpty) {
      setState(() {
        firstNameErrorMsg = "First name can't be empty";
        firstNameErrorStatus = true;
      });
    } else if (firstName.trim().length < 2) {
      setState(() {
        firstNameErrorMsg = "Enter a valid first name";
        firstNameErrorStatus = true;
      });
    } else {
      setState(() {
        firstNameErrorStatus = false;
      });
    }
    if (lastName.trim().isEmpty) {
      setState(() {
        lastNameErrorMsg = "Last name can't be empty";
        lastNameErrorStatus = true;
      });
    } else if (lastName.trim().length < 2) {
      setState(() {
        lastNameErrorMsg = "Enter a valid last name";
        lastNameErrorStatus = true;
      });
    } else {
      setState(() {
        lastNameErrorStatus = false;
      });
    }
    if (email.trim().isEmpty) {
      setState(() {
        emailErrorMsg = "Email can't be empty";
        emailErrorStatus = true;
      });
    } else if (!RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(email)) {
      setState(() {
        emailErrorMsg = "Enter a valid email address";
        emailErrorStatus = true;
      });
    } else {
      setState(() {
        emailErrorStatus = false;
      });
    }
    if (phoneNumber.isEmpty) {
      setState(() {
        phoneErrorMsg = "Phone number can't be empty";
        phoneNumberErrorStatus = true;
      });
    } else if (phoneNumber
            .replaceAll(RegExp(r'[^\w\s]+'), '')
            .replaceAll(" ", "")
            .length <
        10) {
      setState(() {
        phoneErrorMsg = "Enter a valid phone number";
        phoneNumberErrorStatus = true;
      });
    } else {
      setState(() {
        phoneNumberErrorStatus = false;
      });
    }
    if (address.trim().isEmpty) {
      setState(() {
        addressErrorStatus = true;
        addressErrorMsg = "Address can't be empty";
      });
    } else if (address.trim().length < 2) {
      setState(() {
        addressErrorMsg = "Enter a valid address";
        addressErrorStatus = true;
      });
    } else {
      setState(() {
        addressErrorStatus = false;
      });
    }
    if (city.trim().isEmpty) {
      setState(() {
        cityErrorStatus = true;
        cityErrorMsg = "City can't be empty";
      });
    } else if (city.length < 2) {
      setState(() {
        cityErrorStatus = true;
        cityErrorMsg = "City must be at least 2 characters.";
      });
    } else {
      setState(() {
        cityErrorStatus = false;
      });
    }
    if (state.trim().isEmpty) {
      stateErrorMsg = "State can't be empty";
      stateErrorStatus = true;
    } else {
      setState(() {
        stateErrorStatus = false;
      });
    }
    if (zipCode.trim().isEmpty) {
      setState(() {
        zipCodeErrorStatus = true;
        zipCodeErrorMsg = "Zipcode can't be empty";
      });
    } else if (zipCode.length < 5) {
      setState(() {
        zipCodeErrorStatus = true;
        zipCodeErrorMsg = "Please enter a valid zipcode";
      });
    } else {
      setState(() {
        zipCodeErrorStatus = false;
      });
    }

    networkCheck().then((value) {
      if (!value &&
          !firstNameErrorStatus &&
          !lastNameErrorStatus &&
          !emailErrorStatus &&
          !phoneNumberErrorStatus &&
          !addressErrorStatus &&
          !cityErrorStatus &&
          !zipCodeErrorStatus) {
        CommonWidgets().showDialog(
            context, 'Please check your internet connection and try again');
        return;
      }
      if (widget.customerEdit != null &&
          !firstNameErrorStatus &&
          !lastNameErrorStatus &&
          !emailErrorStatus &&
          !phoneNumberErrorStatus &&
          !addressErrorStatus &&
          !cityErrorStatus &&
          !zipCodeErrorStatus) {
        if (state is! EditCustomerLoading) {
          context.read<CustomerBloc>().add(EditCustomerDetails(
              context: context,
              firstName: firstNameController.text,
              lastName: lastNameController.text,
              email: emailController.text,
              mobileNo: phoneNumberController.text
                  .trim()
                  .replaceAll(RegExp(r'[^\w\s]+'), '')
                  .replaceAll(" ", ""),
              customerNotes: customerNotesController.text,
              address: addressController.text,
              city: cityController.text,
              state: provinceController.text,
              stateId: provinceId == null
                  ? widget.customerEdit!.provinceId.toString()
                  : provinceId.toString(),
              pinCode: zipCodeController.text,
              id: widget.customerEdit!.id.toString()));
        }
      } else {
        if (!firstNameErrorStatus &&
            !lastNameErrorStatus &&
            !emailErrorStatus &&
            !phoneNumberErrorStatus &&
            !addressErrorStatus &&
            !cityErrorStatus &&
            !zipCodeErrorStatus) {
          if (state is! AddCustomerLoading) {
            context.read<CustomerBloc>().add(AddCustomerDetails(
                context: context,
                firstName: firstNameController.text,
                lastName: lastNameController.text,
                email: emailController.text,
                mobileNo: phoneNumberController.text
                    .trim()
                    .replaceAll(RegExp(r'[^\w\s]+'), '')
                    .replaceAll(" ", ""),
                customerNotes: customerNotesController.text,
                address: addressController.text,
                city: cityController.text,
                state: provinceController.text,
                stateId: provinceId.toString(),
                pinCode: zipCodeController.text));
          }
        }
      }
    });
  }
}
