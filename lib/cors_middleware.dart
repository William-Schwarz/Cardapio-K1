import 'dart:async';
import 'dart:io';

FutureOr<Function> corsMiddleware(handler) {
  return (HttpRequest request) async {
    var response = await handler(request);

    Map<String, Object> corsHeaders = {
      'Access-Control-Allow-Origin': 'cardapio-k1-c3881.web.app',
      'Access-Control-Allow-Methods': 'GET, POST, DELETE, PUT, OPTIONS',
      'Access-Control-Allow-Headers': '*',
    };

    HttpHeaders headers = response.headers;
    corsHeaders.forEach((key, value) {
      headers.set(key, value);
    });

    if (request.method == 'OPTIONS') {
      request.response
        ..statusCode = HttpStatus.ok
        ..headers.add(corsHeaders as String, headers)
        ..close();
    } else {
      await for (var chunk in response) {
        request.response.add(chunk);
      }
      await request.response.close();
    }
  };
}

void main() async {
  // Crie um servidor HTTP.
  var server = await HttpServer.bind(InternetAddress.anyIPv4, 8080);

  server.listen(corsMiddleware((HttpRequest request) async {
    return request.response;
  }) as void Function(HttpRequest event)?);

  print('Servidor iniciado na porta ${server.port}');
}
