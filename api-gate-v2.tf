
// API Gateway stuff

resource "aws_apigatewayv2_api" "crud-api" {
  name          = "apigw-http-lambda"
  protocol_type = "HTTP"
  description   = "Serverlessland API Gwy HTTP API and AWS Lambda function"

  cors_configuration {
      allow_credentials = false
      allow_headers     = []
      allow_methods     = [
          "GET",
          "HEAD",
          "OPTIONS",
          "POST",
      ]
      allow_origins     = [
          "*",
      ]
      expose_headers    = []
      max_age           = 0
  }
}


resource "aws_apigatewayv2_stage" "default" {
  api_id = aws_apigatewayv2_api.crud-api.id

  name        = "$default"
  auto_deploy = true

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.api_gw.arn

    format = jsonencode({
      requestId               = "$context.requestId"
      sourceIp                = "$context.identity.sourceIp"
      requestTime             = "$context.requestTime"
      protocol                = "$context.protocol"
      httpMethod              = "$context.httpMethod"
      resourcePath            = "$context.resourcePath"
      routeKey                = "$context.routeKey"
      status                  = "$context.status"
      responseLength          = "$context.responseLength"
      integrationErrorMessage = "$context.integrationErrorMessage"
      }
    )
  }
  depends_on = [aws_cloudwatch_log_group.api_gw]
}

resource "aws_apigatewayv2_integration" "crud-api" {
  api_id = aws_apigatewayv2_api.crud-api.id
  integration_uri    = aws_lambda_function.learn-crud.invoke_arn
  integration_type   = "AWS_PROXY"
  integration_method = "ANY"
}

resource "aws_apigatewayv2_route" "any" {
  api_id = aws_apigatewayv2_api.crud-api.id
  route_key = "PUT /items"
  target    = "integrations/${aws_apigatewayv2_integration.crud-api.id}"
}

resource "aws_apigatewayv2_route" "any_get" {
  api_id = aws_apigatewayv2_api.crud-api.id
  route_key = "GET /items"
  target    = "integrations/${aws_apigatewayv2_integration.crud-api.id}"
}

resource "aws_apigatewayv2_route" "any_get_all" {
  api_id = aws_apigatewayv2_api.crud-api.id
  route_key = "GET /items/{id}"
  target    = "integrations/${aws_apigatewayv2_integration.crud-api.id}"
}

resource "aws_apigatewayv2_route" "any_delete_all" {
  api_id = aws_apigatewayv2_api.crud-api.id
  route_key = "DELETE /items/{id}"
  target    = "integrations/${aws_apigatewayv2_integration.crud-api.id}"
}

resource "aws_cloudwatch_log_group" "api_gw" {
  name = "/aws/api_gw/${aws_apigatewayv2_api.crud-api.name}"

  retention_in_days = 1
}

resource "aws_lambda_permission" "api_gw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.learn-crud.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.crud-api.execution_arn}/*/*"
}
