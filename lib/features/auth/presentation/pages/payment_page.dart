import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentPage extends StatefulWidget {
  final Uri url;

  const PaymentPage({super.key, required this.url});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  late WebViewController webViewController;

  @override
  void initState() {
    super.initState();

    webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(widget.url)
      ..setNavigationDelegate(NavigationDelegate(
        onNavigationRequest: (NavigationRequest request) {
          print('Navigating to: ${request.url}');
          return NavigationDecision.navigate;
        },
        onPageFinished: (String url) {
          print('Page finished loading: $url');

          // Logika pengecekan status pembayaran selesai
          if (url.contains('payment_success')) { // Sesuaikan URL untuk mendeteksi pembayaran sukses
            // Kembali ke halaman BuktiDaftarPage dengan status "Lunas"
            Navigator.pop(context, true); // Kembalikan nilai `true` jika pembayaran sukses
          }
        },
      ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pembayaran'),
      ),
      body: WebViewWidget(controller: webViewController),
    );
  }
}
