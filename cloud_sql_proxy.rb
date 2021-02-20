class CloudSqlProxy < Formula
  desc "The Cloud SQL Proxy for GoogleCloudPlatform"
  homepage "https://github.com/GoogleCloudPlatform/cloudsql-proxy"
  version "1.19.2+darwin.amd64"
  url "https://storage.googleapis.com/cloudsql-proxy/v1.19.2/cloud_sql_proxy.darwin.amd64"
  sha256 "75177340ee762964b19b436199e144f38266d40ce869d54684cc0478d66c19cb"

  def install
    bin.install "cloud_sql_proxy.darwin.amd64" => "cloud_sql_proxy"
  end
end
