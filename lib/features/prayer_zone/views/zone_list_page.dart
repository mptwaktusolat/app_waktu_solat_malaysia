import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../../../l10n/app_localizations.dart';
import '../../../location_utils/location_database.dart';
import '../../../providers/location_provider.dart';
import '../../../shared/models/jakim_zones.dart';
import 'components/location_bubble_widget.dart';

/// A page that shows available prayer time zones.
/// This file is modified from the framework's about.dart (/flutter/packages/flutter/lib/src/material/about.dart)
class ZoneListPage extends StatefulWidget {
  const ZoneListPage({super.key});

  @override
  State<ZoneListPage> createState() => _ZoneListPageState();
}

class _ZoneListPageState extends State<ZoneListPage> {
  final ValueNotifier<int?> selectedId = ValueNotifier<int?>(null);

  @override
  void dispose() {
    selectedId.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _MasterDetailFlow(
      detailPageFABlessGutterWidth: _getGutterSize(context),
      title: Text(AppLocalizations.of(context)!.zoneManualSelectZone),
      detailPageBuilder: _prayerZonesPage,
      masterViewBuilder: _prayerZonesView,
    );
  }

  Widget _prayerZonesPage(
      BuildContext _, Object? args, ScrollController? scrollController) {
    final _DetailArguments detailArguments = args! as _DetailArguments;
    return _PrayerZonesPage(
      negeriName: detailArguments.packageName,
      zoneEntries: detailArguments.daerahEntries,
      scrollController: scrollController,
    );
  }

  Widget _prayerZonesView(final BuildContext _, final bool isLateral) {
    return _PrayerZonesView(isLateral: isLateral, selectedId: selectedId);
  }
}

class _PrayerZonesView extends StatefulWidget {
  const _PrayerZonesView({required this.isLateral, required this.selectedId});

  final bool isLateral;
  final ValueNotifier<int?> selectedId;

  @override
  _PrayerZonesViewState createState() => _PrayerZonesViewState();
}

class _PrayerZonesViewState extends State<_PrayerZonesView> {
  final allZones = LocationDatabase.allLocation;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return ValueListenableBuilder<int?>(
          valueListenable: widget.selectedId,
          builder: (BuildContext context, int? selectedId, Widget? _) {
            return Center(
              child: Material(
                color: Theme.of(context).cardColor,
                elevation: 4.0,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 600.0),
                  child: _negeriList(
                    context,
                    selectedId,
                    allZones,
                    widget.isLateral,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _negeriList(
    final BuildContext context,
    final int? selectedId,
    final List<JakimZones> data,
    final bool drawSelection,
  ) {
    final negeriNameList = data.map((e) => e.negeri).toSet().toList()
      ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
    return ListView.builder(
      itemCount: negeriNameList.length,
      itemBuilder: (BuildContext context, int index) {
        final String negeriName = negeriNameList[index];
        final List<JakimZones> daerahList = data
            .where((element) => element.negeri == negeriName)
            .toList(growable: false);
        return _PrayerZoneListTile(
          packageName: negeriName,
          index: index,
          isSelected: drawSelection && index == (selectedId ?? 0),
          onTap: () {
            widget.selectedId.value = index;
            _MasterDetailFlow.of(context).openDetailPage(
              _DetailArguments(
                negeriName,
                daerahList,
              ),
            );
          },
        );
      },
    );
  }
}

class _PrayerZoneListTile extends StatelessWidget {
  const _PrayerZoneListTile({
    required this.packageName,
    this.index,
    required this.isSelected,
    this.onTap,
  });

  final String packageName;
  final int? index;
  final bool isSelected;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Ink(
      color: isSelected
          ? Theme.of(context).highlightColor
          : Theme.of(context).cardColor,
      child: ListTile(
        title: Text(packageName),
        selected: isSelected,
        onTap: onTap,
      ),
    );
  }
}

class _PrayerZonesPage extends StatefulWidget {
  const _PrayerZonesPage({
    required this.negeriName,
    required this.zoneEntries,
    required this.scrollController,
  });

  final String negeriName;
  final List<JakimZones> zoneEntries;
  final ScrollController? scrollController;

  @override
  _PrayerZonesPageState createState() => _PrayerZonesPageState();
}

class _PrayerZonesPageState extends State<_PrayerZonesPage> {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final String title = widget.negeriName;
    final double pad = _getGutterSize(context);
    final EdgeInsets padding =
        EdgeInsets.only(left: pad, right: pad, bottom: pad);

    // Build the list of widgets dynamically using Consumer
    final List<Widget> listWidgets = <Widget>[
      Consumer<LocationProvider>(
        builder: (context, locationProvider, child) {
          final jakimCode = locationProvider.currentLocationCode;
          return Column(
            children: widget.zoneEntries.map((JakimZones jakimZone) {
              return ListTile(
                selected: jakimZone.jakimCode == jakimCode,
                leading: LocationBubbleWidget(
                  jakimZone.jakimCode,
                  isSelected: jakimZone.jakimCode == jakimCode,
                ),
                title: Text(jakimZone.daerah),
                onTap: () {
                  locationProvider.currentLocationCode = jakimZone.jakimCode;
                  Fluttertoast.showToast(
                      msg: AppLocalizations.of(context)!
                          .zoneUpdatedSuccess(jakimZone.daerah));
                },
              );
            }).toList(),
          );
        },
      ),
    ];

    final Widget page;
    if (widget.scrollController == null) {
      page = Scaffold(
        appBar: AppBar(
          title: _PrayerZonePageTitle(
            title: title,
            theme:
                theme.useMaterial3 ? theme.textTheme : theme.primaryTextTheme,
            titleTextStyle: theme.appBarTheme.titleTextStyle,
            foregroundColor: theme.appBarTheme.foregroundColor,
          ),
        ),
        body: Center(
          child: Material(
            color: theme.cardColor,
            elevation: 4.0,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600.0),
              child: ScrollConfiguration(
                // A Scrollbar is built-in below.
                behavior:
                    ScrollConfiguration.of(context).copyWith(scrollbars: false),
                child: Scrollbar(
                  child: ListView(
                      primary: true, padding: padding, children: listWidgets),
                ),
              ),
            ),
          ),
        ),
      );
    } else {
      page = CustomScrollView(
        controller: widget.scrollController,
        slivers: <Widget>[
          SliverAppBar(
            automaticallyImplyLeading: false,
            pinned: true,
            backgroundColor: theme.cardColor,
            title: _PrayerZonePageTitle(
              title: title,
              theme: theme.textTheme,
              titleTextStyle: theme.textTheme.titleLarge,
            ),
          ),
          SliverPadding(
            padding: padding,
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) => listWidgets[index],
                childCount: listWidgets.length,
              ),
            ),
          ),
        ],
      );
    }
    return DefaultTextStyle(style: theme.textTheme.bodySmall!, child: page);
  }
}

