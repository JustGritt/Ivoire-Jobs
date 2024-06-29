import 'package:barassage_app/core/init_dependencies.dart';
import 'package:barassage_app/features/profile_mod/services/push_tokens_services.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:googleapis_auth/googleapis_auth.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;



class Firebaseapi {
  final _firebaseMessaging = FirebaseMessaging.instance;
  final  _pushTokensService = serviceLocator<PushTokensService>();

  Future<void> initNotifications() async {
    NotificationSettings notificationSettings = await _firebaseMessaging.requestPermission();
    if(notificationSettings.authorizationStatus == AuthorizationStatus.authorized){
        final token = await getNotificationToken();
        _pushTokensService.storeToken(token);
        print(token);
        // FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
    }
  }

  Future<void> handleBackgroundMessage(RemoteMessage message) async {
    print('Handling a background message ${message}');
  }

  Future<String> getNotificationToken() async {
    ServiceAccountCredentials serviceAccountJson = ServiceAccountCredentials.fromJson({
      "type": "service_account",
      "project_id": "barassageapp",
      "private_key_id": "50f4cb75ba0fa1aefd093df85cf96f155625aafd",
      "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCs/D6qe1+1SML1\n/mr9v+WXhjwXAjymfBlKXWmM+XRJAfYqIOl1RN3bKT2vOkTsL4KB2IFBnXdo443I\n3Zb/r2n+bL/49O+P8OzbfiFwGf5nrWYs7IZmlC6qJTBLLfIK/MGhiGJUtyRWlQkv\ngmT6fqMUgcioF0WnubG166rA9VWqTYHlM5xkIijv1ZSsJ3sr2lTSQkdwIJlFe5eE\nSkNMfg1yLHMYEzgKZVCDsX/40MqtWieAebCxg/4z+jkIiEftleDC1eO/fIFtdPFr\n1gEJVJI/VmsgkVjdOtTvS+pYlMwYALJf39h5Hw7lmeDiEm57h8VtnfvjjXVMWAFR\nPb//K287AgMBAAECggEAB3YsxWswWMaZMxKbQdoxSJgJNBx4490hgb3F+K2mVvBA\n0onJGDGOxYFumdLdHmthAttrnYClCHJPiNtwd0bCC/zCSrZVNdorrvIU9iig4SiV\n6jH2DPgVi50Y2EohXfKPvAYagh+Rb5l0V0cvUBP+hW46hHAKJW7fzzWQD+YYbZHI\nTOSdM9rnmKDfLubp2kpf3bkwJKikjf0s7RQW8exrQT7mIv0bA7DteXQYJGn6XIDH\nbyn5gDvZKDqyH+YZ14zs6Tt0TzHUQZUjKjjllmvX9TJmttl3h8viS/4z9k4mkdKO\nYoAAbyqElsn38XGI3wZyyNyKmoOTcXUgN78hlMQbFQKBgQDj0a/Aq1WHQ6tvkBP2\ng/OghISNUdOposGJGDrmhX1e0x53yp7SD/OtglPLVYaagiu2Tw7SQbZEap2uvOzP\nCIRvTxr5x/DawbpKynwB8EBVIZwKUKLOxQ3VcX5FPJsWKoSyFKOisF2VqSH6JNBC\ncD4wIKVgOLZTn6qxJvGD8VO1nQKBgQDCYiVQx9l6JlcPmrkCTjWjmtjJ+I6W/npd\neY+VB/j+4vWownGHAVvXqGUkD3N8L2zJ0Z1gZ9bM7sQ073GMipXAsdRLMf0P3yPI\n+5i8C/jv7e0GzS42hXFC/J8caQ7G36UKqGKMq0PhyRLMgN3zFh3Qu71wtdz5+Hox\n8HQfhPJMtwKBgQCIWoNfxOx+9hCQyGI6ZIWXqFkRoE0YNfKyFE+Ek5cS/zc4KYzf\nW27UhbGTfNAAgDKbfjv3uh7WWh2gbTErRQTG/ki+AV52AAd5JjIMkvheO6yCO/sF\n2MlL3A7gb8K/BJnBYDsEb5zDq6RLbGc9rKJ7+b4hljACYwkt2IorF3CrvQKBgHF6\nAFTHRpODnGGUrprE85VeCV7nBr7pMqAtHgAflmGeN1Fcqg/pYCdmvBywFHgT64tq\nHliwZfpfDRXmDsDACqpiZg+70AMa/fYPwttMlffjSvMkhuz3O+aiOXTJdAHvf5bY\nNCfwt4Ew9BOEy41khOVdJDuPP8CCKTvMJs5bu2PDAoGACopibyjMKoaUjUaVCTzj\nZqbG6gmtmFyIeGsWxZSCdW8wAPVfsLo4wLy87e/t2ySMTzHUei2R7Hsex3B8TpoI\nA0Apc8eoxFSQVO7aFNA+DLmQKCeeTMHurcdVCCTKiKxP8nY8VHp7ysZO0JCPkqzu\nY4om9y46Kat0I72ZJEA0bvU=\n-----END PRIVATE KEY-----\n",
      "client_email": "firebase-adminsdk-hak9y@barassageapp.iam.gserviceaccount.com",
      "client_id": "105581346067939992131",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-hak9y%40barassageapp.iam.gserviceaccount.com",
      "universe_domain": "googleapis.com"
    });

    List<String> scopes = [
      "https://www.googleapis.com/auth/firebase.messaging"
    ];

    //Create an HTTP client
    final client = await auth.clientViaServiceAccount(serviceAccountJson, scopes);
    //Obtain the access credentials
    final accessToken = await client.credentials.accessToken.data;
    //close the client
    client.close();

    return accessToken;
  }



}