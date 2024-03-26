import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:auto_pilot/Models/all_invoice_report_model.dart';
import 'package:auto_pilot/Models/all_orders_report_model.dart';
import 'package:auto_pilot/Models/customer_summary_report_model.dart';
import 'package:auto_pilot/Models/end_of_day_report_model.dart';
import 'package:auto_pilot/Models/line_item_detail_report_model.dart';
import 'package:auto_pilot/Models/payment_type_report_model.dart';
import 'package:auto_pilot/Models/profitablity_report_model.dart';
import 'package:auto_pilot/Models/report_technician_list_model.dart';
import 'package:auto_pilot/Models/sales_tax_report_model.dart';
import 'package:auto_pilot/Models/service_technician_report_model.dart';
import 'package:auto_pilot/Models/service_writer_model.dart';
import 'package:auto_pilot/Models/shop_performance_report_model.dart';
import 'package:auto_pilot/Models/technician_only_model.dart';
import 'package:auto_pilot/Models/time_log_report_model.dart';
import 'package:auto_pilot/Models/transaction_report_model.dart';
import 'package:auto_pilot/api_provider/api_repository.dart';
import 'package:auto_pilot/utils/app_utils.dart';
import 'package:auto_pilot/utils/common_widgets.dart';
import 'package:bloc/bloc.dart';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:http/http.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart'
    as internet;
import 'package:url_launcher/url_launcher.dart';

part 'report_event.dart';
part 'report_state.dart';

class ReportBloc extends Bloc<ReportEvent, ReportState> {
  final apiRepo = ApiRepository();
  int currentPage = 1;
  int totalPages = 0;
  bool isFetching = false;
  ReportBloc() : super(ReportInitial()) {
    on<GetAllInvoiceReportEvent>(getAllInvoiceReportBloc);
    on<GetSalesTaxReportEvent>(getSalesTaxReportBloc);
    on<GetTimeLogReportEvent>(getTimeLogReportBloc);
    on<GetPaymentTypeReportEvent>(getPaymentTypeReportBloc);
    on<GetServiceByTechnicianReportEvent>(getServiceByTechnicianReportBloc);
    on<InternetConnectionEvent>(internetConnectionBloc);
    on<GetAllTechnicianEvent>(getAllTechnicianBloc);
    on<ExportReportEvent>(exportReportBloc);
    on<GetShopPerformanceReportEvent>(getShopPerformanceReportBloc);
    on<GetTransactionReportEvent>(getTransactionReportBloc);
    on<GetAllOrderReportEvent>(getAllOrdersReportBloc);
    on<GetLineItemDetailReportEvent>(getLineItemDetailReportBloc);
    on<GetEndOfDayReportEvent>(getEndOfDayReportBloc);
    on<GetProfitablityReportEvent>(getProfitablityReportBloc);
    on<GetServiceWriterEvent>(getAllServiceWriterBloc);
    on<GetCustomerSummaryReportEvent>(getCustomerSummaryReportBloc);
  }

