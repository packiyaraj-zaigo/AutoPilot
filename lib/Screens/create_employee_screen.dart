import 'package:auto_pilot/utils/app_colors.dart';
import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CreateEmployeeScreen extends StatefulWidget {
  const CreateEmployeeScreen({super.key});

  @override
  State<CreateEmployeeScreen> createState() => _CreateEmployeeScreenState();
}

class _CreateEmployeeScreenState extends State<CreateEmployeeScreen> {
  final TextEditingController firstNameController = TextEditingController();
  String firstNameError = '';
  final TextEditingController lastNameController = TextEditingController();
  String lastNameError = '';
  final TextEditingController positionController = TextEditingController();
  String positionError = '';
  final TextEditingController emailController = TextEditingController();
  String emailError = '';
  final TextEditingController phoneController = TextEditingController();
  String phoneError = '';
  final TextEditingController addressController = TextEditingController();
  String addressError = '';
  final TextEditingController cityController = TextEditingController();
  String cityError = '';
  final TextEditingController stateController = TextEditingController();
  final TextEditingController zipController = TextEditingController();
  String stateZipError = '';
  CountryCode? selectedCountry;
  final countryPicker = const FlCountryCodePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFFFAFAFA),
        elevation: 0,
        title: const Text(
          'New Employee',
          style: TextStyle(color: Colors.black87, fontSize: 16),
        ),
        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.close,
              color: Colors.black87,
            ),
          ),
          const SizedBox(
            width: 20,
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Basic Details',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(
                    0xFF061237,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              textBox('Enter name...', TextEditingController(), 'First Name',
                  firstNameError.isNotEmpty),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Visibility(
                    visible: firstNameError.isNotEmpty,
                    child: Text(
                      firstNameError,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(
                          0xffD80027,
                        ),
                      ),
                    )),
              ),
              const SizedBox(height: 16),
              textBox('Enter name...', TextEditingController(), 'Last Name',
                  lastNameError.isNotEmpty),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Visibility(
                    visible: lastNameError.isNotEmpty,
                    child: Text(
                      lastNameError,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(
                          0xffD80027,
                        ),
                      ),
                    )),
              ),
              const SizedBox(height: 16),
              textBox('Enter position...', TextEditingController(), 'Position',
                  positionError.isNotEmpty),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Visibility(
                    visible: positionError.isNotEmpty,
                    child: Text(
                      positionError,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(
                          0xffD80027,
                        ),
                      ),
                    )),
              ),
              const SizedBox(height: 16),
              textBox('Enter email', TextEditingController(), 'Email',
                  emailError.isNotEmpty),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Visibility(
                    visible: emailError.isNotEmpty,
                    child: Text(
                      emailError,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(
                          0xffD80027,
                        ),
                      ),
                    )),
              ),
              const SizedBox(height: 16),
              textBox('ex. 555-555-5555', TextEditingController(), 'Phone',
                  phoneError.isNotEmpty),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Visibility(
                    visible: phoneError.isNotEmpty,
                    child: Text(
                      phoneError,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(
                          0xffD80027,
                        ),
                      ),
                    )),
              ),
              const SizedBox(height: 16),
              textBox('Enter address...', TextEditingController(), 'Address',
                  addressError.isNotEmpty),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Visibility(
                    visible: addressError.isNotEmpty,
                    child: Text(
                      addressError,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(
                          0xffD80027,
                        ),
                      ),
                    )),
              ),
              const SizedBox(height: 16),
              textBox('Enter city...', TextEditingController(), 'City',
                  cityError.isNotEmpty),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Visibility(
                    visible: cityError.isNotEmpty,
                    child: Text(
                      cityError,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(
                          0xffD80027,
                        ),
                      ),
                    )),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  halfTextBox('Select', stateController, 'State',
                      stateZipError.contains('State')),
                  halfTextBox('Zipcode', zipController, 'Zip',
                      stateZipError.contains('Zipcode')),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Visibility(
                    visible: stateZipError.isNotEmpty,
                    child: Text(
                      stateZipError,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(
                          0xffD80027,
                        ),
                      ),
                    )),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(top: 32.0),
                child: GestureDetector(
                  onTap: () {
                    // Navigator.push(context, MaterialPageRoute(
                    //   builder: (context) {
                    //     return LoginAndSignupScreen(
                    //       widgetIndex: 1,
                    //     );
                    //   },
                    // ));
                  },
                  child: GestureDetector(
                    onTap: () {
                      // validateData(loginEmailController.text,
                      //     loginPasswordController.text, context);
                    },
                    child: Container(
                      height: 56,
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: const Color(0xff333333),
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
              ),
              const SizedBox(height: 34),
            ],
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
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xff6A7187),
          ),
        ),
        const SizedBox(height: 3),
        Padding(
          padding: const EdgeInsets.only(top: 6.0),
          child: SizedBox(
            height: 56,
            width: MediaQuery.of(context).size.width,
            child: TextField(
              controller: controller,
              keyboardType: label == 'Phone' ? TextInputType.number : null,
              maxLength: label == 'Phone' ? 16 : 50,
              decoration: InputDecoration(
                hintText: placeHolder,
                counterText: "",
                prefixIcon: label == 'Phone' ? countryPickerWidget() : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: errorStatus == true
                        ? const Color(0xffD80027)
                        : const Color(0xffC1C4CD),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: errorStatus == true
                        ? const Color(0xffD80027)
                        : const Color(0xffC1C4CD),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: errorStatus == true
                        ? const Color(0xffD80027)
                        : const Color(0xffC1C4CD),
                  ),
                ),
              ),
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
        Text(
          label,
          style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xff6A7187)),
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
                  suffixIcon: label == "State"
                      ? const Icon(
                          CupertinoIcons.chevron_down,
                          color: Colors.black,
                        )
                      : null,
                  hintText: placeHolder,
                  hintStyle: label == 'State'
                      ? const TextStyle(color: Colors.black)
                      : null,
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
      ],
    );
  }

  Widget countryPickerWidget() {
    return GestureDetector(
      onTap: () async {
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
}
