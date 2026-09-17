import 'package:growth_flutter_fase_05_riverpood/ui/routing/app_route.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/screens/events/event_detail_page.dart';
import 'package:router_core/router_core.dart';

class EventDetailRouteModule implements IRouteModule {
  @override
  StatefulShellBranch? get branch => null;

  @override
  List<RouteBase> get rootRoutes => [
    GoRoute(
      path: AppRoute.eventDetail.path,
      name: 'event-detail',
      pageBuilder: (context, state) {
        final eventId = state.pathParameters['id'] ?? '';
        return AppBuildStackAnimationPage<AppRoute>(
          state: state,
          child: EventDetailPage(eventId: eventId),
          animationType: AnimationTransitionEnum.slideHorizontal,
          routeEnum: AppRoute.eventDetail,
        ).build();
      },
    ),
  ];
}
