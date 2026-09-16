import 'package:growth_flutter_fase_05_riverpood/ui/routing/app_route.dart';
import 'package:growth_flutter_fase_05_riverpood/ui/screens/eventos/evento_detalle_page.dart';
import 'package:router_core/router_core.dart';

class EventoDetalleRouteModule implements IRouteModule {
  @override
  StatefulShellBranch? get branch => null;

  @override
  List<RouteBase> get rootRoutes => [
    GoRoute(
      path: AppRoute.eventoDetalle.path,
      name: 'evento-detalle',
      pageBuilder: (context, state) {
        final eventoId = state.pathParameters['id'] ?? '';
        return AppBuildStackAnimationPage<AppRoute>(
          state: state,
          child: EventoDetallePage(eventoId: eventoId),
          animationType: AnimationTransitionEnum.slideHorizontal,
          routeEnum: AppRoute.eventoDetalle,
        ).build();
      },
    ),
  ];
}
