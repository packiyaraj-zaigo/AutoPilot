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
  final String page;
  final String? sortBy;
  final String? tableName;
  final String? fieldName;
  GetAllInvoiceReportEvent(
      {required this.startDate,
      required this.endDate,
      required this.paidFilter,
      required this.searchQuery,
      required this.currentPage,
      required this.exportType,
      required this.page,
      this.sortBy,
      this.tableName,
      this.fieldName});
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
  final String page;
  final String? sortBy;
  final String? tableName;
  final String? fieldName;

  GetTimeLogReportEvent(
      {required this.monthFilter,
      required this.techFilter,
      required this.searchQuery,
      required this.currentPage,
      required this.exportType,
      required this.page,
      this.sortBy,
      this.tableName,
      this.fieldName});
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
  final String page;
  final String? sort;
  final String? tableName;
  final String? fieldName;
  GetServiceByTechnicianReportEvent(
      {required this.startDate,
      required this.endDate,
      required this.searchQuery,
      required this.techFilter,
      required this.currentPage,
      required this.pagination,
      required this.exportType,
      required this.page,
      this.sort,
      this.tableName,
      this.fieldName});
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

class GetShopPerformanceReportEvent extends ReportEvent {
  final String exportType;
  GetShopPerformanceReportEvent({required this.exportType});
}

class GetTransactionReportEvent extends ReportEvent {
  final String page;
  final String exportType;
  final String createFilter;
  GetTransactionReportEvent(
      {required this.page,
      required this.exportType,
      required this.createFilter});
}

class GetAllOrderReportEvent extends ReportEvent {
  final String exportType;
  final String page;
  final String createFilter;
  GetAllOrderReportEvent(
      {required this.exportType,
      required this.page,
      required this.createFilter});
}

class GetLineItemDetailReportEvent extends ReportEvent {}

class GetEndOfDayReportEvent extends ReportEvent {
  final String exportType;
  GetEndOfDayReportEvent({required this.exportType});
}

class GetProfitablityReportEvent extends ReportEvent {
  final String fromDate;
  final String toDate;
  final String serviceId;
  final String exportType;
  final String page;

  GetProfitablityReportEvent(
      {required this.fromDate,
      required this.toDate,
      required this.serviceId,
      required this.page,
      required this.exportType});
}

class GetServiceWriterEvent extends ReportEvent {}