class _PrayerZonePageTitle extends StatelessWidget {
  const _PrayerZonePageTitle({
    required this.title,
    required this.theme,
    this.titleTextStyle,
    this.foregroundColor,
  });

  final String title;
  final TextTheme theme;
  final TextStyle? titleTextStyle;
  final Color? foregroundColor;

  @override
  Widget build(BuildContext context) {
    final TextStyle? effectiveTitleTextStyle =
        titleTextStyle ?? theme.titleLarge;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(title,
            style: effectiveTitleTextStyle?.copyWith(color: foregroundColor)),
      ],
    );
  }
}

const int _materialGutterThreshold = 720;
const double _wideGutterSize = 24.0;
const double _narrowGutterSize = 12.0;

double _getGutterSize(BuildContext context) =>
    MediaQuery.widthOf(context) >= _materialGutterThreshold
        ? _wideGutterSize
        : _narrowGutterSize;

/// Signature for the builder callback used by [_MasterDetailFlow].
typedef _MasterViewBuilder = Widget Function(
    BuildContext context, bool isLateralUI);

/// Signature for the builder callback used by [_MasterDetailFlow.detailPageBuilder].
///
/// scrollController is provided when the page destination is the draggable
/// sheet in the lateral UI. Otherwise, it is null.
typedef _DetailPageBuilder = Widget Function(BuildContext context,
    Object? arguments, ScrollController? scrollController);

/// Signature for the builder callback used by [_MasterDetailScaffold.actionBuilder].
///
/// Builds the actions that go in the app bars constructed for the master and
/// lateral UI pages. actionLevel indicates the intended destination of the
/// return actions.
typedef _ActionBuilder = List<Widget> Function(
    BuildContext context, _ActionLevel actionLevel);

/// Describes which type of app bar the actions are intended for.
enum _ActionLevel {
  /// Indicates the top app bar in the lateral UI.
  top,

  /// Indicates the master view app bar in the lateral UI.
  view,
}

/// Describes which layout will be used by [_MasterDetailFlow].
enum _LayoutMode {
  /// Always use a lateral layout.
  lateral,

  /// Always use a nested layout.
  nested,
}

const String _navMaster = 'master';
const String _navDetail = 'detail';

