package live.iqfareez.waktusolatmalaysia.util

import android.content.Context
import android.content.SharedPreferences

/**
 * Get the SharedPreference instance for the specified widget ID.
 */
fun Context.getWidgetSharedPreferences(appWidgetId: Int): SharedPreferences {
    val name = "widget-preference-$appWidgetId"
    return this.getSharedPreferences(name, Context.MODE_PRIVATE);
}