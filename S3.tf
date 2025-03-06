data "aws_s3_bucket" "existing_bucket" {
  bucket = "pipeline-90"
}

resource "aws_s3_bucket" "pipeline-90" {
  bucket = "pipeline-90"

  tags = {
    Name        = "test"
    Environment = "Dev"
  }
}