  //Bloc to get all invoice report.
  Future<void> getAllInvoiceReportBloc(
      GetAllInvoiceReportEvent event, Emitter<ReportState> emit) async {
    try {
      if (currentPage == 1) {
        if (event.exportType == "") {
          emit(ReportLoadingState());
        } else {
          emit(GetExportLinkLoadingState());
        }
      } else {
        emit(TableLoadingState());
      }
      //change nullable with original model class
      AllInvoiceReportModel allInvoiceReportModel;

      final token = await AppUtils.getToken();
      if (event.page == "next") {
        if (currentPage < totalPages) {
          currentPage++; // Increment the current page value
        }
      } else if (event.page == "prev") {
        if (currentPage > 1) {
          currentPage--; // Decrement the current page value
        }
      } else {
        currentPage =
            1; // Reset to the first page if not navigating forward or backward
      }

      Response response = await apiRepo.getAllinvoiceReport(
          token,
          event.startDate,
          event.endDate,
          event.paidFilter,
          currentPage,
          event.searchQuery,
          event.exportType,
          event.sortBy,
          event.tableName,
          event.fieldName);
      if (response.statusCode == 200) {
        //decode response into model class.
        /////////////////////////////////
        ///
        if (event.exportType == "") {
          allInvoiceReportModel = allInvoiceReportModelFromJson(response.body);

          totalPages = allInvoiceReportModel.data.paginator.lastPage ?? 1;
          currentPage = allInvoiceReportModel.data.paginator.currentPage;
          isFetching = false;

          emit(GetAllInvoiceReportSuccessState(
              allInvoiceReportModel: allInvoiceReportModel));

          print(currentPage.toString() + "current here");
        } else {
          var decodedBody = json.decode(response.body);
          emit(GetExportLinkState(link: decodedBody['data']));
        }
      } else {
        var decodedBody = json.decode(response.body);
        emit(GetAllInvoiceReportErrorState(errorMessage: decodedBody['msg']));
      }
    } catch (e, s) {
      print(s);
      print(e.toString());
      emit(GetAllInvoiceReportErrorState(errorMessage: "Something went wrong"));
    }
  }

  //Bloc to get sales tax report
  Future<void> getSalesTaxReportBloc(
      GetSalesTaxReportEvent event, Emitter<ReportState> emit) async {
    try {
      emit(ReportLoadingState());
      //change nullable with original model class
      SalesTaxReportModel salesTaxReportModel;
      final token = await AppUtils.getToken();

      Response response = await apiRepo.getSalesTaxReport(token,
          event.startDate, event.endDate, event.currentPage, event.exportType);
      if (response.statusCode == 200) {
        if (event.exportType == "") {
          salesTaxReportModel = salesTaxReportModelFromJson(response.body);
          //decode response into model class.
          /////////////////////////////////
          emit(GetSalesTaxReportSuccessState(
              salesTaxReportModel: salesTaxReportModel)); //change force null.
        } else {
          var decodedBody = json.decode(response.body);
          emit(GetExportLinkState(link: decodedBody['data']));
        }
      } else {
        var decodedBody = json.decode(response.body);
        emit(GetSalesTaxReportErrorState(errorMessage: decodedBody['msg']));
      }
    } catch (e) {
      print(e.toString());
      emit(GetSalesTaxReportErrorState(errorMessage: "Something went wrong"));
    }
  }

  //Bloc to get time log report
  Future<void> getTimeLogReportBloc(
      GetTimeLogReportEvent event, Emitter<ReportState> emit) async {
    try {
      if (currentPage == 1) {
        emit(ReportLoadingState());
      } else {
        emit(TableLoadingState());
      }
      //change nullable with original model class
      TimeLogReportModel timeLogReportModel;
      final token = await AppUtils.getToken();

      if (event.page == "next") {
        if (currentPage < totalPages) {
          currentPage++; // Increment the current page value
        }
      } else if (event.page == "prev") {
        if (currentPage > 1) {
          currentPage--; // Decrement the current page value
        }
      } else {
        currentPage =
            1; // Reset to the first page if not navigating forward or backward
      }

      Response response = await apiRepo.getTimeLogReport(
          token,
          event.monthFilter,
          event.techFilter,
          event.searchQuery,
          currentPage,
          event.exportType,
          event.sortBy,
          event.tableName,
          event.fieldName);
      if (response.statusCode == 200) {
        //decode response into model class.

        if (event.exportType == "") {
          timeLogReportModel = timeLogReportModelFromJson(response.body);
          totalPages = timeLogReportModel.data.paginator.lastPage ?? 1;
          currentPage = timeLogReportModel.data.paginator.currentPage;
          isFetching = false;

          emit(GetTimeLogReportSuccessState(
              timeLogReportModel: timeLogReportModel));
        } else {
          var decodedBody = json.decode(response.body);
          emit(GetExportLinkState(link: decodedBody['data']));
        }
      } else {
        var decodedBody = json.decode(response.body);
        emit(GetTimeLogReportErrorState(errorMessage: decodedBody['msg']));
      }
    } catch (e, s) {
      print(e.toString());
      print(s);
      emit(GetTimeLogReportErrorState(errorMessage: "Something went wrong"));
    }
  }

