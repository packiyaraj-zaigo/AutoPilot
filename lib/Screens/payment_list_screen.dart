import 'package:auto_pilot/Models/payment_history_model.dart';
import 'package:auto_pilot/api_provider/api_repository.dart';
import 'package:auto_pilot/bloc/estimate_bloc/estimate_bloc.dart';
import 'package:auto_pilot/utils/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class PaymentListScreen extends StatefulWidget {
  final String orderId;
  const PaymentListScreen({super.key, required this.orderId});

  @override
  State<PaymentListScreen> createState() => _PaymentListScreenState();
}

class _PaymentListScreenState extends State<PaymentListScreen> {
  final scrollController = ScrollController();
  List<Datum> paymentList = [];
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EstimateBloc(apiRepository: ApiRepository())
        ..add(GetPaymentHistoryEvent(orderId: widget.orderId)),
      child: BlocListener<EstimateBloc, EstimateState>(
        listener: (context, state) {
          if (state is GetPaymentHistoryState) {
            paymentList.addAll(state.paymentHistoryModel.data.data);
          }
          // TODO: implement listener
        },
        child: BlocBuilder<EstimateBloc, EstimateState>(
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(
                elevation: 0,
                backgroundColor: Colors.transparent,
                foregroundColor: AppColors.primaryTitleColor,
                centerTitle: true,
                title: const Text(
                  "Payment History",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.all(24.0),
                child: state is GetPaymentHistoryLoadingState
                    ? const Center(
                        child: CupertinoActivityIndicator(),
                      )
                    : paymentList.isNotEmpty
                        ? ListView.builder(
                            itemBuilder: (context, index) {
                              if (index == paymentList.length) {
                                return BlocProvider.of<EstimateBloc>(context)
                                                .paymentCurrentPage <=
                                            BlocProvider.of<EstimateBloc>(
                                                    context)
                                                .paymentTotalPage &&
                                        BlocProvider.of<EstimateBloc>(context)
                                                .paymentCurrentPage !=
                                            0
                                    ? const SizedBox(
                                        height: 40,
                                        child: CupertinoActivityIndicator(
                                          color: AppColors.primaryColors,
                                        ))
                                    : Container();
                              }
                              return paymentTile(
                                  paymentList[index].id.toString(),
                                  paymentList[index].paymentMode,
                                  paymentList[index].paymentDate,
                                  paymentList[index].paidAmount);
                            },
                            itemCount: paymentList.length + 1,
                            shrinkWrap: true,
                            controller: scrollController
                              ..addListener(() {
                                if ((BlocProvider.of<EstimateBloc>(context)
                                            .paymentCurrentPage <=
                                        BlocProvider.of<EstimateBloc>(context)
                                            .paymentTotalPage) &&
                                    scrollController.offset ==
                                        scrollController
                                            .position.maxScrollExtent &&
                                    BlocProvider.of<EstimateBloc>(context)
                                            .paymentCurrentPage !=
                                        0 &&
                                    !BlocProvider.of<EstimateBloc>(context)
                                        .paymentIsFetching) {
                                  context.read<EstimateBloc>()
                                    ..paymentIsFetching = true
                                    ..add(GetPaymentHistoryEvent(
                                        orderId: widget.orderId));
                                }
                              }),
                            physics: ClampingScrollPhysics(),
                          )
                        : const Center(
                            child: Text("No Payment History Found"),
                          ),
              ),
            );
          },
        ),
      ),
    );
  }

  paymentTile(
      String paymentId, String paymentMode, DateTime date, String amount) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.07),
                offset: const Offset(0, 4),
                blurRadius: 10,
              )
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Payment #$paymentId",
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: AppColors.primaryTitleColor,
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      paymentMode == "CreditCard" ? "Credit Card" : paymentMode,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        height: 1.5,
                        color: AppColors.primaryTitleColor,
                      ),
                    ),
                    Text(
                      "\$ $amount",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        height: 1.5,
                        color: AppColors.primaryTitleColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  DateFormat("MM/dd/yyyy").format(date),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    height: 1.5,
                    color: AppColors.primaryTitleColor,
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
