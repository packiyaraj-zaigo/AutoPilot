import 'package:auto_pilot/bloc/service_bloc/service_bloc.dart';
import 'package:auto_pilot/utils/app_colors.dart';
import 'package:auto_pilot/utils/app_utils.dart';
import 'package:auto_pilot/utils/common_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddVendorScreen extends StatefulWidget {
  const AddVendorScreen({super.key});

  @override
  State<AddVendorScreen> createState() => _AddVendorScreenState();
}

class _AddVendorScreenState extends State<AddVendorScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController contactPersonController = TextEditingController();

  String nameError = '';
  String emailError = '';
  String contactPersonError = '';
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ServiceBloc(),
      child: BlocListener<ServiceBloc, ServiceState>(
        listener: (context, state) {
          if (state is CreateVendorSuccessState) {
            Navigator.pop(context, [state.vendorId, nameController.text]);
            CommonWidgets()
                .showSuccessDialog(context, 'Vendor created successfully');
          } else if (state is CreateVendorErrorState) {
            CommonWidgets().showDialog(context, state.message);
          }
        },
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: const Color(0xFFFAFAFA),
            elevation: 0,
            title: const Text(
              'New Vendor',
              style: TextStyle(color: Colors.black87, fontSize: 16),
            ),
            centerTitle: true,
            actions: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop(false);
                },
                child: const Icon(
                  Icons.close,
                  color: AppColors.primaryColors,
                ),
              ),
              const SizedBox(
                width: 20,
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: ListView(
              // crossAxisAlignment: CrossAxisAlignment.start,
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
                textBox('Enter Name', nameController, 'Name',
                    nameError.isNotEmpty, context),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Visibility(
                      visible: nameError.isNotEmpty,
                      child: Text(
                        nameError,
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
                textBox('Enter Email', emailController, 'Email',
                    emailError.isNotEmpty, context),
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
                textBox('Enter Contact Person', contactPersonController,
                    'Contact Person', contactPersonError.isNotEmpty, context),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Visibility(
                      visible: contactPersonError.isNotEmpty,
                      child: Text(
                        contactPersonError,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(
                            0xffD80027,
                          ),
                        ),
                      )),
                ),
                const SizedBox(height: 77),
                BlocBuilder<ServiceBloc, ServiceState>(
                  builder: (context, state) {
                    if (state is CreateVendorLoadingState) {
                      return const Center(
                        child: CupertinoActivityIndicator(),
                      );
                    }
                    return ElevatedButton(
                      onPressed: () async {
                        final status = validate();
                        if (status) {
                          if (state is! CreateVendorLoadingState) {
                            BlocProvider.of<ServiceBloc>(context).add(
                              CreateVendorEvent(
                                name: nameController.text.trim(),
                                email: emailController.text.trim(),
                                contactPerson:
                                    contactPersonController.text.trim(),
                              ),
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: AppColors.primaryColors,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        fixedSize: Size(MediaQuery.of(context).size.width, 56),
                      ),
                      child: const Text(
                        "Confirm",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 34),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool validate() {
    bool status = true;
    if (nameController.text.isEmpty) {
      nameError = "Name can't be empty";
      status = false;
    } else if (nameController.text.length < 2) {
      nameError = 'Name should be atleast 2 characters';
      status = false;
    } else {
      nameError = '';
    }
    if (emailController.text.isEmpty) {
      emailError = "Email can't be empty";
      status = false;
    } else if (emailController.text.length < 2) {
      emailError = 'Email should be atleast 2 characters';
      status = false;
    } else if (!AppUtils.validateEmail(emailController.text)) {
      emailError = 'Email should be valid';
      status = false;
    } else {
      emailError = '';
    }
    if (contactPersonController.text.isEmpty) {
      contactPersonError = "Contact person can't be empty";
      status = false;
    } else if (contactPersonController.text.length < 2) {
      contactPersonError = 'Contact person should be atleast 2 characters';
      status = false;
    } else {
      contactPersonError = '';
    }

    setState(() {});
    return status;
  }

  Widget textBox(String placeHolder, TextEditingController controller,
      String label, bool errorStatus, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xff6A7187),
              ),
            ),
            const Text(
              " *",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Color(
                  0xffD80027,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 3),
        Padding(
          padding: const EdgeInsets.only(top: 6.0),
          child: SizedBox(
            height: 56,
            width: MediaQuery.of(context).size.width,
            child: TextField(
              controller: controller,
              textCapitalization: label != "Email"
                  ? TextCapitalization.sentences
                  : TextCapitalization.none,
              keyboardType: label == 'Phone' ? TextInputType.number : null,
              maxLength: 100,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                hintText: placeHolder,
                counterText: "",
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
}
