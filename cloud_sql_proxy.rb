class CloudSqlProxy < Formula
  desc "The Cloud SQL Proxy for GoogleCloudPlatform"
  homepage "https://github.com/GoogleCloudPlatform/cloud-sql-proxy"
  version "2.12.0+darwin.amd64"
  url "https://storage.googleapis.com/cloud-sql-connectors/cloud-sql-proxy/v2.12.0/cloud-sql-proxy.darwin.amd64"
  sha256 "d4bae260cd8b371a7040f3596d2bccfe48b030aa94aee972865b21e2bdb9accd"

  def install
    bin.install "cloud_sql_proxy.darwin.amd64" => "cloud_sql_proxy"
  end
end
