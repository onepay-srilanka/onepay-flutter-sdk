import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ipg_flutter/bloc/3ds_bloc.dart';
import 'package:ipg_flutter/widgets/inter_medium_text.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../ipg_config.dart';
import '../models/create_customer_token_response.dart';
import '../resources/colors.dart';

class ThreeDSecureScreen extends StatefulWidget {
  final CallbackData customerTokenData;
  final String appToken;

  const ThreeDSecureScreen({
    super.key,
    required this.customerTokenData,
    required this.appToken,
  });

  @override
  State<ThreeDSecureScreen> createState() => _ThreeDSecureScreenState();
}

class _ThreeDSecureScreenState extends State<ThreeDSecureScreen> {
  late final WebViewController _controller;
  late ThreeDSBloc _bloc;

  @override
  void initState() {
    _bloc = ThreeDSBloc();
    _listenToListStream();
    final html = '''
    <html>
      <body onload="document.forms[0].submit()">
        <form method="POST" action="${widget.customerTokenData.acsUrl}">
          <input type="hidden" name="creq" value="${widget.customerTokenData.acsCreq}" />
        </form>
      </body>
    </html>
    ''';

    final String contentBase64 = base64Encode(
      const Utf8Encoder().convert(html),
    );

    _controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setNavigationDelegate(
            NavigationDelegate(
              onNavigationRequest: (NavigationRequest request) {
                return NavigationDecision.navigate;
              },
            ),
          )
          ..loadRequest(Uri.parse('data:text/html;base64,$contentBase64'));
    _bloc.checkStatus(widget.customerTokenData.onepayTransactionId!, widget.appToken);
    super.initState();
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: InterMediumText(
          '3DS Secure Authentication',
          color: AppColors.white,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: AppColors.onyx,
      ),
      body: WebViewWidget(controller: _controller),
    );
  }

  void _listenToListStream() {
    _bloc.check3DSStatusStream.listen((data) {
      if (!mounted) return;

      switch (data.status) {
        case Status.loading:
          break;
        case Status.completed:
          Navigator.pop(context, data.data?.isAuthenticate);
          break;
        case Status.error:
          Navigator.pop(context, data.message);
          break;
      }
    });
  }
}
