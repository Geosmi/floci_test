resource "aws_sqs_queue" "stream_q" {
  name = "stream-q"
}

resource "aws_sqs_queue" "stream_q_ddl" {
  name = "stream-q-ddl"
  redrive_allow_policy = jsonencode({
    redrivePermission = "byQueue",
    sourceQueueArns   = [aws_sqs_queue.stream_q.arn]
  })
}

resource "aws_sqs_queue_redrive_policy" "stream_q" {
  queue_url = aws_sqs_queue.stream_q.id
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.stream_q_ddl.arn
    maxReceiveCount     = 4
  })
}