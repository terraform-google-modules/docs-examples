resource "google_storage_bucket" "default" {
  name          = "transcoder-job-${local.name_suffix}"
  location      = "US"
  force_destroy = true

  uniform_bucket_level_access = true
  public_access_prevention = "enforced"
}

resource "google_storage_bucket_object" "example_mp4" {
  name   = "example.mp4"
  source = "./test-fixtures/example.mp4"
  bucket = google_storage_bucket.default.name
}

resource "google_transcoder_job" "default" {
  template_id = google_transcoder_job_template.default.name
  location    = "us-central1"

  labels = {
    "label" = "key"
  }
}

resource "google_transcoder_job_template" "default" {
  job_template_id = "example-job-template-${local.name_suffix}"
  location = "us-central1"
  config {
    inputs {
      key = "input0"
      uri = "gs://${google_storage_bucket.default.name}/${google_storage_bucket_object.example_mp4.name}"
    }
    output {
      uri = "gs://${google_storage_bucket.default.name}/outputs/"
    }
    edit_list {
      key               = "atom0"
      inputs            = ["input0"]
      start_time_offset = "0s"
    }
    elementary_streams {
      key = "video-stream0"
      video_stream {
        h264 {
          width_pixels      = 640
          height_pixels     = 360
          bitrate_bps       = 550000
          frame_rate        = 60
          pixel_format      = "yuv420p"
          rate_control_mode = "vbr"
          crf_level         = 21
          gop_duration      = "3s"
          vbv_size_bits     = 550000
          vbv_fullness_bits = 495000
          entropy_coder     = "cabac"
          profile           = "high"
          preset            = "veryfast"

        }
      }
    }
    elementary_streams {
      key = "video-stream1"
      video_stream {
        h264 {
          width_pixels      = 1280
          height_pixels     = 720
          bitrate_bps       = 550000
          frame_rate        = 60
          pixel_format      = "yuv420p"
          rate_control_mode = "vbr"
          crf_level         = 21
          gop_duration      = "3s"
          vbv_size_bits     = 2500000
          vbv_fullness_bits = 2250000
          entropy_coder     = "cabac"
          profile           = "high"
          preset            = "veryfast"
        }
      }
    }
    elementary_streams {
      key = "audio-stream0"
      audio_stream {
        codec             = "aac"
        bitrate_bps       = 64000
        channel_count     = 2
        channel_layout    = ["fl", "fr"]
        sample_rate_hertz = 48000
      }
    }
    mux_streams {
      key                = "sd"
      file_name          = "sd.mp4"
      container          = "mp4"
      elementary_streams = ["video-stream0", "audio-stream0"]
    }
    mux_streams {
      key                = "hd"
      file_name          = "hd.mp4"
      container          = "mp4"
      elementary_streams = ["video-stream1", "audio-stream0"]
    }
  }
  labels = {
    "label" = "key"
  }
}
