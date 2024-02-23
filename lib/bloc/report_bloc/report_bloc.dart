import 'dart:convert';
import 'dart:io';

import 'package:auto_pilot/Models/all_invoice_report_model.dart';
import 'package:auto_pilot/Models/payment_type_report_model.dart';
import 'package:auto_pilot/Models/report_technician_list_model.dart';
import 'package:auto_pilot/Models/sales_tax_report_model.dart';
import 'package:auto_pilot/Models/service_technician_report_model.dart';
import 'package:auto_pilot/Models/technician_only_model.dart';
import 'package:auto_pilot/Models/time_log_report_model.dart';
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
  }

  //Bloc to get all invoice report.
  Future<void> getAllInvoiceReportBloc(
      GetAllInvoiceReportEvent event, Emitter<ReportState> emit) async {
    try {
      if (currentPage == 1) {
        emit(ReportLoadingState());
      } else {
        emit(TableLoadingState());
      }
      //change nullable with original model class
      AllInvoiceReportModel allInvoiceReportModel;

      final token = await AppUtils.getToken();

      Response response = await apiRepo.getAllinvoiceReport(
          token,
          event.startDate,
          event.endDate,
          event.paidFilter,
          currentPage,
          event.searchQuery);
      if (response.statusCode == 200) {
        //decode response into model class.
        /////////////////////////////////
        allInvoiceReportModel = allInvoiceReportModelFromJson(response.body);

        totalPages = allInvoiceReportModel.data.lastPage ?? 1;
        currentPage = allInvoiceReportModel.data.currentPage;
        isFetching = false;

        emit(GetAllInvoiceReportSuccessState(
            allInvoiceReportModel: allInvoiceReportModel));

        if (totalPages > currentPage && currentPage != 0) {
          currentPage += 1;
          print("here1");
        } else {
          currentPage = 1;
          print("here2");
        }
        print(currentPage.toString() + "current here");
      } else {
        var decodedBody = json.decode(response.body);
        emit(GetAllInvoiceReportErrorState(errorMessage: decodedBody['msg']));
      }
    } catch (e) {
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

      Response response = await apiRepo.getSalesTaxReport(
          token, event.startDate, event.endDate, event.currentPage);
      if (response.statusCode == 200) {
        salesTaxReportModel = salesTaxReportModelFromJson(response.body);
        //decode response into model class.
        /////////////////////////////////
        emit(GetSalesTaxReportSuccessState(
            salesTaxReportModel: salesTaxReportModel)); //change force null.
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
      emit(ReportLoadingState());
      //change nullable with original model class
      TimeLogReportModel timeLogReportModel;
      final token = await AppUtils.getToken();

      Response response = await apiRepo.getTimeLogReport(
          token,
          event.monthFilter,
          event.techFilter,
          event.searchQuery,
          event.currentPage);
      if (response.statusCode == 200) {
        //decode response into model class.
        timeLogReportModel = timeLogReportModelFromJson(response.body);

        emit(GetTimeLogReportSuccessState(
            timeLogReportModel: timeLogReportModel)); //change force null.
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
          token, event.monthFilter, event.searchQuery, event.currentPage);
      if (response.statusCode == 200) {
        paymentTypeReportModel = paymentTypeReportModelFromJson(response.body);
        //decode response into model class.
        /////////////////////////////////
        emit(GetPaymentTypeReportSuccessState(
            paymentReportModel: paymentTypeReportModel)); //change force null.
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

      Response response = await apiRepo.getServiceByTechnicianReport(
          token,
          event.startDate,
          event.endDate,
          event.searchQuery,
          event.techFilter,
          currentPage);
      if (response.statusCode == 200) {
        //decode response into model class.
        /////////////////////////////////
        serviceByTechReportModel =
            serviceByTechReportModelFromJson(response.body);

        totalPages = serviceByTechReportModel.data.lastPage ?? 1;
        currentPage = serviceByTechReportModel.data.currentPage;
        isFetching = false;
        emit(GetServiceByTechnicianReportSuccessState(
            serviceByTechReportModel: serviceByTechReportModel));

        // if (event.pagination == "next") {
        if (totalPages > currentPage && currentPage != 0) {
          currentPage += 1;
          print("here1");
        } else {
          currentPage = 0;
          print("here2");
        }
        // }
        //  else {
        //   if (totalPages > currentPage && currentPage != 0) {
        //     currentPage -= 1;
        //   } else {
        //     currentPage = 0;
        //   }
        // }
        print(currentPage.toString() + "current");
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
      if (Platform.isAndroid) {
        FileDownloader.downloadFile(
            url: event.downloadUrl,
            name: "Report", //(optional)

            onDownloadCompleted: (String path) {
              print('FILE DOWNLOADED TO PATH: $path');
              // emit(ExportReportState(
              //     message: "File downloaded to $path", time: DateTime.now()));

              CommonWidgets()
                  .showDialog(event.context, "File downloaded to $path");
            },
            onDownloadError: (String error) {
              print('DOWNLOAD ERROR: $error');
              CommonWidgets().showDialog(event.context, "Download Failed");
              emit(ExportReportErrorState(errorMessage: error));
            });
      } else {
        // function to download file in ios
      }
    } catch (e, s) {
      print(e.toString());
      print(s);

      emit(ExportReportErrorState(errorMessage: "Something went wrong"));
    }
  }
}
