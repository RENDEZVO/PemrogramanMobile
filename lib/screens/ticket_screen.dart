import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart'; // Import QR Generator
import 'package:google_fonts/google_fonts.dart';

class TicketScreen extends StatelessWidget {
  final Map<String, dynamic> bookingData;

  const TicketScreen({super.key, required this.bookingData});

  @override
  Widget build(BuildContext context) {
    // Ambil data biar kodingnya rapi
    final String bookingId = bookingData['booking_id'];
    final String destination = bookingData['destination_name'];
    final String capital = bookingData['destination_capital'];
    final String travelDate = bookingData['travel_date'];
    final String userName = bookingData['user_name'];
    final int tickets = bookingData['ticket_count'];

    // Format Tanggal Simpel
    DateTime date = DateTime.parse(travelDate);
    String dateStr = "${date.day}/${date.month}/${date.year}";
    String timeStr = "${date.hour}:${date.minute.toString().padLeft(2, '0')}";

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text("E-Ticket", style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // --- KARTU TIKET ---
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  children: [
                    // 1. HEADER (Gambar Destinasi)
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                      child: Image.network(
                        bookingData['image_url'],
                        height: 150,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (ctx, err, stack) => 
                            Container(height: 150, color: Colors.grey),
                      ),
                    ),
                    
                    // 2. DETAIL PENERBANGAN
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildCode("JKT", "Jakarta"),
                              const Icon(Icons.flight_takeoff, color: Colors.purpleAccent, size: 30),
                              _buildCode(capital.substring(0, 3).toUpperCase(), capital),
                            ],
                          ),
                          const SizedBox(height: 24),
                          
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildLabel("Passenger", userName),
                              _buildLabel("Date", dateStr),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildLabel("Flight", "TL-707"),
                              _buildLabel("Gate", "A4"),
                              _buildLabel("Seat", "12A"),
                              _buildLabel("Class", "Economy"),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // GARIS PUTUS-PUTUS (Pemisah)
                    Row(
                      children: List.generate(30, (index) => Expanded(
                        child: Container(
                          color: index % 2 == 0 ? Colors.transparent : Colors.grey[300],
                          height: 2,
                        ),
                      )),
                    ),

                    // 3. QR CODE AREA
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          QrImageView(
                            data: bookingId, // Isi QR adalah ID Booking
                            version: QrVersions.auto,
                            size: 180.0,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            "Scan this QR code at the gate",
                            style: GoogleFonts.poppins(color: Colors.grey, fontSize: 12),
                          ),
                          Text(
                            bookingId,
                            style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCode(String code, String city) {
    return Column(
      children: [
        Text(code, style: GoogleFonts.poppins(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black)),
        Text(city, style: GoogleFonts.poppins(color: Colors.grey)),
      ],
    );
  }

  Widget _buildLabel(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 10)),
        Text(value, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14)),
      ],
    );
  }
}