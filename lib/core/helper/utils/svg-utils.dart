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
