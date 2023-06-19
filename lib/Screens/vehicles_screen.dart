import 'package:alphabet_scroll_view/alphabet_scroll_view.dart';
import 'package:auto_pilot/Screens/vechile_information_screen.dart';
import 'package:auto_pilot/utils/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class VehiclesScreen extends StatefulWidget {
  const VehiclesScreen({Key? key}) : super(key: key);

  @override
  State<VehiclesScreen> createState() => _VehiclesScreenState();
}

class _VehiclesScreenState extends State<VehiclesScreen> {
  int selectedIndex = 0;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController yearController = TextEditingController();
  final TextEditingController modelController = TextEditingController();
  final TextEditingController subModelController = TextEditingController();
  final TextEditingController engineController = TextEditingController();
  final TextEditingController colorController = TextEditingController();
  final TextEditingController vinController = TextEditingController();
  final TextEditingController licController = TextEditingController();
  bool nameErrorStatus = false;
  bool yearErrorStaus = false;
  bool modelErrorStatus = false;
  bool subModelErrorStatus = false;
  bool engineErrorStatus = false;
  bool colorErrorStatus = false;
  bool vinErrorStatus = false;
  bool licErrorStatus = false;
  bool isChecked = false;

  List<String> list = [
    '2020 Tesla Model 3',
    '2020 Tesla Model 3',
    '2020 Tesla Model 3',
    '2020 Tesla Model 3',
    '2020 Tesla Model 3',
    '2020 Tesla Model 3',
    '2020 Tesla Model 3',
    '2020 Tesla Model 3',
    '2020 Tesla Model 3',
    '2020 Tesla Model 3',
    '2020 Tesla Model 3',
    '2020 Tesla Model 3',
    '2020 Tesla Model 3',
    '2020 Tesla Model 3',
    '2020 Tesla Model 3',
    '2020 Tesla Model 3',
    '2020 Tesla Model 3',
    '2020 Tesla Model 3',
    '2020 Tesla Model 3',
    '2020 Tesla Model 3',
    '2020 Tesla Model 3',
    '2020 Tesla Model 3',
    '2020 Tesla Model 3',
    '2020 Tesla Model 3',
    '2020 Tesla Model 3',
    '2020 Tesla Model 3',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: Text(
          'Autopilot',
          style: TextStyle(
              color: AppColors.primaryBlackColors,
              fontSize: 18,
              fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        actions: [
          InkWell(
            onTap: () {
              _show(context);
            },
            child: SvgPicture.asset(
              "assets/images/add_icon.svg",
              color: AppColors.primaryBlackColors,
              height: 20,
              width: 20,
            ),
          ),
          SizedBox(
            width: 20,
          )
        ],
        leading: IconButton(
          icon: const Icon(
            Icons.menu,
            color: Colors.black87,
          ),
          onPressed: () {},
        ),
        // backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.only(left: 24, right: 34, top: 24, bottom: 6),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Vehicles',
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryBlackColors),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: Offset(0, 7), // changes position of shadow
                      ),
                    ],
                  ),
                  height: 50,
                  child: CupertinoSearchTextField(
                    backgroundColor: Colors.white,
                    placeholder: 'Search Vehicles...',
                    prefixIcon: Padding(
                      padding: const EdgeInsets.only(left: 24, right: 16),
                      child: Icon(
                        CupertinoIcons.search,
                        color: AppColors.primaryTextColors,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: AlphabetScrollView(
              list: list.map((e) => AlphaModel(e)).toList(),
              isAlphabetsFiltered: false,
              alignment: LetterAlignment.right,
              itemExtent: 200,
              unselectedTextStyle: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                  color: Colors.grey),
              selectedTextStyle: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
              itemBuilder: (_, k, id) {
                return Padding(
                    padding:
                        const EdgeInsets.only(top: 10, right: 34, left: 24),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: Offset(0, 7), // changes position of shadow
                          ),
                        ],
                      ),
                      child: ListTile(
                        title: Text(
                          '$id',
                          style: TextStyle(
                              color: AppColors.primaryTitleColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                        ),
                        subtitle: Text(
                          'Fernando Arbulu',
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: AppColors.greyText),
                        ),
                        // trailing: Icon(Icons.add),),
                      ),
                    ));
              },
            ),
          )
        ],
      ),
    );
  }

  _show(BuildContext ctx) {
    showModalBottomSheet(
        isScrollControlled: true,
        elevation: 10,
        context: ctx,
        builder: (ctx) => Container(
            height: MediaQuery.of(context).size.height * 0.95,
            color: Colors.white54,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(),
                      Text(
                        "New Vehicle",
                        style: TextStyle(
                            fontSize: 16,
                            color: AppColors.primaryBlackColors,
                            fontWeight: FontWeight.w500),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: SvgPicture.asset(
                          "assets/images/close.svg",
                          color: AppColors.primaryColors,
                          height: 16,
                          width: 16,
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                      child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Basic Details",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primaryTitleColor),
                            ),
                            textBox("Enter email...", nameController, "Owner",
                                nameErrorStatus),
                            textBox("Enter year...", yearController, "Year",
                                yearErrorStaus),
                            Text(
                              "Make",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.greyText),
                            ),
                            SizedBox(
                              height: 50,
                              child: CupertinoTextField(
                                readOnly: false,
                                placeholder: 'Select',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.primaryBlackColors),
                                suffix: Icon(Icons.arrow_drop_down_outlined),
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  border: Border.all(color: AppColors.greyText),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            textBox("Enter model...", modelController, "Model",
                                modelErrorStatus),
                            textBox("Enter Sub-model...", subModelController,
                                "Model", subModelErrorStatus),
                            textBox("Enter engin...", engineController, "Model",
                                engineErrorStatus),
                            textBox("Enter color...", colorController, "Model",
                                colorErrorStatus),
                            textBox("Enter number...", vinController, "Model",
                                vinErrorStatus),
                            textBox("Enter number...", licController, "Model",
                                licErrorStatus),
                            Text(
                              "Type",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.greyText),
                            ),
                            SizedBox(
                              height: 50,
                              child: CupertinoTextField(
                                readOnly: false,
                                placeholder: 'Select',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.primaryBlackColors),
                                suffix: Icon(Icons.arrow_drop_down_outlined),
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  border: Border.all(color: AppColors.greyText),
                                ),
                              ),
                            ),
                            Center(
                              child: Row(
                                children: <Widget>[
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  Checkbox(
                                    checkColor: Colors.white,
                                    value: isChecked,
                                    onChanged: (bool? value) {
                                      setState(() {
                                        isChecked = value!;
                                      });
                                    },
                                  ),
                                  Text(
                                    "Create new estimate using this vehicle",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                        color: AppColors.primaryTitleColor),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              VechileInformation()));
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: AppColors.primaryColors,
                                  shape: new RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(10.0),
                                  ),
                                ),
                                child: const Text(
                                  'Confirm',
                                  style: TextStyle(fontSize: 15),
                                ),
                              ),
                            ),
                          ]),
                    ),
                  ))
                ],
              ),
            )));
  }

  Widget textBox(String placeHolder, TextEditingController controller,
      String label, bool errorStatus) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xff6A7187)),
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
}
