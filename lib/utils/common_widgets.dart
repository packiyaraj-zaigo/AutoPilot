import 'package:auto_pilot/Models/employee_response_model.dart';
import 'package:auto_pilot/Screens/employee_details_screen.dart';
import 'package:auto_pilot/utils/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/material/dialog.dart' as dialog;
import 'package:flutter_svg/svg.dart';

class CommonWidgets {
  Future showDialog(BuildContext context, message) {
    return showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        // title: const Text("title"),
        content: Text(message),
        actions: <Widget>[
          CupertinoDialogAction(
            child: const Text("Ok"),
            onPressed: () => Navigator.of(context).pop(false),
          ),
        ],
      ),
    );
  }

  employeeCard({required Employee item}) {
    return _EmployeeCard(item: item);
  }

  showSuccessDialog(BuildContext context, String message) {
    return dialog.showDialog(
      context: context,
      builder: (context) {
        Future.delayed(const Duration(seconds: 2)).then((value) {
          if (context.mounted) {
            Navigator.pop(context);
          }
        });
        return AlertDialog(
          scrollable: true,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset("assets/images/success_icon.svg"),
              const SizedBox(
                height: 16,
              ),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primaryTitleColor,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _EmployeeCard extends StatelessWidget {
  const _EmployeeCard({
    // super.key,
    required this.item,
  });

  final Employee item;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => EmployeeDetailsScreen(
              employee: item,
            ),
          ),
        );
      },
      child: Container(
        height: 77,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.07),
              offset: const Offset(0, 4),
              blurRadius: 10,
            ),
          ],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
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
                (item.roles?[0].name![0].toUpperCase() ?? '') +
                    (item.roles?[0].name!.substring(1) ?? ''),
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
    );
  }
}
