data "google_client_openid_userinfo" "me" {
}

resource "google_os_login_ssh_public_key" "cache" {
  user =  data.google_client_openid_userinfo.me.email
  key = file("../static/ssh_rsa.pub")
}
