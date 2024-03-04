import 'package:bloc_learn/data/model/user.dart';
import 'package:dio/dio.dart';

class ApiService {
  final dio = Dio(BaseOptions(baseUrl: 'https://reqres.in/api'));

  Future<DataUser> getUsers() async {
    final response = await dio.get('/users');
    return DataUser.fromJson(response.data);
  }
}