enum _Focus { master, detail }

/// A Master Detail Flow widget. Depending on screen width it builds either a
/// lateral or nested navigation flow between a master view and a detail page.
///
/// If focus is on detail view, then switching to nested navigation will
/// populate the navigation history with the master page and the detail page on
/// top. Otherwise the focus is on the master view and just the master page
/// is shown.
class _MasterDetailFlow extends StatefulWidget {
  /// Creates a master detail navigation flow which is either nested or
  /// lateral depending on screen width.
  const _MasterDetailFlow({
    required this.detailPageBuilder,
    required this.masterViewBuilder,
    this.detailPageFABlessGutterWidth,
    this.title,
  });

  /// Builder for the master view for lateral navigation.
  ///
  /// This builder builds the master page required for nested navigation, also
  /// builds the master view inside a [Scaffold] with an [AppBar].
  final _MasterViewBuilder masterViewBuilder;

  /// Builder for the detail page.
  ///
  /// If scrollController == null, the page is intended for nested navigation. The lateral detail
  /// page is inside a [DraggableScrollableSheet] and should have a scrollable element that uses
  /// the [ScrollController] provided. In fact, it is strongly recommended the entire lateral
  /// page is scrollable.
  final _DetailPageBuilder detailPageBuilder;

  /// Override the width of the gutter when there is no floating action button.
  final double? detailPageFABlessGutterWidth;

  /// The title for the lateral UI [AppBar].
  ///
  /// See [AppBar.title].
  final Widget? title;

  @override
  _MasterDetailFlowState createState() => _MasterDetailFlowState();

  // The master detail flow proxy from the closest instance of this class that encloses the given
  // context.
  //
  // Typical usage is as follows:
  //
  // ```dart
  // _MasterDetailFlow.of(context).openDetailPage(arguments);
  // ```
  static _MasterDetailFlowProxy of(BuildContext context) {
    _PageOpener? pageOpener =
        context.findAncestorStateOfType<_MasterDetailScaffoldState>();
    pageOpener ??= context.findAncestorStateOfType<_MasterDetailFlowState>();
    assert(() {
      if (pageOpener == null) {
        throw FlutterError(
          'Master Detail operation requested with a context that does not include a Master Detail '
          'Flow.\nThe context used to open a detail page from the Master Detail Flow must be '
          'that of a widget that is a descendant of a Master Detail Flow widget.',
        );
      }
      return true;
    }());
    return _MasterDetailFlowProxy._(pageOpener!);
  }
}

/// Interface for interacting with the [_MasterDetailFlow].
class _MasterDetailFlowProxy implements _PageOpener {
  _MasterDetailFlowProxy._(this._pageOpener);

  final _PageOpener _pageOpener;

  /// Open detail page with arguments.
  @override
  void openDetailPage(Object arguments) =>
      _pageOpener.openDetailPage(arguments);

  /// Set the initial page to be open for the lateral layout. This can be set at any time, but
  /// will have no effect after any calls to openDetailPage.
  @override
  void setInitialDetailPage(Object arguments) =>
      _pageOpener.setInitialDetailPage(arguments);
}

abstract class _PageOpener {
  void openDetailPage(Object arguments);

  void setInitialDetailPage(Object arguments);
}

const int _materialWideDisplayThreshold = 840;

