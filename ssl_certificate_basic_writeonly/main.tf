resource "google_compute_ssl_certificate" "default" {
  name_prefix            = "my-certificate-"
  description            = "a description"
  private_key_wo         = file("../static/ssl_cert/test.key")
  private_key_wo_version = parseint(filesha256("../static/ssl_cert/test.key"),16)%pow(2,32)
  certificate            = file("../static/ssl_cert/test.crt")

  lifecycle {
    create_before_destroy = true
  }
}
