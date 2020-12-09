class CloudSqlProxy < Formula
  desc "The Cloud SQL Proxy for GoogleCloudPlatform"
  homepage "https://github.com/GoogleCloudPlatform/cloudsql-proxy"
  version "1.19.1+darwin.amd64"
  url "https://dl.google.com/cloudsql/cloud_sql_proxy.darwin.amd64"
  sha256 "a77e311f6c7bb1249022f23111c45181aced59db7af05d736a532f0b44838968"

  def install
    bin.install "cloud_sql_proxy.darwin.amd64" => "cloud_sql_proxy"
  end
end
