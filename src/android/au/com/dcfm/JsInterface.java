package au.com.dcfm;

import android.app.Activity;
import android.content.Context;
import android.os.Handler;
import android.util.Log;
import android.webkit.JavascriptInterface;
import android.webkit.WebView;
import android.widget.Toast;
import android.util.Log;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.PluginResult;
import org.json.JSONException;
import org.json.JSONObject;

/**
 * Created by aligorkem on 21/11/17.
 */
public class JsInterface {

    private static final String TAG = "JTMWebViewer";
    private final CallbackContext _jtmWebViewer;

    private Context _context;
    private WebView _techView;
    private WebView _syncView;
    private String _userId;
    private String _password;
    private int _version = 0;

    /**
     * Instantiate the interface and set the context
     */
    JsInterface(Context context, CallbackContext jtmWebViewer, WebView techView, WebView syncView, String userId, String password) {

        _context = context;
        _jtmWebViewer = jtmWebViewer;
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

    /**
     * webToNative_Action
     */
    @JavascriptInterface
    public void webToNative_Action(String action, String value) {

        Log.d(TAG, "webToNative_Action: " + action );

        if( value != null ){
            Log.d(TAG, "webToNative_Action value: " + value );
        }

        onActionReceived(action, value, "");

//        if( action != null ){
//
//            if( action == "TakePhoto" ){
//
//                onActionReceived();
//                //_jtmWebViewer.onActionReceived();
//
//            }else if( action  == "OpenDocument" ){
//
//                onActionReceived();
//
//                //_jtmWebViewer.onActionReceived();
//
//            }
//        }

    }


    /**
     * webToNative_IsJobClosable
     */
    @JavascriptInterface
    public void webToNative_IsJobClosable(String jobid, String apptid) {

        Log.d(TAG, "webToNative_IsJobClosable: jobid " + jobid + ", apptid: " + apptid);

        this.onActionReceived("IsJobClosable", jobid, apptid );

        //onActionReceived(action,value);
    }

    // This method will be fired later.
    public void onActionReceived(String action, String jobid, String apptid) {
        Log.d(TAG, "onActionReceived");

        String returnValue = "{";
        returnValue = returnValue + "\"jobid\":\""+jobid+"\",";
        returnValue = returnValue + "\"action\":\""+action+"\",";
        returnValue = returnValue + "\"apptid\":\""+apptid+"\",";
        returnValue = returnValue + "\"ping\":\"false\"}";

        if( _jtmWebViewer != null) {
            try {
//                JSONObject parameter = new JSONObject();
//                parameter.put("param1", "1");
//                parameter.put("param2", "2");
                // callback.success(parameter);
                PluginResult result = new PluginResult(PluginResult.Status.OK, returnValue);
                result.setKeepCallback(true);
                _jtmWebViewer.sendPluginResult(result);

            } catch (Exception e) {
                Log.e(TAG, e.toString());
            }
        }
    }



}