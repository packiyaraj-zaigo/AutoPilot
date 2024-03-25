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

class GetExportLinkState extends ReportState {
  final String link;
  GetExportLinkState({required this.link});
}

class GetExportLinkLoadingState extends ReportState {}

class GetExportLinkErrorState extends ReportState {}

class GetShopPerformanceReportState extends ReportState {
  final ShopPerformanceReportModel shopPerformanceReportModel;
  GetShopPerformanceReportState({required this.shopPerformanceReportModel});

  @override
  List<Object> get props => [shopPerformanceReportModel];
}

class GetShopPerformanceReportErrorState extends ReportState {
  final String errorMessage;
  GetShopPerformanceReportErrorState({required this.errorMessage});
}

class GetTransactionReportState extends ReportState {
  final TransactionReportModel transactionReportModel;
  GetTransactionReportState({required this.transactionReportModel});

  @override
  List<Object> get props => [transactionReportModel];
}

class GetTransactionReportErrorState extends ReportState {
  final String errorMessage;
  GetTransactionReportErrorState({required this.errorMessage});
}

class GetAllOrdersReportState extends ReportState {
  final AllOrdersReportModel allOrdersReportModel;
  GetAllOrdersReportState({required this.allOrdersReportModel});

  @override
  List<Object> get props => [allOrdersReportModel];
}

class GetAllOrdersReportErrorState extends ReportState {
  final String errorMessage;
  GetAllOrdersReportErrorState({required this.errorMessage});
}

class GetLineItemDetailReportState extends ReportState {
  final LineItemDetailReportModel lineItemDetailReportModel;
  GetLineItemDetailReportState({required this.lineItemDetailReportModel});

  @override
  List<Object> get props => [lineItemDetailReportModel];
}

class GetLineItemDetailReportErrorState extends ReportState {
  final String errorMessage;
  GetLineItemDetailReportErrorState({required this.errorMessage});
}

class GetEndOfDayReportState extends ReportState {
  final EndOfDayReportModel endOfDayReportModel;
  GetEndOfDayReportState({required this.endOfDayReportModel});

  @override
  List<Object> get props => [endOfDayReportModel];
}

class GetEndOfDayReportErrorState extends ReportState {
  final String errorMessage;

  GetEndOfDayReportErrorState({required this.errorMessage});
}

class GetProfitablityReportState extends ReportState {
  final ProfitablityReportModel profitablityReportModel;
  GetProfitablityReportState({required this.profitablityReportModel});
}

class GetProfitablityReportErrorState extends ReportState {
  final String errorMessage;
  GetProfitablityReportErrorState({required this.errorMessage});
}

class GetServiceWriterState extends ReportState {
  final ServiceWriterModel serviceWriterModel;

  GetServiceWriterState({required this.serviceWriterModel});

  @override
  List<Object> get props => [serviceWriterModel];
}

class GetServiceWriterErrorState extends ReportState {
  final String errorMessage;
  GetServiceWriterErrorState({required this.errorMessage});
}

class GetCustomerSummaryReportState extends ReportState {
  final CustomerSummaryReportModel customerSummaryReportModel;
  GetCustomerSummaryReportState({required this.customerSummaryReportModel});

  @override
  List<Object> get props => [customerSummaryReportModel];
}

class GetCustomerSummaryReportErrorState extends ReportState {
  final String errorMessage;
  GetCustomerSummaryReportErrorState({required this.errorMessage});
}
