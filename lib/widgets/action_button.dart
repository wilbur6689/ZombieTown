import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final ActionButtonStyle style;
  final bool isLoading;
  final double? width;
  final double? height;

  const ActionButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.style = ActionButtonStyle.primary,
    this.isLoading = false,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final buttonStyle = _getButtonStyle();
    
    return SizedBox(
      width: width,
      height: height ?? 48,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonStyle.backgroundColor,
          foregroundColor: buttonStyle.foregroundColor,
          disabledBackgroundColor: buttonStyle.disabledColor,
          elevation: buttonStyle.elevation,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(buttonStyle.borderRadius),
            side: buttonStyle.borderSide ?? BorderSide.none,
          ),
        ),
        child: isLoading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    buttonStyle.foregroundColor,
                  ),
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 18),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    text,
                    style: TextStyle(
                      fontSize: buttonStyle.fontSize,
                      fontWeight: buttonStyle.fontWeight,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  _ButtonStyleData _getButtonStyle() {
    switch (style) {
      case ActionButtonStyle.primary:
        return _ButtonStyleData(
          backgroundColor: Colors.blue.shade600,
          foregroundColor: Colors.white,
          disabledColor: Colors.grey.shade400,
          elevation: 2,
          borderRadius: 8,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        );
      case ActionButtonStyle.secondary:
        return _ButtonStyleData(
          backgroundColor: Colors.grey.shade600,
          foregroundColor: Colors.white,
          disabledColor: Colors.grey.shade400,
          elevation: 2,
          borderRadius: 8,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        );
      case ActionButtonStyle.danger:
        return _ButtonStyleData(
          backgroundColor: Colors.red.shade600,
          foregroundColor: Colors.white,
          disabledColor: Colors.grey.shade400,
          elevation: 2,
          borderRadius: 8,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        );
      case ActionButtonStyle.success:
        return _ButtonStyleData(
          backgroundColor: Colors.green.shade600,
          foregroundColor: Colors.white,
          disabledColor: Colors.grey.shade400,
          elevation: 2,
          borderRadius: 8,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        );
      case ActionButtonStyle.warning:
        return _ButtonStyleData(
          backgroundColor: Colors.orange.shade600,
          foregroundColor: Colors.white,
          disabledColor: Colors.grey.shade400,
          elevation: 2,
          borderRadius: 8,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        );
      case ActionButtonStyle.outline:
        return _ButtonStyleData(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.blue.shade600,
          disabledColor: Colors.grey.shade400,
          elevation: 0,
          borderRadius: 8,
          fontSize: 16,
          fontWeight: FontWeight.w600,
          borderSide: BorderSide(color: Colors.blue.shade600, width: 2),
        );
      case ActionButtonStyle.zombie:
        return _ButtonStyleData(
          backgroundColor: Colors.red.shade800,
          foregroundColor: Colors.white,
          disabledColor: Colors.grey.shade400,
          elevation: 4,
          borderRadius: 6,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        );
      case ActionButtonStyle.survival:
        return _ButtonStyleData(
          backgroundColor: Colors.brown.shade700,
          foregroundColor: Colors.white,
          disabledColor: Colors.grey.shade400,
          elevation: 3,
          borderRadius: 8,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        );
    }
  }
}

class GameActionButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData icon;
  final Color? color;
  final bool requiresAction;
  final int actionCost;

  const GameActionButton({
    super.key,
    required this.text,
    required this.icon,
    this.onPressed,
    this.color,
    this.requiresAction = true,
    this.actionCost = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ActionButton(
        text: requiresAction ? '$text (${actionCost}AP)' : text,
        icon: icon,
        onPressed: onPressed,
        style: color != null ? ActionButtonStyle.primary : ActionButtonStyle.survival,
        width: double.infinity,
      ),
    );
  }
}

class QuickActionBar extends StatelessWidget {
  final List<QuickAction> actions;
  final bool isCompact;

  const QuickActionBar({
    super.key,
    required this.actions,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isCompact) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.7),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: actions.map((action) => 
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: IconButton(
                icon: Icon(action.icon, size: 20),
                onPressed: action.onPressed,
                color: action.color ?? Colors.white,
                tooltip: action.label,
              ),
            ),
          ).toList(),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.8),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: actions.map((action) => 
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: ActionButton(
              text: action.label,
              icon: action.icon,
              onPressed: action.onPressed,
              style: ActionButtonStyle.secondary,
              width: double.infinity,
            ),
          ),
        ).toList(),
      ),
    );
  }
}

class QuickAction {
  final String label;
  final IconData icon;
  final VoidCallback? onPressed;
  final Color? color;

  const QuickAction({
    required this.label,
    required this.icon,
    this.onPressed,
    this.color,
  });
}

enum ActionButtonStyle {
  primary,
  secondary,
  danger,
  success,
  warning,
  outline,
  zombie,
  survival,
}

class _ButtonStyleData {
  final Color backgroundColor;
  final Color foregroundColor;
  final Color disabledColor;
  final double elevation;
  final double borderRadius;
  final double fontSize;
  final FontWeight fontWeight;
  final BorderSide? borderSide;

  _ButtonStyleData({
    required this.backgroundColor,
    required this.foregroundColor,
    required this.disabledColor,
    required this.elevation,
    required this.borderRadius,
    required this.fontSize,
    required this.fontWeight,
    this.borderSide,
  });
}