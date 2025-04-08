import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:taxify_user/shared/utils/utils.dart';
import 'package:taxify_user/shared/widgets/bouncing_loader.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

class WebPage extends StatefulWidget {
  final String webPageUrl;
  final String? title;
  const WebPage({super.key, required this.webPageUrl, this.title});

  @override
  State<WebPage> createState() => _WebPageState();
}

class _WebPageState extends State<WebPage> {
  WebViewControllerPlus? _controller;
  bool loading = true;

  @override
  void initState() {
    _controller =
        WebViewControllerPlus()
          ..setNavigationDelegate(
            NavigationDelegate(
              onPageFinished: (url) async {
                setState(() {
                  loading = false;
                });
              },
            ),
          )
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setBackgroundColor(Color(0XFFFFFFFF))
          ..loadRequest(Uri.parse(widget.webPageUrl));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null) {
      return Scaffold(body: Center(child: BouncingLoader()));
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title:
            widget.title != null
                ? Text(widget.title!, style: getTextTheme(context).bodyLarge)
                : null,
        leading: IconButton(
          onPressed: GoRouter.of(context).pop,
          icon: Icon(Icons.close, size: 28),
        ),
      ),
      body: SizedBox(
        height: double.maxFinite,
        child: WebViewWidget(controller: _controller!),
      ),
    );
  }
}
