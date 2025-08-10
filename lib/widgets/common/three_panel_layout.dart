import 'package:flutter/material.dart';
import '../../utils/responsive.dart';

class ThreePanelLayout extends StatelessWidget {
  final String flavorText;
  final Widget centerContent;
  final List<NavigationAction> actions;
  final String? backgroundImage;
  final String? leftPanelTitle;
  final Widget? leftPanelContent;

  const ThreePanelLayout({
    super.key,
    required this.flavorText,
    required this.centerContent,
    required this.actions,
    this.backgroundImage,
    this.leftPanelTitle,
    this.leftPanelContent,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: backgroundImage != null
              ? DecorationImage(
                  image: AssetImage(backgroundImage!),
                  fit: BoxFit.cover,
                )
              : null,
          color: backgroundImage == null ? const Color(0xFF2D2D2D) : null,
        ),
        child: SafeArea(
          child: Row(
            children: [
              // Left Panel - Flavor Text or Custom Content
              Expanded(
                flex: 2,
                child: leftPanelContent ?? _FlavorTextPanel(text: flavorText, title: leftPanelTitle),
              ),
              // Center Panel - Main Content
              Expanded(
                flex: 3,
                child: _CenterContentPanel(child: centerContent),
              ),
              // Right Panel - Navigation Actions
              Expanded(
                flex: 2,
                child: _NavigationPanel(actions: actions),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FlavorTextPanel extends StatelessWidget {
  final String text;
  final String? title;

  const _FlavorTextPanel({required this.text, this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF8B6914),
          width: 3,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            offset: const Offset(2, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF8B6914).withOpacity(0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                title ?? 'STORY',
                style: TextStyle(
                  color: const Color(0xFFDAA520),
                  fontSize: ResponsiveHelper.getFontSize(context, baseFontSize: 14),
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  text,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: ResponsiveHelper.getFontSize(context, baseFontSize: 12),
                    height: 1.4,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CenterContentPanel extends StatelessWidget {
  final Widget child;

  const _CenterContentPanel({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFF1A3A5C).withOpacity(0.9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF8B6914),
          width: 3,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            offset: const Offset(2, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(9),
        child: child,
      ),
    );
  }
}

class _NavigationPanel extends StatelessWidget {
  final List<NavigationAction> actions;

  const _NavigationPanel({required this.actions});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF8B6914),
          width: 3,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            offset: const Offset(2, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF8B6914).withOpacity(0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'ACTIONS',
                style: TextStyle(
                  color: const Color(0xFFDAA520),
                  fontSize: ResponsiveHelper.getFontSize(context, baseFontSize: 14),
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.separated(
                itemCount: actions.length,
                separatorBuilder: (context, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final action = actions[index];
                  return _ActionButton(
                    action: action,
                    context: context,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final NavigationAction action;
  final BuildContext context;

  const _ActionButton({
    required this.action,
    required this.context,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: ResponsiveHelper.getButtonHeight(context),
      child: ElevatedButton(
        onPressed: action.isEnabled ? action.onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: action.isEnabled
              ? const Color(0xFF2D5A2D)
              : Colors.grey.shade600,
          foregroundColor: action.isEnabled ? Colors.white : Colors.grey.shade400,
          disabledBackgroundColor: Colors.grey.shade600,
          disabledForegroundColor: Colors.grey.shade400,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(
              color: action.isEnabled
                  ? const Color(0xFF8B6914)
                  : Colors.grey.shade500,
              width: 2,
            ),
          ),
          elevation: action.isEnabled ? 3 : 1,
          shadowColor: Colors.black.withOpacity(0.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (action.icon != null) ...[
              Icon(
                action.icon,
                size: ResponsiveHelper.getIconSize(context, baseSize: 18),
              ),
              const SizedBox(width: 8),
            ],
            Flexible(
              child: Text(
                action.title,
                style: TextStyle(
                  fontSize: ResponsiveHelper.getFontSize(context, baseFontSize: 12),
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NavigationAction {
  final String title;
  final VoidCallback onPressed;
  final IconData? icon;
  final bool isEnabled;

  const NavigationAction({
    required this.title,
    required this.onPressed,
    this.icon,
    this.isEnabled = true,
  });
}