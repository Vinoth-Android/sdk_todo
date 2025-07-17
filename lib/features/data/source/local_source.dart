abstract class LocalSource {
  LocalSource();

  // Future<DemoModel> demoLogin({
  //   required String email,
  //   required String password,
  // });
}

class LocalSourceImpl extends LocalSource {
  LocalSourceImpl();

  // @override
  // Future<DemoModel> demoLogin({
  //   required String email,
  //   required String password,
  // }) async {
  //   try {
  //     final response = await dio.post(
  //       '/login',
  //       data: {'email': email, 'password': password},
  //     );
  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       return DemoModel.fromJson(response.data);
  //     }
  //   } catch (e) {
  //     rethrow;
  //   }
  // }
}