class _MasterDetailFlowState extends State<_MasterDetailFlow>
    implements _PageOpener {
  /// Tracks whether focus is on the detail or master views. Determines behavior when switching
  /// from lateral to nested navigation.
  _Focus focus = _Focus.master;

  /// Cache of arguments passed when opening a detail page. Used when rebuilding.
  Object? _cachedDetailArguments;

  /// Record of the layout that was built.
  _LayoutMode? _builtLayout;

  /// Key to access navigator in the nested layout.
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void openDetailPage(Object arguments) {
    _cachedDetailArguments = arguments;
    switch (_builtLayout) {
      case _LayoutMode.nested:
        _navigatorKey.currentState!.pushNamed(_navDetail, arguments: arguments);
      case _LayoutMode.lateral || null:
        focus = _Focus.detail;
    }
  }

  @override
  void setInitialDetailPage(Object arguments) {
    _cachedDetailArguments = arguments;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double availableWidth = constraints.maxWidth;
        if (availableWidth >= _materialWideDisplayThreshold) {
          return _lateralUI(context);
        }
        return _nestedUI(context);
      },
    );
  }

  Widget _nestedUI(BuildContext context) {
    _builtLayout = _LayoutMode.nested;
    final MaterialPageRoute<void> masterPageRoute = _masterPageRoute(context);

    return NavigatorPopHandler(
      onPop: () {
        _navigatorKey.currentState!.maybePop();
      },
      child: Navigator(
        key: _navigatorKey,
        initialRoute: 'initial',
        onGenerateInitialRoutes:
            (NavigatorState navigator, String initialRoute) {
          return switch (focus) {
            _Focus.master => <Route<void>>[masterPageRoute],
            _Focus.detail => <Route<void>>[
                masterPageRoute,
                _detailPageRoute(_cachedDetailArguments),
              ],
          };
        },
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case _navMaster:
              // Matching state to navigation event.
              focus = _Focus.master;
              return masterPageRoute;
            case _navDetail:
              // Matching state to navigation event.
              focus = _Focus.detail;
              // Cache detail page settings.
              _cachedDetailArguments = settings.arguments;
              return _detailPageRoute(_cachedDetailArguments);
            default:
              throw Exception('Unknown route ${settings.name}');
          }
        },
      ),
    );
  }

  MaterialPageRoute<void> _masterPageRoute(BuildContext context) {
    return MaterialPageRoute<dynamic>(
      builder: (BuildContext c) {
        return BlockSemantics(
          child: _MasterPage(
            leading: Navigator.of(context).canPop()
                ? BackButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                : null,
            title: widget.title,
            masterViewBuilder: widget.masterViewBuilder,
          ),
        );
      },
    );
  }

  MaterialPageRoute<void> _detailPageRoute(Object? arguments) {
    return MaterialPageRoute<void>(
      builder: (BuildContext context) {
        return PopScope<void>(
          onPopInvokedWithResult: (bool didPop, void result) {
            // No need for setState() as rebuild happens on navigation pop.
            focus = _Focus.master;
          },
          child: BlockSemantics(
              child: widget.detailPageBuilder(context, arguments, null)),
        );
      },
    );
  }

  Widget _lateralUI(BuildContext context) {
    _builtLayout = _LayoutMode.lateral;
    return _MasterDetailScaffold(
      actionBuilder: (_, __) => const <Widget>[],
      detailPageBuilder: (BuildContext context, Object? args,
              ScrollController? scrollController) =>
          widget.detailPageBuilder(
              context, args ?? _cachedDetailArguments, scrollController),
      detailPageFABlessGutterWidth: widget.detailPageFABlessGutterWidth,
      initialArguments: _cachedDetailArguments,
      masterViewBuilder: (BuildContext context, bool isLateral) =>
          widget.masterViewBuilder(context, isLateral),
      title: widget.title,
    );
  }
}

class _MasterPage extends StatelessWidget {
  const _MasterPage({this.leading, this.title, this.masterViewBuilder});

  final _MasterViewBuilder? masterViewBuilder;
  final Widget? title;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: title, leading: leading, actions: const <Widget>[]),
      body: masterViewBuilder!(context, false),
    );
  }
}

const double _kCardElevation = 4.0;
const double _kMasterViewWidth = 320.0;
const double _kDetailPageFABlessGutterWidth = 40.0;
const double _kDetailPageFABGutterWidth = 84.0;

class _MasterDetailScaffold extends StatefulWidget {
  const _MasterDetailScaffold({
    required this.detailPageBuilder,
    required this.masterViewBuilder,
    this.actionBuilder,
    this.initialArguments,
    this.title,
    this.detailPageFABlessGutterWidth,
  });

  final _MasterViewBuilder masterViewBuilder;

  /// Builder for the detail page.
  ///
  /// The detail page is inside a [DraggableScrollableSheet] and should have a scrollable element
  /// that uses the [ScrollController] provided. In fact, it is strongly recommended the entire
  /// lateral page is scrollable.
  final _DetailPageBuilder detailPageBuilder;
  final _ActionBuilder? actionBuilder;
  final Object? initialArguments;
  final Widget? title;
  final double? detailPageFABlessGutterWidth;

  @override
  _MasterDetailScaffoldState createState() => _MasterDetailScaffoldState();
}

