import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../loading/loading_controller.dart';
import '../controller/auth_controller.dart';
import 'auth_phone_view.dart';

class AuthOtpView extends ConsumerStatefulWidget {
  const AuthOtpView({
    super.key,
    required this.userId,
  });

  final String userId;

  @override
  ConsumerState<AuthOtpView> createState() => _AuthOtpViewState();
}

class _AuthOtpViewState extends ConsumerState<AuthOtpView> {
  final _otpController = TextEditingController();

  void _onCompleted(String pin) {
    ref.read(authControllerProvider.notifier).verifySession(
          context: context,
          userId: widget.userId,
          secret: pin,
        );
  }

  @override
  void dispose() {
    super.dispose();
    _otpController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(loadingProvider);
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 60),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 24, horizontal: 12),
                  child: Column(
                    children: [
                      OtpTextField(
                        numberOfFields: 6,
                        borderColor: Colors.grey.shade700,
                        focusedBorderColor: Colors.black,
                        cursorColor: Colors.black,
                        filled: true,
                        fillColor: Colors.grey.shade300,
                        showFieldAsBox: false,
                        borderWidth: 4.0,
                        onSubmit: (pin) => _onCompleted(pin),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  minWidth: double.infinity,
                  height: 60,
                  color: Colors.black,
                  onPressed: isLoading
                      ? () {}
                      : () {
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (context) => const AuthPhoneView(),
                              ),
                              (route) => false);
                        },
                  child: isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Go Back',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
