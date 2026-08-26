class ImageUrl {

  // ✅ Fix #3: Helper to replace localhost with actual IP
 static String fixImageUrl(String url) {
    return url
        .replaceAll(
      'http://localhost:5000',
      'https://omnigo-app-backend-production.up.railway.app',
    )
        .replaceAll(
      'http://192.168.100.69:5000',
      'https://omnigo-app-backend-production.up.railway.app',
    );
  }
}