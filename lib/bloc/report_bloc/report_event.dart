part of 'report_bloc.dart';

abstract class ReportEvent extends Equatable {
  const ReportEvent();

  @override
  List<Object> get props => [];
}

class GetAllInvoiceReportEvent extends ReportEvent {
  final String startDate;
  final String endDate;
  final String paidFilter;
  final String searchQuery;
  final int currentPage;
  final String exportType;
  GetAllInvoiceReportEvent(
      {required this.startDate,
      required this.endDate,
      required this.paidFilter,
      required this.searchQuery,
      required this.currentPage,
      required this.exportType});
}

class GetSalesTaxReportEvent extends ReportEvent {
  final String startDate;
  final String endDate;
  final int currentPage;
  final String exportType;
  GetSalesTaxReportEvent(
      {required this.startDate,
      required this.endDate,
      required this.currentPage,
      required this.exportType});
}

class GetTimeLogReportEvent extends ReportEvent {
  final String monthFilter;
  final String techFilter;
  final String searchQuery;
  final int currentPage;
  final String exportType;

  GetTimeLogReportEvent(
      {required this.monthFilter,
      required this.techFilter,
      required this.searchQuery,
      required this.currentPage,
      required this.exportType});
}

class GetPaymentTypeReportEvent extends ReportEvent {
  final String typeFilter;
  final String searchQuery;
  final int currentPage;
  final String exportType;

  GetPaymentTypeReportEvent(
      {required this.typeFilter,
      required this.searchQuery,
      required this.currentPage,
      required this.exportType});
}

class GetServiceByTechnicianReportEvent extends ReportEvent {
  final String startDate;
  final String endDate;
  final String techFilter;
  final String searchQuery;
  final int currentPage;
  final String pagination;
  final String exportType;
  GetServiceByTechnicianReportEvent(
      {required this.startDate,
      required this.endDate,
      required this.searchQuery,
      required this.techFilter,
      required this.currentPage,
      required this.pagination,
      required this.exportType});
}

class InternetConnectionEvent extends ReportEvent {}

class GetAllTechnicianEvent extends ReportEvent {}

class ExportReportEvent extends ReportEvent {
  final String downloadUrl;
  final String downloadPath;
  final String fileName;
  final BuildContext context;
  ExportReportEvent(
      {required this.downloadPath,
      required this.downloadUrl,
      required this.fileName,
      required this.context});
}
