class Orders {
  final List<Map<String, dynamic>> items;
  final String status;
  final DateTime timeStamp;
  final double totalAmount;
  final String userId;
  final String orderId;

  Orders({
    required this.orderId,
    required this.userId,
    required this.items,
    required this.status,
    required this.timeStamp,
    required this.totalAmount,
  });
}
