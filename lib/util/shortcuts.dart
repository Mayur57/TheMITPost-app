import 'package:quick_actions/quick_actions.dart';

class AppShortcuts {
  static final noticeAction = const ShortcutItem(
    type: "notice",
    localizedTitle: "Notices",
    icon: "icon_notice",
  );

  static final slcmAction = const ShortcutItem(
    type: "slcm",
    localizedTitle: "SLCM",
    icon: "icon_slcm",
  );

  static final shortcuts = <ShortcutItem>[
    noticeAction,
    slcmAction,
  ];
}
