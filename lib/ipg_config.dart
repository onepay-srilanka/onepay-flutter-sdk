

class IpgConfig {
  static String baseUrl =
      "https://onepay-subscription-live-ftbwggf2frgqfza6.centralindia-01.azurewebsites.net/v3/";

  static const String publicKeyPem = """
-----BEGIN PUBLIC KEY-----
MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAuU5jIuZ00tSfszJR6H4i
fAelmPJoHa+ybYQ5WkdyGh7Xy9ulX8rjgtUIn/hU8/s5CID3zhoPYnqx9CqQKpaK
fgljAYdWNFBYHdnzAzOFQUTknd6BMFZLZ1DkY+pcYtn6iT9vXpn7SeoSanACZOip
bYvMykCfliS3AdEly9aeWtJvA7pI01sPA0L4eknaSQ5zBCeDidDbuXCwXPMQEAde
oRmMqAVGmUX4EuW8y3RuZbHPcvN5VnKdOOiTQa7TFI9kZMYL1qrH1ttwCyd3qTAM
E0W6/gMusliKrZbl4BL3ug3VKo7ygnMaxSyoEYxZnx6j05pWaPhFuMY7fgcSqGiT
gwIDAQAB
-----END PUBLIC KEY-----
""";
}

enum Status { loading, completed, error }
