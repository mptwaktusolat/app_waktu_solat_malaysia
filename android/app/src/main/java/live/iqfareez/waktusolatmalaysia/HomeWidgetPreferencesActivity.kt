package live.iqfareez.waktusolatmalaysia

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.material3.TopAppBar
import androidx.compose.material3.TopAppBarDefaults
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.tooling.preview.Preview
import live.iqfareez.waktusolatmalaysia.ui.theme.AndroidTheme
import me.zhanghai.compose.preference.ProvidePreferenceLocals
import me.zhanghai.compose.preference.rememberPreferenceState
import me.zhanghai.compose.preference.switchPreference


@OptIn(ExperimentalMaterial3Api::class)
class HomeWidgetPreferencesActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setResult(RESULT_OK)
        enableEdgeToEdge()
        setContent {
            AndroidTheme {
                Scaffold(
                    modifier = Modifier.fillMaxSize(),
                    topBar = {
                        TopAppBar(
                            colors = TopAppBarDefaults.topAppBarColors(
                                containerColor = MaterialTheme.colorScheme.primaryContainer,
                                titleContentColor = MaterialTheme.colorScheme.primary,
                            ),
                            title = {
                                Text(stringResource(R.string.title_activity_time_widget_settings))
                            }
                        )
                    },
                ) { innerPadding ->
                    SettingsComponent(
                        modifier = Modifier.padding(innerPadding)
                    )
                }
            }
        }
    }
}

@Composable
fun SettingsComponent(modifier: Modifier = Modifier) {
    ProvidePreferenceLocals {
        val hijriDateState = rememberPreferenceState(
            key = "hijri_date_preference",
            defaultValue = false
        )
        val isHijriDateEnabled by hijriDateState

        LaunchedEffect(isHijriDateEnabled) {
            println("Hijri date preference changed to: $isHijriDateEnabled")
            // TODO: Add your logic here to update widgets or call a ViewModel
        }
        LazyColumn(modifier = modifier) {
            switchPreference(
                key = "hijri_date_preference",
                defaultValue = false,
                title = { Text(text = stringResource(R.string.date_type_title)) },
            )
        }
    }
}

@Preview(showBackground = true)
@Composable
fun SettingsComponentPreview() {
    AndroidTheme {
        SettingsComponent()
    }
}