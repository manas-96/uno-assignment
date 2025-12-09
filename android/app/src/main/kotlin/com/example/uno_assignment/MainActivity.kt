package com.example.uno_assignment

import io.flutter.embedding.android.FlutterActivity
import com.almoullim.background_location.BackgroundLocationPlugin
import io.flutter.embedding.engine.FlutterEngine

class MainActivity: FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        BackgroundLocationPlugin.setPluginRegistrantCallback(flutterEngine)
    }
}
