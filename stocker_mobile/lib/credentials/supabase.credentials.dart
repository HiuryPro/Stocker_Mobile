import 'package:supabase/supabase.dart';

class SupaBaseCredentials {
  static String apiKey =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9tc29tcXRoc3hpY3F1Zmdqa2lrIiwicm9sZSI6ImFub24iLCJpYXQiOjE2NjE3Mzc4OTcsImV4cCI6MTk3NzMxMzg5N30.ByzR3LfUwOJBJpJyBhboWpzmi0IV1qydFUyt-OOICE4";
  static String apiUrl = "https://omsomqthsxicqufgjkik.supabase.co";

  static SupabaseClient supaBaseClient = SupabaseClient(apiUrl, apiKey);
}
