part of 'dashboard_bloc.dart';

abstract class DashboardState extends Equatable {
  const DashboardState();
  
  @override
  List<Object> get props => [];
}



// ignore: must_be_immutable
class GetRevenueChartDataState extends DashboardState{
  RevenueChartModel revenueData;
  GetRevenueChartDataState({required this.revenueData});



}

class DashboardLoadingState extends DashboardState{}

class GetProfileDetailsState extends DashboardState{
  final UserProfileModel userProfile;
  const GetProfileDetailsState({required this.userProfile});

}

class GetUserProfileLoadingState extends DashboardState{

}


class GetProvinceState extends DashboardState{
  final ProvinceModel provinceList;
  const GetProvinceState({required this.provinceList});


  @override
  @override
  List<Object> get props => [provinceList];

}

class AddCompanySucessState extends DashboardState{

}

class AddCompanyLoadingState extends DashboardState{}

