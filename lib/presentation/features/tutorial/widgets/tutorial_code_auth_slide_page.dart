import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nawiapp/presentation/features/tutorial/providers/tutorial_slider_provider.dart';

class TutorialCodeAuthSlidePage extends ConsumerStatefulWidget {
  const TutorialCodeAuthSlidePage({super.key});

  @override
  ConsumerState<TutorialCodeAuthSlidePage> createState() => _TutorialPinSlidePageState();
}

class _TutorialPinSlidePageState extends ConsumerState<TutorialCodeAuthSlidePage> {

  final _codeAuthController = TextEditingController();
  final _verifyCodeAuthController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final tutorialState = ref.watch(tutorialSliderProvider);
    final tutorialNotifier = ref.read(tutorialSliderProvider.notifier);
    final expectedLength = tutorialState.isUsingDni ? 8 : 4;

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            tutorialState.isUsingDni ? 'Ingrese su DNI' : 'Ingresa tu PIN de 4 dígitos',
            style: const TextStyle(fontSize: 22),
            textAlign: TextAlign.center
          ),

          Text('Esta acción es necesaria para asegurar que eres tu el que está usando la app'),

          const SizedBox(height: 16),

          TextFormField(
            controller: _codeAuthController,
            maxLength: expectedLength,
            keyboardType: TextInputType.number,
            inputFormatters: [ FilteringTextInputFormatter.digitsOnly ],
            onChanged: tutorialNotifier.setCodeAuth,
            onTapOutside: (_) => FocusScope.of(context).unfocus(),
            decoration: InputDecoration(
              labelText: tutorialState.isUsingDni ? 'DNI' : 'PIN',
              counterText: '${_codeAuthController.text.length}',
              errorText: tutorialNotifier.codeAuthErrorText,
            ),
          ),

          TextFormField(
            controller: _verifyCodeAuthController,
            maxLength: expectedLength,
            keyboardType: TextInputType.number,
            inputFormatters: [ FilteringTextInputFormatter.digitsOnly ],
            onChanged: tutorialNotifier.setVerifyCodeAuth,
            onTapOutside: (_) => FocusScope.of(context).unfocus(),
            decoration: InputDecoration(
              labelText: 'Verificar ${tutorialState.isUsingDni ? 'DNI' : 'PIN'}',
              counterText: '${_verifyCodeAuthController.text.length}',
              errorText: tutorialNotifier.verifyCodeAuthErrorText,
            ),
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              Checkbox(
                value: tutorialState.isUsingDni,
                onChanged: (value) {
                  tutorialNotifier.useDni(value);
                  _codeAuthController.clear();
                  _verifyCodeAuthController.clear();
                },
              ),
              const Text('Usar DNI'),
            ],
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _codeAuthController.dispose();
    _verifyCodeAuthController.dispose();
    super.dispose();
  }
}