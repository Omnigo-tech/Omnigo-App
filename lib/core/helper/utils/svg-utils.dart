import 'package:flutter_svg/flutter_svg.dart';
import '../constants/images-resources.dart';

class SvgUtils {
  static List<SvgAssetLoader> svgAssets = [
    const SvgAssetLoader(ImageResource.ICON_EMAIL),
    const SvgAssetLoader(ImageResource.ICON_FAVOURITE),
    const SvgAssetLoader(ImageResource.ICON_HOME),
    const SvgAssetLoader(ImageResource.ICON_ORDER),
    const SvgAssetLoader(ImageResource.ICON_USER),
    const SvgAssetLoader(ImageResource.FORWARD_ICON),
    const SvgAssetLoader(ImageResource.BACK_ICON),
    const SvgAssetLoader(ImageResource.FILTER_ICON),
    const SvgAssetLoader(ImageResource.BYKE_ICON),
    const SvgAssetLoader(ImageResource.CALL_ICON),
    const SvgAssetLoader(ImageResource.MESSAGE_ICON),
    const SvgAssetLoader(ImageResource.CLOCK_ICON),
    const SvgAssetLoader(ImageResource.LOCATION_ICON),
    const SvgAssetLoader(ImageResource.HOME_DELIVERED_ICON),
    const SvgAssetLoader(ImageResource.STORE_ICON),

  ];

  static Future<void> preCacheSVGs() async {
    for (var icons in svgAssets) {
      await svg.cache.putIfAbsent(
        icons.cacheKey(null),
            () => icons.loadBytes(null),
      );
    }
  }
}
