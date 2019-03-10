

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';


const Color colorPrimary = Color(0xFFF44336);

const String DEFAULT_VIDEO_SUFFIX = ".mp4";
const String AWEME_URL = "https://aweme.snssdk.com/aweme/v1/aweme/detail/";
const String WE_VIDEO_URL =
    "https://h5.weishi.qq.com/webapp/json/weishi/WSH5GetPlayPage";
const String AWEME_SIGN = "douyin.com";
const String WE_VIDEO_SIGN = "h5.weishi.qq.com";


final String dPath = "aweme/v1/aweme/detail/";

final BaseOptions dOptions = new BaseOptions(
  baseUrl: "https://api.amemv.com/",
  connectTimeout: 5000,
  receiveTimeout: 3000,
  method: "POST",
);

final Dio dClient = new Dio(dOptions);


final InterceptorsWrapper redirectUrlInterceptor = new InterceptorsWrapper(onError: (DioError e) {
      print(e);
      String id = Uri.parse(e.response.headers["location"][0])
          .pathSegments[2];
      return new Response(statusCode: 200, data: id); //continue
    }
);

final BaseOptions weSeeOptions = new BaseOptions(
  baseUrl: "https://h5.weishi.qq.com/webapp/json/weishi/WSH5GetPlayPage",
  connectTimeout: 5000,
  receiveTimeout: 3000,
  method: "POST",
);
final Dio wClient = new Dio(dOptions);


Map<String, String> generateDParam(String id) {
  Map<String, String> param = new Map();
  param["aweme_id"] = id;
//  param["app_name"] = "aweme";
//  param["version_code"] = "400";
//  param["version_name"] = "4.0.0";
//  param["device_platform"] = "android";
//  param["device_type"] = "Mi%20Note%202";
  return param;
}

Map<String, String> generateWParam(String id) {
  Map<String, String> param = new Map();
  param["feedid"] = id;
  return param;
}






