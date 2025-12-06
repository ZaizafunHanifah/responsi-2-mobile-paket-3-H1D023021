class Book {
  int? id;
  String judul;
  int harga;
  int jumlah;
  String tanggalMasuk;
  int volume;
  String penulis;
  String penerbit;
  String? createdAt;
  String? updatedAt;

  Book({
    this.id,
    required this.judul,
    required this.harga,
    this.jumlah = 0,
    required this.tanggalMasuk,
    this.volume = 0,
    this.penulis = '',
    this.penerbit = '',
    this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'judul': judul,
      'harga': harga,
      'jumlah': jumlah,
      'tanggal_masuk': tanggalMasuk,
      'volume': volume,
      'penulis': penulis,
      'penerbit': penerbit,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'] != null ? int.tryParse(json['id'].toString()) : null,
      judul: json['judul'],
      harga: json['harga'] != null ? int.tryParse(json['harga'].toString()) ?? 0 : 0,
      jumlah: json['jumlah'] != null ? int.tryParse(json['jumlah'].toString()) ?? 0 : 0,
      tanggalMasuk: json['tanggal_masuk'],
      volume: json['volume'] != null ? int.tryParse(json['volume'].toString()) ?? 0 : 0,
      penulis: json['penulis'],
      penerbit: json['penerbit'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}

class BookResponse {
  String status;
  String? message;
  List<Book>? data;
  Book? singleData;

  BookResponse({
    required this.status,
    this.message,
    this.data,
    this.singleData,
  });

  factory BookResponse.fromJson(Map<String, dynamic> json) {
    return BookResponse(
      status: json['status'],
      message: json['message'],
      data: json['data'] != null
          ? List<Book>.from(json['data'].map((x) => Book.fromJson(x)))
          : null,
      singleData: json['data'] != null && json['data'] is Map
          ? Book.fromJson(json['data'])
          : null,
    );
  }
}