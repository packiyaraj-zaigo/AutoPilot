import 'api_provider.dart';

class ApiRepository {
  final apiProvider = ApiProvider();

   Future createAccount(String firstName,lastName,email,phoneNumber,password) {
    return apiProvider.createAccount(firstName, lastName, email, password, phoneNumber);
  }

   Future login(String email,password) {
    return apiProvider.login( email, password);
  }

}

class NetworkError extends Error {}
