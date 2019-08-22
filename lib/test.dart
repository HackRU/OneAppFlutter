import 'package:dart_lcs_client/dart_lcs_client.dart';
import 'dart:convert';

const MISC_URL = 'http://hackru-misc.s3-website-us-west-2.amazonaws.com';

scannerEvents() async {
  var response =  await getMisc(MISC_URL, "/events.txt");
  print(response.body.toUpperCase().split('\n'));
}

void main(){
  scannerEvents();
}