  //Bloc to get payment type report.
  Future<void> getPaymentTypeReportBloc(
      GetPaymentTypeReportEvent event, Emitter<ReportState> emit) async {
    try {
      emit(ReportLoadingState());
      //change nullable with original model class
      PaymentTypeReportModel paymentTypeReportModel;
      final token = await AppUtils.getToken();

      Response response = await apiRepo.getPaymentTypeReport(
          token,
          event.typeFilter,
          event.searchQuery,
          event.currentPage,
          event.exportType);
      if (response.statusCode == 200) {
        if (event.exportType == "") {
          paymentTypeReportModel =
              paymentTypeReportModelFromJson(response.body);
          //decode response into model class.
          /////////////////////////////////
          emit(GetPaymentTypeReportSuccessState(
              paymentReportModel: paymentTypeReportModel));
        } else {
          var decodedBody = json.decode(response.body);
          emit(GetExportLinkState(link: decodedBody['data']));
        }
      } else {
        var decodedBody = json.decode(response.body);
        emit(GetPaymentTypeReportErrorState(errorMessage: decodedBody['msg']));
      }
    } catch (e, s) {
      print(e.toString());
      print(s);

      emit(
          GetPaymentTypeReportErrorState(errorMessage: "Something went wrong"));
    }
  }

  //Bloc to get service by technician report
  Future<void> getServiceByTechnicianReportBloc(
      GetServiceByTechnicianReportEvent event,
      Emitter<ReportState> emit) async {
    try {
      if (currentPage == 1) {
        emit(ReportLoadingState());
      } else {
        emit(TableLoadingState());
      }

      //change nullable with original model class
      ServiceByTechReportModel serviceByTechReportModel;
      final token = await AppUtils.getToken();

      if (event.page == "next") {
        if (currentPage < totalPages) {
          currentPage++; // Increment the current page value
        }
      } else if (event.page == "prev") {
        if (currentPage > 1) {
          currentPage--; // Decrement the current page value
        }
      } else {
        currentPage =
            1; // Reset to the first page if not navigating forward or backward
      }

      Response response = await apiRepo.getServiceByTechnicianReport(
          token,
          event.startDate,
          event.endDate,
          event.searchQuery,
          event.techFilter,
          currentPage,
          event.exportType,
          event.sort,
          event.tableName,
          event.fieldName);
      if (response.statusCode == 200) {
        //decode response into model class.
        /////////////////////////////////
        ///
        if (event.exportType == "") {
          serviceByTechReportModel =
              serviceByTechReportModelFromJson(response.body);

          totalPages = serviceByTechReportModel.data.paginator.lastPage ?? 1;
          currentPage = serviceByTechReportModel.data.paginator.currentPage;
          isFetching = false;
          emit(GetServiceByTechnicianReportSuccessState(
              serviceByTechReportModel: serviceByTechReportModel));

          // if (event.pagination == "next") {

          // }
          //  else {
          //   if (totalPages > currentPage && currentPage != 0) {
          //     currentPage -= 1;
          //   } else {
          //     currentPage = 0;
          //   }
          // }
          print(currentPage.toString() + "current");
        } else {
          var decodedBody = json.decode(response.body);
          emit(GetExportLinkState(link: decodedBody['data']));
        }

        //change force null.
      } else {
        var decodedBody = json.decode(response.body);
        emit(GetServiceByTechnicianReportErrorState(
            errorMessage: decodedBody['msg']));
      }
    } catch (e) {
      print(e.toString());
      emit(GetServiceByTechnicianReportErrorState(
          errorMessage: "Something went wrong"));
    }
  }

