

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';


const Color colorPrimary = Color(0xFFF44336);

const String DEFAULT_VIDEO_SUFFIX = ".mp4";
const String D_URL = "https://aweme.snssdk.com/aweme/v1/aweme/detail/";
const String W_URL =
    "https://h5.weishi.qq.com/webapp/json/weishi/WSH5GetPlayPage";
const String D_SIGN = "douyin.com";
const String W_SIGN = "h5.weishi.qq.com";


final String dPath = "aweme/v1/aweme/detail/";
final String wPath = "/webapp/json/weishi/WSH5GetPlayPage";

final BaseOptions dOptions = new BaseOptions(
  baseUrl: "https://api.amemv.com/",
  connectTimeout: 10000,
  receiveTimeout: 10000,
  method: "GET",
);

final Dio dClient = new Dio(dOptions);


final BaseOptions wOptions = new BaseOptions(
  baseUrl: "https://h5.weishi.qq.com/",
  connectTimeout: 10000,
  receiveTimeout: 10000,
  method: "GET",
);
final Dio wClient = new Dio(wOptions);


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






