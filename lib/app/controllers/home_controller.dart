import 'package:nylo_framework/nylo_framework.dart';
import 'controller.dart';

class HomeController extends Controller {
  onTapDocumentation() async {
    await openUrl("https://nylo.dev/docs");
  }

  onTapGithub() async {
    await openUrl("https://github.com/nylo-core/nylo");
  }

  onTapChangeLog() async {
    await openUrl("https://github.com/nylo-core/nylo/releases");
  }

  onTapYouTube() async {
    await openUrl("https://m.youtube.com/@nylo_dev");
  }

  onTapX() async {
    await openUrl("https://x.com/nylo_dev");
  }
}