  //bloc to check internet connection
  Future<void> internetConnectionBloc(
      InternetConnectionEvent event, Emitter<ReportState> emit) async {
    try {
      emit(ReportLoadingState());
      bool result =
          await internet.InternetConnectionCheckerPlus().hasConnection;
      if (result) {
        emit(InternetConnectionSuccessState());
      } else {
        emit(InternerConnectionErrorState());
      }
    } catch (e) {
      print(e.toString());
      emit(InternerConnectionErrorState());
    }
  }

  //bloc to get all technicain data
  getAllTechnicianBloc(
    GetAllTechnicianEvent event,
    Emitter<ReportState> emit,
  ) async {
    try {
      emit(ReportLoadingState());
      ReportTechnicianListModel technicianModel;

      final token = await AppUtils.getToken();
      Response getTechnicianResponse =
          await apiRepo.getReportTechnicianList(token);
      if (getTechnicianResponse.statusCode == 200) {
        technicianModel =
            reportTechnicianListModelFromJson(getTechnicianResponse.body);
        emit(GetAllTechnicianState(technicianModel: technicianModel));
      } else {
        emit(GetAllTechnicianErrorState(errorMessage: "Something went wrong"));
      }
    } catch (e) {
      print(e.toString());
      emit(GetAllTechnicianErrorState(errorMessage: "Something went wrong"));
    }
  }

  //bloc to export report
  Future<void> exportReportBloc(
      ExportReportEvent event, Emitter<ReportState> emit) async {
    try {
      emit(ExportReportLoadingState());
      //change nullable with original model class

      final token = await AppUtils.getToken();

      // dio.Response response = await dio.Dio()
      //     .download(event.downloadUrl, event.downloadPath + "file.pdf");
      // if (response.statusCode == 200 || response.statusCode == 201) {
      //   emit(ExportReportState());
      // } else {
      //   emit(ExportReportErrorState(
      //       errorMessage: "Download Failed.Please try again"));
      // }

      //You can download a single file
      //  if (Platform.isAndroid) {
      try {
        // FileDownloader.downloadFile(
        //     url: event.downloadUrl,
        //     name: event.downloadPath,
        //     onDownloadCompleted: (String path) {
        //       print('FILE DOWNLOADED TO PATH: $path');
        //       // emit(ExportReportState(
        //       //     message: "File downloaded to $path", time: DateTime.now()));

        //       CommonWidgets()
        //           .showDialog(event.context, "File downloaded to $path");
        //     },
        //     onDownloadError: (String error) {
        //       print('DOWNLOAD ERROR: $error');
        //       CommonWidgets().showDialog(event.context, "Download Failed");
        //       emit(ExportReportErrorState(errorMessage: error));
        //     });

        if (await canLaunchUrl(Uri.parse(event.downloadUrl))) {
          await launchUrl(Uri.parse(event.downloadUrl),
              mode: LaunchMode.externalApplication);
        } else {
          throw 'Could not launch ${event.downloadUrl}';
        }
      } catch (e, s) {
        print(s);
        print(e.toString());
      }
      // } else {
      //   // function to download file in ios
      // }
    } catch (e, s) {
      print(e.toString());
      print(s);

      emit(ExportReportErrorState(errorMessage: "Something went wrong"));
    }
  }

  //bloc to get shop performance report
  Future<void> getShopPerformanceReportBloc(
      GetShopPerformanceReportEvent event, Emitter<ReportState> emit) async {
    try {
      emit(ReportLoadingState());
      //change nullable with original model class
      ShopPerformanceReportModel shopPerformanceReportModel;
      final token = await AppUtils.getToken();

      Response response =
          await apiRepo.getShopPerformanceReport(token, event.exportType);
      if (response.statusCode == 200) {
        if (event.exportType == "") {
          shopPerformanceReportModel =
              shopPerformanceReportModelFromJson(response.body);

          emit(GetShopPerformanceReportState(
              shopPerformanceReportModel: shopPerformanceReportModel));
        } else {
          var decodedBody = json.decode(response.body);
          emit(GetExportLinkState(link: decodedBody['data']));
        }
      } else {
        var decodedBody = json.decode(response.body);
        emit(GetShopPerformanceReportErrorState(
            errorMessage: decodedBody['msg']));
      }
    } catch (e, s) {
      print(e.toString());
      print(s);

      emit(GetShopPerformanceReportErrorState(
          errorMessage: "Something went wrong"));
    }
  }

