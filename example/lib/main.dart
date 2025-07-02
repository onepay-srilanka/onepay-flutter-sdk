import 'package:flutter/material.dart';
import 'package:ipg_flutter/ipg_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IPG Flutter Demo',
      home: const IpgDemoScreen(),
    );
  }
}

class IpgDemoScreen extends StatefulWidget {
  const IpgDemoScreen({super.key});
  @override
  State<IpgDemoScreen> createState() => _IpgDemoScreenState();
}

class _IpgDemoScreenState extends State<IpgDemoScreen> {

  late Ipg ipg;

  @override
  void initState() {
    super.initState();
    ipg = Ipg.init(
      appToken: 'your_token',
      appId: 'your_app_id',
      firstName: 'John',
      lastName: 'Doe',
      email: 'john.doe@sample.com',
      phoneNumber: '0000000000',
    );

    ipg.addCardEventCallback = (status, message) {
      debugPrint("ADD CARD CALLBACK: $status");
    };

    ipg.getCustomersEventCallback = (customers, message) {
      debugPrint("GET CUSTOMERS CALLBACK: $customers");
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("IPG Demo")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => ipg.addNewCard(context),
              child: const Text("Add New Card"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => ipg.getCustomers(),
              child: const Text("Get Customers"),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    ipg.dispose();
    super.dispose();
  }
}