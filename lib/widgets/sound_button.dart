import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class SoundButton extends StatefulWidget {
  const SoundButton({Key? key}) : super(key: key);

  @override
  State<SoundButton> createState() => _SoundButtonState();
}

class _SoundButtonState extends State<SoundButton>
    with SingleTickerProviderStateMixin {
  final AudioPlayer _player = AudioPlayer();
  double _scale = 1.0;

  @override
  void dispose() {
    _player.dispose(); // ปิด player ตอนเลิกใช้งาน
    super.dispose();
  }

  // ฟังก์ชันเล่นเสียง
  void _playSound() async {
    try {
      // หยุดเสียงเก่าก่อน (กันซ้อน)
      await _player.stop();

      // Debug log ว่าเริ่มเล่นเสียง
      debugPrint('Playing sound: sounds/baby.mp3');

      // เล่นไฟล์จาก assets (path ต้องตรงกับ pubspec.yaml)
      await _player.play(AssetSource('assets/sounds/baby.mp3'));
    } catch (e) {
      debugPrint('Error playing sound: $e');
    }
  }

  // กดปุ่มลง
  void _onTapDown(TapDownDetails details) {
    setState(() => _scale = 0.9);
    _playSound();
  }

  // ปล่อยปุ่มขึ้น
  void _onTapUp(TapUpDetails details) {
    setState(() => _scale = 1.0);
  }

  // ถ้าลากออกจากปุ่ม (ยกเลิกการกด)
  void _onTapCancel() {
    setState(() => _scale = 1.0);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 100),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.blueAccent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Text(
            'click me',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
