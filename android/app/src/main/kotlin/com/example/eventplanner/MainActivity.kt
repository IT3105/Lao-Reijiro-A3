// android/app/src/main/kotlin/com/example/eventplanner/MainActivity.kt
package com.example.eventplanner

import android.appwidget.AppWidgetManager
import android.content.ComponentName
import android.os.Bundle
import android.widget.RemoteViews
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.example.eventplanner/widget"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "updateEventWidget") {
                val events: String? = call.argument("events")
                if (events != null) {
                    updateWidget(events)
                }
                result.success(null)
            } else {
                result.notImplemented()
            }
        }
    }

    private fun updateWidget(events: String) {
        val appWidgetManager = AppWidgetManager.getInstance(this)
        val views = RemoteViews(packageName, R.layout.event_widget)
        views.setTextViewText(R.id.widget_event_list, events)

        val widgetComponent = ComponentName(this, EventWidgetProvider::class.java)
        appWidgetManager.updateAppWidget(widgetComponent, views)
    }
}
