import 'package:dart_frog/dart_frog.dart';
import 'package:myserver/constants.dart';

Future<Response> onRequest(RequestContext context, String id) async {
  final number = int.tryParse(id);
  if (number != null && number >= 1 && number <= 30) { 
    final request = context.request;
    var data = const FormData(fields: {}, files: {});
    try {
      data = await request.formData();
    } catch (e) { 
      // nothing!
    }
    final body = await request.body();
    final headers = request.headers;
    return Response.json(
      body: quotes[number-1],
      headers: {
        'request-method':request.method.name,
        'body':body,
        'data':data.fields.toString(),
        'headers':headers.toString(),
      },
    );
  } else { 
    return Response(body: 'something went wrong!', statusCode: 400);
  }
}
