// ignore_for_file: lines_longer_than_80_chars

import 'package:dart_frog/dart_frog.dart';
import 'package:myserver/constants.dart';

Future<Response> onRequest(RequestContext context) async {
  final request = context.request;
  final params = request.uri.queryParameters;
  final sort = params['sort'] ?? 'ids';
  final order = params['order'] ?? 'asc';
  final skip = int.tryParse(params['skip'] ?? '0') ?? 0;
  final limit = int.tryParse(params['limit'] ?? '30') ?? 30;
  if (sorters.contains(sort) && orders.contains(order) && skip.inValidLimit() && limit.inValidLimit()) { 
    var mutablesQuotes = quotes;
    var isFormated = false;
    for (final entri in params.entries) { 
      switch(entri.key) { 
        case 'skip' : mutablesQuotes = mutablesQuotes.skip(skip).toList();
        case 'limit' : mutablesQuotes = mutablesQuotes.take(limit).toList();
        default : { if (!isFormated) mutablesQuotes = getFormatedQuotes(sort, order, mutablesQuotes); isFormated = true; }
      }
    }
    var data = const FormData(fields: {}, files: {});
    try {
      data = await request.formData();
    } catch (e) { 
      // nothing!
    }
    final body = await request.body();
    final headers = request.headers;
    return Response.json(
      body: params.containsKey('justQuotes')? mutablesQuotes : {
        'quotes':mutablesQuotes,
        'limit':limit,
        'skip':skip,
        'total':quotes.length,
      },
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
