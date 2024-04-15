class Orders {
  final String orderId;
  final String userId;
  final List<dynamic> items;
  final String status;
  final DateTime timeStamp;
  final double totalAmount;
  final String name;

  Orders({
    required this.orderId,
    required this.userId,
    required this.items,
    required this.status,
    required this.timeStamp,
    required this.totalAmount,
    required this.name,
  });
}
