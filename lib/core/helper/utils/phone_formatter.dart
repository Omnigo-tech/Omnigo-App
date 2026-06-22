class ImageUrl {

  // ✅ Fix #3: Helper to replace localhost with actual IP
static  String fixImageUrl(String url) {
    return url.replaceAll('localhost', '192.168.100.69');
  }
}