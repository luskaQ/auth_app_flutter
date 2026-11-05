import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

enum LottieDialogState { loading, success }

class LottieDialogController extends ValueNotifier<LottieDialogState> {
  String successMessage;

  LottieDialogController({
    LottieDialogState initialState = LottieDialogState.loading,
    this.successMessage = 'Sucesso!',
  }) : super(initialState);

  void showSuccess([String? message]) {
    if (message != null) {
      successMessage = message;
    }
    value = LottieDialogState.success;
  }
}

class LottieDialogWidget extends StatelessWidget {
  final LottieDialogController controller;
  final String loadingMessage;

  const LottieDialogWidget({
    super.key,
    required this.controller,
    this.loadingMessage = 'Carregando...',
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: ValueListenableBuilder<LottieDialogState>(
          valueListenable: controller,
          builder: (context, state, child) {
            final isSuccess = state == LottieDialogState.success;
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Lottie.asset(
                  isSuccess
                      ? 'assets/animations/success.json'
                      : 'assets/animations/loading.json',
                  height: 120,
                  width: 120,
                  repeat: !isSuccess,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      isSuccess ? Icons.check_circle : Icons.hourglass_top,
                      size: 80,
                      color: isSuccess ? Colors.green : Colors.blue,
                    );
                  },
                ),
                const SizedBox(height: 16),
                Text(
                  isSuccess ? controller.successMessage : loadingMessage,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
