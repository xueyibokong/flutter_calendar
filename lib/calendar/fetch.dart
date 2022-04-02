import 'package:fast_gbk/fast_gbk.dart';
import 'package:dio/dio.dart';
import 'package:dart_date/dart_date.dart';

fetchAlmanacOpts(DateTime date) async {
  var url = Uri.https(
    'sp1.baidu.com',
    '/8aQDcjqpAAV3otqbppnN2DJv/api.php',
    {
      'tn': 'wisetpl',
      'query': date.getYear.toString() + '年' + date.getMonth.toString() + '月',
      'resource_id': '39043',
      'format': 'json',
    },
  );
  var response = await Dio().get(
    url.toString(),
    options: Options(
      responseDecoder: (List<int> responseBytes, RequestOptions options,
              ResponseBody responseBody) =>
          gbk.decode(responseBytes),
    ),
  );
  if (response.statusCode == 200) {
    return response.data;
  } else {
    return Error();
  }
}

fetchHolidaysTitleOpts() async {
  var url = Uri.https(
    'sp1.baidu.com',
    '/8aQDcjqpAAV3otqbppnN2DJv/api.php',
    {
      'tn': 'wisetpl',
      'query': '法定节假日',
      'resource_id': '39042',
      'format': 'json',
    },
  );
  var response = await Dio().get(
    url.toString(),
    options: Options(
      responseDecoder: (List<int> responseBytes, RequestOptions options,
              ResponseBody responseBody) =>
          gbk.decode(responseBytes),
    ),
  );
  if (response.statusCode == 200) {
    return response.data;
  } else {
    return Error();
  }
}
