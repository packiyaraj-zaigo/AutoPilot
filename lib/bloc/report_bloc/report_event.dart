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
  GetAllInvoiceReportEvent(
      {required this.startDate,
      required this.endDate,
      required this.paidFilter,
      required this.searchQuery,
      required this.currentPage});
}

class GetSalesTaxReportEvent extends ReportEvent {
  final String startDate;
  final String endDate;
  final int currentPage;
  GetSalesTaxReportEvent(
      {required this.startDate,
      required this.endDate,
      required this.currentPage});
}

class GetTimeLogReportEvent extends ReportEvent {
  final String monthFilter;
  final String techFilter;
  final String searchQuery;
  final int currentPage;

  GetTimeLogReportEvent(
      {required this.monthFilter,
      required this.techFilter,
      required this.searchQuery,
      required this.currentPage});
}

class GetPaymentTypeReportEvent extends ReportEvent {
  final String monthFilter;
  final String searchQuery;
  final int currentPage;

  GetPaymentTypeReportEvent(
      {required this.monthFilter,
      required this.searchQuery,
      required this.currentPage});
}

class GetServiceByTechnicianReportEvent extends ReportEvent {
  final String startDate;
  final String endDate;
  final String techFilter;
  final String searchQuery;
  final int currentPage;
  final String pagination;
  GetServiceByTechnicianReportEvent(
      {required this.startDate,
      required this.endDate,
      required this.searchQuery,
      required this.techFilter,
      required this.currentPage,
      required this.pagination});
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
