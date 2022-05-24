#Test S3 Bucket
resource "aws_s3_bucket" "tests3" {
  bucket = "dennis-terraform-test"
  versioning {
    enabled = true
  }
}
