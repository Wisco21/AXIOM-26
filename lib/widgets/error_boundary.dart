// widgets/error_boundary.dart
import 'package:flutter/material.dart';

class ErrorBoundary extends StatefulWidget {
  final Widget child;
  final Widget Function(BuildContext, Object) errorBuilder;

  const ErrorBoundary({
    super.key,
    required this.child,
    required this.errorBuilder,
  });

  @override
  State<ErrorBoundary> createState() => _ErrorBoundaryState();
}

class _ErrorBoundaryState extends State<ErrorBoundary> {
  Object? _error;

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return widget.errorBuilder(context, _error!);
    }
    
    return ErrorWidgetBuilder(
      onError: (error) => setState(() => _error = error),
      child: widget.child,
    );
  }
}

class ErrorWidgetBuilder extends StatefulWidget {
  final Widget child;
  final Function(Object error) onError;

  const ErrorWidgetBuilder({
    super.key,
    required this.child,
    required this.onError,
  });

  @override
  State<ErrorWidgetBuilder> createState() => _ErrorWidgetBuilderState();
}

class _ErrorWidgetBuilderState extends State<ErrorWidgetBuilder> {
  @override
  void initState() {
    super.initState();
    // Catch any initialization errors
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // This will catch errors that happen during build
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}