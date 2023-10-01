import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import './ThrowError.dart';

Future<String> getWarpUrl (String filePath) async {
	print('Getting warp URL');
	List<String> urls = Utf8Decoder(allowMalformed: true).convert(await File('$filePath\\StarRail_Data\\webCaches\\2.15.0.0\\Cache\\Cache_Data\\data_2').readAsBytes()).split('1/0/');
	for(int i = 0; i<urls.length; i++) {
		if(urls[i].startsWith('https://api-os-takumi.mihoyo.com')) {
			Map response;
			try {
				response = jsonDecode((await http.get(Uri.parse(urls[i].split('&os_system')[0]))).body);
			} catch (e) {
				break;
			}
			if(response['retcode'] == 0) {
				print('got warp URL');
				return urls[i].split('&os_system')[0];
			}
		}
	}
	throwError('Failed to get warp url');
	throw Exception();
}