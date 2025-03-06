resource "aws_s3_bucket" "pipeline-90" {
  bucket = "pipeline-90"

  tags = {
    Name        = "test"
    Environment = "Dev"
  }
}
