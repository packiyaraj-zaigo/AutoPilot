part of 'report_bloc.dart';

abstract class ReportState extends Equatable {
  const ReportState();

  @override
  List<Object> get props => [];
}

class ReportInitial extends ReportState {}

class ReportLoadingState extends ReportState {}

class GetAllInvoiceReportSuccessState extends ReportState {
  final AllInvoiceReportModel allInvoiceReportModel;
  GetAllInvoiceReportSuccessState({required this.allInvoiceReportModel});

  @override
  List<Object> get props => [allInvoiceReportModel];
}

class GetAllInvoiceReportErrorState extends ReportState {
  final String errorMessage;
  GetAllInvoiceReportErrorState({required this.errorMessage});
}

class GetSalesTaxReportSuccessState extends ReportState {
  final SalesTaxReportModel salesTaxReportModel;
  GetSalesTaxReportSuccessState({required this.salesTaxReportModel});

  @override
  List<Object> get props => [salesTaxReportModel];
}

class GetSalesTaxReportErrorState extends ReportState {
  final String errorMessage;
  GetSalesTaxReportErrorState({required this.errorMessage});
}

class GetTimeLogReportSuccessState extends ReportState {
  final TimeLogReportModel timeLogReportModel;
  GetTimeLogReportSuccessState({required this.timeLogReportModel});

  @override
  List<Object> get props => [timeLogReportModel];
}

class GetTimeLogReportErrorState extends ReportState {
  final String errorMessage;
  GetTimeLogReportErrorState({required this.errorMessage});
}

class GetPaymentTypeReportSuccessState extends ReportState {
  final PaymentTypeReportModel paymentReportModel;
  GetPaymentTypeReportSuccessState({required this.paymentReportModel});

  @override
  List<Object> get props => [paymentReportModel];
}

class GetPaymentTypeReportErrorState extends ReportState {
  final String errorMessage;
  GetPaymentTypeReportErrorState({required this.errorMessage});
}

class GetServiceByTechnicianReportSuccessState extends ReportState {
  final ServiceByTechReportModel serviceByTechReportModel;
  GetServiceByTechnicianReportSuccessState(
      {required this.serviceByTechReportModel});

  @override
  List<Object> get props => [serviceByTechReportModel];
}

class GetServiceByTechnicianReportErrorState extends ReportState {
  final String errorMessage;
  GetServiceByTechnicianReportErrorState({required this.errorMessage});
}

class InternetConnectionSuccessState extends ReportState {}

class InternerConnectionErrorState extends ReportState {}

class GetAllTechnicianState extends ReportState {
  final ReportTechnicianListModel technicianModel;
  GetAllTechnicianState({required this.technicianModel});

  @override
  List<Object> get props => [technicianModel];
}

class GetAllTechnicianErrorState extends ReportState {
  final String errorMessage;
  GetAllTechnicianErrorState({required this.errorMessage});
}

class ExportReportState extends ReportState {
  final String message;
  final DateTime time;
  ExportReportState({required this.message, required this.time});

  @override
  List<Object> get props => [message, time];
}

class ExportReportLoadingState extends ReportState {}

class ExportReportErrorState extends ReportState {
  final String errorMessage;
  ExportReportErrorState({required this.errorMessage});
}

class TableLoadingState extends ReportState {}
