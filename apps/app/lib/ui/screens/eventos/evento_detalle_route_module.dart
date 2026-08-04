import 'package:router_core/router_core.dart';

import '../../routing/app_route.dart';
import 'evento_detalle_page.dart';

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
