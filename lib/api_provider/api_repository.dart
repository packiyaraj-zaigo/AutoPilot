import 'api_provider.dart';

class ApiRepository {
  final apiProvider = ApiProvider();

   Future createAccount(String firstName,lastName,email,phoneNumber,password) {
    return apiProvider.createAccount(firstName, lastName, email, password, phoneNumber);
  }

   Future login(String email,password) {
    return apiProvider.login( email, password);
  }


   Future getRevenueChartData(dynamic token) {
    return apiProvider.getRevenueChartData(token);
  }


     Future resetPasswordGetOtp(String emailId) {
    return apiProvider.resetPasswordGetOtp(emailId);
  }

     Future resetPasswordSendOtp(String emailId,String otp) {
    return apiProvider.resetPasswordSendOtp(emailId,otp);
  }

       Future getUserProfile(String token) {
    return apiProvider.getUserProfile(token);
  }

}

class NetworkError extends Error {}
