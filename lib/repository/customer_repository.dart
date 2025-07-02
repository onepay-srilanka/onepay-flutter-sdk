import '../models/create_customer_token_request.dart';
import '../models/create_customer_token_response.dart';
import '../models/customer_list_response.dart';
import '../models/three_d_s_status_response.dart';
import '../networking/http_client.dart';

class CustomerRepository {
  final AuthHttpClient _authHttpClient = AuthHttpClient();

  Future<CreateCustomerTokenResponse> createCustomerToken(
    CreateCustomerTokenRequest payload,
    String appToken,
  ) async {
    final response = await _authHttpClient.post(
      "customer/token/",
      appToken,
      body: payload.toJson(),
    );
    return CreateCustomerTokenResponse.fromJson(response);
  }

  Future<ThreeDSStatusResponse> get3DSStatus(
    String token,
    String appToken,
  ) async {
    final response = await _authHttpClient.get(
      "customer/token/$token/get-status/",
      appToken,
    );
    return ThreeDSStatusResponse.fromJson(response);
  }

  Future<CustomerListResponse> getCustomers(
      String appToken,
      ) async {
    final response = await _authHttpClient.get(
      "customer/",
      appToken,
    );
    return CustomerListResponse.fromJson(response);
  }
}