class _MasterDetailScaffoldState extends State<_MasterDetailScaffold>
    implements _PageOpener {
  late FloatingActionButtonLocation floatingActionButtonLocation;
  late double detailPageFABGutterWidth;
  late double detailPageFABlessGutterWidth;
  late double masterViewWidth;

  final ValueNotifier<Object?> _detailArguments = ValueNotifier<Object?>(null);

  @override
  void initState() {
    super.initState();
    detailPageFABlessGutterWidth =
        widget.detailPageFABlessGutterWidth ?? _kDetailPageFABlessGutterWidth;
    detailPageFABGutterWidth = _kDetailPageFABGutterWidth;
    masterViewWidth = _kMasterViewWidth;
    floatingActionButtonLocation = FloatingActionButtonLocation.endTop;
  }

  @override
  void dispose() {
    _detailArguments.dispose();
    super.dispose();
  }

  @override
  void openDetailPage(Object arguments) {
    SchedulerBinding.instance
        .addPostFrameCallback((_) => _detailArguments.value = arguments);
    _MasterDetailFlow.of(context).openDetailPage(arguments);
  }

  @override
  void setInitialDetailPage(Object arguments) {
    SchedulerBinding.instance
        .addPostFrameCallback((_) => _detailArguments.value = arguments);
    _MasterDetailFlow.of(context).setInitialDetailPage(arguments);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Scaffold(
          floatingActionButtonLocation: floatingActionButtonLocation,
          appBar: AppBar(
            title: widget.title,
            actions: widget.actionBuilder!(context, _ActionLevel.top),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(kToolbarHeight),
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: masterViewWidth,
                    child: IconTheme(
                      data: Theme.of(context).primaryIconTheme,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Align(
                          alignment: AlignmentDirectional.centerEnd,
                          child: OverflowBar(
                            spacing: 8,
                            overflowAlignment: OverflowBarAlignment.end,
                            children: widget.actionBuilder!(
                                context, _ActionLevel.view),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          body: Align(
              alignment: AlignmentDirectional.centerStart,
              child: _masterPanel(context)),
        ),
        // Detail view stacked above main scaffold and master view.
        SafeArea(
          child: Padding(
            padding: EdgeInsetsDirectional.only(
              start: masterViewWidth - _kCardElevation,
              end: detailPageFABlessGutterWidth,
            ),
            child: ValueListenableBuilder<Object?>(
              valueListenable: _detailArguments,
              builder: (BuildContext context, Object? value, Widget? child) {
                return AnimatedSwitcher(
                  transitionBuilder:
                      (Widget child, Animation<double> animation) =>
                          const FadeUpwardsPageTransitionsBuilder()
                              .buildTransitions<void>(
                    null,
                    null,
                    animation,
                    null,
                    child,
                  ),
                  duration: const Duration(milliseconds: 500),
                  child: SizedBox.expand(
                    key: ValueKey<Object?>(value ?? widget.initialArguments),
                    child: _DetailView(
                      builder: widget.detailPageBuilder,
                      arguments: value ?? widget.initialArguments,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  ConstrainedBox _masterPanel(BuildContext context,
      {bool needsScaffold = false}) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: masterViewWidth),
      child: needsScaffold
          ? Scaffold(
              appBar: AppBar(
                title: widget.title,
                actions: widget.actionBuilder!(context, _ActionLevel.top),
              ),
              body: widget.masterViewBuilder(context, true),
            )
          : widget.masterViewBuilder(context, true),
    );
  }
}

class _DetailView extends StatelessWidget {
  const _DetailView({required _DetailPageBuilder builder, Object? arguments})
      : _builder = builder,
        _arguments = arguments;

  final _DetailPageBuilder _builder;
  final Object? _arguments;

  @override
  Widget build(BuildContext context) {
    if (_arguments == null) {
      return const SizedBox.shrink();
    }
    final double screenHeight = MediaQuery.heightOf(context);
    final double minHeight = (screenHeight - kToolbarHeight) / screenHeight;

    return DraggableScrollableSheet(
      initialChildSize: minHeight,
      minChildSize: minHeight,
      expand: false,
      builder: (BuildContext context, ScrollController controller) {
        return MouseRegion(
          // TODO(TonicArtos): Remove MouseRegion workaround for pointer hover events passing through DraggableScrollableSheet once https://github.com/flutter/flutter/issues/59741 is resolved.
          child: Card(
            color: Theme.of(context).cardColor,
            elevation: _kCardElevation,
            clipBehavior: Clip.antiAlias,
            margin: const EdgeInsets.fromLTRB(
                _kCardElevation, 0.0, _kCardElevation, 0.0),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(3.0)),
            ),
            child: _builder(context, _arguments, controller),
          ),
        );
      },
    );
  }
}

@immutable
class _DetailArguments {
  const _DetailArguments(this.packageName, this.daerahEntries);

  final String packageName;
  final List<JakimZones> daerahEntries;

  @override
  bool operator ==(final Object other) {
    if (other is _DetailArguments) {
      return other.packageName == packageName;
    }
    return other == this;
  }

  @override
  int get hashCode => Object.hash(packageName, Object.hashAll(daerahEntries));
}
