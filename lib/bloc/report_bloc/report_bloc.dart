import 'dart:convert';

import 'package:auto_pilot/Models/all_invoice_report_model.dart';
import 'package:auto_pilot/Models/payment_type_report_model.dart';
import 'package:auto_pilot/Models/sales_tax_report_model.dart';
import 'package:auto_pilot/Models/service_technician_report_model.dart';
import 'package:auto_pilot/Models/time_log_report_model.dart';
import 'package:auto_pilot/api_provider/api_repository.dart';
import 'package:auto_pilot/utils/app_utils.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart';

part 'report_event.dart';
part 'report_state.dart';

class ReportBloc extends Bloc<ReportEvent, ReportState> {
  final apiRepo = ApiRepository();
  ReportBloc() : super(ReportInitial()) {
    on<GetAllInvoiceReportEvent>(getAllInvoiceReportBloc);
    on<GetSalesTaxReportEvent>(getSalesTaxReportBloc);
    on<GetTimeLogReportEvent>(getTimeLogReportBloc);
    on<GetPaymentTypeReportEvent>(getPaymentTypeReportBloc);
    on<GetServiceByTechnicianReportEvent>(getServiceByTechnicianReportBloc);
  }

  //Bloc to get all invoice report.
  Future<void> getAllInvoiceReportBloc(
      GetAllInvoiceReportEvent event, Emitter<ReportState> emit) async {
    try {
      emit(ReportLoadingState());
      //change nullable with original model class
      List<AllInvoiceReportModel> allInvoiceReportModel;

      final token = await AppUtils.getToken();

      Response response = await apiRepo.getAllinvoiceReport(
          token,
          event.monthFilter,
          event.paidFilter,
          event.currentPage,
          event.searchQuery);
      if (response.statusCode == 200) {
        //decode response into model class.
        /////////////////////////////////
        allInvoiceReportModel = allInvoiceReportModelFromJson(response.body);
        emit(GetAllInvoiceReportSuccessState(
            allInvoiceReportModel: allInvoiceReportModel)); //change force null.
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
      List<SalesTaxReportModel> salesTaxReportModel;
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
      List<TimeLogReportModel> timeLogReportModel;
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
    } catch (e) {
      print(e.toString());
      emit(GetTimeLogReportErrorState(errorMessage: "Something went wrong"));
    }
  }

  //Bloc to get payment type report.
  Future<void> getPaymentTypeReportBloc(
      GetPaymentTypeReportEvent event, Emitter<ReportState> emit) async {
    try {
      emit(ReportLoadingState());
      //change nullable with original model class
      List<PaymentTypeReportModel> paymentTypeReportModel;
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
    } catch (e) {
      print(e.toString());
      emit(
          GetPaymentTypeReportErrorState(errorMessage: "Something went wrong"));
    }
  }

  //Bloc to get service by technician report
  Future<void> getServiceByTechnicianReportBloc(
      GetServiceByTechnicianReportEvent event,
      Emitter<ReportState> emit) async {
    try {
      emit(ReportLoadingState());
      //change nullable with original model class
      List<ServiceByTechReportModel> serviceByTechReportModel;
      final token = await AppUtils.getToken();

      Response response = await apiRepo.getServiceByTechnicianReport(
          token,
          event.monthFilter,
          event.searchQuery,
          event.techFilter,
          event.currentPage);
      if (response.statusCode == 200) {
        //decode response into model class.
        /////////////////////////////////
        serviceByTechReportModel =
            serviceByTechReportModelFromJson(response.body);
        emit(GetServiceByTechnicianReportSuccessState(
            serviceByTechReportModel:
                serviceByTechReportModel)); //change force null.
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
}
