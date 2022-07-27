# CDN load balancer with Cloud bucket as backend

# Cloud Storage bucket
resource "google_storage_bucket" "default" {
  name                        = "my-bucket-${local.name_suffix}"
  location                    = "us-east1"
  uniform_bucket_level_access = true
  storage_class               = "STANDARD"
  // delete bucket and contents on destroy.
  force_destroy = true
  // Assign specialty files
  website {
    main_page_suffix = "index.html"
    not_found_page   = "404.html"
  }
}


# make bucket public
resource "google_storage_bucket_iam_member" "default" {
  bucket = google_storage_bucket.default.name
  role   = "roles/storage.objectViewer"
  member = "allUsers"
}

resource "google_storage_bucket_object" "index_page" {
  name    = "index-page-${local.name_suffix}"
  bucket  = google_storage_bucket.default.name
  content = <<-EOT
    <html><body>
    <h1>Congratulations on setting up Google Cloud CDN with Storage backend!</h1>
    </body></html>
  EOT
}

resource "google_storage_bucket_object" "error_page" {
  name    = "404-page-${local.name_suffix}"
  bucket  = google_storage_bucket.default.name
  content = <<-EOT
    <html><body>
    <h1>404 Error: Object you are looking for is no longer available!</h1>
    </body></html>
  EOT
}

# image object for testing, try to access http://<your_lb_ip_address>/test.jpg
resource "google_storage_bucket_object" "test_image" {
  name = "test-object-${local.name_suffix}"
  # Uncomment and add valid path to an object.
  #  source       = "/path/to/an/object"
  #  content_type = "image/jpeg"

  # Delete after uncommenting above source and content_type attributes
  content      = "Data as string to be uploaded"
  content_type = "text/plain"

  bucket = google_storage_bucket.default.name
}

# reserve IP address
resource "google_compute_global_address" "default" {
  name = "example-ip-${local.name_suffix}"
}

# forwarding rule
resource "google_compute_global_forwarding_rule" "default" {
  name                  = "http-lb-forwarding-rule-${local.name_suffix}"
  ip_protocol           = "TCP"
  load_balancing_scheme = "EXTERNAL"
  port_range            = "80"
  target                = google_compute_target_http_proxy.default.id
  ip_address            = google_compute_global_address.default.id
}

# http proxy
resource "google_compute_target_http_proxy" "default" {
  name    = "http-lb-proxy-${local.name_suffix}"
  url_map = google_compute_url_map.default.id
}

# url map
resource "google_compute_url_map" "default" {
  name            = "http-lb-${local.name_suffix}"
  default_service = google_compute_backend_bucket.default.id
}

# backend bucket with CDN policy with default ttl settings
resource "google_compute_backend_bucket" "default" {
  name        = "cat-backend-bucket-${local.name_suffix}"
  description = "Contains beautiful images"
  bucket_name = google_storage_bucket.default.name
  enable_cdn  = true
  cdn_policy {
    cache_mode        = "CACHE_ALL_STATIC"
    client_ttl        = 3600
    default_ttl       = 3600
    max_ttl           = 86400
    negative_caching  = true
    serve_while_stale = 86400
  }
}