  //bloc to get transaction report
  Future<void> getTransactionReportBloc(
      GetTransactionReportEvent event, Emitter<ReportState> emit) async {
    try {
      if (currentPage == 1) {
        emit(ReportLoadingState());
      } else {
        emit(TableLoadingState());
      }
      //change nullable with original model class
      TransactionReportModel transactionReportModel;
      final token = await AppUtils.getToken();
      if (event.page == "next") {
        if (currentPage < totalPages) {
          currentPage++; // Increment the current page value
        }
      } else if (event.page == "prev") {
        if (currentPage > 1) {
          currentPage--; // Decrement the current page value
        }
      } else {
        currentPage =
            1; // Reset to the first page if not navigating forward or backward
      }

      Response response = await apiRepo.getTransactionReport(
          token,
          currentPage,
          event.exportType,
          event.createFilter,
          event.sortBy,
          event.fieldName,
          event.table);
      if (response.statusCode == 200) {
        if (event.exportType == "") {
          transactionReportModel =
              transactionReportModelFromJson(response.body);

          totalPages = transactionReportModel.data.paginator.lastPage ?? 1;
          currentPage = transactionReportModel.data.paginator.currentPage;
          isFetching = false;

          emit(GetTransactionReportState(
              transactionReportModel: transactionReportModel));

          print(currentPage.toString() + "current here");
        } else {
          var decodedBody = json.decode(response.body);
          emit(GetExportLinkState(link: decodedBody['data']));
        }
      } else {
        var decodedBody = json.decode(response.body);
        emit(GetTransactionReportErrorState(errorMessage: decodedBody['msg']));
      }
    } catch (e, s) {
      print(e.toString());
      print(s);

      emit(
          GetTransactionReportErrorState(errorMessage: "Something went wrong"));
    }
  }

  //bloc to get all orders report
  Future<void> getAllOrdersReportBloc(
      GetAllOrderReportEvent event, Emitter<ReportState> emit) async {
    try {
      if (currentPage == 1) {
        emit(ReportLoadingState());
      } else {
        emit(TableLoadingState());
      }
      //change nullable with original model class
      AllOrdersReportModel allOrdersReportModel;
      final token = await AppUtils.getToken();

      if (event.page == "next") {
        if (currentPage < totalPages) {
          currentPage++; // Increment the current page value
        }
      } else if (event.page == "prev") {
        if (currentPage > 1) {
          currentPage--; // Decrement the current page value
        }
      } else {
        currentPage =
            1; // Reset to the first page if not navigating forward or backward
      }

      Response response = await apiRepo.getAllOrdersReport(
          token,
          currentPage,
          event.exportType,
          event.createFilter,
          event.sortBy,
          event.table,
          event.fieldName);
      if (response.statusCode == 200) {
        if (event.exportType == "") {
          allOrdersReportModel = allOrdersReportModelFromJson(response.body);

          totalPages = allOrdersReportModel.data.paginator.lastPage ?? 1;
          currentPage = allOrdersReportModel.data.paginator.currentPage;
          isFetching = false;

          emit(GetAllOrdersReportState(
              allOrdersReportModel: allOrdersReportModel));

          print(currentPage.toString() + "current here");
        } else {
          var decodedBody = json.decode(response.body);
          emit(GetExportLinkState(link: decodedBody['data']));
        }
      } else {
        var decodedBody = json.decode(response.body);
        emit(GetAllOrdersReportErrorState(errorMessage: decodedBody['msg']));
      }
    } catch (e, s) {
      print(e.toString());
      print(s);

      emit(GetAllOrdersReportErrorState(errorMessage: "Something went wrong"));
    }
  }

