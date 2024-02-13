part of 'report_bloc.dart';

abstract class ReportState extends Equatable {
  const ReportState();

  @override
  List<Object> get props => [];
}

class ReportInitial extends ReportState {}

class ReportLoadingState extends ReportState {}

class GetAllInvoiceReportSuccessState extends ReportState {
  final List<AllInvoiceReportModel> allInvoiceReportModel;
  GetAllInvoiceReportSuccessState({required this.allInvoiceReportModel});

  @override
  List<Object> get props => [allInvoiceReportModel];
}

class GetAllInvoiceReportErrorState extends ReportState {
  final String errorMessage;
  GetAllInvoiceReportErrorState({required this.errorMessage});
}

class GetSalesTaxReportSuccessState extends ReportState {
  final List<SalesTaxReportModel> salesTaxReportModel;
  GetSalesTaxReportSuccessState({required this.salesTaxReportModel});

  @override
  List<Object> get props => [salesTaxReportModel];
}

class GetSalesTaxReportErrorState extends ReportState {
  final String errorMessage;
  GetSalesTaxReportErrorState({required this.errorMessage});
}

class GetTimeLogReportSuccessState extends ReportState {
  final List<TimeLogReportModel> timeLogReportModel;
  GetTimeLogReportSuccessState({required this.timeLogReportModel});

  @override
  List<Object> get props => [timeLogReportModel];
}

class GetTimeLogReportErrorState extends ReportState {
  final String errorMessage;
  GetTimeLogReportErrorState({required this.errorMessage});
}

class GetPaymentTypeReportSuccessState extends ReportState {
  final List<PaymentTypeReportModel> paymentReportModel;
  GetPaymentTypeReportSuccessState({required this.paymentReportModel});

  @override
  List<Object> get props => [paymentReportModel];
}

class GetPaymentTypeReportErrorState extends ReportState {
  final String errorMessage;
  GetPaymentTypeReportErrorState({required this.errorMessage});
}

class GetServiceByTechnicianReportSuccessState extends ReportState {
  final List<ServiceByTechReportModel> serviceByTechReportModel;
  GetServiceByTechnicianReportSuccessState(
      {required this.serviceByTechReportModel});

  @override
  List<Object> get props => [serviceByTechReportModel];
}

class GetServiceByTechnicianReportErrorState extends ReportState {
  final String errorMessage;
  GetServiceByTechnicianReportErrorState({required this.errorMessage});
}
