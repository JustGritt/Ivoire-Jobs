import 'package:barassage_app/features/profile_mod/widgets/become_barasseur_info.dart';
import 'package:barassage_app/core/helpers/constants_helper.dart';
import 'package:animate_gradient/animate_gradient.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BecomeBarasseurScreen extends StatefulWidget {
  const BecomeBarasseurScreen({super.key});

  @override
  State<BecomeBarasseurScreen> createState() => _BecomeBarasseurScreenState();
}

class _BecomeBarasseurScreenState extends State<BecomeBarasseurScreen>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    List<Color> IVORYCOAST_COLORS_SHUFFLED = IVORYCOAST_COLORS.toList();
    IVORYCOAST_COLORS_SHUFFLED.shuffle();

    Size size = MediaQuery.of(context).size;

    AnimationController? _controller = null;

    @override
    void initState() {
      super.initState();
      _controller = AnimationController(vsync: this);
    }

    @override
    void dispose() {
      _controller?.dispose();
      super.dispose();
    }

    return CupertinoPageScaffold(
        child: AnimateGradient(
      controller: _controller,
      primaryColors: IVORYCOAST_COLORS_SHUFFLED,
      secondaryColors: IVORYCOAST_COLORS,
      child: SizedBox(
        height: size.height,
        width: size.width,
        child: Stack(
          alignment: Alignment.center,
          children: [
            AnimateGradient(
              controller: _controller,
              primaryEnd: Alignment.bottomLeft,
              secondaryEnd: Alignment.topRight,
              primaryColors: IVORYCOAST_COLORS,
              secondaryColors: IVORYCOAST_COLORS_SHUFFLED,
            ),
            Positioned(
              child: BecomeBarasseurInfo(),
            )
          ],
        ),
      ),
    ));
  }
}