  //bloc to get line item detail report
  Future<void> getLineItemDetailReportBloc(
      GetLineItemDetailReportEvent event, Emitter<ReportState> emit) async {
    try {
      if (currentPage == 1) {
        emit(ReportLoadingState());
      } else {
        emit(TableLoadingState());
      }
      //change nullable with original model class
      LineItemDetailReportModel lineItemDetailReportModel;
      final token = await AppUtils.getToken();
      if (event.page == "next") {
        if (currentPage < totalPages) {
          currentPage++; // Increment the current page value
        }
      } else if (event.page == "prev") {
        if (currentPage > 1) {
          currentPage--; // Decrement the current page value
        }
      } else {
        currentPage =
            1; // Reset to the first page if not navigating forward or backward
      }

      Response response = await apiRepo.getLineItemDetailReport(
          token,
          currentPage,
          event.createFilter,
          event.exportType,
          event.sortBy,
          event.fieldName,
          event.table);
      if (response.statusCode == 200) {
        if (event.exportType == "") {
          lineItemDetailReportModel =
              lineItemDetailReportModelFromJson(response.body);
          totalPages = lineItemDetailReportModel.data.paginator.lastPage ?? 1;
          currentPage = lineItemDetailReportModel.data.paginator.currentPage;
          emit(GetLineItemDetailReportState(
              lineItemDetailReportModel: lineItemDetailReportModel));
        } else {
          //export decode.
          var decodedBody = json.decode(response.body);
          emit(GetExportLinkState(link: decodedBody['data']));
        }
      } else {
        var decodedBody = json.decode(response.body);
        emit(GetLineItemDetailReportErrorState(
            errorMessage: decodedBody['msg']));
      }
    } catch (e, s) {
      print(e.toString());
      print(s);

      emit(GetLineItemDetailReportErrorState(
          errorMessage: "Something went wrong"));
    }
  }

  //bloc to get end of day report
  Future<void> getEndOfDayReportBloc(
      GetEndOfDayReportEvent event, Emitter<ReportState> emit) async {
    try {
      emit(ReportLoadingState());
      //change nullable with original model class
      EndOfDayReportModel endOfDayReportModel;
      final token = await AppUtils.getToken();

      Response response =
          await apiRepo.getEndOfDayReport(token, event.exportType);
      if (response.statusCode == 200) {
        if (event.exportType == "") {
          endOfDayReportModel = endOfDayReportModelFromJson(response.body);

          emit(
              GetEndOfDayReportState(endOfDayReportModel: endOfDayReportModel));
        } else {
          var decodedBody = json.decode(response.body);
          emit(GetExportLinkState(link: decodedBody['data']));
        }
      } else {
        var decodedBody = json.decode(response.body);
        emit(GetEndOfDayReportErrorState(errorMessage: decodedBody['msg']));
      }
    } catch (e, s) {
      print(e.toString());
      print(s);

      emit(GetEndOfDayReportErrorState(errorMessage: "Something went wrong"));
    }
  }

