import 'package:flutter/material.dart';
import '../models/book.dart';

class BookDetailScreen extends StatelessWidget {
  final Book book;

  const BookDetailScreen({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Buku Zaza'),
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.book, color: Colors.brown, size: 32),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            book.judul,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.brown,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildDetailRow(Icons.person, 'Penulis', book.penulis),
                    _buildDetailRow(Icons.business, 'Penerbit', book.penerbit),
                    _buildDetailRow(Icons.attach_money, 'Harga', 'Rp ${book.harga}'),
                    _buildDetailRow(Icons.numbers, 'Jumlah', book.jumlah.toString()),
                    _buildDetailRow(Icons.format_list_numbered, 'Volume', book.volume.toString()),
                    _buildDetailRow(Icons.calendar_today, 'Tanggal Masuk', book.tanggalMasuk),
                    if (book.createdAt != null)
                      _buildDetailRow(Icons.access_time, 'Dibuat', book.createdAt!),
                    if (book.updatedAt != null)
                      _buildDetailRow(Icons.update, 'Diupdate', book.updatedAt!),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.brown, size: 20),
          const SizedBox(width: 8),
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.brown,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}