import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:settings/view/pages/power/power_settings_model.dart';
import 'package:settings/view/pages/power/power_settings_widgets.dart';

Future<void> showAutomaticSuspendDialog(BuildContext context) async {
  return showDialog(
    context: context,
    builder: (_) => ChangeNotifierProvider.value(
      value: context.read<SuspendModel>(),
      child: const AutomaticSuspendDialog(),
    ),
  );
}

class AutomaticSuspendDialog extends StatelessWidget {
  const AutomaticSuspendDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.watch<SuspendModel>();
    return SimpleDialog(
      title: const Center(child: Text('Automatic Suspend')),
      contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
      children: <Widget>[
        SuspendDelaySettingsRow(
          actionLabel: 'On Battery Power',
          suspend: model.suspendOnBattery,
          onSuspendChanged: model.setSuspendOnBattery,
          delay: model.suspendOnBatteryDelay,
          onDelayChanged: model.setSuspendOnBatteryDelay,
        ),
        const SizedBox(height: 16.0),
        SuspendDelaySettingsRow(
          actionLabel: 'When Plugged In',
          suspend: model.suspendWhenPluggedIn,
          onSuspendChanged: model.setSuspendWhenPluggedIn,
          delay: model.suspendWhenPluggedInDelay,
          onDelayChanged: model.setSuspendWhenPluggedInDelay,
        ),
      ],
    );
  }
}