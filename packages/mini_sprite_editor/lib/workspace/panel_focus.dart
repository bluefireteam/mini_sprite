import 'package:flutter/widgets.dart';

class PanelFocus extends StatefulWidget {
  const PanelFocus({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  State<PanelFocus> createState() => _PanelFocusState();
}

class _PanelFocusState extends State<PanelFocus> {
  late final fn = FocusNode();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    FocusScope.of(context).addListener(onScopeFocusChanged);
  }

  void onScopeFocusChanged() {
    final scope = FocusScope.of(context);

    if (!scope.hasFocus) {
      return;
    }
    fn.requestFocus();
  }

  @override
  void dispose() {
    FocusScope.of(context).removeListener(onScopeFocusChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: fn,
      autofocus: true,
      child: widget.child,
    );
  }
}
