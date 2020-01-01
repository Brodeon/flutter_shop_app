import 'dart:async';

import 'package:chopper/chopper.dart';

class MyInterceptor implements ResponseInterceptor {

  @override
  FutureOr<Response> onResponse(Response response) async {
    var request = response.base.request;
    var res = await request.send();
    return Response(res, res.stream);
  }


}