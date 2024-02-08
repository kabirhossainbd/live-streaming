///
//  Generated code. Do not modify.
//  source: proto/rtc/rtc.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

import 'dart:async' as $async;

import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'rtc.pb.dart' as $0;
export 'rtc.pb.dart';

class RTCClient extends $grpc.Client {
  static final _$signal = $grpc.ClientMethod<$0.Request, $0.Reply>(
      '/rtc.RTC/Signal',
      ($0.Request value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.Reply.fromBuffer(value));

  RTCClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options, interceptors: interceptors);

  $grpc.ResponseStream<$0.Reply> signal($async.Stream<$0.Request> request,
      {$grpc.CallOptions? options}) {
    return $createStreamingCall(_$signal, request, options: options);
  }
}

abstract class RTCServiceBase extends $grpc.Service {
  $core.String get $name => 'rtc.RTC';

  RTCServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.Request, $0.Reply>(
        'Signal',
        signal,
        true,
        true,
        ($core.List<$core.int> value) => $0.Request.fromBuffer(value),
        ($0.Reply value) => value.writeToBuffer()));
  }

  $async.Stream<$0.Reply> signal(
      $grpc.ServiceCall call, $async.Stream<$0.Request> request);
}
