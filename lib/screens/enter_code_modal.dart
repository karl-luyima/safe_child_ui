import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class EnterCodeModal extends StatelessWidget {
  final Function(String code) onCodeSubmitted;

  const EnterCodeModal({Key? key, required this.onCodeSubmitted});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Enter Verification Code",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Pinput(
              length: 6,
              autofocus: true,
              onCompleted: (pin) {
                onCodeSubmitted(pin);
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
            )
          ],
        ),
      ),
    );
  }
}