import 'package:flutter/material.dart';

import '../addons/addons.dart';
import '../fields/fields.dart';
import '../state/state.dart';
import 'safe_boundaries.dart';
import 'use_case_builder.dart';

class Workbench extends StatelessWidget {
  const Workbench({super.key});

  @override
  Widget build(BuildContext context) {
    final state = WidgetbookState.of(context);

    return Scaffold(
      body: SafeBoundaries(
        child: state.appBuilder(
          context,
          MultiAddonBuilder(
            addons: state.addons,
            builder: (context, addon, child) {
              final state = WidgetbookState.of(context);
              final groupMap = FieldCodec.decodeQueryGroup(
                state.queryParams[addon.groupName],
              );

              final newSetting = addon.valueFromQueryGroup(groupMap);

              return addon.buildUseCase(
                context,
                child,
                newSetting,
              );
            },
            child: Stack(
              // The Stack is used to loosen the constraints of
              // the UseCaseBuilder. Without the Stack, UseCaseBuilder
              // would expand to the whole size of the Workbench.
              children: [
                SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: ColoredBox(
                    color: Theme.of(context).scaffoldBackgroundColor,
                  ),
                ),
                Center(
                  child: UseCaseBuilder(
                    key: ValueKey(state.uri),
                    builder: (context) {
                      return WidgetbookState.of(context).useCase?.build(context) ?? const SizedBox.shrink();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
