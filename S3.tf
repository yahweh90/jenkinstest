resource "aws_s3_bucket" "jenkins_bucket" {
  bucket = "jenkins_bucket"

  tags = {
    Name        = "jenkins_bucket"
    Environment = "Dev"
  }
}
