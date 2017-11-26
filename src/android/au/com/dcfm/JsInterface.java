package au.com.dcfm;

import android.app.Activity;
import android.content.Context;
import android.os.Handler;
import android.util.Log;
import android.webkit.JavascriptInterface;
import android.webkit.WebView;
import android.widget.Toast;

/**
 * Created by aligorkem on 21/11/17.
 */
public class JsInterface {


    private Context _context;
    private WebView _techView;
    private WebView _syncView;
    private String _userId;
    private String _password;
    private int _version = 0;

    /**
     * Instantiate the interface and set the context
     */
    JsInterface(Context context, WebView techView, WebView syncView, String userId, String password) {

        _context = context;
        _techView = techView;
        _syncView = syncView;
        _userId = userId;
        _password = password;
    }



    /**
     * webToNative_AutoLogin
     */
    @JavascriptInterface
    public void webToNative_AutoLogin() {

        _techView.post(new Runnable() {
            @Override
            public void run() {
                String params = "'" + _userId + "','" + _password + "'," + _version + "";
                _techView.loadUrl("javascript:autoLogin(" + params + ");");

                //if you need to handle return value, use below one
                //_view.evaluateJavascript( js, callback )
            }
        });

    }


    /**
     * webToNative_SyncAll
     */
    @JavascriptInterface
    public void webToNative_SyncAll() {

        _syncView.post(new Runnable() {
            @Override
            public void run() {
                _syncView.loadUrl("javascript:SYNC();");

                //if you need to handle return value, use below one
                //_view.evaluateJavascript( js, callback )
            }
        });


    }

    /**
     * webToNative_SyncSuccessful
     */
    @JavascriptInterface
    public void webToNative_SyncSuccessful() {

        _techView.post(new Runnable() {
            @Override
            public void run() {
                _techView.loadUrl("javascript:SyncSuccessful();");

                //if you need to handle return value, use below one
                //_view.evaluateJavascript( js, callback )
            }
        });

    }



    /**
     * webToNativeReLoadSYNCPage
     */
    @JavascriptInterface
    public void webToNativeReLoadSYNCPage() {


    }


}