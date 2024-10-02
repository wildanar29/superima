class PoliKlinik {
  final String serviceUnitID;
  final String serviceUnitName;
  // final String type; // Tambahkan properti 'type'

  PoliKlinik({
    required this.serviceUnitID,
    required this.serviceUnitName,
    // required this.type, // Inisialisasi properti 'type'
  });

  factory PoliKlinik.fromJson(Map<String, dynamic> json) {
    return PoliKlinik(
      serviceUnitID: json['serviceunitid'] as String, // Field 'serviceunitid' dari API
      serviceUnitName: json['serviceunitname'] as String, // Field 'serviceunitname' dari API
      // type: json['type'] as String, // Field 'type' dari API
    );
  }
}
