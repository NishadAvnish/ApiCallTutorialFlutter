import 'dart:async';

import 'package:apicallflutter/mixin/refresh_token.dart';
import 'package:http_interceptor/http_interceptor.dart';

class ExpiredTokenRetryPolicy implements RetryPolicy {
  @override
  Duration delayRetryAttemptOnException({required int retryAttempt}) {
    return Duration.zero;
  }

  @override
  Duration delayRetryAttemptOnResponse({required int retryAttempt}) {
    return Duration.zero;
  }

  @override
  int get maxRetryAttempts => 2;

  @override
  FutureOr<bool> shouldAttemptRetryOnException(
      Exception reason, BaseRequest request) {
    return true;
  }

  @override
  Future<bool> shouldAttemptRetryOnResponse(BaseResponse response) async {
    bool retry = false;
    if (response is Response) {
      if (response.statusCode == 401) {
        final bool success = await RefreshToken().getToken();
        if (success) {
          retry = false;
        } else {
          retry = true;
        }
      }
    }

    return retry;
  }
}