  //bloc to get all profitablity report
  Future<void> getProfitablityReportBloc(
      GetProfitablityReportEvent event, Emitter<ReportState> emit) async {
    try {
      if (currentPage == 1) {
        emit(ReportLoadingState());
      } else {
        emit(TableLoadingState());
      }
      //change nullable with original model class
      ProfitablityReportModel profitablityReportModel;
      final token = await AppUtils.getToken();

      if (event.page == "next") {
        if (currentPage < totalPages) {
          currentPage++; // Increment the current page value
        }
      } else if (event.page == "prev") {
        if (currentPage > 1) {
          currentPage--; // Decrement the current page value
        }
      } else {
        currentPage =
            1; // Reset to the first page if not navigating forward or backward
      }

      Response response = await apiRepo.getProfitablityReport(
          token,
          event.fromDate,
          event.toDate,
          event.serviceId,
          event.exportType,
          currentPage,
          event.sortBy,
          event.fieldName,
          event.table);
      if (response.statusCode == 200) {
        if (event.exportType == "") {
          profitablityReportModel =
              profitablityReportModelFromJson(response.body);

          totalPages = profitablityReportModel.data.paginator.lastPage ?? 1;
          currentPage = profitablityReportModel.data.paginator.currentPage;
          isFetching = false;

          emit(GetProfitablityReportState(
              profitablityReportModel: profitablityReportModel));

          print(currentPage.toString() + "current here");
        } else {
          var decodedBody = json.decode(response.body);
          emit(GetExportLinkState(link: decodedBody['data']));
        }
      } else {
        var decodedBody = json.decode(response.body);
        emit(GetProfitablityReportErrorState(errorMessage: decodedBody['msg']));
      }
    } catch (e, s) {
      print(e.toString());
      print(s);

      emit(GetProfitablityReportErrorState(
          errorMessage: "Something went wrong"));
    }
  }

  //bloc to get summary by customer report
  Future<void> getCustomerSummaryReportBloc(
      GetCustomerSummaryReportEvent event, Emitter<ReportState> emit) async {
    try {
      if (currentPage == 1) {
        emit(ReportLoadingState());
      } else {
        emit(TableLoadingState());
      }
      //change nullable with original model class
      CustomerSummaryReportModel customerSummaryReportModel;
      final token = await AppUtils.getToken();

      if (event.page == "next") {
        if (currentPage < totalPages) {
          currentPage++; // Increment the current page value
        }
      } else if (event.page == "prev") {
        if (currentPage > 1) {
          currentPage--; // Decrement the current page value
        }
      } else {
        currentPage =
            1; // Reset to the first page if not navigating forward or backward
      }

      Response response = await apiRepo.getCustomerSummaryReport(
          token,
          event.createFilter,
          event.exportType,
          currentPage,
          event.sortBy,
          event.fieldName,
          event.table);
      if (response.statusCode == 200) {
        if (event.exportType == "") {
          customerSummaryReportModel =
              customerSummaryReportModelFromJson(response.body);

          totalPages = customerSummaryReportModel.data.paginator.lastPage ?? 1;
          currentPage = customerSummaryReportModel.data.paginator.currentPage;
          isFetching = false;

          emit(GetCustomerSummaryReportState(
              customerSummaryReportModel: customerSummaryReportModel));

          print(currentPage.toString() + "current here");
        } else {
          var decodedBody = json.decode(response.body);
          emit(GetExportLinkState(link: decodedBody['data']));
        }
      } else {
        var decodedBody = json.decode(response.body);
        emit(GetCustomerSummaryReportErrorState(
            errorMessage: decodedBody['msg']));
      }
    } catch (e, s) {
      print(e.toString());
      print(s);

      emit(GetCustomerSummaryReportErrorState(
          errorMessage: "Something went wrong"));
    }
  }

  //bloc to get all service writer data
  getAllServiceWriterBloc(
    GetServiceWriterEvent event,
    Emitter<ReportState> emit,
  ) async {
    try {
      emit(ReportLoadingState());
      ServiceWriterModel serviceWriterModel;

      final token = await AppUtils.getToken();
      Response getServiceWriterReponse = await apiRepo.getServiceWriter(token);
      if (getServiceWriterReponse.statusCode == 200) {
        serviceWriterModel =
            serviceWriterModelFromJson(getServiceWriterReponse.body);
        emit(GetServiceWriterState(serviceWriterModel: serviceWriterModel));
      } else {
        emit(GetServiceWriterErrorState(errorMessage: "Something went wrong"));
      }
    } catch (e) {
      print(e.toString());
      emit(GetServiceWriterErrorState(errorMessage: "Something went wrong"));
    }
  }
}
