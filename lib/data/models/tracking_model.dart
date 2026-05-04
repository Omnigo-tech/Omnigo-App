class TrackingModel {
  final String status;
  final String estimatedTime;
  final String deliveryHeroName;
  final String deliveryHeroImage;
  final String storeName;
  final String storeAddress;
  final String destinationAddress;
  final double progress;
  final String phonenumber;// 0.0 to 1.0

  TrackingModel({
    required this.status,
    required this.estimatedTime,
    required this.deliveryHeroName,
    required this.deliveryHeroImage,
    required this.storeName,
    required this.storeAddress,
    required this.destinationAddress,
    required this.progress,
    required this.phonenumber,
  });

  factory TrackingModel.mock() {
    return TrackingModel(
      status: "On the way",
      estimatedTime: "10 Min",
      deliveryHeroName: "Abdulmalik Qasim",
      deliveryHeroImage: "assets/images/delivery_hero.png", // Make sure this exists or use a placeholder
      storeName: "Grocery Store",
      storeAddress: "Store Location Details",
      destinationAddress: "Queen Road Karachi",
      progress: 0.4,
      phonenumber: "03125214609"
    );
  }
}
